Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7744F30A1C3
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 07:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhBAGA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 01:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhBAF6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 00:58:36 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D8EC0613ED;
        Sun, 31 Jan 2021 21:57:18 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z9so1698767pjl.5;
        Sun, 31 Jan 2021 21:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9WcgY/7dzWX3O9rNeZQ45WY9vESYPTTGXpSkl0YUkI=;
        b=Ih0G2mIOJJKmBb2ZACWolGcOpStbwLKcyk6kFoADEB0DP5RFHVEQumuS4q1QL6gRhx
         XymbM/t3dKVkAO2sV6yIHPRjw93zfHa/7CSinrC2hfs9k0QVVs5hJ8g8APHdfTjetOtk
         yKHRMGH37CXPXbVtEgNJSPQ9s5dHSs7HprVGRGLZHFR7i7UMz3NO2acZuKmAHVqlUcQp
         q4z627DeuguOgMLczPFgl5UeNWiVCe1dPCmCEf2VosjvxwZs9qHAW927MooWjH0hbFF2
         4cIngYZIjDY/Pa2MflMjZSp1hHe1eHHaFX/koE6Ag5nd/4yQ/aVtpBOKd0HXf798WSU7
         vHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9WcgY/7dzWX3O9rNeZQ45WY9vESYPTTGXpSkl0YUkI=;
        b=fIaTjOlvpVtSW+RfMEYgkl6GeK2zw4OaMkHMPaj9Oz2dYAfE23C9N4ZrhQtMRnPz/5
         /DfFUIcJ8Btb3TDmoXMK1uE1/bE8puSbDQePBafskkwgIcsJgvL41kz5TsAlHGqo1KDe
         glOMnwiXDlLJ4TV5ukYj2VJNoqO5YVPym+E8EJzl90mfdB/uKDqksJyEStnYUvw3aGp/
         yrHKadep4tm6f99k1F4hQYJj7V0n+Hll9P+ML0npDvp9ENO8cN+gNsoN1qNEjjBVaOKM
         hxqvaqPpC9dBsD2w+INpcOJ5S+Lm0CFcJU6ydH/K1a/J4OfEJdrVrz90KEMRy1nF14eO
         xR5g==
X-Gm-Message-State: AOAM531aeT4JlUEiC6MwHkUmVZ3X9YqxMCrz9JrBeCCstAvZ5s10qWCw
        4mH5wIrckPCZXgyQJMYRzEM=
X-Google-Smtp-Source: ABdhPJxl+cgcAoXEBEpC1VwLLcuK8i3ig1a4dYX68teiMTM77/zkxVELptriuY7MljTxLwmUrn+BUg==
X-Received: by 2002:a17:902:e812:b029:de:5af2:3d09 with SMTP id u18-20020a170902e812b02900de5af23d09mr16457146plg.33.1612159038341;
        Sun, 31 Jan 2021 21:57:18 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:f50:a17:3dc5:18ab])
        by smtp.gmail.com with ESMTPSA id x63sm16992608pfc.145.2021.01.31.21.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 21:57:17 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: lapb: Copy the skb before sending a packet
Date:   Sun, 31 Jan 2021 21:57:06 -0800
Message-Id: <20210201055706.415842-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sending a packet, we will prepend it with an LAPB header.
This modifies the shared parts of a cloned skb, so we should copy the
skb rather than just clone it, before we prepend the header.

In "Documentation/networking/driver.rst" (the 2nd point), it states
that drivers shouldn't modify the shared parts of a cloned skb when
transmitting.

The "dev_queue_xmit_nit" function in "net/core/dev.c", which is called
when an skb is being sent, clones the skb and sents the clone to
AF_PACKET sockets. Because the LAPB drivers first remove a 1-byte
pseudo-header before handing over the skb to us, if we don't copy the
skb before prepending the LAPB header, the first byte of the packets
received on AF_PACKET sockets can be corrupted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/lapb/lapb_out.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/lapb/lapb_out.c b/net/lapb/lapb_out.c
index 7a4d0715d1c3..a966d29c772d 100644
--- a/net/lapb/lapb_out.c
+++ b/net/lapb/lapb_out.c
@@ -82,7 +82,8 @@ void lapb_kick(struct lapb_cb *lapb)
 		skb = skb_dequeue(&lapb->write_queue);
 
 		do {
-			if ((skbn = skb_clone(skb, GFP_ATOMIC)) == NULL) {
+			skbn = skb_copy(skb, GFP_ATOMIC);
+			if (!skbn) {
 				skb_queue_head(&lapb->write_queue, skb);
 				break;
 			}
-- 
2.27.0

