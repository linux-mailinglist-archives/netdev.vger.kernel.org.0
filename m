Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9086C2BC
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 23:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfGQVm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:42:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39192 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfGQVm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 17:42:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id f17so7499775pfn.6
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 14:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kl9yNljOWc7+nq5LzihsD/npOAxJjIk2+RGu+am0yhM=;
        b=kjG86lI1INEwAtzHzjp73w4dh1lNko5k8IWqrM7OF5RSYCd1rgqPnB5dgv8JA7Xjl4
         nO4wac6D3zjMBptpqzwiNaSiZcD/KyprYaIpILsbVztCWb9+Yn+mr+m2pIJsN9QLfJh4
         wh6VP6+v1hvrVTUrbOXGQg7FnqNJKgijoncGP9Q8y2VQTLBuhSp0Df4DiLfFoAtD7BXZ
         OO2LyXP5vwtRUv69Nn2OlNx1LtEtMuUzxH5UO9oWJ2uabF4PY+mPBLN+kmcct0iPeSio
         jS6PcH6yu9E5sGwxBJPst22BFbQdWj3/N+TBhkYFP/P3mtxPVcG4djRYw6G79BlnzGOr
         LUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kl9yNljOWc7+nq5LzihsD/npOAxJjIk2+RGu+am0yhM=;
        b=XbycNTRowc+cP8j+ys7/zXpeL+o4ne+vo3yGfqUZD+y5S4FnXjpVxSmLfbJDXe/B6f
         lvAdAFVysQHKS/GqOPWo3ZUxOgaw0SXUG95j4xkaux/avityQ/X+Hww93imDoOgOZliU
         3lby08P2jHxrO5pQnUDN2ZWs2o9aeI6WatVwNUgw1VdLyJY2h2vNQZjAJoynR2u63vJ+
         6OrBGk7RnWrb4zA9JmgPa5sH1PeQ3FKM6Plhy6RUc2CYryWvanRtL08g2cpzbo8by9KP
         AYRc4GdFGGAbjlwIuT9ThwMEDQlBIk+pVyeHD81HIfR7gbaTJtCUObvw2yhqDc76qrWJ
         6irw==
X-Gm-Message-State: APjAAAXB7HXRy+oBcvB36kkhQuHdGJpOIBP3KC7bo/PdbKDm/XnPI0sp
        R0GkaeEsNDmMJCkW7J3zkPS/mk0DSSg=
X-Google-Smtp-Source: APXvYqxN76BiyckaLPGgURaqE15Dcii74yb9AgPZWwVXZQ3Avh+rCReNjkHk6GKwszABKHTukGtv1g==
X-Received: by 2002:a65:50c5:: with SMTP id s5mr43512310pgp.368.1563399745880;
        Wed, 17 Jul 2019 14:42:25 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id 23sm27476615pfn.176.2019.07.17.14.42.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 14:42:24 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Cong Wang <xiyou.wangcong@gmail.com>,
        Julian Anastasov <ja@ssi.bg>
Subject: [Patch net v3 1/2] fib: relax source validation check for loopback packets
Date:   Wed, 17 Jul 2019 14:41:58 -0700
Message-Id: <20190717214159.25959-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a rare case where we redirect local packets from veth to lo,
these packets fail to pass the source validation when rp_filter
is turned on, as the tracing shows:

  <...>-311708 [040] ..s1 7951180.957825: fib_table_lookup: table 254 oif 0 iif 1 src 10.53.180.130 dst 10.53.180.130 tos 0 scope 0 flags 0
  <...>-311708 [040] ..s1 7951180.957826: fib_table_lookup_nh: nexthop dev eth0 oif 4 src 10.53.180.130

So, the fib table lookup returns eth0 as the nexthop even though
the packets are local and should be routed to loopback nonetheless,
but they can't pass the dev match check in fib_info_nh_uses_dev()
without this patch.

It should be safe to relax this check for this special case, as
normally packets coming out of loopback device still have skb_dst
so they won't even hit this slow path.

Cc: Julian Anastasov <ja@ssi.bg>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/fib_frontend.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 317339cd7f03..e8bc939b56dd 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -388,6 +388,11 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	fib_combine_itag(itag, &res);
 
 	dev_match = fib_info_nh_uses_dev(res.fi, dev);
+	/* This is not common, loopback packets retain skb_dst so normally they
+	 * would not even hit this slow path.
+	 */
+	dev_match = dev_match || (res.type == RTN_LOCAL &&
+				  dev == net->loopback_dev);
 	if (dev_match) {
 		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
 		return ret;
-- 
2.21.0

