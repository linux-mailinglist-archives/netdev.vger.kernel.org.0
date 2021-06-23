Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974283B18A1
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhFWLQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:16:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230274AbhFWLQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qk5GBiM0tj1/P0/7gaLS65wrkya24n+AVH6Pdae+6a0=;
        b=Cb5k67aOTH0QJaglOjMGxRP278uzlUhli3srN85Hbr3ukvroWuvpgoCb0wZhceqZ/zBgjr
        09BFBfxhUk1zJRzgZMyQ7fIRX3P23WKiCYM9oClXcfa/3H9GmZ85CmqA546YF9utLpkc3o
        oAiXj0WZKXV/kIIz+HlcyqqoCdHvMCw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-G2Li0p56OXKWWTzLCm9vMg-1; Wed, 23 Jun 2021 07:13:44 -0400
X-MC-Unique: G2Li0p56OXKWWTzLCm9vMg-1
Received: by mail-ed1-f72.google.com with SMTP id p23-20020aa7cc970000b02903948bc39fd5so1104959edt.13
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qk5GBiM0tj1/P0/7gaLS65wrkya24n+AVH6Pdae+6a0=;
        b=fpAZ1N6PeJchq6NLfr2g8oiuShqO6XISZAtYVPxAv66ar0te+qSpOPUGxB0OK51frX
         lZvCUbhYvw/HRy43f8JG81ZL85qEmHW9LPyiajvBMK1kJyt7H8dK23rcCXLEV5CKswWJ
         QoqVW875ex4yYd9hsGzjPFutc4JCclx1b1dtbJElEmq+BpSvjowxkdXiRPDqZdIclHoo
         xouYwvclE+sefSje0tejwbEu/hk2AR3qaAOexw51LvGFUU8g4RFtYneuIyyx/RB0pX0b
         xCcXx5g1mdIGQ+kvPdP+lP5xCDYcneqWJewYLPfPGdxMdeX3Kagra6uG/V+MIaPFEIdU
         KOIg==
X-Gm-Message-State: AOAM533Oalei32tB89C61EPrVu0WZR5OMsHhkmvzV5a/Xn5dmfPJvcwY
        cilLKqep9iXLbqx1cLpiAP/PDGWebPcHJz8GXe/nBz1mwf8zW8rK+ay3H46K+gjy0CoLy/Tooja
        pZUNDpZNs3pH+V01n
X-Received: by 2002:aa7:c50d:: with SMTP id o13mr11372717edq.9.1624446823855;
        Wed, 23 Jun 2021 04:13:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztF5ae03ntoyILjp8pqHlp+iOfl1HNxJXBQz0XPbt2+lIDWho8ON30nAuFqqxYDRxnx9LSsA==
X-Received: by 2002:aa7:c50d:: with SMTP id o13mr11372696edq.9.1624446823683;
        Wed, 23 Jun 2021 04:13:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g8sm13567784edw.89.2021.06.23.04.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:13:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3EFD618073B; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v4 11/19] net: intel: remove rcu_read_lock() around XDP program invocation
Date:   Wed, 23 Jun 2021 13:07:19 +0200
Message-Id: <20210623110727.221922-12-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Intel drivers all have rcu_read_lock()/rcu_read_unlock() pairs around
XDP program invocations. However, the actual lifetime of the objects
referred by the XDP program invocation is longer, all the way through to
the call to xdp_do_flush(), making the scope of the rcu_read_lock() too
small. This turns out to be harmless because it all happens in a single
NAPI poll cycle (and thus under local_bh_disable()), but it makes the
rcu_read_lock() misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around.

Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com> # i40e
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 2 --
 drivers/net/ethernet/intel/i40e/i40e_xsk.c        | 6 +-----
 drivers/net/ethernet/intel/ice/ice_txrx.c         | 6 +-----
 drivers/net/ethernet/intel/ice/ice_xsk.c          | 6 +-----
 drivers/net/ethernet/intel/igb/igb_main.c         | 2 --
 drivers/net/ethernet/intel/igc/igc_main.c         | 7 ++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c      | 6 +-----
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 --
 9 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index de70c16ef619..ae3a64b6f5f8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2298,7 +2298,6 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 
 	if (!xdp_prog)
