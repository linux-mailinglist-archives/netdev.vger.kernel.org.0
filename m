Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC521143F00
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgAUONE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:13:04 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40027 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbgAUONE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:13:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id s21so1389996plr.7
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2uovNGb+lKBlRCCG60YvuMeC27obyxyhFFb9kLEQM8w=;
        b=J047vUvRIXiNN0a6F1VhSrFlRTRrlLWlowIaW6lHnWqrjc58tcbK6lq1cQkjd3FCGo
         lgDZB85LGZ3vCWm2KjAixyOuw6oRFryOjexgT5zN3tSWIVas9U5S3kSUT5qrwDbzMySA
         zgm4YNb3SFhCUedN1h1cUKehM6j+OpvqLdQH9moN17/Bi9b2Pu6qSPxpDIWApzL69vMy
         V8I9fALvCt/fshhjKf5rITsKYfCQmi/A1Gf+QgVGNfjkslII0aMBuJUVovRv0PCzjTpc
         2KNgThrxEF/9JLTTcca1b/izT1Sr1ToIVAl/9E38hH8qk3DWZulf9hCqsQr9/oq6AjOq
         TXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2uovNGb+lKBlRCCG60YvuMeC27obyxyhFFb9kLEQM8w=;
        b=S9AMf5ujcbyFDAZxxU6ioGYZHZvCMrYCwW1JItD0TNA9IXyzrDCyzKiBMSjiynjUyV
         sE3AqKwO47juVaMpTEpIdE1hPsGw/g2xAHS5D3dNu0w9g4C+pE822S+WJbWYmI0inm6R
         Ho9hBFqKnoacjSYqppOTqw0bMffYWLXKEZ1633+gjZeB11Sfe6C7WaDgtmFEvlGQNm3y
         oXhfKorq8g4lig6w3AQkI5O1IyPK22Ix48fjCqTiL6Im1L2iVm5yrimjtHm0BxGWAeeX
         2FwIp+F3899mxR0u29opq7CyeN+kQb7AjZBlBOMOuXwms8XbXzDHL79d5ZQSv+6pW1CM
         fA3A==
X-Gm-Message-State: APjAAAUu7By426gepQbLxmoJa9nEhLG/V51diHDma8xOaxpBmWAeg+mh
        yvp0P3GfojVBjV5curLoga4A6oB8bTyXUQ==
X-Google-Smtp-Source: APXvYqz/LmRbNeh0+PRB3cNDVmP8MPZayIyqE5Fedn/gBmSd0FhwHOF4nnYdQljpbHbhQ4qKm4Rjeg==
X-Received: by 2002:a17:902:b781:: with SMTP id e1mr5832862pls.128.1579615983631;
        Tue, 21 Jan 2020 06:13:03 -0800 (PST)
Received: from localhost.localdomain ([223.186.212.224])
        by smtp.gmail.com with ESMTPSA id y203sm44836443pfb.65.2020.01.21.06.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:13:02 -0800 (PST)
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
Subject: [PATCH net-next v4 00/10] net: sched: add Flow Queue PIE packet scheduler
Date:   Tue, 21 Jan 2020 19:42:39 +0530
Message-Id: <20200121141250.26989-1-gautamramk@gmail.com>
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

For more information:
https://tools.ietf.org/html/rfc8033

Changes from v4 to v5
 - This patch series breaks down patch 1 of v4 into
   separate logical commits as suggested by David Miller.
 - Patch #1
   - Creates pie.h and moves all small functions and structures
     common to PIE and FQ-PIE here. The functions are all made
     inline.
 - Patch #2 - #8
   - Addresses code formatting, indentation and comment changes.
 - Patch #9
   - Refactors sch_pie.c by changing arguments to
     calculate_probability(), drop_early() and
     pie_process_dequeue() to make it generic enough to
     be used by sch_fq_pie.c. These functions are exported
     to be used by sch_fq_pie.c.
 - Patch #10
   - Adds the FQ-PIE Qdisc.

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
 net/sched/sch_fq_pie.c         | 559 +++++++++++++++++++++++++++++++++
 net/sched/sch_pie.c            | 287 ++++++-----------
 6 files changed, 845 insertions(+), 184 deletions(-)
 create mode 100644 include/net/pie.h
 create mode 100644 net/sched/sch_fq_pie.c

-- 
2.17.1

