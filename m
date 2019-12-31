Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03A912D834
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 12:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfLaLYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 06:24:01 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40484 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfLaLYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 06:24:01 -0500
Received: by mail-pj1-f65.google.com with SMTP id bg7so1119204pjb.5
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 03:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=J+n4RNUkjLZ1Q5dOhzkAcTyNjU/uNTOTbUbEGkM/MfM=;
        b=myr7d/CTBSGfPlgv4iIJrOsk9RyzgVFWGl5BbdzbHIOeK/VIJUPnJulc1BjMWYI86w
         9Ilz78vqb8vdNk5P2ABfeos16hM2O+jHoojCJg/d8/9XE/pI884xGNRE+usp/kLAIyss
         VaQTTsJIggbTEYBaxvp40d+xxnw2epA0g7eCyqvtgkizgFXCLbtlsxi9jXyzyzYj3fhy
         f2uPsi7xtdTgRvZFttXvhgbgblpzjX53n2UyvIs74wbCdh7KM/PX6iHFehaQcBNb3hgJ
         lVhpAzA5wLmxrrgkD+aiUXuXcQsd10jY6w9HVBYI7ijZ8EA6J04uQ3/FbWGbHFmsAS7m
         aFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=J+n4RNUkjLZ1Q5dOhzkAcTyNjU/uNTOTbUbEGkM/MfM=;
        b=l7JAdZqKe1rLRlF3SFoY4fDZzqFlkmX/isGEzzZlxJhM6ov/vpvJbNQFpXTC/To/kG
         sPWnPCyWYtl4tlyyGpU9XC2BZVewIrdJlTwMMbSX+AhaD2KexKXbLQaXhIP5ItZSvpoM
         9X5hM3eXxg5qls/exWNDHVjNymaa1QGhb6bYOCZbVWYs/D0r5yel+tRx3Z5qd6WzCv6j
         FC2VeigCem9rYqu0OGp6X/5eXAP5gzLA3xnFP0np+SxFYrept78DNwoxPAIaeFv1yFX1
         8IK19Vr76+BBy5pw7ocpYwNANDoMqhVu/IOOw+jRkhgr3WT7DfckgN+jBe3wKgWunh/a
         vzUQ==
X-Gm-Message-State: APjAAAX5+/FFKsYbh1lhKlzcL4cjT6DsGgwyCx/D3e5x2asnXaz58vut
        mtAWb0VSCFBUbPilclj/kdPW7OoxHy7CLQ==
X-Google-Smtp-Source: APXvYqzwrrhMrsA5In6hYZvOQQDf44pHhhSug/YsWmWkA/gcv3LOxmBMKlBIY2tpYHYsJJ8av5nkrw==
X-Received: by 2002:a17:90a:a014:: with SMTP id q20mr5689417pjp.60.1577791440359;
        Tue, 31 Dec 2019 03:24:00 -0800 (PST)
Received: from localhost.localdomain ([223.186.204.218])
        by smtp.gmail.com with ESMTPSA id 68sm51208848pge.14.2019.12.31.03.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2019 03:23:59 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Subject: [PATCH net-next v2 0/2] net: sched: add Flow Queue PIE packet scheduler
Date:   Tue, 31 Dec 2019 16:53:14 +0530
Message-Id: <20191231112316.2788-1-gautamramk@gmail.com>
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
algorithm. It integrates the PIE AQM with a deficit round-robin
scheme.

FQ-PIE is implemented over the latest version of PIE which uses timestamps
to calculate queue delay with an additional option of using average dequeue
rate (Little's law) to calculate the queue delay. This patch also adds a
memory limit of all the packets across all queues to a default value of
32Mb.

For more information: 
https://tools.ietf.org/html/rfc8033

Changes from v1 (and RFC patch) to v2
 - Added timestamp to calculate queue delay as recommended
   by Dave Taht
 - Packet memory limit implemented as recommended by Toke.
 - Added external classifier as recommended by Toke.
 - Used NET_XMIT_CN instead of NET_XMIT_DROP as the return
   value in the fq_pie_qdisc_enqueue function.

Mohit P. Tahiliani (2):
  net: sched: pie: refactor code
  net: sched: add Flow Queue PIE packet scheduler

 include/net/pie.h              | 401 ++++++++++++++++++++++++
 include/uapi/linux/pkt_sched.h |  33 ++
 net/sched/Kconfig              |  11 +
 net/sched/Makefile             |   1 +
 net/sched/sch_fq_pie.c         | 550 +++++++++++++++++++++++++++++++++
 net/sched/sch_pie.c            | 386 +----------------------
 6 files changed, 1011 insertions(+), 371 deletions(-)
 create mode 100644 include/net/pie.h
 create mode 100644 net/sched/sch_fq_pie.c

-- 
2.17.1

