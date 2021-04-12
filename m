Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9359B35D294
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhDLVYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbhDLVYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 17:24:48 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C60C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 14:24:29 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id k25so14956885iob.6
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 14:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SErWmlC8LnAVFg10EQrSUIl9iJTpdn9AfBuGrIp4r3E=;
        b=Uk+DzUY0ql1Gtf/3LFkrvSa7cAqYcYZiQ+z6zpnveIIebA++28q2QVpjGimSFeRd0y
         UmQiSXIzG7D/OkiVZOAHXrpEyzaxY1sA6czMIU0velb7RHM7j6fKvcgIS3dj1gN1C4x6
         3jE0J0tpo/KJR507W3OzCNw0DhuPK3h1oPldmxFpKhtJfBWGb680C+8Zr8+IT8vqiUFC
         edtzQgRRhoQAeVac7EAsCu3hE2WhUws9KoCvu0xReABrfuBVmbsj+TUnyqYgM0xkmTkT
         ba/oTJsATWJNPH2CmwufODGd/6fzPz9p2SxbPgjxqwl6NAaL3K9eBOoiICL+FqQEo5av
         vA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SErWmlC8LnAVFg10EQrSUIl9iJTpdn9AfBuGrIp4r3E=;
        b=cLP6JlCVdlZ7kQugTWNC9qMCsp9JLJXmJlYc/eRQwopXcRzGJljhnlRBAXxfYUK8QH
         dPJDARjTcpAxpfC9rSst2dOM3NBMaPK7KX7CsFZ1QpoNrfkF6w4Ss7fvy7gzqtCRtPUH
         BBquMB5aeMU5IYjpaMaQRWicC+w0AEifuR5HIqJ4pTDFqDRmjdoVFzk54eUfocqIwXJH
         SbWyaxli23EtfCYphaHodA81lsnYnM+3yGXBwHZCd/WRlieSnGB7z9G0zaLFXDclgM3h
         6a+jNPrUylq5BlHoK2G4+6rgT2Em+S0NNg+W409QPoz55Ve2hY/Gc4v2Tec+KSnraRMI
         aRyg==
X-Gm-Message-State: AOAM532dhI7kM9sorhNrBclnN1NGZf+fdIrpcMWltw58meBC9bFtWIAl
        B1H3y45G0k5XpBBaXXy/pbo+d2B8VMQ=
X-Google-Smtp-Source: ABdhPJzGsylhoQp1n1lxJaFb9m5HZsyxgyHY5QAFkUAmO5bgJD0J2D3S+COaabIZ0KBoblvPZfvXpg==
X-Received: by 2002:a6b:8e0d:: with SMTP id q13mr17152250iod.63.1618262669090;
        Mon, 12 Apr 2021 14:24:29 -0700 (PDT)
Received: from aroeseler-ly545.hsd1.ut.comcast.net ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.googlemail.com with ESMTPSA id s17sm4274966ilt.77.2021.04.12.14.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 14:24:28 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V2] icmp: ICMPV6: pass RFC 8335 reply messages to ping_rcv
Date:   Mon, 12 Apr 2021 16:23:56 -0500
Message-Id: <20210412212356.22403-1-andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current icmp_rcv function drops all unknown ICMP types, including
ICMP_EXT_ECHOREPLY (type 43). In order to parse Extended Echo Reply messages, we have
to pass these packets to the ping_rcv function, which does not do any
other filtering and passes the packet to the designated socket.

Pass incoming RFC 8335 ICMP Extended Echo Reply packets to the ping_rcv
handler instead of discarding the packet.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes:
v1 -> v2:
 - Add ICMPV6 to patch
---
 net/ipv4/icmp.c | 5 +++++
 net/ipv6/icmp.c | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 76990e13a2f9..8bd988fbcb31 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1196,6 +1196,11 @@ int icmp_rcv(struct sk_buff *skb)
 		goto success_check;
 	}
 
+	if (icmph->type == ICMP_EXT_ECHOREPLY) {
+		success = ping_rcv(skb);
+		goto success_check;
+	}
+
 	/*
 	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
 	 *
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 1bca2b09d77e..e8398ffb5e35 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -916,6 +916,10 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		success = ping_rcv(skb);
 		break;
 
+	case ICMPV6_EXT_ECHO_REPLY:
+		success = ping_rcv(skb);
+		break;
+
 	case ICMPV6_PKT_TOOBIG:
 		/* BUGGG_FUTURE: if packet contains rthdr, we cannot update
 		   standard destination cache. Seems, only "advanced"
-- 
2.31.1

