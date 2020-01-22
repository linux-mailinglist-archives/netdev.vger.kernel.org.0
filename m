Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA878145B7D
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgAVSWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:22:47 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35648 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:22:46 -0500
Received: by mail-pf1-f193.google.com with SMTP id i23so245292pfo.2
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XyXwjVTKydn9KcRb1vC9nQABU5a4lCre4VNwAmiVy0Y=;
        b=hGq92sS2SgFFt2vGPCvLXXKvaZh+1bLn7mbz+KSB1GHq9B6R4eP6orZgRp6qtGETGe
         qMltw/Pcfe0wqu0J95dGADohLphxEzn9EPreKtx4fiUaMYcF8l3xdLpoLjXbUQxKB5pj
         FS+zdf0xW8NSnCmE7ObL3kPHdTxEijOMPNH8rgmFXZwJUqn58y2udSitpu/bRvWYWzuU
         3Kdd0d/4J8A2dSL4s/W69PPZi8Zu5NeDAFYHrwbWQZui+L/yrPC7+K4d4ZpuGDi5uboL
         atyCXbhT3dlyeFCB9v6bilxspq/CejvxNaZDLyrWX2yqQeNP7Ue6IKLy7iJd0LZpzHkb
         KO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XyXwjVTKydn9KcRb1vC9nQABU5a4lCre4VNwAmiVy0Y=;
        b=thchUuhkms/Z964EiPKDk6Zm4C8HI7ugJ/MfBzL9ByMRsjfT61hm8uMk4vdUIcrdLw
         Ofell0CKqOddA+XvsHVwms1YWwacIn1njSOo+f+eljUceLReUYrweLrlvoOQFsMkihww
         ZczZ0iY9JUDzlmlXaJr9K1FEUdcnV6bMJwFX0Ygli+ylsd0XU3KN+YiOxnzHSND+Jb0K
         zt2Exrej73LdBP6kn+4hZlD97BV0FIK62G8yFrh1q5b3m111MY5SuB7uDH+i0kSL4YU7
         Px8echs+IiUQrrIZhPVhFDiB6nGX+KET9u03Auf4VXP0t8L19E3F9mNptyUZZtBMS5iZ
         gH8Q==
X-Gm-Message-State: APjAAAXt2pVmq99SZrewyjCqLBWzdpV06RKCQDF7LYZPeopdEJxcJHlt
        2uTBeywaKV8Qn9mHsKukh8xMPYleH595ESAY
X-Google-Smtp-Source: APXvYqx+ffvZvR4yQuslXsl/FPofa0uJQ3AP0/d+NKALS1D8q9NGpJE2+9uEiq1z8A4jmo4V3qJaiA==
X-Received: by 2002:a63:941:: with SMTP id 62mr12883460pgj.203.1579717365694;
        Wed, 22 Jan 2020 10:22:45 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id o17sm3996532pjq.1.2020.01.22.10.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:22:44 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Subject: [PATCH net-next v7 00/10] net: sched: add Flow Queue PIE packet scheduler
Date:   Wed, 22 Jan 2020 23:52:23 +0530
Message-Id: <20200122182233.3940-1-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gautam Ramakrishnan <gautamramk@gmail.com>

Flow Queue PIE packet scheduler

This patch series implements the Flow Queue Proportional
Integral controller Enhanced (FQ-PIE) active queue
Management algorithm. It is an enhancement over the PIE
algorithm. It integrates the PIE aqm with a deficit round robin
scheme.

FQ-PIE is implemented over the latest version of PIE which
uses timestamps to calculate queue delay with an additional
option of using average dequeue rate to calculate the queue
delay. This patch also adds a memory limit of all the packets
across all queues to a default value of 32Mb.

 - Patch #1
   - Creates pie.h and moves all small functions and structures
     common to PIE and FQ-PIE here. The functions are all made
     inline.
 - Patch #2 - #8
   - Addresses code formatting, indentation, comment changes
     and rearrangement of structure members.
 - Patch #9
   - Refactors sch_pie.c by changing arguments to
     calculate_probability(), [pie_]drop_early() and
     pie_process_dequeue() to make it generic enough to
     be used by sch_fq_pie.c. These functions are exported
     to be used by sch_fq_pie.c.
 - Patch #10
   - Adds the FQ-PIE Qdisc.

For more information:
https://tools.ietf.org/html/rfc8033

Changes from v6 to v7
 - Call tcf_block_put() when destroying the Qdisc as suggested
   by Jakub Kicinski.

Changes from v5 to v6
 - Rearranged struct members according to their access pattern
   and to remove holes.

Changes from v4 to v5
 - This patch series breaks down patch 1 of v4 into
   separate logical commits as suggested by David Miller.

Changes from v3 to v4
 - Used non deprecated version of nla_parse_nested
 - Used SZ_32M macro
 - Removed an unused variable
 - Code cleanup
 All suggested by Jakub and Toke.

Changes from v2 to v3
 - Exported drop_early, pie_process_dequeue and
   calculate_probability functions from sch_pie as
   suggested by Stephen Hemminger.

Changes from v1 ( and RFC patch) to v2
 - Added timestamp to calculate queue delay as recommended
   by Dave Taht
 - Packet memory limit implemented as recommended by Toke.
 - Added external classifier as recommended by Toke.
 - Used NET_XMIT_CN instead of NET_XMIT_DROP as the return
   value in the fq_pie_qdisc_enqueue function.


Mohit P. Tahiliani (10):
  net: sched: pie: move common code to pie.h
  pie: use U64_MAX to denote (2^64 - 1)
  pie: rearrange macros in order of length
  pie: use u8 instead of bool in pie_vars
  pie: rearrange structure members and their initializations
  pie: improve comments and commenting style
  net: sched: pie: fix commenting
  net: sched: pie: fix alignment in struct instances
  net: sched: pie: export symbols to be reused by FQ-PIE
  net: sched: add Flow Queue PIE packet scheduler

 include/net/pie.h              | 138 ++++++++
 include/uapi/linux/pkt_sched.h |  31 ++
 net/sched/Kconfig              |  13 +
 net/sched/Makefile             |   1 +
 net/sched/sch_fq_pie.c         | 562 +++++++++++++++++++++++++++++++++
 net/sched/sch_pie.c            | 289 ++++++-----------
 6 files changed, 849 insertions(+), 185 deletions(-)
 create mode 100644 include/net/pie.h
 create mode 100644 net/sched/sch_fq_pie.c

-- 
2.17.1

