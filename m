Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC01292609
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 12:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgJSKt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 06:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbgJSKt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 06:49:56 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85108C0613CE;
        Mon, 19 Oct 2020 03:49:56 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b6so3130206pju.1;
        Mon, 19 Oct 2020 03:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZeXQB503+W7irppENYUXNUt9TL7p7KQ2c0tGFSb0Ww=;
        b=Q7uTNJ6d2CLKNsu67mfAofdTcCvVFozvXWJ6iIEn3DJqYkhNRKYpY2xX8lBjDbOOFN
         Y8I+H46ZSOVSPWni8neUPrJQ6JrmNEhwoQF3ppOCFnK5y4+242b5ZI9wD4TE8tnCGqCT
         MYlsjeWl6pkcCBtW6i8ALiLL3nKIAews+q3npApTaqIJHvZQ9VXrRDlO6w0/X3nTNwaF
         HdKjFKUo70U+OXywVkqbPNfMU8uny27ENVw7VYLC3pcyYtX7G32uhvNPBLZqMGUn7B7p
         tQqeUu8THLcgHU10a3lkUv1Wc3DVGoEcSZSBBZaR98KiTQpE+sNx7hs0d4oRAOOyPTMf
         yRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZeXQB503+W7irppENYUXNUt9TL7p7KQ2c0tGFSb0Ww=;
        b=KtNAPcqkdmhZO0daRK6eo3ytEOf9Lp+SQhCbDZxCvI8nAgeIDEVNIf0bqXxRtSH3nI
         B8M+3oawFoyXiJMeGjbfdYB2syLRx4K8PENHVn+ePnb5VBwNeSMDNJBDDdh3woeL7nJ5
         mgo4sBESHVhVw4GSNKYTrH6HPTzmoU+XJq6ySW+U3PN6XlGaq5sQVvt7dG1uKEjh35Lj
         aQulJk2O9DLpPzUt1ifaQL37/JyqXzYO5VOVuW+A+y+32DAFJpdEP+jjxxKGuGdLNCU4
         rGleztaPlPsUwyDY9mOZmENggcU1glJjFiGqXGWlS+ij4gX0HhNRaLFJ+rhuoSD/XlPZ
         u9ew==
X-Gm-Message-State: AOAM530AAWExfYv5n/uiv/CjoPS08qXXPkdXYXM56ggn+yd7MHObKDu6
        zVz5gLCexQnLS+XMaIU6Wbk=
X-Google-Smtp-Source: ABdhPJwD9HD7pSgL5Ol97zW0d1cfKEe8k5iy5UGa6MeEf+b8hl7dAmKnMLFAmMkpyEV3aRcxRNWvFQ==
X-Received: by 2002:a17:902:7284:b029:d5:e92b:fe67 with SMTP id d4-20020a1709027284b02900d5e92bfe67mr3139202pll.44.1603104596095;
        Mon, 19 Oct 2020 03:49:56 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:b903:ac74:ad6d:beb7])
        by smtp.gmail.com with ESMTPSA id f4sm11194694pjs.8.2020.10.19.03.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 03:49:55 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] drivers/net/wan/hdlc: In hdlc_rcv, check to make sure dev is an HDLC device
Date:   Mon, 19 Oct 2020 03:49:42 -0700
Message-Id: <20201019104942.364914-1-xie.he.0141@gmail.com>
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
processing.

To reliably check if a device is an HDLC device, we can check if its
dev->netdev_ops->ndo_start_xmit == hdlc_start_xmit, because all HDLC
devices are required to set their ndo_start_xmit to hdlc_start_xmit
(and all non-HDLC devices would not set their ndo_start_xmit to this).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 9b00708676cf..0a392fb9aff8 100644
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
+	if (dev->netdev_ops->ndo_start_xmit != hdlc_start_xmit) {
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
+	}
+
+	hdlc = dev_to_hdlc(dev);
 
 	if (!net_eq(dev_net(dev), &init_net)) {
 		kfree_skb(skb);
-- 
2.25.1

