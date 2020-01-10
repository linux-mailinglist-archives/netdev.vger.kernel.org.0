Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB23136766
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbgAJG1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 01:27:13 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:40912 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731495AbgAJG1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:27:12 -0500
Received: by mail-pg1-f180.google.com with SMTP id k25so504501pgt.7
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 22:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DwAeG1q2U5MtGjMXKj/C+Yj7VuMBhv4bDmYZtUidW20=;
        b=EtZopCZgL6hZwBsfZMazBnnVYkIU2irUL+rpV6la748NA0ShBcWbYIWh29YkLwHGiu
         glw7hyCnyGZVwVpML6rMLNoe/UxOsYzmbl8ss8FeQ/46bA5vNLqiZPtaQGoQFG2ac82g
         R90ThMpl+MFomf8gICOV4cThlKRpIA18sL7HWJd8WP4vb8SCkjc7tJNI1D7h+e8AwbxF
         Pk66jUYz1oK5TT2L0N8/Jmz6HWyP9HHW2IS9kHxmxSpXvxYX+W4Tl1TCN8odvkgSJI/8
         TwWI3cyDtGcIpg53fIWtnZDGvEbds70upgvrKxIfvd2P7euJJSkWpMReAhQIQNrp7Uiz
         pj9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DwAeG1q2U5MtGjMXKj/C+Yj7VuMBhv4bDmYZtUidW20=;
        b=FL/w9qb2o+HhrQ5ckP3OLjsuOONgR2LL8BdOFfk/Zh5RazSUOkTehwHLn+6ZZRcKEE
         AzMDkZJoSEQzEyV29Jef40jjJp7h/DLzhEiurtxh2NrYsfzq3kyn127aUhEXzNZiBdHp
         LaqBIV5zANEIeLRxHp7Skzei/wOsXOYGgTMO8W/FxMQGR9lK4MyYsdnj3QeUsOXtINB4
         9/uG3Fv5HpjH7ZzsUV5OGxOXZFDmx/7Vjurfwq/p71HzXXUt+gvxVocrmhTh3W1lpdec
         RcJSHI2wD6skYNG4oDFJxnVVutWEJnCSu4F4jDvH3xCrcJkHwJ3YWWBko44sYY/Dx2gE
         DV5A==
X-Gm-Message-State: APjAAAU+A/oQCZtINCaJ+fnpCCbdlT1pvX2Ae4jxCikc6OaHR6JLhePB
        2oInhi+eWARNkyr4P8nIWhGYcTN6eo+qYQ==
X-Google-Smtp-Source: APXvYqzNhabkYX/6O6mnMTUPDSHv7R3k5sqolcYunke7+fNG17wU5RCnvSdPfkcVw6XCqYpUKK68Dg==
X-Received: by 2002:a65:5608:: with SMTP id l8mr2475327pgs.210.1578637631615;
        Thu, 09 Jan 2020 22:27:11 -0800 (PST)
Received: from localhost.localdomain ([223.186.236.152])
        by smtp.gmail.com with ESMTPSA id u12sm1139011pfm.165.2020.01.09.22.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 22:27:10 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Subject: [PATCH net-next v3 0/2] net: sched: add Flow Queue PIE packet scheduler
Date:   Fri, 10 Jan 2020 11:56:55 +0530
Message-Id: <20200110062657.7217-1-gautamramk@gmail.com>
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


Mohit P. Tahiliani (2):
  net: sched: pie: refactor code
  net: sched: add Flow Queue PIE packet scheduler

 include/net/pie.h              | 138 +++++++++
 include/uapi/linux/pkt_sched.h |  33 ++
 net/sched/Kconfig              |  12 +
 net/sched/Makefile             |   1 +
 net/sched/sch_fq_pie.c         | 550 +++++++++++++++++++++++++++++++++
 net/sched/sch_pie.c            | 302 +++++++-----------
 6 files changed, 846 insertions(+), 190 deletions(-)
 create mode 100644 include/net/pie.h
 create mode 100644 net/sched/sch_fq_pie.c

-- 
2.17.1

