Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3132018F56B
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgCWNOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:14:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58436 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728240AbgCWNOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:14:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ND6LZM019104;
        Mon, 23 Mar 2020 06:14:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=9fs6nDV5mQA+2KJYT5Mllt00nd4z3LNGfsgoCjG2Wao=;
 b=k9GIxP24NInvS6vphgFUUJbD8ufazj1HG8MhdvBIK+8Iead32DF66arzTjZf6IogYMTX
 S5uqxwfp+qcXq4Fd9vu/M6CzqNvkac0fI8pJpS5tlhWHRxMheSOY3HkWihMcJKwMECpG
 j99VyD6Y43JDvFWmADBuZVph6kUk2jOHvMY5hzeNFBuqbbPgD14f8yf8igfNtKP+VYP4
 8I/QBdDOMZIvlWYRW7rUg+GzWHLBUjMhLn4wubzx7d+x42cLLFKIV/G9Da6Fhc7NDHFY
 qZzqL7b+fOqGrpAj7gGm/EU8OuzozHnYmH7IoIixK6KbAotkuznTrqYdAMWep1wilEel ig== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqmn3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 06:14:48 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:14:46 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 06:14:46 -0700
Received: from localhost.localdomain (unknown [10.9.16.91])
        by maili.marvell.com (Postfix) with ESMTP id C7E093F7041;
        Mon, 23 Mar 2020 06:14:44 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 03/17] net: macsec: allow to reference a netdev from a MACsec context
Date:   Mon, 23 Mar 2020 16:13:34 +0300
Message-ID: <20200323131348.340-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323131348.340-1-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_04:2020-03-21,2020-03-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

This patch allows to reference a net_device from a MACsec context. This
is needed to allow implementing MACsec operations in net device drivers.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/net/macsec.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/macsec.h b/include/net/macsec.h
index 2e4780dbf5c6..71de2c863df7 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -220,7 +220,10 @@ struct macsec_secy {
  * struct macsec_context - MACsec context for hardware offloading
  */
 struct macsec_context {
-	struct phy_device *phydev;
+	union {
+		struct net_device *netdev;
+		struct phy_device *phydev;
+	};
 	enum macsec_offload offload;
 
 	struct macsec_secy *secy;
-- 
2.17.1

