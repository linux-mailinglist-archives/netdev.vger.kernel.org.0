Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E624ED4C1
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 09:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiCaH3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 03:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiCaH3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 03:29:03 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F05C6811
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 00:27:16 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id yy13so46226945ejb.2
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 00:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvu8rz9cP/tdlkhq2cwevWc78KdfThG0T1nMSudnVUM=;
        b=Eht3iYGjLrVYj2cUzLhGdgq3Hvac9n33VlylDxub/hl9SxSRzrlAD8p1+xkslR9G6k
         F2B7kuAGM81YXqf/WyCABQ3YpQ+vHJLBPbME5uSJWXUtM6P+MFaa9zvWtQ7HJsetD/vN
         p0ZXJl1AO/Asl1s8040N9fbB0AN2uFn6FUpNEWqfIri+i/89TYL7V/Jnbdj+8bjYAgXq
         99sQzvviPmf0CtroamWAZNiAAvHYqNMzRFjpWIjMBKnhjrQKzpufHXu4axEH1FK+JF/s
         eHRORXodoLevbBIxzzGENbrseEGb39TZ6ZBPtJNK8u/v/rxtJPGwED43EOTiHD1UjW96
         1gIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvu8rz9cP/tdlkhq2cwevWc78KdfThG0T1nMSudnVUM=;
        b=5KFNyW2pyS9va3w8DSZGu8gVik+1y5RsHgzIJxUWyIazP8iSRfXSDPmm1QahBPOlNE
         zHJr3KjlqDP6CEnHlhMO5/T6Tq0ejqxR+bquzx5sKLF9LRQcePQiNvioM8Sf2FBP8lpA
         0W19/XVMnnOJlMJpub8TWMQk/flOM62Ib+hLShVWGTM5i+zxs6beodHqlTYz6mMyTBRc
         1JILIcb9J6iDlWjQ08RtLLp88Rn2ULFQ3dS0ZLWvuMdncMWwF73uSIPoWcQrutK9zDaP
         2KrUOQsGju7rAip2bbJeciIVmH6NKyVyPZx5YQmJSXVA2I/6XLoxmsqfZKw+9gpOBvnJ
         tUDQ==
X-Gm-Message-State: AOAM532mfhnY1z8SMbQkWAh1CaQetEf6OSh/h7BaeV6lrIdgRTmEaasv
        ZU8CQ+ByOTjr2qsZnTqLOCU=
X-Google-Smtp-Source: ABdhPJyRCXknoyfRhafTqNkGopGMivYbxYOT/1I+vNXwsUKUqSM57l4EDPrkXbvzBBfgrlu8i1O7Ag==
X-Received: by 2002:a17:907:3f07:b0:6e0:2fa0:2482 with SMTP id hq7-20020a1709073f0700b006e02fa02482mr3686050ejc.766.1648711634893;
        Thu, 31 Mar 2022 00:27:14 -0700 (PDT)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id g21-20020a056402115500b00413c824e422sm10751887edw.72.2022.03.31.00.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 00:27:14 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, andrea.mayer@uniroma2.it
Cc:     netdev@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH net] vrf: fix packet sniffing for traffic originating from ip tunnels
Date:   Thu, 31 Mar 2022 10:26:43 +0300
Message-Id: <20220331072643.3026742-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in commit 048939088220
("vrf: add mac header for tunneled packets when sniffer is attached")
an Ethernet header was cooked for traffic originating from tunnel devices.

However, the header is added based on whether the mac_header is unset
and ignores cases where the device doesn't expose a mac header to upper
layers, such as in ip tunnels like ipip and gre.

Traffic originating from such devices still appears garbled when capturing
on the vrf device.

Fix by observing whether the original device exposes a header to upper
layers, similar to the logic done in af_packet.

In addition, skb->mac_len needs to be adjusted after adding the Ethernet
header for the skb_push/pull() surrounding dev_queue_xmit_nit() to work
on these packets.

Fixes: 048939088220 ("vrf: add mac header for tunneled packets when sniffer is attached")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 drivers/net/vrf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 85e362461d71..cfc30ce4c6e1 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1265,6 +1265,7 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
 	eth = (struct ethhdr *)skb->data;
 
 	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
 
 	/* we set the ethernet destination and the source addresses to the
 	 * address of the VRF device.
@@ -1294,9 +1295,9 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
  */
 static int vrf_add_mac_header_if_unset(struct sk_buff *skb,
 				       struct net_device *vrf_dev,
-				       u16 proto)
+				       u16 proto, struct net_device *orig_dev)
 {
-	if (skb_mac_header_was_set(skb))
+	if (skb_mac_header_was_set(skb) && dev_has_header(orig_dev))
 		return 0;
 
 	return vrf_prepare_mac_header(skb, vrf_dev, proto);
@@ -1402,6 +1403,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 	/* if packet is NDISC then keep the ingress interface */
 	if (!is_ndisc) {
+		struct net_device *orig_dev = skb->dev;
+
 		vrf_rx_stats(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
@@ -1410,7 +1413,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 			int err;
 
 			err = vrf_add_mac_header_if_unset(skb, vrf_dev,
-							  ETH_P_IPV6);
+							  ETH_P_IPV6,
+							  orig_dev);
 			if (likely(!err)) {
 				skb_push(skb, skb->mac_len);
 				dev_queue_xmit_nit(skb, vrf_dev);
@@ -1440,6 +1444,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 				  struct sk_buff *skb)
 {
+	struct net_device *orig_dev = skb->dev;
+
 	skb->dev = vrf_dev;
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
@@ -1460,7 +1466,8 @@ static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 	if (!list_empty(&vrf_dev->ptype_all)) {
 		int err;
 
-		err = vrf_add_mac_header_if_unset(skb, vrf_dev, ETH_P_IP);
+		err = vrf_add_mac_header_if_unset(skb, vrf_dev, ETH_P_IP,
+						  orig_dev);
 		if (likely(!err)) {
 			skb_push(skb, skb->mac_len);
 			dev_queue_xmit_nit(skb, vrf_dev);
-- 
2.25.1

