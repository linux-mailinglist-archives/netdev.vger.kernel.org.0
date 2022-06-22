Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4344554228
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356920AbiFVFN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356783AbiFVFNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B5035A88
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:11 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-317bfb7aaacso68225167b3.1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q6zxvPds/JEM81DuSyUCoS9FcG5gc9gJ3cgYpcc9rFw=;
        b=qsYiWrkfm+NDL6WamE5xDK/htzaG7INzh7PNSREvciuG+ZXkJ73MIjy3TPJ6ecmPVH
         qcmXrzMAvN5xLoHjyOnaYF8zl0Yw55ALcQS+Pxus61exiR3kFrZHBMYzdLo12NgUVE9p
         l4E/GSjw/1SwjNO+KMJDtpbi+2J+GfXeKDJZMckTvW8S9SZoQxtxEy0Kz/4re3H22Kgb
         4nQ5GxE6znp5lcr6hreSC151wBSpStCnNrClJ3hCtHEcbIGnw11+vBoOPK/qeIoQ8JsG
         y+KmkxAH3r4aYwTl1gsckm2aWXWFQPKlendBOVBgLQ13N2QcVxpD/9vAfpmvdgDsQ/I+
         JHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q6zxvPds/JEM81DuSyUCoS9FcG5gc9gJ3cgYpcc9rFw=;
        b=mAzX+4u5ICPUxnItMr2bxKuDurGu1yGeCnbupc/JTSOiDcCYGt4DGMfB+narHMzOxu
         5WVx5F7XsTj+9r9qb9YHwQKW9L9Rf8FVC1K1UUoxz1/tZYfrK94p/CThzzMJnXVcEo/8
         AWRIG0mK3kFxtlX7GmeqXCQEoNr0tQTZfwDYHiJNt+ACWETExOOFVXdxwK4CesV015FA
         GPmODND8cPclIRbYyREc434GDA3H8Ti5pIECJ9/hC1dWO2ejAeLd2gfPE3BnqcpMuKR0
         iDn7A5PalHnhD1xEjkW6idLrVeDOtNTv2As14CaaKm5hHgDY1RjmNFAsnnBMyvJJKwGS
         MnHw==
X-Gm-Message-State: AJIora+omPC9UKyKz8PeMzPC0bN/y72ZFNVL8TyDBR3vBvZ/zry92IM9
        +ONveX/+t2CwxVVgF1neYgvbxY33sEORUw==
X-Google-Smtp-Source: AGRyM1vnvXFM39fDMQqt29WqHKdME9ih9kqdT/oESYFdxf4puQCiliC91fy8fTQPA0w4zXWOocDQlIYWVpu+vA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:cad1:0:b0:318:1eeb:3cce with SMTP id
 m200-20020a0dcad1000000b003181eeb3ccemr2132544ywd.371.1655874791141; Tue, 21
 Jun 2022 22:13:11 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:42 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-7-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 06/19] ipmr: do not acquire mrt_lock in ioctl(SIOCGETVIFCNT)
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

