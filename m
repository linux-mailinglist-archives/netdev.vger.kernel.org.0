Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FF72A1938
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgJaSLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgJaSLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:11:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D711FC0617A6;
        Sat, 31 Oct 2020 11:11:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id k9so5857202pgt.9;
        Sat, 31 Oct 2020 11:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4OdtTTsb5oeQcbyGruvkyQTB5rSp5snExHVKrgbeYhs=;
        b=b2HQaM9bDwVaJZGMnqXVrOHjGpNMIAil1UOmN2Q/SkHERrnbPZW+C11CUSavFQhTuZ
         xhZDBL5lzob7l+saB3ifrhMs47dd8XYun5mebYVpQC+jHvyoPOmcgJbvPLTnw0URpCut
         dykeA5gEuG2B7++bvVVoU+81iHyRsWZzZwi0n9l8+OmgVMhBcmB1pZi4UGSb6uT2CGy0
         VG96fYUCK28W/9cC2nM7WFtPaLd2d/fr3RS2rtg6QV1w9Pm80Duz05VflrwY/KNQEL5M
         MpriPXYPUcUKQEIsYhLkWB1a0NS6oGuZqycxDeEgrXj48nnLz7wMTx4tRnU09metbKqw
         1B9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4OdtTTsb5oeQcbyGruvkyQTB5rSp5snExHVKrgbeYhs=;
        b=I1AwgPdjQ8Zu4M63co+CQ/nMQrTX9KrZq+1CSn5TwD3wMaJAlykZJuv/DEWEOANlhk
         KA2pe/IsJ+z18rClBORN8lgMG7Y1UViB3Xb+VNalYHSeecTdLnnM6GUuy/ab3BdES+FM
         YQ16+vghdHyDkFwJRAZkp6U5jZpAsrnfA8owQNK717cRlJLHg8Ug1JDwH7Q6eKXHP934
         oBu0x+ReX3g2aI0OBsKkgvGMG5DkG33GWbud5FtXUYBRkkNsF+/MLpaRCyVCZjFGVzJr
         9Q1fcOIR3Bz1ZJhpQjUB3azvzaayi4R2kOX/C4die8jcQP78JADSmAHgXwREclMPrcbK
         Pcpg==
X-Gm-Message-State: AOAM5317OHDHWCsQMYeRrixoz0ZGwe0ziH2xMT7kz0ILWX2gOnxU190k
        mk41tbaokTg/JegASbcSqUw=
X-Google-Smtp-Source: ABdhPJwQHfWFbnndm62dCjmdUfizBXIAMudribvjIBhRN3fSmtVcaPgXr84h4mEvefbpHBzmYVqLAg==
X-Received: by 2002:a63:5b64:: with SMTP id l36mr7045365pgm.435.1604167906480;
        Sat, 31 Oct 2020 11:11:46 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:32f8:16e7:6105:7fb5])
        by smtp.gmail.com with ESMTPSA id n6sm6967137pjj.34.2020.10.31.11.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:11:46 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v7 3/5] net: hdlc_fr: Do skb_reset_mac_header for skbs received on normal PVC devices
Date:   Sat, 31 Oct 2020 11:10:41 -0700
Message-Id: <20201031181043.805329-4-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031181043.805329-1-xie.he.0141@gmail.com>
References: <20201031181043.805329-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an skb is received on a normal (non-Ethernet-emulating) PVC device,
call skb_reset_mac_header before we pass it to upper layers.

This is because normal PVC devices don't have header_ops, so any header we
have would not be visible to upper layer code when sending, so the header
shouldn't be visible to upper layer code when receiving, either.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 71ee9b60d91b..eb83116aa9df 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -935,6 +935,7 @@ static int fr_rx(struct sk_buff *skb)
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
 		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IP);
+		skb_reset_mac_header(skb);
 
 	} else if (data[3] == NLPID_IPV6) {
 		if (!pvc->main)
@@ -942,6 +943,7 @@ static int fr_rx(struct sk_buff *skb)
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
 		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IPV6);
+		skb_reset_mac_header(skb);
 
 	} else if (skb->len > 10 && data[3] == FR_PAD &&
 		   data[4] == NLPID_SNAP && data[5] == FR_PAD) {
@@ -958,6 +960,7 @@ static int fr_rx(struct sk_buff *skb)
 				goto rx_drop;
 			skb->dev = pvc->main;
 			skb->protocol = htons(pid);
+			skb_reset_mac_header(skb);
 			break;
 
 		case 0x80C20007: /* bridged Ethernet frame */
-- 
2.27.0

