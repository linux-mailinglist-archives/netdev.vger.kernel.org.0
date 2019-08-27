Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398979F2F5
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfH0TJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:09:37 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43605 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730262AbfH0TJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 15:09:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id b11so120186qtp.10
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 12:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IbBhE5drx8qeLPrR3IPO+iWqiJ6vMaqKMAzhYc1KZG4=;
        b=kUPeTVHLNhGb50E3Ljp2D1T6Zmn33IJvY8e5eZ2uQD/jNF7gGTig8XtF2TAfWknSpA
         Dk/+BmhbASX+Ubfecq5ZSEV/hvAH/ep4cK0VtrgHPYS4gi//Lzj3CPIansufhoDXYJoP
         7DuxMnrHJ25Jm1lVa72el+wXwFG33IrzMxr0nsHe5Z3Kv3TP5eOpES75n2glYqxUktCa
         Yi9YK+ecishDZfq46z/pTvujm/d7sjuzIxhlFCnqk/eKe9PBLafbDm7ioYd1FAIvg1X2
         b83cG1Eb14dV5ZP22OVcK51kThXd5pBMYZHq+i9L5stSpr/QhCpXZnJ+Uic8SIzokwdd
         MJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IbBhE5drx8qeLPrR3IPO+iWqiJ6vMaqKMAzhYc1KZG4=;
        b=EpcypIVAHIGaDJwm9nLUaW2JUjiD8txOCenS8bXAVMur8QNJAQtn/stZKAAP41hU6G
         pU+fbdn2EGKXR/pPsTDHxTNh4dO202dkJGgCIaqCBwUzsOVrioGUsOa490NwFXcgMH1d
         Zx+4CrIgWtqrmHfkm1HbGaN/ngnH2kRnhxvtR/rCgpFRLudTAQuquxitS/7dnNmdqG/S
         GdMplmdNLpp/VcP0Wg12PKMd4OlTuO758l0YciwF5UIZs0EbyfqpxfvIa9VsZQaPt51x
         Qn3ZHEpolItnC2OEVkB2QeNK9eZyvnGlxeGROSqkOLR9V0ODsP74VXYKPcATNzt0xnv9
         pUeQ==
X-Gm-Message-State: APjAAAWz1boaT9sRwH7riPn5ndYMxW86p+nTCku/HHsVOCalebz8aL5F
        AmF2/rhkXW6nb/HeEJLwPZWgebHQ
X-Google-Smtp-Source: APXvYqzUW2Tg5ARcctWIRKXFY0ZaIdKuEGXxxQOqf34A/vvDQvEUU2iJk4qbw50E9P8SSf+kLF7EIA==
X-Received: by 2002:ac8:2b47:: with SMTP id 7mr436308qtv.116.1566932975702;
        Tue, 27 Aug 2019 12:09:35 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:89db:8f93:8219:1619])
        by smtp.gmail.com with ESMTPSA id g14sm140005qkm.42.2019.08.27.12.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 12:09:34 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        jakub.kicinski@netronome.com, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] tcp: inherit timestamp on mtu probe
Date:   Tue, 27 Aug 2019 15:09:33 -0400
Message-Id: <20190827190933.227725-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

TCP associates tx timestamp requests with a byte in the bytestream.
If merging skbs in tcp_mtu_probe, migrate the tstamp request.

Similar to MSG_EOR, do not allow moving a timestamp from any segment
in the probe but the last. This to avoid merging multiple timestamps.

Tested with the packetdrill script at
https://github.com/wdebruij/packetdrill/commits/mtu_probe-1

Link: http://patchwork.ozlabs.org/patch/1143278/#2232897
Fixes: 4ed2d765dfac ("net-timestamp: TCP timestamping")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/tcp_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5c46bc4c7e8d..42abc9bd687a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2053,7 +2053,7 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
 		if (len <= skb->len)
 			break;
 
-		if (unlikely(TCP_SKB_CB(skb)->eor))
+		if (unlikely(TCP_SKB_CB(skb)->eor) || tcp_has_tx_tstamp(skb))
 			return false;
 
 		len -= skb->len;
@@ -2170,6 +2170,7 @@ static int tcp_mtu_probe(struct sock *sk)
 			 * we need to propagate it to the new skb.
 			 */
 			TCP_SKB_CB(nskb)->eor = TCP_SKB_CB(skb)->eor;
+			tcp_skb_collapse_tstamp(nskb, skb);
 			tcp_unlink_write_queue(skb, sk);
 			sk_wmem_free_skb(sk, skb);
 		} else {
-- 
2.23.0.187.g17f5b7556c-goog

