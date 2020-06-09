Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026C71F3DA0
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgFIOJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgFIOJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 10:09:42 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD55C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 07:09:40 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id j32so17632460qte.10
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 07:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eba5c9P97/IUEbxiaUFpTC20O2nKdmnk/L3iYLRz3L8=;
        b=Ri8jnG9KQKa/KsAsf8TkSWyUjqIFAcGzQkUoWIZqXGF7Uj4mEJs4LpMxgnU+60B5aF
         ODuWUVeEKkPuO1kO7K2np54ZGS/iQR9mB4NfK2AZS6sRCwIg9GpVv8g3iAXydwiRe9Lw
         0ipe/0ycptes/+TYHhssa6A4AxmtB4CDnkJcY/SXmAokKetq49trHQeDT9gEUkAHVk3R
         VTM47hHBzkzY6Fs6tVL5Bsm/ymejq+CxX07xwg6mHKwMPLLz6YHMpCmDv8PF1bcS24pw
         bMhKunUsw1sWlQk0K5BoDnIxYf80fy72OK54R74V6cqyY3z7gWyeZrrnePiSBmL7ngxR
         iwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eba5c9P97/IUEbxiaUFpTC20O2nKdmnk/L3iYLRz3L8=;
        b=ZWTeXBXkQTRJdQElGQk33CLVoH/l59H08TGaWHAildYP81e9oa0eMsUD1WoZ0uRlgV
         c90MvCbr81VfudhL3mpcj0yZ7FI1eGZN07kNHrUYNKfwxbEuGAyn0fx30oOIIDcrKrno
         k+1Bx6SXXP56y8yZgsJylWZOzkxYqlaC8eAYVDylK8a9mh61L9CltxRQMse/8UD7w+9D
         An5zEnWRm4hOWOG63ql8USR+YdoqFuS+lsWa5zn6ZsKNafG5dJyOE7nAGIp4OC4pXPK+
         TaVoghBoPREHVGBVApeYF5a4YsGx9c+4lKeQ9dVafckTJyQwGgu6yx0O8nFD+b8Dtaj0
         9Veg==
X-Gm-Message-State: AOAM533XCaoexPOkw4JKdOcT5xE3g90Ua8ljE6OKMqaPlp8krhSLjm/P
        pwcwxOgcIQznPq2Dyrif6DjubEHP
X-Google-Smtp-Source: ABdhPJwHbFuO/rO1GDdgQllUo5S1aeRjGD0QP3UoiLFPjndPX9+dn0psLfnqkjhwPO76JYxyaH87Iw==
X-Received: by 2002:ac8:3ae3:: with SMTP id x90mr28826257qte.339.1591711779291;
        Tue, 09 Jun 2020 07:09:39 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id u25sm10454614qtc.11.2020.06.09.07.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:09:38 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC net-next 1/6] net: multiple release time SO_TXTIME
Date:   Tue,  9 Jun 2020 10:09:29 -0400
Message-Id: <20200609140934.110785-2-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
In-Reply-To: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
References: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Pace transmission of segments in a UDP GSO datagram.

Batching datagram protocol stack traversals with UDP_SEGMENT saves
significant cycles for large data transfers.

But GSO packets are sent at once. Pacing traffic to internet clients
often requires sending just a few MSS per msec pacing interval.

SO_TXTIME allows delivery of packets at a later time. Extend it
to allow pacing the segments in a UDP GSO packet, to be able to build
larger GSO datagrams.

Add SO_TXTIME flag SOF_TXTIME_MULTI_RELEASE. This reinterprets the
lower 8 bits of the 64-bit release timestamp as

  - bits 4..7: release time interval in usec
  - bits 0..3: number of segments sent per period

So a timestamp of 0x148 means

  - 0x100 initial timestamp in Qdisc selected clocksource
  - every 4 usec release N MSS
  - N is 8

A subsequent qdisc change will pace the individual segments.

Packet transmission can race with the socket option. This is safe.
For predictable behavior, it is up to the caller to not toggle the
feature while packets on a socket are in flight.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/netdevice.h       |  1 +
 include/net/sock.h              |  3 ++-
 include/uapi/linux/net_tstamp.h |  3 ++-
 net/core/dev.c                  | 44 +++++++++++++++++++++++++++++++++
 net/core/sock.c                 |  4 +++
 5 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a96e9c4ec36..15ea976dd446 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4528,6 +4528,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 				  netdev_features_t features, bool tx_path);
 struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
 				    netdev_features_t features);
