Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0640248B85
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfFQSLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:11:32 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45445 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfFQSLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:11:31 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so11845260qtr.12
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AMC6deF+6+l1sIzTV6dze35plxZ2DmSHea7P0oIImwU=;
        b=ZUbey0VxH3YjPx/e1ik8scopBamCH/gztCUYHjJto/G4ytXsf4HXL1y7ooVTTRpYh4
         +9tkDteyEXzeFtAzxqeDE/b6gITpJi0DCr+BMZRryKxboKLETleQpIQTi4mALEMpgNL1
         WZtXTR9msnSpKwu6erJ8xXB0mbeonZQpjUJa4EaNP47CAyeL9Z4OUTdipKzpzASbyHXu
         lwvU08s/uXpyUo8/7d5IVe3HknrvCeyMFps/ZWejpl2u80qa7XUitLoHERqIr8rRzf3w
         UB4Y6IebVNsLwTdOaddIalihHviyt0XpYUBi2VhgUQkZtMYueqrU8OIuKKuutaotC+Hf
         1kzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AMC6deF+6+l1sIzTV6dze35plxZ2DmSHea7P0oIImwU=;
        b=mVsVbWQPUxcoM4eoioyBUTR4i8ZO+rq4ZgjaboxiNeI1vWZiYCzIgBnb36sd14ggEo
         iaMKW41ugoRIOOzOjsFxbPKhnAUyesBODGBQHf1O+wGn/nJfR7Gg+eNggbjpbiGxW77y
         KlMBlFZBDkZeEE+T9Z0jj0xWEbjsSl2zhI8kY9YsP5tRlyETdN7TQFzRkts5pfhKFUr1
         OhAv72iVFnaGXMQ82cjVDhcqZ6CL7nAwAvhCesIE24e02GL4MsT1IQZmKoyADIVwZQYP
         HZdYjhUvkF1ydWjUgSn9KC2NQUA2ryOsIAXaxjh2PoWTjbYHPoNOSfK1waZSJWTkh6Lu
         COHw==
X-Gm-Message-State: APjAAAUqhrWbZKl66HoUCC6OeBlvndi3Z4Up1nMgaokHphS6p6MfuzPW
        qsd9W3xUW+dnucIrAGZcO0sPqA==
X-Google-Smtp-Source: APXvYqwgMAz4j/sWlfKFnVK/Q6B9P2KJHBzj8ZKBjqkUMsmmTqC9R/MsDRe4jX3YIxEYPfqM+w1UtQ==
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr9431574qvv.38.1560795090832;
        Mon, 17 Jun 2019 11:11:30 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x10sm9048564qtc.34.2019.06.17.11.11.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 11:11:30 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, xiyou.wangcong@gmail.com
Cc:     stephen@networkplumber.org, jhs@mojatatu.com, jiri@resnulli.us,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, edumazet@google.com, posk@google.com,
        nhorman@tuxdriver.com
Subject: [PATCH net v2 0/2] net: netem: fix issues with corrupting GSO frames
Date:   Mon, 17 Jun 2019 11:11:09 -0700
Message-Id: <20190617181111.5025-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Corrupting GSO frames currently leads to crashes, due to skb use
after free.  These stem from the skb list handling - the segmented
skbs come back on a list, and this list is not properly unlinked
before enqueuing the segments.  Turns out this condition is made
very likely to occur because of another bug - in backlog accounting.
Segments are counted twice, which means qdisc's limit gets reached
leading to drops and making the use after free very likely to happen.

The bugs are fixed in order in which they were added to the tree.

Jakub Kicinski (2):
  net: netem: fix backlog accounting for corrupted GSO frames
  net: netem: fix use after free and double free with packet corruption

 net/sched/sch_netem.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

-- 
2.21.0

