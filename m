Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A350A19291B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCYNDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:03:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58680 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726998AbgCYNDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:03:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCso1n018250;
        Wed, 25 Mar 2020 06:03:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=KLJ48gbUc8+HlhYRMXHKB7za/+UwzCPDPMcfLaS7sKE=;
 b=lKrjOQHyfRLF8e/4+gOHERbn17oEcVk0eA6lF2BH8Y0Q+x+mJEtbjgc5FB/6SR+aoZfO
 Ytxlp0v2wy8cavsZtvZnVqNmJ8Vn1MgiCSsusfDUEaDJaAFHP3lpj0RkwG1KuikCSdv5
 NM7/RJtDHqfJGKfelt/4VQB33dqKT618NDJDMo0IDeHGnzQlNN+34fA5EPlPgBdhzEci
 BjTlU9xMKQC70u1+WaebkBDkLSsh+TU4drRdqYW1+6fD5b37R33/HpSvE0M2oC709Q98
 nkxgMdDxiEkMbQwoiKd69wUUgyEh19Gm6ut43a7pWEohh6vVUkL/Tt5yg+bZvw+c337u ew== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3006xkr71e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 06:03:46 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 06:03:43 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 06:03:43 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id 9EE343F703F;
        Wed, 25 Mar 2020 06:03:42 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next] net: macsec: add support for specifying offload upon link creation
Date:   Wed, 25 Mar 2020 16:01:34 +0300
Message-ID: <20200325130134.1129-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds new netlink attribute to allow a user to (optionally)
specify the desired offload mode immediately upon MACSec link creation.

Separate iproute patch will be required to support this from user space.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c               | 31 ++++++++++++++++++++++++++++--
 include/uapi/linux/if_link.h       |  1 +
 tools/include/uapi/linux/if_link.h |  1 +
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 49b138e7aeac..6fc2ed6df09c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1445,6 +1445,11 @@ static struct net_device *get_dev_from_nl(struct net *net,
 	return dev;
 }
 
+static enum macsec_offload nla_get_offload(const struct nlattr *nla)
+{
+	return (__force enum macsec_offload)nla_get_u8(nla);
+}
+
 static sci_t nla_get_sci(const struct nlattr *nla)
 {
 	return (__force sci_t)nla_get_u64(nla);
@@ -3861,8 +3866,16 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 
 	macsec->real_dev = real_dev;
 
-	/* MACsec offloading is off by default */
-	macsec->offload = MACSEC_OFFLOAD_OFF;
+	if (data && data[IFLA_MACSEC_OFFLOAD])
+		macsec->offload = nla_get_offload(data[IFLA_MACSEC_OFFLOAD]);
+	else
+		/* MACsec offloading is off by default */
+		macsec->offload = MACSEC_OFFLOAD_OFF;
+
+	/* Check if the offloading mode is supported by the underlying layers */
+	if (macsec->offload != MACSEC_OFFLOAD_OFF &&
+	    !macsec_check_offload(macsec->offload, macsec))
+		return -EOPNOTSUPP;
 
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
@@ -3905,6 +3918,20 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 			goto del_dev;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(macsec, &ctx);
+		if (ops) {
+			ctx.secy = &macsec->secy;
+			err = macsec_offload(ops->mdo_add_secy, &ctx);
+			if (err)
+				goto del_dev;
+		}
+	}
+
 	err = register_macsec_dev(real_dev, dev);
 	if (err < 0)
 		goto del_dev;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 61e0801c82df..f256ab912d49 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -463,6 +463,7 @@ enum {
 	IFLA_MACSEC_REPLAY_PROTECT,
 	IFLA_MACSEC_VALIDATION,
 	IFLA_MACSEC_PAD,
+	IFLA_MACSEC_OFFLOAD,
 	__IFLA_MACSEC_MAX,
 };
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 024af2d1d0af..e88e049bdacc 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -463,6 +463,7 @@ enum {
 	IFLA_MACSEC_REPLAY_PROTECT,
 	IFLA_MACSEC_VALIDATION,
 	IFLA_MACSEC_PAD,
+	IFLA_MACSEC_OFFLOAD,
 	__IFLA_MACSEC_MAX,
 };
 
-- 
2.17.1

