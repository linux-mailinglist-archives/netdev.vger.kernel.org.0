Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EA7193B7A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgCZJGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:06:35 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52298 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgCZJGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:06:35 -0400
Received: by mail-pj1-f67.google.com with SMTP id ng8so2183201pjb.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YF4Hx50wlfCDXd5QNDV7S8jxVtCcc8j0irVu0R3q9nU=;
        b=KWiziuHUi0mtF1csPrKpXeuL2rMqXHNfzg6pLp4pwQrqAUeiIbQ0OfL0osOravcQsj
         2gzp6alGCB74aRZKKmTmFpxJE0Kq/r/GzuAfGrzQiV1bpEO8eVswZhMlMm/TYGNhFhv1
         5Hs9iTbAfBJhTMoeqUTMZ+7JUPTy++7BhLDDet7TBz4ZYkevIBiHYaplmt2wm2fCGHtG
         zzc7FBJPzHhCLmWieRtXo7+oxX5wu5DMN6jr/xMDpgPSM78cndDzDZVKPMIpXveeHnIR
         4wXeEaf10KCkMncj/VhGxKUOVWBgxFYpfdCmz6Qvpn7U594bOIbgTDdejRQUHmYpiKU1
         SbRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YF4Hx50wlfCDXd5QNDV7S8jxVtCcc8j0irVu0R3q9nU=;
        b=PIS8jAGSM1b/MwcLE5MqVzc8P4cU07lFXydSgutbcKnguECbrr2rOLHDYvb616O01P
         wO3PCeMNzlNyWKM0UsCMNPSM2AxVMfSWuHzpirHJslbrg7BtoRQHfmsj3pJBH+6q8yo/
         sYid3i1bt2WpE1cnOBFCGES9mktPtzcCVGs5Xf0t3IkX2t+wFFOXXgefIPhzjgwQWwVE
         k+H9j06xiihtI4bafgcsCcsFbQPA5HGao9O3m9hm6kGjbwuQFgQPAyp+LbWYjys9c1h4
         O25DoySuwfyiOiMNod3FEy1Ax46ccuPARLXfoaVvdCDNxlG444XnEUpels3mlyM85gWL
         aTrg==
X-Gm-Message-State: ANhLgQ1t1aDUizT9x8gCoL3Rp8Xy+SX73Q6BUmCzOE+ahu6yDuuIoUZO
        vsD9KIBjTqTNXcjv6LzF5PXtggpv
X-Google-Smtp-Source: ADFU+vu5EHOANhYY5jjL6pA4ph3kFslCwvEm/rxJ6LIF+/w0RIe8r+Ge4TQFKbqvZoCc/7x//X3M2g==
X-Received: by 2002:a17:902:7c05:: with SMTP id x5mr2097208pll.255.1585213593662;
        Thu, 26 Mar 2020 02:06:33 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h15sm1175437pfq.10.2020.03.26.02.06.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 02:06:33 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] udp: fix a skb extensions leak
Date:   Thu, 26 Mar 2020 17:06:25 +0800
Message-Id: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On udp rx path udp_rcv_segment() may do segment where the frag skbs
will get the header copied from the head skb in skb_segment_list()
by calling __copy_skb_header(), which could overwrite the frag skbs'
extensions by __skb_ext_copy() and cause a leak.

This issue was found after loading esp_offload where a sec path ext
is set in the skb.

On udp tx gso path, it works well as the frag skbs' extensions are
not set. So this issue should be fixed on udp's rx path only and
release the frag skbs' extensions before going to do segment.

Reported-by: Xiumei Mu <xmu@redhat.com>
Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/udp.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index e55d5f7..7bf0ca5 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -486,6 +486,10 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		skb->ip_summed = CHECKSUM_PARTIAL;
 
+	if (skb_has_frag_list(skb) && skb_has_extensions(skb))
+		skb_walk_frags(skb, segs)
+			skb_ext_put(segs);
+
 	/* the GSO CB lays after the UDP one, no need to save and restore any
 	 * CB fragment
 	 */
-- 
2.1.0

