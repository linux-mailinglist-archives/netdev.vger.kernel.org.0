Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9455D554224
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356992AbiFVFNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357010AbiFVFNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEF234678
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g132-20020a25db8a000000b00668a2ef6a95so13649865ybf.22
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wU6WCF7T9LlGsf1erjP98rpgqQYf0p7+pD0Eq8p6bVo=;
        b=QCPqmqebglnsEXPRluifa8ufTUiEhazdOmQWKyfneVEEycPr5Kdpki9mTFbxLxF7zp
         a6epUJkVQ8BlQJQ42lNHa6/fIJvKlL4RfwRLhMId9tx6nYaHsqlJpAJyFeUs6dcaD+eY
         A9Fgp/RBIvh2eKdNfyI2OillzWUw6kkt3YAvNokrDMJytxQ81SEcaad86u2cSsHWGD1/
         03FdgIL1/e/nKOOxBdiSReUFJEonpMZa1LqdaGqRlx92iAbamM7AcTvUWm8ij6EzeY4Z
         FAfBYDKmhVcStYkNFyVDPZg9RmGDEfmI5JwzdJlzWIrr7Gf/aCl2Zp212qEJw/XVHkxu
         OpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wU6WCF7T9LlGsf1erjP98rpgqQYf0p7+pD0Eq8p6bVo=;
        b=m1Cbz1RPT/ZSPaAWV2PCiKb4g11v0vT1hp3E6kNTeBgN0MzPONYDmD3as8zVebsLOa
         BswyLJLseu7AnugIyq7JYIZoOLso2OqQo0vf0pHkIGmWZwPtm8RSlRCqHa2tlQeZ+fOB
         Jt+wJn+U6vBeLvbKeYdDzi6GewdpOwJqDCezyLeLicxFdXNR2v4Zg8pUINKjP08ECM6E
         QU33u+i0bAoDriSJ0Qj4PkbwzK+JDiBEvDODFWSc9jI6hFICSbhK3fzjcbJ8+oa3Oijn
         HCa8TbQsaP0DQoDetEyFaExQqveZ8ouVrW7aoLHFjSPkaFWPmj2B3+Eg1eNv61fVGwHy
         JSLg==
X-Gm-Message-State: AJIora8qRh9TLUZA3wkFa5vfprTNMmh+rR+ZxLvB/GqHHSRXL7D6U70g
        bKY7ndDmUPKaKNmLQwfe0rNQL7rA7l9aiQ==
X-Google-Smtp-Source: AGRyM1vixpAXNAkvMFzEGUpsvC1+XQ3tJXKs2QKZPBiNYiiWwwHjcTv8K6xsfKh3Z4q8YglJh3tx9v5bXg1wgQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:ca17:0:b0:664:60ce:9369 with SMTP id
 a23-20020a25ca17000000b0066460ce9369mr1783052ybg.455.1655874801528; Tue, 21
 Jun 2022 22:13:21 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:48 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-13-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 12/19] ip6mr: do not acquire mrt_lock in ioctl(SIOCGETMIFCNT_IN6)
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rcu_read_lock() protection is good enough.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index fa6720377e82d732ccafa02b37cc28e0ab1cea07..b4ad606e24bdaf12c233f642cee303f06ccfa4eb 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1896,20 +1896,20 @@ int ip6mr_ioctl(struct sock *sk, int cmd, void __user *arg)
 		if (vr.mifi >= mrt->maxvif)
 			return -EINVAL;
 		vr.mifi = array_index_nospec(vr.mifi, mrt->maxvif);
-		read_lock(&mrt_lock);
+		rcu_read_lock();
 		vif = &mrt->vif_table[vr.mifi];
 		if (VIF_EXISTS(mrt, vr.mifi)) {
-			vr.icount = vif->pkt_in;
-			vr.ocount = vif->pkt_out;
-			vr.ibytes = vif->bytes_in;
-			vr.obytes = vif->bytes_out;
-			read_unlock(&mrt_lock);
+			vr.icount = READ_ONCE(vif->pkt_in);
+			vr.ocount = READ_ONCE(vif->pkt_out);
+			vr.ibytes = READ_ONCE(vif->bytes_in);
+			vr.obytes = READ_ONCE(vif->bytes_out);
+			rcu_read_unlock();
 
 			if (copy_to_user(arg, &vr, sizeof(vr)))
 				return -EFAULT;
 			return 0;
 		}
-		read_unlock(&mrt_lock);
+		rcu_read_unlock();
 		return -EADDRNOTAVAIL;
 	case SIOCGETSGCNT_IN6:
 		if (copy_from_user(&sr, arg, sizeof(sr)))
@@ -1971,20 +1971,20 @@ int ip6mr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
 		if (vr.mifi >= mrt->maxvif)
 			return -EINVAL;
 		vr.mifi = array_index_nospec(vr.mifi, mrt->maxvif);
-		read_lock(&mrt_lock);
+		rcu_read_lock();
 		vif = &mrt->vif_table[vr.mifi];
 		if (VIF_EXISTS(mrt, vr.mifi)) {
-			vr.icount = vif->pkt_in;
-			vr.ocount = vif->pkt_out;
-			vr.ibytes = vif->bytes_in;
-			vr.obytes = vif->bytes_out;
-			read_unlock(&mrt_lock);
+			vr.icount = READ_ONCE(vif->pkt_in);
+			vr.ocount = READ_ONCE(vif->pkt_out);
+			vr.ibytes = READ_ONCE(vif->bytes_in);
+			vr.obytes = READ_ONCE(vif->bytes_out);
+			rcu_read_unlock();
 
 			if (copy_to_user(arg, &vr, sizeof(vr)))
 				return -EFAULT;
 			return 0;
 		}
-		read_unlock(&mrt_lock);
+		rcu_read_unlock();
 		return -EADDRNOTAVAIL;
 	case SIOCGETSGCNT_IN6:
 		if (copy_from_user(&sr, arg, sizeof(sr)))
@@ -2038,8 +2038,8 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 
 #ifdef CONFIG_IPV6_PIMSM_V2
 	if (vif->flags & MIFF_REGISTER) {
-		vif->pkt_out++;
-		vif->bytes_out += skb->len;
+		WRITE_ONCE(vif->pkt_out, vif->pkt_out + 1);
+		WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
 		vif_dev->stats.tx_bytes += skb->len;
 		vif_dev->stats.tx_packets++;
 		rcu_read_lock();
@@ -2077,8 +2077,8 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	 * result in receiving multiple packets.
 	 */
 	skb->dev = vif_dev;
-	vif->pkt_out++;
-	vif->bytes_out += skb->len;
+	WRITE_ONCE(vif->pkt_out, vif->pkt_out + 1);
+	WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
 
 	/* We are about to write */
 	/* XXX: extension headers? */
@@ -2168,8 +2168,10 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 	}
 
 forward:
-	mrt->vif_table[vif].pkt_in++;
-	mrt->vif_table[vif].bytes_in += skb->len;
+	WRITE_ONCE(mrt->vif_table[vif].pkt_in,
+		   mrt->vif_table[vif].pkt_in + 1);
+	WRITE_ONCE(mrt->vif_table[vif].bytes_in,
+		   mrt->vif_table[vif].bytes_in + skb->len);
 
 	/*
 	 *	Forward the frame
-- 
2.37.0.rc0.104.g0611611a94-goog

