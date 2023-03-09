Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7CD6B2201
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjCIK5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjCIK4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:56:31 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BAEE982F
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 02:55:13 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329ALh20013922;
        Thu, 9 Mar 2023 02:55:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=ODN61q7IeygtRing57sYlfcuJ49t+FhakgwvNj/F8dg=;
 b=AHxjbbpooIeMY/ep+QqtDPwFnd2qSNaL7EfVNPk4r4tLgkcc5pFY7t3jpvXfpW5z/YmA
 xy/RZxN3qjVCYLlOd+YstRGkWxKx3l3bloSLAtDZE7f7QlDOeu5pduBOXgthDgKWc3NK
 7RkwvbeBIs4hn02ccrPF7Cqa68f/S80NKkgnCw57cpnAXDND1iAJgZ9bGh6PXcMKb7hO
 XXIK+JVBeTxVChiEHtWa4MZWdvHwwKBazJCyH2eEAEDI0XDWQdPChgl7UBz8pGU0/7yF
 ZeTiBfDrzgdTYbUk2ZGLU1A9PC/4ehm6xVqElSMZjT9k9Raw1TCFSx/1O9/jD2kEi2mR 2Q== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p746p326j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Mar 2023 02:55:08 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server id
 15.1.2507.17; Thu, 9 Mar 2023 02:54:34 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        <netdev@vger.kernel.org>
Subject: [PATCH RESEND net-next] ptp_ocp: add force_irq to xilinx_spi configuration
Date:   Thu, 9 Mar 2023 02:54:21 -0800
Message-ID: <20230309105421.2953451-1-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-ORIG-GUID: iarwqX0ECYOY5m0__Hm0EYYPy4yud4tW
X-Proofpoint-GUID: iarwqX0ECYOY5m0__Hm0EYYPy4yud4tW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_06,2023-03-08_03,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flashing firmware via devlink flash was failing on PTP OCP devices
because it is using Quad SPI mode, but the driver was not properly
behaving. With force_irq flag landed it now can be fixed.

Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 drivers/ptp/ptp_ocp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4bbaccd543ad..2b63f3487645 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -662,6 +662,7 @@ static struct ocp_resource ocp_fb_resource[] = {
 				.num_chipselect = 1,
 				.bits_per_word = 8,
 				.num_devices = 1,
+				.force_irq = true,
 				.devices = &(struct spi_board_info) {
 					.modalias = "spi-nor",
 				},
-- 
2.30.2

