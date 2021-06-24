Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6A03B338A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhFXQJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:09:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230296AbhFXQIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624550785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d8AUSo1RzaNAGEUROtgo1E1rKFmBeyherDHigclTTCY=;
        b=IE8bP2WbFK3ImObfziU1L9Cp1GcqPEN8fQ05Hh8CxN6bCZCivfzV6P5Eg5DNW8m19/0RWm
        JwA5pHB+cBs679QfKboJD5KthCjfOVOWj7t8EWYnUQ4gVXFNfHosbYj8oz9k9O5nbLEgsU
        2G+6AkjhXBgmEB+f6zbZX1kNrgw9JNY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-sruUud8ePx-BvVI_c_gCaw-1; Thu, 24 Jun 2021 12:06:23 -0400
X-MC-Unique: sruUud8ePx-BvVI_c_gCaw-1
Received: by mail-ed1-f71.google.com with SMTP id p19-20020aa7c4d30000b0290394bdda6d9cso3555175edr.21
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d8AUSo1RzaNAGEUROtgo1E1rKFmBeyherDHigclTTCY=;
        b=d7/ThVkiR1ZsGJztI+u01nRKePh+3fga64/nz0is5WG5IqXvU5yeerGjYvRU2rzmH7
         wUThFMqc1vj8wVPD1CDUookP9aOtw42bB/yTQYQRNkyd9rjijQ6McON31RyycgaP/8uL
         DWp5H+R4a/LeGNVCMa0eE1fEn95XDxEA0kjgsCZBlI/5emfMlzOPOIZQ2/DH9zsV53qw
         PoKfJnaCuk3hY+jnqrYVCix3FrDJ+LghDFvlVqOX30B/eIcw2bcX3IF/ZRhsTGTpB9DH
         uP9+CUoSzUqGlE6GBb0f9CUZdhe3xKedXW1AJ1ndRhvA3RU8sPJdtrmbQpYE5irsIFph
         4AIQ==
X-Gm-Message-State: AOAM531CTKYxJdqtuUk1V1QkfBP/Ncy+wtpDCRLfxbP2uVCKO6BGSawK
        4mJKSxN4QkqzUMS0WYf+0b8woYVxnqnl64NM57R8QyhxJdxx1jYp1SYcyqTpVEzPoUKSSJW5RhB
        rAw54+uGDzQveOqJE
X-Received: by 2002:aa7:db93:: with SMTP id u19mr8156327edt.227.1624550782748;
        Thu, 24 Jun 2021 09:06:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnTEqbmUGGZILpfV8wM2Ht6OYgL4HLYG/bFhxmow1xj2znDDrOXghxHZUpB9hR+99yIK7QTg==
X-Received: by 2002:aa7:db93:: with SMTP id u19mr8156296edt.227.1624550782604;
        Thu, 24 Jun 2021 09:06:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u22sm2217624edr.11.2021.06.24.09.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:06:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7746518073C; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
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
Subject: [PATCH bpf-next v5 11/19] net: intel: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 24 Jun 2021 18:06:01 +0200
Message-Id: <20210624160609.292325-12-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
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
 drivers/net/ethernet/intel/i40e/i40e_xsk.c        | 3 ---
 drivers/net/ethernet/intel/ice/ice_txrx.c         | 6 +-----
 drivers/net/ethernet/intel/ice/ice_xsk.c          | 3 ---
 drivers/net/ethernet/intel/igb/igb_main.c         | 2 --
 drivers/net/ethernet/intel/igc/igc_main.c         | 7 ++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c      | 3 ---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 --
 9 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b883ab809df3..38eb8151ee9a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2298,7 +2298,6 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 
 	if (!xdp_prog)
@@ -2334,7 +2333,6 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		break;
 	}
 xdp_out:
-	rcu_read_unlock();
 	return result;
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 68f177a86403..e7e778ca074c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -153,7 +153,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	rcu_read_lock();
 	/* NB! xdp_prog will always be !NULL, due to the fact that
 	 * this path is enabled by setting an XDP program.
 	 */
@@ -164,7 +163,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
 		if (err)
 			goto out_failure;
-		rcu_read_unlock();
 		return I40E_XDP_REDIR;
 	}
 
@@ -188,7 +186,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		result = I40E_XDP_CONSUMED;
 		break;
 	}
-	rcu_read_unlock();
 	return result;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 917eba7fdd0c..dd791ca34fab 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1135,15 +1135,11 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
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
index 239b9bf10794..8a093368f631 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -466,7 +466,6 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 	struct ice_ring *xdp_ring;
 	u32 act;
 
-	rcu_read_lock();
 	/* ZC patch is enabled only when XDP program is set,
 	 * so here it can not be NULL
 	 */
@@ -478,7 +477,6 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
 		if (err)
 			goto out_failure;
-		rcu_read_unlock();
 		return ICE_XDP_REDIR;
 	}
 
@@ -503,7 +501,6 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 		break;
 	}
 
-	rcu_read_unlock();
 	return result;
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5db303d64d14..7e6435dc7e80 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8381,7 +8381,6 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 
 	if (!xdp_prog)
@@ -8416,7 +8415,6 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 		break;
 	}
 xdp_out:
-	rcu_read_unlock();
 	return ERR_PTR(-result);
 }
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3f6b6d4543a8..95323095094d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2240,18 +2240,15 @@ static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
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
index 2ac5b82676f3..ffff69efd78a 100644
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
index f72d2978263b..96dd1a4f956a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -100,7 +100,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	struct xdp_frame *xdpf;
 	u32 act;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
@@ -108,7 +107,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
 		if (err)
 			goto out_failure;
-		rcu_read_unlock();
 		return IXGBE_XDP_REDIR;
 	}
 
@@ -134,7 +132,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		result = IXGBE_XDP_CONSUMED;
 		break;
 	}
-	rcu_read_unlock();
 	return result;
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index dc56931fc1dc..c714e1ecd308 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1054,7 +1054,6 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 
 	if (!xdp_prog)
@@ -1082,7 +1081,6 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 		break;
 	}
 xdp_out:
-	rcu_read_unlock();
 	return ERR_PTR(-result);
 }
 
-- 
2.32.0