+struct sk_buff *skb_gso_segment_txtime(struct sk_buff *skb);
 
 struct netdev_bonding_info {
 	ifslave	slave;
diff --git a/include/net/sock.h b/include/net/sock.h
index c53cc42b5ab9..491e389b3570 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -493,7 +493,8 @@ struct sock {
 	u8			sk_clockid;
 	u8			sk_txtime_deadline_mode : 1,
 				sk_txtime_report_errors : 1,
-				sk_txtime_unused : 6;
+				sk_txtime_multi_release : 1,
+				sk_txtime_unused : 5;
 
 	struct socket		*sk_socket;
 	void			*sk_user_data;
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index 7ed0b3d1c00a..ca1ae3b6f601 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -162,8 +162,9 @@ struct scm_ts_pktinfo {
 enum txtime_flags {
 	SOF_TXTIME_DEADLINE_MODE = (1 << 0),
 	SOF_TXTIME_REPORT_ERRORS = (1 << 1),
+	SOF_TXTIME_MULTI_RELEASE = (1 << 2),
 
-	SOF_TXTIME_FLAGS_LAST = SOF_TXTIME_REPORT_ERRORS,
+	SOF_TXTIME_FLAGS_LAST = SOF_TXTIME_MULTI_RELEASE,
 	SOF_TXTIME_FLAGS_MASK = (SOF_TXTIME_FLAGS_LAST - 1) |
 				 SOF_TXTIME_FLAGS_LAST
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 061496a1f640..5058083375fb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3377,6 +3377,50 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(__skb_gso_segment);
 
+struct sk_buff *skb_gso_segment_txtime(struct sk_buff *skb)
+{
+	int mss_per_ival, mss_in_cur_ival;
+	struct sk_buff *segs, *seg;
+	struct skb_shared_info *sh;
+	u64 step_ns, tstamp;
+
+	if (!skb->sk || !sk_fullsock(skb->sk) ||
+	    !skb->sk->sk_txtime_multi_release)
+		return NULL;
+
+	/* extract multi release variables mss and stepsize */
+	mss_per_ival = skb->tstamp & 0xF;
+	step_ns = ((skb->tstamp >> 4) & 0xF) * NSEC_PER_MSEC;
+	tstamp = skb->tstamp;
+
+	if (mss_per_ival == 0)
+		return NULL;
+
+	/* skip multi-release if total segs can be sent at once */
+	sh = skb_shinfo(skb);
+	if (sh->gso_segs <= mss_per_ival)
+		return NULL;
+
+	segs = skb_gso_segment(skb, NETIF_F_SG | NETIF_F_HW_CSUM);
+	if (IS_ERR_OR_NULL(segs))
+		return segs;
+
+	mss_in_cur_ival = 0;
+
+	for (seg = segs; seg; seg = seg->next) {
+		seg->tstamp = tstamp & ~0xFF;
+
+		mss_in_cur_ival++;
+		if (mss_in_cur_ival == mss_per_ival) {
+			tstamp += step_ns;
+			mss_in_cur_ival = 0;
+		}
+	}
+
+	return segs;
+}
+EXPORT_SYMBOL_GPL(skb_gso_segment_txtime);
+
 /* Take action when hardware reception checksum errors are detected. */
 #ifdef CONFIG_BUG
 void netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
diff --git a/net/core/sock.c b/net/core/sock.c
index 6c4acf1f0220..7036b8855154 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1258,6 +1258,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			!!(sk_txtime.flags & SOF_TXTIME_DEADLINE_MODE);
 		sk->sk_txtime_report_errors =
 			!!(sk_txtime.flags & SOF_TXTIME_REPORT_ERRORS);
+		sk->sk_txtime_multi_release =
+			!!(sk_txtime.flags & SOF_TXTIME_MULTI_RELEASE);
 		break;
 
 	case SO_BINDTOIFINDEX:
@@ -1608,6 +1610,8 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 				  SOF_TXTIME_DEADLINE_MODE : 0;
 		v.txtime.flags |= sk->sk_txtime_report_errors ?
 				  SOF_TXTIME_REPORT_ERRORS : 0;
+		v.txtime.flags |= sk->sk_txtime_multi_release ?
+				  SOF_TXTIME_MULTI_RELEASE : 0;
 		break;
 
 	case SO_BINDTOIFINDEX:
-- 
2.27.0.278.ge193c7cf3a9-goog

