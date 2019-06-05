Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB43A36683
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfFEVMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:10 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42263 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFEVMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so212193qtk.9
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ulUmx8g8SzjRW0G1FmnXVZQ1KCjrxp2ilQlP+1itrt0=;
        b=lFgc4oOxBBHUTX7BMnQr/ACsSjsV+w24HRHG2L8I0gmRajUjPtONDkgpnckp041Rsc
         7NxSm0WDsQHvuN99BA6P51WiesVaQENLLL2M9/pDgcWZhIY4VFXJB2Tf+pkwa+j/oolu
         aLpiqeZ6lM71ujFcHIdLyCJur8gf1+zPrVt2DA2tHR5h2oIR+050JLHvWObnZ2lFajcD
         4GfY9DztCtkUSlHAdILAwUMYhHDFu8bROESylix/RLOi60YA+xYUjXpWXDa3xI3KLZ3o
         VxbiFuV4MQIfxN8YIGinJHmf4DRIf3Q6ptfkfN/uF2QwnUCYI+TNBiVYkUR+yrX5vl4s
         rH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ulUmx8g8SzjRW0G1FmnXVZQ1KCjrxp2ilQlP+1itrt0=;
        b=KQ6Yd3RKkn81/Kzc413+n0FGOxSiP3mwqnLjD9Q3qE2WKxAMYDTm5VN/n9kqkJKd8t
         RA/tdyNSQvJHDrYQ6863YE/USA5zh3xkmgXZXzspzEfXFoLKwRBE1snZnOoORkWSURRY
         P/gGaqu+eUn2djhutu3KHCx45X8hkNBTHTQvfkpuOyfCnIL9BKmp3/cN1+fVvt4Oqaml
         pC/EmghlbwWXYRGAYgozfFr1f9T89fQ2fxj2iUMCSVjWDx2tIpn5qjSexYZ0ZhyDhe0A
         2Gn0Bh8YRBfPIcIrvZKkOH+/KFJR74GS2YEJcbCQ4lLh3Lv3LnRj4tUfGjhqx5IpSNhT
         qQtg==
X-Gm-Message-State: APjAAAUbwFiOXjZLZV4G6fvGkztv29CmmZUE05BbV+JtCqlS3eIN7rAR
        U//cmrcb0vPpfE9PbFw1GuE6fg==
X-Google-Smtp-Source: APXvYqzL2bs3XHlI+8y6VxXQnJ2iwQWj6OOi8iH8VD7bjtnM5j9wvW4+qUM1/C8Nrr2N1Pun1HA1OQ==
X-Received: by 2002:ac8:4619:: with SMTP id p25mr5380387qtn.73.1559769128772;
        Wed, 05 Jun 2019 14:12:08 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:08 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 05/13] nfp: parse crypto opcode TLV
Date:   Wed,  5 Jun 2019 14:11:35 -0700
Message-Id: <20190605211143.29689-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parse TLV containing a bitmask of supported crypto operations.
The TLV contains a capability bitmask (supported operations)
and enabled bitmask.  Each operation describes the crypto
protocol quite exhaustively (protocol, AEAD, direction).

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c | 11 +++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h | 10 ++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
index 6c207c5e9265..d835c14b7257 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
@@ -103,6 +103,17 @@ int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
 			if (length >= 4)
 				caps->mbox_cmsg_types = readl(data);
 			break;
+		case NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS:
+			if (length < 32) {
+				dev_err(dev,
+					"CRYPTO OPS TLV should be at least 32B, is %dB offset:%u\n",
+					length, offset);
+				return -EINVAL;
+			}
+
+			caps->crypto_ops = readl(data);
+			caps->crypto_enable_off = data - ctrl_mem + 16;
+			break;
 		default:
 			if (!FIELD_GET(NFP_NET_CFG_TLV_HEADER_REQUIRED, hdr))
 				break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index b94db7fb691d..bd4e2194dda5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -472,6 +472,11 @@
  * Variable, bitmap of control message types supported by the mailbox handler.
  * Bit 0 corresponds to message type 0, bit 1 to 1, etc.  Control messages are
  * encapsulated into simple TLVs, with an end TLV and written to the Mailbox.
+ *
+ * %NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS:
+ * 8 words, bitmaps of supported and enabled crypto operations.
+ * First 16B (4 words) contains a bitmap of supported crypto operations,
+ * and next 16B contain the enabled operations.
  */
 #define NFP_NET_CFG_TLV_TYPE_UNKNOWN		0
 #define NFP_NET_CFG_TLV_TYPE_RESERVED		1
@@ -482,6 +487,7 @@
 #define NFP_NET_CFG_TLV_TYPE_EXPERIMENTAL1	6
 #define NFP_NET_CFG_TLV_TYPE_REPR_CAP		7
 #define NFP_NET_CFG_TLV_TYPE_MBOX_CMSG_TYPES	10
+#define NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS		11 /* see crypto/fw.h */
 
 struct device;
 
@@ -492,6 +498,8 @@ struct device;
  * @mbox_len:		vNIC mailbox area length
  * @repr_cap:		capabilities for representors
  * @mbox_cmsg_types:	cmsgs which can be passed through the mailbox
+ * @crypto_ops:		supported crypto operations
+ * @crypto_enable_off:	offset of crypto ops enable region
  */
 struct nfp_net_tlv_caps {
 	u32 me_freq_mhz;
@@ -499,6 +507,8 @@ struct nfp_net_tlv_caps {
 	unsigned int mbox_len;
 	u32 repr_cap;
 	u32 mbox_cmsg_types;
+	u32 crypto_ops;
+	unsigned int crypto_enable_off;
 };
 
 int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
-- 
2.21.0

