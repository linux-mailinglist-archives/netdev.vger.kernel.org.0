Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB8157DFE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 10:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfF0INH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 04:13:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33222 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfF0ING (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 04:13:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so1445092wru.0
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 01:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0rm8BZ15/9VA+TRcRb1HIn70mIfsKA7nZmITW8NJ0ZE=;
        b=gyYtXj7usmQqmoPo5vP6PrXrJGUHbf8c4FU7Yo2+OOZpl4AJQw07zOVjREHgvkYI3B
         05OIcYYPfFLchO6I9cYAbEA/sw4jDJpuo+jNegm2Sb6IX7I3FSrRkTeMQAyv1cqwbbUV
         vBJb/7J20TZ8Mg0SXALjeqN3YdYwSp8lqDxBY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0rm8BZ15/9VA+TRcRb1HIn70mIfsKA7nZmITW8NJ0ZE=;
        b=b8kDJrl6C3N869vLMZ3j3Go0RJBwq7A2rg/aj/ka+UUzLGcCbnG2dL+0cjxwmgY53x
         QbH1MwqcUA0Ow9AaMNWSDCpCdgT2u63LtuovzlWzmkZIDkWZYXaRAWPdrbh1WbVuf1Eo
         lrp0dcH280bWtOTfQap9SteZS6bwG40SLH2YT2ne5sZalUMHOZththuTeC0yQy4daRy9
         bh7QlYZrDwLlwebnU3K82jZp0QjmbgXLi6beFEkBuW7viz6x6gXx03+W/XgCQVm/Do3w
         o1qDh8oMt6+q7rFqCxLsmq1y0eS86XqFknhHDOgAqiUnNjXE8psubkpH720fgyA3dEya
         S2Vw==
X-Gm-Message-State: APjAAAVtd5eT1gowpH4pqfZZDSYRCmpXq/9Y5qqYPRpTszFRGjUaql3w
        LYHOplvPJMPm80Gvh7VYDHpkcZII9uk=
X-Google-Smtp-Source: APXvYqwKD1NkoQ6XG5mDXOf51TPrTFuvluZEV7ogRf1oxNXof2q171zomE6LuShu+4egn5Osy96qTA==
X-Received: by 2002:a5d:624c:: with SMTP id m12mr1990433wrv.20.1561623184188;
        Thu, 27 Jun 2019 01:13:04 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o6sm6969949wmc.15.2019.06.27.01.13.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 01:13:03 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 0/4] em_ipt: add support for addrtype
Date:   Thu, 27 Jun 2019 11:10:43 +0300
Message-Id: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
We would like to be able to use the addrtype from tc for ACL rules and
em_ipt seems the best place to add support for the already existing xt
match. The biggest issue is that addrtype revision 1 (with ipv6 support)
is NFPROTO_UNSPEC and currently em_ipt can't differentiate between v4/v6
if such xt match is used because it passes the match's family instead of
the packet one. The first 3 patches make em_ipt match only on IP
traffic (currently both policy and addrtype recognize such traffic
only) and make it pass the actual packet's protocol instead of the xt
match family when it's unspecified. They also add support for NFPROTO_UNSPEC
xt matches. The last patch allows to add addrtype rules via em_ipt.
We need to keep the user-specified nfproto for dumping in order to be
compatible with libxtables, we cannot dump NFPROTO_UNSPEC as the nfproto
or we'll get an error from libxtables, thus the nfproto is limited to
ipv4/ipv6 in patch 03 and is recorded.

v3: don't use the user nfproto for matching, only for dumping, more
    information is available in the commit message in patch 03
v2: change patch 02 to set the nfproto only when unspecified and drop
    patch 04 from v1 (Eyal Birger)

Thank you,
  Nikolay Aleksandrov


Nikolay Aleksandrov (4):
  net: sched: em_ipt: match only on ip/ipv6 traffic
  net: sched: em_ipt: set the family based on the packet if it's
    unspecified
  net: sched: em_ipt: keep the user-specified nfproto and dump it
  net: sched: em_ipt: add support for addrtype matching

 net/sched/em_ipt.c | 48 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

-- 
2.21.0

