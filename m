Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6561D14AB31
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 21:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgA0Ukh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 15:40:37 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42378 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgA0Ukh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 15:40:37 -0500
Received: by mail-qt1-f196.google.com with SMTP id j5so8491071qtq.9
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 12:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w5mLIqhlG+D02O6dRiTkCJD1g/OXPajidxvsn+Q3y8I=;
        b=m4kJ7jL31g8OKN15DdeKNbWnqCBXr7qZXqxvnhMhRo/vCuBwGOhvzEZVKny7qGAuD4
         3q+W6GltJBOsTiJqUFfKXgEIMDuvaUO9T+SGSCsPfGEe++GOYVGYt9ujUVHRvykPT0yM
         e8lb7fpT4zdekpr+I7r1Zo5cHdihDaMiGXf4UZIIXN5kqMzTsZQTjdId5WZ1zPuIXLGG
         +Iq1pejhOluL7UFancj5KhOhW3YFQS5JMa5Iqf1nDx7RFjTy4nXUlBaYzsnW+5OsFNEk
         rMeb1En1nYS7867QtkkIcvUDofnU2a8hIocAIiOM2aa6prk8niRE76cErOLp7LWJ+BtA
         i2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w5mLIqhlG+D02O6dRiTkCJD1g/OXPajidxvsn+Q3y8I=;
        b=JxnTMGfB+iyxsr2H34SdUUdRgYWx+4siZqNoZl2Ptkvd8Sn/zhxBwFP9NJ+UZ15GfD
         Vw7o+jimCZZiSD4eyvIxMJ7SHR099LyOH/gQOMo1/IcldwWzpxDefwC4LZCfMgHrkDEz
         ZkDqa+WBPluR9bvnBlAGzULtKm7XY0/9mJWd08GZ9YsI1mG6mECHJHNIumAn2sq5eOD5
         xOWywKR6+F2P8yjayU8NB+0y9MCN/HFFg7dBEho0EJq0giwVC0Rx0FUn3coHP6wvRBE8
         6sFBXgqz5aPmDPpkCgUXK5dvC4WP5mlyvNCE2GsY4DAyOEimHSBCS1KM6gc9UU1lvkbI
         hoXw==
X-Gm-Message-State: APjAAAUeAhzylljwbUNkXw+MJJyWZPoOhFZVvQFt0VYynesN3d7WgHPM
        jg58OMJcROhVdNRXJ4HtHH3tDk8P
X-Google-Smtp-Source: APXvYqxb4lxrHuOUV1EftcGztGvQk5r2WVrG2GeL55rL1KGTDkd0QioAAuFFU+2NqhqerEapaeD+Sw==
X-Received: by 2002:ac8:43d0:: with SMTP id w16mr18151474qtn.43.1580157635977;
        Mon, 27 Jan 2020 12:40:35 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:6084:feee:4efa:5ea9])
        by smtp.gmail.com with ESMTPSA id r13sm10661207qtt.70.2020.01.27.12.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 12:40:35 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] udp: segment looped gso packets correctly
Date:   Mon, 27 Jan 2020 15:40:31 -0500
Message-Id: <20200127204031.244254-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Multicast and broadcast packets can be looped from egress to ingress
pre segmentation with dev_loopback_xmit. That function unconditionally
sets ip_summed to CHECKSUM_UNNECESSARY.

udp_rcv_segment segments gso packets in the udp rx path. Segmentation
usually executes on egress, and does not expect packets of this type.
__udp_gso_segment interprets !CHECKSUM_PARTIAL as CHECKSUM_NONE. But
the offsets are not correct for gso_make_checksum.

UDP GSO packets are of type CHECKSUM_PARTIAL, with their uh->check set
to the correct pseudo header checksum. Reset ip_summed to this type.
(CHECKSUM_PARTIAL is allowed on ingress, see comments in skbuff.h)

Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/net/udp.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index bad74f7808311..8f163d674f072 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -476,6 +476,9 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	if (!inet_get_convert_csum(sk))
 		features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 
+	if (skb->pkt_type == PACKET_LOOPBACK)
+		skb->ip_summed = CHECKSUM_PARTIAL;
+
 	/* the GSO CB lays after the UDP one, no need to save and restore any
 	 * CB fragment
 	 */
-- 
2.25.0.341.g760bfbb309-goog

