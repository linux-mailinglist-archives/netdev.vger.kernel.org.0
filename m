Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5FAA131161
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 12:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgAFLXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 06:23:03 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18892 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726561AbgAFLXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 06:23:02 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 006BFRXo024242;
        Mon, 6 Jan 2020 03:23:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=XzKCPx/Bwj4cR3ah+G1m2/nfrtMv6Mkv0Hw+0rfbpEg=;
 b=H/q2UoE6ki5bAteNxaSeJ09qMqKxZjcjWnoEb4jozBtmDCFUQ53jLrs9ZV1Eu7mlzvCT
 8gvg8OaeXHb4KB2EpN+qFZOt4VynLz7tpXeV0o65wdK6yzPVnY1LeOgemUG4rVxMuSDz
 5S34kAqMzJrp9xnevccQ0VzuoYGA642y1MLpmBbVUCOAyPCTCS3APt0edb+c+SAHWMOJ
 zhysgrYMuynntA5jQI82YB1jHb4Y+3gj5sAxhKSTR5NGg91JHdE741jq1ny6NGiudLn8
 Nyc3djuxXXFE3ycckVHZ4qxc/OpTUY6xoaE36uSvRljj11Qj7rUIDLGvzH0yIK0TNnUO VQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xarxv5k2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jan 2020 03:23:01 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jan
 2020 03:22:59 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jan 2020 03:22:59 -0800
Received: from NN-LT0019.marvell.com (unknown [10.9.16.57])
        by maili.marvell.com (Postfix) with ESMTP id A51893F7041;
        Mon,  6 Jan 2020 03:22:58 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net 2/3] net: atlantic: loopback configuration in improper place
Date:   Mon, 6 Jan 2020 14:22:29 +0300
Message-ID: <ef2f2275fde3898c2adba53ebbdc2faaddde31a3.1578059294.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.24.1.windows.2
In-Reply-To: <cover.1578059294.git.irusskikh@marvell.com>
References: <cover.1578059294.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-06_04:2020-01-06,2020-01-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial loopback configuration should be called earlier, before
starting traffic on HW blocks. Otherwise depending on race conditions
it could be kept disabled.

Fixes: ea4b4d7fc106 ("net: atlantic: loopback tests via private flags")
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index a17a4da7bc15..c85e3e29012c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -403,6 +403,8 @@ int aq_nic_start(struct aq_nic_s *self)
 	if (err < 0)
 		goto err_exit;
 
+	aq_nic_set_loopback(self);
+
 	err = self->aq_hw_ops->hw_start(self->aq_hw);
 	if (err < 0)
 		goto err_exit;
@@ -413,8 +415,6 @@ int aq_nic_start(struct aq_nic_s *self)
 
 	INIT_WORK(&self->service_task, aq_nic_service_task);
 
-	aq_nic_set_loopback(self);
-
 	timer_setup(&self->service_timer, aq_nic_service_timer_cb, 0);
 	aq_nic_service_timer_cb(&self->service_timer);
 
-- 
2.20.1

