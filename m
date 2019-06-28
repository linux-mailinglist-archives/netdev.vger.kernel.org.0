Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7A75A396
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfF1Saa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:30:30 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40626 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF1Sa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:30:29 -0400
Received: by mail-io1-f66.google.com with SMTP id n5so14513937ioc.7
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=F6JEZEenAD668FxY5bjGOrYEBPrHJPZUTJrtAA0D0yM=;
        b=yOsb5i3uuU9cZ6n9Lha5RoFFcwz9OdPpaa0RLZQUlrwaMkCpoc7Pif4TZ4YJI4ccK5
         M3lUlVM64tTVF0hnPz6IeYjHfqLgHwR7tN36Yu5W6jOIiGVN3nKyV0vkw5e0ZtAiEG5k
         4TpnBAFGLJRLJqrLDGugSm1yBU7y2z/yHb0tkaoVwBOrRq0Y3HVd6ApiFMywcjnMJeJl
         IMCehuZJn/zvtDT8lLimHpxCWBSkpDKaeSkK0XAbcToWkB9sbVCoIJohbatFlszxw32H
         Bw94oCm73yKgMbi60FkvFQjkMJdhBDEaYWDBg4k3NqHMP39qNke797nS8QfEDjP5IZKt
         y7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F6JEZEenAD668FxY5bjGOrYEBPrHJPZUTJrtAA0D0yM=;
        b=SZf6/vfjsBqhL//liU+rwGfGXWVX6Uc5WzCdSgEitZAxGtcVq6SdnV3UZQNJeR42T+
         QnzwY9yUbRHp1nm/e9qzEgw9VU6ZIZos7FZOEZy8tUI3+jFrbCro3orhXtTauQYq0Dup
         pbpXA7xzMPOZmJg5eZYeLToFQ9Y7x98UDUARbyYxt8TkHODAVpGnMrABzh+pDZl7y2zU
         oqwnMnammwz+rbgJ9KFt9oJyA6fSUfAXX+oosK4Csaj4znB582ErNqER5p+3tpf94c+o
         A2MO8GNaxsCoQykQJcGFfH/SWRdoYZx1LPc2CjmxSYy32HAdY0KsW17j4EpD9E8xAdLt
         SlJQ==
X-Gm-Message-State: APjAAAUustbxzaCh/hJLFUWHWoKs72djuFE81kkqx3BJIXM2LocH+dl3
        bXMXAjAsrJNeRVxbUHw8w9HHrt0ezjc=
X-Google-Smtp-Source: APXvYqxnTo/S/FBGU38yYQJ4FQ2/z4Lv/FdWoIZG8f2ebx+1cL73RMyOxRFZXf7fIkBaPh0dgeU9pQ==
X-Received: by 2002:a02:b68f:: with SMTP id i15mr12971685jam.107.1561746628906;
        Fri, 28 Jun 2019 11:30:28 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id t4sm2472804iop.0.2019.06.28.11.30.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 28 Jun 2019 11:30:28 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 0/2] Fix batched event generation for mirred action
Date:   Fri, 28 Jun 2019 14:30:16 -0400
Message-Id: <1561746618-29349-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding or deleting a batch of entries, the kernel sends upto
TCA_ACT_MAX_PRIO entries in an event to user space. However it does not
consider that the action sizes may vary and require different skb sizes.

For example :

% cat tc-batch.sh
TC="sudo /mnt/iproute2.git/tc/tc"

$TC actions flush action mirred
for i in `seq 1 $1`;
do
   cmd="action mirred egress redirect dev lo index $i "
   args=$args$cmd
done
$TC actions add $args
%
% ./tc-batch.sh 32
Error: Failed to fill netlink attributes while adding TC action.
We have an error talking to the kernel
%

patch 1 adds callback in tc_action_ops of mirred action, which calculates
the action size, and passes size to tcf_add_notify()/tcf_del_notify().

patch 2 updates the TDC test suite with relevant test cases.

Roman Mashak (2):
  net sched: update mirred action for batched events operations
  tc-testing: updated mirred action tests with batch create/delete

 net/sched/act_mirred.c                             |  6 ++
 .../tc-testing/tc-tests/actions/mirred.json        | 94 ++++++++++++++++++++++
 2 files changed, 100 insertions(+)

-- 
2.7.4

