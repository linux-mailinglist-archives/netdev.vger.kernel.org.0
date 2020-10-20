Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EFB2932B2
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 03:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390042AbgJTBcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 21:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbgJTBcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 21:32:47 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FD6C0613CE;
        Mon, 19 Oct 2020 18:32:47 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id lw2so43281pjb.3;
        Mon, 19 Oct 2020 18:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7PhAZtg/BFVMsF4tamdcXhu9GIS9y/nrr+PwnZqbTS4=;
        b=Y/+tbhVtsm9ciGj0Vc4uVMW1/U6GfU7pG5oaMaq8FZaHbdwx6seA9W9rbmnCxPEZ1y
         5AaRRUZRCeuVPTK71wZAc/qO52DQ2LKFE/Z78vmLpR8kB+Y6mbu4BfabHFbgPW0OEGky
         eADfgWb4c6NowtGbF0Xv5yNEfFKSXO8L1B5N+S7fziA1IelpIdU6h8NMM/u5+h1qlIrW
         cEdqD0J69dNPcexchC20/X5HucnvZchCALgSyN3s9Fs33tHb6WmQrCRSexN9JiW5cSiW
         MX5lsxh/cocbQi8UJGOlz/WEe07c/boLBoHEGAlB7HlzCpZ/S4OIZFBIHOOYozSFO0wa
         3Lvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7PhAZtg/BFVMsF4tamdcXhu9GIS9y/nrr+PwnZqbTS4=;
        b=MST/sA4NHeI1nG0n28Ny85JpiqlUlIAAHpT3joV3qTT54ZCkmbkGdY3fMe4mcyg2NZ
         90Q0GHY7kR/DI2aYcI62HPV6WZLvgXr4Q8eRnEi//pWIBJZrz1mRpPg/uB4MhMrQ7Tba
         mi5x9djyLADTXwQ7OCEHS91TTknZa/e9JkZMPtHCjf5qnOgIjSu+ILQS9LfxGmBrSrKO
         d/jARibOv7fk+cr0hGWEySs0f9XdNHKr87yQRoLUU6cHEeSupnu8VCiGPcLtqje5xGUC
         el+gQ88kk+QmVb6JGst8dM3FcD1xj9kkXc9VYaA0U13kDuOPE117+zw4thFHAwTd23BI
         8FOQ==
X-Gm-Message-State: AOAM531r9m57Y81xaINLmj1xUcmf5B7GgptHYxSB5KDUZlLy0/sX5yC2
        B6tc2bk68H0DkmNAXrJLmIU=
X-Google-Smtp-Source: ABdhPJxitRwPVpb07mMZCWVhh0PgKx/2rU0rhTPoM2psB9tUMaHDYqCv9hTZeodjoWB4wN/pOhSUgA==
X-Received: by 2002:a17:902:c410:b029:d3:d4ae:87fb with SMTP id k16-20020a170902c410b02900d3d4ae87fbmr533253plk.81.1603157567454;
        Mon, 19 Oct 2020 18:32:47 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6caa:ebf2:3bbb:f04e])
        by smtp.gmail.com with ESMTPSA id e21sm68355pgi.91.2020.10.19.18.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 18:32:46 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net v2] net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device
Date:   Mon, 19 Oct 2020 18:31:52 -0700
Message-Id: <20201020013152.89259-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hdlc_rcv function is used as hdlc_packet_type.func to process any
skb received in the kernel with skb->protocol == htons(ETH_P_HDLC).
The purpose of this function is to provide second-stage processing for
skbs not assigned a "real" L3 skb->protocol value in the first stage.

This function assumes the device from which the skb is received is an
HDLC device (a device created by this module). It assumes that
netdev_priv(dev) returns a pointer to "struct hdlc_device".

However, it is possible that some driver in the kernel (not necessarily
in our control) submits a received skb with skb->protocol ==
htons(ETH_P_HDLC), from a non-HDLC device. In this case, the skb would
still be received by hdlc_rcv. This will cause problems.

hdlc_rcv should be able to recognize and drop invalid skbs. It should
first make sure "dev" is actually an HDLC device, before starting its
processing. This patch adds this check to hdlc_rcv.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 9b00708676cf..1bdd3df0867a 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -46,7 +46,15 @@ static struct hdlc_proto *first_proto;
 static int hdlc_rcv(struct sk_buff *skb, struct net_device *dev,
 		    struct packet_type *p, struct net_device *orig_dev)
 {
-	struct hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct hdlc_device *hdlc;
+
+	/* First make sure "dev" is an HDLC device */
+	if (!(dev->priv_flags & IFF_WAN_HDLC)) {
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
+	}
+
+	hdlc = dev_to_hdlc(dev);
 
 	if (!net_eq(dev_net(dev), &init_net)) {
 		kfree_skb(skb);
-- 
2.25.1

