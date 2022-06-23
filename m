Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68EC5571C9
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiFWEk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347334AbiFWEfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:19 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0308630F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:19 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2fed274f3fbso160525717b3.17
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q6zxvPds/JEM81DuSyUCoS9FcG5gc9gJ3cgYpcc9rFw=;
        b=n60/C1U/chc1f1Mi9qN3h0/wK/ahYXG2JcX5NIoYiIMPIoYrAJ547zkUfUxKKPKPN3
         fcZfhfZf34bKEfNSvUI3DdLwiE1vFaW1BQwHgrawghnfDM459TilzJ8OYtIUoHk1p7n/
         FA8JK3kWwwK9wrMvr5GLqkyNlkvFie/X/DZfP7WT6N+hwiUBxiUfBxCUtttVOVxh08mk
         wfLe1kBfflk8qg+2qkXjMbqRprqPLqd1mwDUoevyraiKXWR2q+zlgY6KwpwXhyJDQGP7
         4S3Bh68h5b8FmkkZw86G71uM2wxpop7C14V0aSk2RFV3uo9uIGIlP9GeRFS48018cW89
         zV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q6zxvPds/JEM81DuSyUCoS9FcG5gc9gJ3cgYpcc9rFw=;
        b=0W7xRGKOVHTAcwd5dIisSfmbA2pm4GZ2cx8Ub8F3ohiw25MGq4don7deGxunRSaL5C
         iFzl+43+GX5ElMZfzK6lErQJVqtTB/y5fQ5Mge34SgVSUdKx/nwrynukMf856Wz5xalH
         6rrV3zMqve/7VnyqKNgi9HH7/ddycl8BC3jixOJVaQ55aom0B1u2J13yJwAJk6bTX5Mf
         RURJURt2Czy72DOntBa1Rj8pKhu8g4y3YF56C97aQ0wvMCzZJnv+nXIhffJ0+OPz1Cze
         wnHhsUKTHriJDj9zn6kgf/OSD4fFMnagG09dVKhZTSmOmOuCW/KO5Pc8TprSPUoHhyAk
         acGw==
X-Gm-Message-State: AJIora+ktKZmU8bebFy+f//rlF4A3iZKIs7VFQkMLF0XVzlDkWFKz1Wo
        hZxjjfQ/DC4hVH50VzKbqLEJEcJVlxyKmg==
X-Google-Smtp-Source: AGRyM1tSscW5DI7Apetd2YmVQvvuaO/A6xohpYcUI/4va1kSrSMA6nZb9VlqLZIbKXZpv2Fqo3pa1+tl1cSX2A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:1e05:0:b0:318:cdd:7e13 with SMTP id
 e5-20020a811e05000000b003180cdd7e13mr8386234ywe.5.1655958918266; Wed, 22 Jun
 2022 21:35:18 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:36 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-7-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 06/19] ipmr: do not acquire mrt_lock in ioctl(SIOCGETVIFCNT)
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
 net/ipv4/ipmr.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 8a94f9a459cd077d74b5e38c3d2f248620d4ecfc..bc8b7504fde6ec3aadd6c0962f23e59c0aac702a 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1611,20 +1611,20 @@ int ipmr_ioctl(struct sock *sk, int cmd, void __user *arg)
 		if (vr.vifi >= mrt->maxvif)
 			return -EINVAL;
 		vr.vifi = array_index_nospec(vr.vifi, mrt->maxvif);
-		read_lock(&mrt_lock);
+		rcu_read_lock();
 		vif = &mrt->vif_table[vr.vifi];
 		if (VIF_EXISTS(mrt, vr.vifi)) {
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
 	case SIOCGETSGCNT:
 		if (copy_from_user(&sr, arg, sizeof(sr)))
@@ -1686,20 +1686,20 @@ int ipmr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
 		if (vr.vifi >= mrt->maxvif)
 			return -EINVAL;
 		vr.vifi = array_index_nospec(vr.vifi, mrt->maxvif);
-		read_lock(&mrt_lock);
+		rcu_read_lock();
 		vif = &mrt->vif_table[vr.vifi];
 		if (VIF_EXISTS(mrt, vr.vifi)) {
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
 	case SIOCGETSGCNT:
 		if (copy_from_user(&sr, arg, sizeof(sr)))
@@ -1835,8 +1835,8 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 		goto out_free;
 
 	if (vif->flags & VIFF_REGISTER) {
-		vif->pkt_out++;
-		vif->bytes_out += skb->len;
+		WRITE_ONCE(vif->pkt_out, vif->pkt_out + 1);
+		WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
 		vif_dev->stats.tx_bytes += skb->len;
 		vif_dev->stats.tx_packets++;
 		rcu_read_lock();
@@ -1885,8 +1885,8 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 		goto out_free;
 	}
 
-	vif->pkt_out++;
-	vif->bytes_out += skb->len;
+	WRITE_ONCE(vif->pkt_out, vif->pkt_out + 1);
+	WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
 
 	skb_dst_drop(skb);
 	skb_dst_set(skb, &rt->dst);
@@ -2002,8 +2002,10 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 	}
 
 forward:
-	mrt->vif_table[vif].pkt_in++;
-	mrt->vif_table[vif].bytes_in += skb->len;
+	WRITE_ONCE(mrt->vif_table[vif].pkt_in,
+		   mrt->vif_table[vif].pkt_in + 1);
+	WRITE_ONCE(mrt->vif_table[vif].bytes_in,
+		   mrt->vif_table[vif].bytes_in + skb->len);
 
 	/* Forward the frame */
 	if (c->mfc_origin == htonl(INADDR_ANY) &&
-- 
2.37.0.rc0.104.g0611611a94-goog

