Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68DCA36681
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfFEVMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:07 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38496 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbfFEVMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so162179qkk.5
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/Q++++o00AF5V9ZUexI0wyJ3BHrrSACJG9scGtGgRc=;
        b=aMlQ3zPiGnH4sEMwjlZp8q+AEYmeBIThva655lT7sCo1dKt9/jJRk51gJ94UpjjuDh
         NJvTLNBs2h3NjkTguSuDhT3+VrdwMRiKm2pW9LJIbQBNzP/uaj0Fvn4fqPGARhA0ezR6
         ncnDyJ72kzL3QNF16/3pTvNTgVPztK4GohEkkwax494S8osa/ESZWApHTvI9O2SQ8b/u
         ptRBEt7fqQyVnypHBXtuDIp8rTuo6NRnSfPIA+ZA2GfIdbshG8xcMFSQ7cv3lKdMqVUv
         XOM5YmB5BuBQdRAImYkG9F/zaWxlvy0cUyGELlQbCaDwSp7z6PvsMIhGE017ofmL2Blr
         ppdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/Q++++o00AF5V9ZUexI0wyJ3BHrrSACJG9scGtGgRc=;
        b=BgD0LXXOsnA375YW882hTt4TyVEAM9TcFjIvFdKC3dMtIKfM5hi4JQ9w2mB+FE06qP
         yu9lnJ9iDmqCPWNxirla64Kk4S8daD5jRc7ME3lf84IOZHwMq5x7Ft/kKa6+8qb1TkEn
         XVKrmg/R5/oUnMOJUvb2HOMt17ioRrZM+ahyxL2Rd5sQQ0tANiOU8nzEh/m3MX3OFK8y
         BMH9v5IlcyX7EXXpGcfS7DssTJYXEw/887Q82s/Y9RRfaxzeggXjQyn6U7vLb4WGf79N
         68+9zbD+hfuFYEOynt4+KJ/dLb7dYKq337uSJaxz+OFsW9BAmdG2YZxWThdVdkX65PUB
         EZyw==
X-Gm-Message-State: APjAAAWqy5UIZHN0oW90+LCHi2sLQKezhFXGnb1mG1dMTGeI8CpfSCvl
        DxHO7Lycuk07DD5TH7rcA5GUVg==
X-Google-Smtp-Source: APXvYqzxz+zeemDInevJ8fUeow1J6SISCeVFJG+8z3Q3qM0BrV5xJ2dk8nKbKNrUouvvRO8C2yP9PQ==
X-Received: by 2002:a37:9d04:: with SMTP id g4mr34365102qke.52.1559769125701;
        Wed, 05 Jun 2019 14:12:05 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:05 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 03/13] nfp: parse the mailbox cmsg TLV
Date:   Wed,  5 Jun 2019 14:11:33 -0700
Message-Id: <20190605211143.29689-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parse the mailbox TLV.  When control message queue is not available
we can fall back to passing the control messages via the vNIC
mailbox.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c | 4 ++++
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
index 6d5213b5bcb0..6c207c5e9265 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
@@ -99,6 +99,10 @@ int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
 
 			caps->repr_cap = readl(data);
 			break;
+		case NFP_NET_CFG_TLV_TYPE_MBOX_CMSG_TYPES:
+			if (length >= 4)
+				caps->mbox_cmsg_types = readl(data);
+			break;
 		default:
 			if (!FIELD_GET(NFP_NET_CFG_TLV_HEADER_REQUIRED, hdr))
 				break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 25919e338071..05a5c82ac8f6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -466,6 +466,11 @@
  * %NFP_NET_CFG_TLV_TYPE_REPR_CAP:
  * Single word, equivalent of %NFP_NET_CFG_CAP for representors, features which
  * can be used on representors.
+ *
+ * %NFP_NET_CFG_TLV_TYPE_MBOX_CMSG_TYPES:
+ * Variable, bitmap of control message types supported by the mailbox handler.
+ * Bit 0 corresponds to message type 0, bit 1 to 1, etc.  Control messages are
+ * encapsulated into simple TLVs, with an end TLV and written to the Mailbox.
  */
 #define NFP_NET_CFG_TLV_TYPE_UNKNOWN		0
 #define NFP_NET_CFG_TLV_TYPE_RESERVED		1
@@ -475,6 +480,7 @@
 #define NFP_NET_CFG_TLV_TYPE_EXPERIMENTAL0	5
 #define NFP_NET_CFG_TLV_TYPE_EXPERIMENTAL1	6
 #define NFP_NET_CFG_TLV_TYPE_REPR_CAP		7
+#define NFP_NET_CFG_TLV_TYPE_MBOX_CMSG_TYPES	10
 
 struct device;
 
@@ -484,12 +490,14 @@ struct device;
  * @mbox_off:		vNIC mailbox area offset
  * @mbox_len:		vNIC mailbox area length
  * @repr_cap:		capabilities for representors
+ * @mbox_cmsg_types:	cmsgs which can be passed through the mailbox
  */
 struct nfp_net_tlv_caps {
 	u32 me_freq_mhz;
 	unsigned int mbox_off;
 	unsigned int mbox_len;
 	u32 repr_cap;
+	u32 mbox_cmsg_types;
 };
 
 int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
-- 
2.21.0