@@ -2329,7 +2328,6 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		break;
 	}
 xdp_out:
-	rcu_read_unlock();
 	return result;
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 46d884417c63..8dca53b7daff 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -153,7 +153,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	rcu_read_lock();
 	/* NB! xdp_prog will always be !NULL, due to the fact that
 	 * this path is enabled by setting an XDP program.
 	 */
@@ -162,9 +161,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
-		rcu_read_unlock();
-		return result;
+		return !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
 	}
 
 	switch (act) {
@@ -184,7 +181,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		result = I40E_XDP_CONSUMED;
 		break;
 	}
-	rcu_read_unlock();
 	return result;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e2b4b29ea207..1a311e91fb6d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1129,15 +1129,11 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
 #endif
 
-		rcu_read_lock();
 		xdp_prog = READ_ONCE(rx_ring->xdp_prog);
-		if (!xdp_prog) {
-			rcu_read_unlock();
+		if (!xdp_prog)
 			goto construct_skb;
-		}
 
 		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog);
-		rcu_read_unlock();
 		if (!xdp_res)
 			goto construct_skb;
 		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index faa7b8d96adb..d6da377f5ac3 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -463,7 +463,6 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 	struct ice_ring *xdp_ring;
 	u32 act;
 
-	rcu_read_lock();
 	/* ZC patch is enabled only when XDP program is set,
 	 * so here it can not be NULL
 	 */
@@ -473,9 +472,7 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
-		rcu_read_unlock();
-		return result;
+		return !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
 	}
 
 	switch (act) {
@@ -496,7 +493,6 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 		break;
 	}
 
-	rcu_read_unlock();
 	return result;
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 038a9fd1af44..8a11b7e55326 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8387,7 +8387,6 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 
 	if (!xdp_prog)
@@ -8420,7 +8419,6 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 		break;
 	}
 xdp_out:
-	rcu_read_unlock();
 	return ERR_PTR(-result);
 }
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ea998d2defa4..2b666a6ec989 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2175,18 +2175,15 @@ static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
 	struct bpf_prog *prog;
 	int res;
 
-	rcu_read_lock();
-
 	prog = READ_ONCE(adapter->xdp_prog);
 	if (!prog) {
 		res = IGC_XDP_PASS;
-		goto unlock;
+		goto out;
 	}
 
 	res = __igc_xdp_run_prog(adapter, prog, xdp);
 
-unlock:
-	rcu_read_unlock();
+out:
 	return ERR_PTR(-res);
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c5ec17d19c59..27d7467534e0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2199,7 +2199,6 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 	struct xdp_frame *xdpf;
 	u32 act;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 
 	if (!xdp_prog)
@@ -2237,7 +2236,6 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 		break;
 	}
 xdp_out:
-	rcu_read_unlock();
 	return ERR_PTR(-result);
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 91ad5b902673..ffbf8a694362 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -100,15 +100,12 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	struct xdp_frame *xdpf;
 	u32 act;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
-		rcu_read_unlock();
-		return result;
+		return !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
 	}
 
 	switch (act) {
@@ -132,7 +129,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		result = IXGBE_XDP_CONSUMED;
 		break;
 	}
-	rcu_read_unlock();
 	return result;
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index ba2ed8a43d2d..fabada4ce315 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1054,7 +1054,6 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 
 	if (!xdp_prog)
@@ -1079,7 +1078,6 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 		break;
 	}
 xdp_out:
-	rcu_read_unlock();
 	return ERR_PTR(-result);
 }
 
-- 
2.32.0

