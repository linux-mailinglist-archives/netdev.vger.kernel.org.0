Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD392A1228
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgJaAth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgJaAtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:49:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37133C0613D5;
        Fri, 30 Oct 2020 17:49:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id i7so4625175pgh.6;
        Fri, 30 Oct 2020 17:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JN/b5liJNkCYHBYSnEufh73PPTqkvt+38op/HGk1BXE=;
        b=JECAtufreVaCdx9L/TIcWPLKWw4PhHbLCNcVhNZqm6f3LNten2zwoD5qw0//F1tOxd
         3SJjxm9Vv9/QWYUcBuedZ05Y6WonPyBN70oF5phSbD2IqI+tYTQtnvvpSrNPTwQgNKmP
         Ciqz9Yaugf9qknrthU2urDmZrqBToQJt7pR/OPIlJzxtVULs3jN7aQLL1dEins16jq9I
         ZFPN1q2L5SksUr/yzo5qpFFytvU9kLSdR0eF5uNAu0G2zVMwQU9FmNiaoudBHUYBcfTv
         35bGZw6lTA2Y7DqKLvFcKz+uEQCergT/C0Lj0lCzc5KAb9LdB6CSfMVtH/ZNJZNotq4m
         uWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JN/b5liJNkCYHBYSnEufh73PPTqkvt+38op/HGk1BXE=;
        b=eQ6JyTEdYlbSDAshmH7zQPR3FJvCENy5Atkt0s+vtmhiq/mfutlkSsjsHU9MDSRlp3
         608KaKtkfKGJ78ErSpNMEya9DMG1LW418odVTozpNMEou3Otcj9Qe+nVgMlaWWiFOiiw
         RtN0dN47spw/LMjCNfAWZBoD0/o+Joqn6yfmv5wEbX26h+4IGr1ADqiCahuOJxAnDK2r
         pmnPqg8zIZzpP9cUqVQRSn5+J3aN2iq64EDlIMiUARaalckQKOS0oFqVaRResSbSLWwg
         ZVT2Lt2Giix5+xwvgSBJHE4zpYDZk56n0UvwvVs7Kqd8OGRy8kAPAt4M7M443/tgR1iM
         YG+g==
X-Gm-Message-State: AOAM531ha537ViiDQq3h/qtsbAuHom8Oy75bQwMEiuOz4UVOt08li0tb
        tNf20C2xBsOyo8mUkAtKWZI=
X-Google-Smtp-Source: ABdhPJwS44rbr0Vdyyxty1C2KpckuYhFDd+jQv/Jpq53RqOzuzBLOqgwlQIui5cnBrizx8HZ6qpe9A==
X-Received: by 2002:a63:cd48:: with SMTP id a8mr4045216pgj.83.1604105371879;
        Fri, 30 Oct 2020 17:49:31 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id w10sm4466634pjy.57.2020.10.30.17.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:49:31 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v6 3/5] net: hdlc_fr: Do skb_reset_mac_header for skbs received on normal PVC devices
Date:   Fri, 30 Oct 2020 17:49:16 -0700
Message-Id: <20201031004918.463475-4-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031004918.463475-1-xie.he.0141@gmail.com>
References: <20201031004918.463475-1-xie.he.0141@gmail.com>
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

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Acked-by: Willem de Bruijn <willemb@google.com>
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

