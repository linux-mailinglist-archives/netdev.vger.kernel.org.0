Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733823A112C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhFIKfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:35:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237132AbhFIKfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:35:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623234819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OXscz2Zggz3CM5+O8rho39EJROdLmluUAHhgL+NUYOY=;
        b=Mh+Dp2m31HM9pRi63ZtCVgG226K0MGDJzY37TOoy7RT6Lh3rXUU6x1vBSRG6jGKgryFhwP
        tieWSTHkhX6yvFp9sdFbZmE0+NiuqyF6ighk/3u7EJfDxY+MTHnfQ3LLp9u/W5M+zR60gG
        4DXXm7njX05eydkE5o9dE1ffRSMoX7Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-TvaMuu1qPMS52Ct9oG8TDw-1; Wed, 09 Jun 2021 06:33:38 -0400
X-MC-Unique: TvaMuu1qPMS52Ct9oG8TDw-1
Received: by mail-ed1-f69.google.com with SMTP id a16-20020aa7cf100000b0290391819a774aso10222036edy.8
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OXscz2Zggz3CM5+O8rho39EJROdLmluUAHhgL+NUYOY=;
        b=mpnZDxhriOOsyGUhYRg9Vq/khGsqK92qMZTJpOXh8VavWDulsy3HUA2l0yenvyKnvw
         JzKDAT/uPupI9ZYOsSEMxsXvMIJTJfjseUkHVTBBRxexYg8M9fWa6kPf1eT3ROKr3jde
         8+LR/oNbS/E60DA+aSQ6aEELxMc3f1G5KvF4NHNsIowO+3JkIYAlFlXxDi4w/h0E8/5e
         GmH1lq9PY50MzTGlSuQAnr7xKhRv7uajXxuZn4WXf1/RR48ZC0C3W/HUhFHYAynJ8xHa
         JxE/PlYnuIXJMd7UH9ld3x1y1f6P5eZk7Bs1iKINBAOGFIuPQ+XXbehXoaMTVQqif04u
         nI5Q==
X-Gm-Message-State: AOAM531UWqol6YAL/zmUjSLW0zbYLBVWU5Vrk/NKMPq/WxI9buBIakAd
        /nx2k0o3ga9rLlM7mEafwZ22LHss62RdRdFXpkxzSM8oKcyjsmVFoRxku8FDEKySmgj0jdfZKfj
        dyYTHkRAJ6Zb08VgN
X-Received: by 2002:a17:906:4d56:: with SMTP id b22mr26898790ejv.78.1623234816996;
        Wed, 09 Jun 2021 03:33:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwCDKewP7XjcGyNfolErrcPHt/2wWqDkF2NBhrGIQsrtCaHXarMEITcengMHqcuVdMIj+HOg==
X-Received: by 2002:a17:906:4d56:: with SMTP id b22mr26898769ejv.78.1623234816671;
        Wed, 09 Jun 2021 03:33:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l8sm974784eds.79.2021.06.09.03.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:33:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A1AA218072C; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [PATCH bpf-next 08/17] freescale: remove rcu_read_lock() around XDP program invocation
Date:   Wed,  9 Jun 2021 12:33:17 +0200
Message-Id: <20210609103326.278782-9-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
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
2.31.1

