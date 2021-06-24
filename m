Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5383B3388
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhFXQI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:08:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231407AbhFXQIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624550783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8n6XcLLXm/HC8/e7TDiaIKa4D1+079NdF0CtM9PlMq8=;
        b=VQfWnt4zia9pxvAY3ZolyWQb1DZiqNHWkk9gscRMnuo/cU+MGikTLxu7pTuli1lLSrzh2u
        prv+DUPAdBuAF/2y93V4oZD9rF22Eb6UYECHQSPjik7654zBk2ICS4SlHkURBTt0wDv8m9
        Lt5HtF4su8MdYpS+Bk087E03odsLcnY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-fI4i4xhXM3S-j-JbOyfqug-1; Thu, 24 Jun 2021 12:06:22 -0400
X-MC-Unique: fI4i4xhXM3S-j-JbOyfqug-1
Received: by mail-ed1-f71.google.com with SMTP id v8-20020a0564023488b0290393873961f6so3593093edc.17
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8n6XcLLXm/HC8/e7TDiaIKa4D1+079NdF0CtM9PlMq8=;
        b=lc60ZRk0CWttHq3gycv+TL+VRvA2feY92EJ0Q1XUA+ZbW/399SYuBFkYvcWd3Wa9c5
         aywMIeA5wZajnGu+d3xMJmAEitC3GfpU+/dS7jn1Sx5AS9pFNIDTq3Vsu0OJJsE8tuKp
         ac+1PXpVHFPJNotp7RMenzwcSjVLsQEu+EUbwucK8mUcTt3Q7ISqolIkP4ql87Syb9/B
         M9/RgFc+HftE1JYKhuSi6tr+nChZJL9ZCjkus/EG4VnsInW8mKBYYJd/zzxIHZjafWov
         n+oNIhBS+iNCBzqlHwItAxpAHwrGpixiM1BEod8I9VF0LjOPayIMAb8Rdri4xkpTHMGv
         SQmA==
X-Gm-Message-State: AOAM531U/Bw9nC5VDDiQSQUQ4gzUWYPwvP/tRhxcewsIS8KabxU4jGQ+
        yLeR1ImJrLRctMh374f+qs8szSVkrNUewc3B/SsgePOl6Hzj5dGHAl6e/4by0leWl9RDNOJXhLY
        2tcc5Ah4ALDafuWT5
X-Received: by 2002:a50:b8e6:: with SMTP id l93mr8489739ede.25.1624550780930;
        Thu, 24 Jun 2021 09:06:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9a+Zc1daHM7E7EaR+rO9SkTP3jW41sNbM6ubu90/JqfixkamnHJK4VwcKKUiE6oKNLXWagA==
X-Received: by 2002:a50:b8e6:: with SMTP id l93mr8489702ede.25.1624550780757;
        Thu, 24 Jun 2021 09:06:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p18sm1308833edu.8.2021.06.24.09.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:06:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6EED918073B; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH bpf-next v5 10/19] freescale: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 24 Jun 2021 18:06:00 +0200
Message-Id: <20210624160609.292325-11-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa and dpaa2 drivers have rcu_read_lock()/rcu_read_unlock() pairs
around XDP program invocations. However, the actual lifetime of the objects
referred by the XDP program invocation is longer, all the way through to
the call to xdp_do_flush(), making the scope of the rcu_read_lock() too
small. This turns out to be harmless because it all happens in a single
NAPI poll cycle (and thus under local_bh_disable()), but it makes the
rcu_read_lock() misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around.

Cc: Madalin Bucur <madalin.bucur@nxp.com>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Reviewed-by: Camelia Groza <camelia.groza@nxp.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 8 +-------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 3 ---
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 177c020bf34a..e6826561cf11 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2558,13 +2558,9 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 	u32 xdp_act;
 	int err;
 
-	rcu_read_lock();
-
 	xdp_prog = READ_ONCE(priv->xdp_prog);
-	if (!xdp_prog) {
-		rcu_read_unlock();
+	if (!xdp_prog)
 		return XDP_PASS;
-	}
 
 	xdp_init_buff(&xdp, DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE,
 		      &dpaa_fq->xdp_rxq);
@@ -2638,8 +2634,6 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 		break;
 	}
 
-	rcu_read_unlock();
-
 	return xdp_act;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8433aa730c42..973352393bd4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -352,8 +352,6 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	u32 xdp_act = XDP_PASS;
 	int err, offset;
 
-	rcu_read_lock();
-
 	xdp_prog = READ_ONCE(ch->xdp.prog);
 	if (!xdp_prog)
 		goto out;
@@ -414,7 +412,6 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 
 	ch->xdp.res |= xdp_act;
 out:
-	rcu_read_unlock();
 	return xdp_act;
 }
 
-- 
2.32.0

