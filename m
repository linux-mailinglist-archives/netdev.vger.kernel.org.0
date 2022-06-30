Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CBC5619A0
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbiF3LxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiF3LxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:53:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53C913E04;
        Thu, 30 Jun 2022 04:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656589999; x=1688125999;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cW0oQUR6mdBMaptzHfnzVmAMNLO56Yt4tc94/lzO07A=;
  b=kWKfi2eI+JDfzNrCn+yuCY7ivbsxZRAzi64Iyg7OX5/XTWJi8srpJiDi
   mXj8Z3OXR76tfrHbfrzqOTnP07WwfNypO5l8Z15IEDHZc4xTx+8V5+kjU
   HZJYP8GRG/shnwnSj4eeg5gGhSNJrFB2w9bNRZauPskT2YxXr49HYhsaL
   BKiBfXSzqou/77v8rkkatkpyxxiubB+y89paUVy6YfAjnNjSdHPj4XeCk
   1QyvhsOrFltadWP81h1P1YejSmV9Q+HzHQMAbD81Baak7lT5fOXhnTfAG
   sYrp4/7VWo3KXEByT6IBvm0pQIjq7p4AKbdQlcauZoAyOoogdtPHyZ0e3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="283060032"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="283060032"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 04:53:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="694023931"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jun 2022 04:53:12 -0700
Date:   Thu, 30 Jun 2022 13:53:11 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf] xsk: mark napi_id on sendmsg()
Message-ID: <Yr2Op9m1xt5gW7Pw@boxer>
References: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
 <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
 <YrxLTiOIpD44JM7R@boxer>
 <20220629091629.1c241c21@kernel.org>
 <20220629091707.20d66524@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629091707.20d66524@kernel.org>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 05:17:07PM +0100, Jakub Kicinski wrote:
> On Wed, 29 Jun 2022 09:16:29 -0700 Jakub Kicinski wrote:
> > > Would it make sense to introduce napi_id to xsk_buff_pool then?
> > > xp_set_rxq_info() could be setting it. We are sure that napi_id is the
> > > same for whole pool (each xdp_buff_xsk's rxq info).  
> > 
> > Would it be possible to move the marking to when the queue is getting
> > bound instead of the recv/send paths? 
> 
> I mean when socket is getting bound.

So Bjorn said that it was the design choice to follow the standard
sockets' approach. I'm including a dirty diff for a discussion which
allows me to get napi_id at bind() time. But, this works for ice as this
driver during the XDP prog/XSK pool load only disables the NAPI, so we are
sure that napi_id stays the same. That might not be the case for other
AF_XDP ZC enabled drivers though, they might delete the NAPI and this
approach wouldn't work...or am I missing something?

I'd prefer the diff below though as it simplifies the data path, but I
can't say if it's safe to do so. We would have to be sure about drivers
keeping their NAPI struct. This would also allow us to drop napi_id from
xdp_rxq_info.

Thoughts?

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 49ba8bfdbf04..3d084558628e 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -312,6 +312,7 @@ ice_xsk_pool_enable(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 		return err;
 
 	set_bit(qid, vsi->af_xdp_zc_qps);
+	xsk_pool_set_napi_id(pool, vsi->rx_rings[qid]->q_vector->napi.napi_id);
 
 	return 0;
 }
@@ -348,7 +349,6 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 
 	pool_failure = pool_present ? ice_xsk_pool_enable(vsi, pool, qid) :
 				      ice_xsk_pool_disable(vsi, qid);
-
 xsk_pool_if_up:
 	if (if_running) {
 		ret = ice_qp_ena(vsi, qid);
@@ -358,6 +358,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
 	}
 
+
 failure:
 	if (pool_failure) {
 		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4aa031849668..1a20320cd556 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -44,6 +44,14 @@ static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
 	xp_set_rxq_info(pool, rxq);
 }
 
+static inline void xsk_pool_set_napi_id(struct xsk_buff_pool *pool,
+					unsigned int napi_id)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	xp_set_napi_id(pool, napi_id);
+#endif
+}
+
 static inline void xsk_pool_dma_unmap(struct xsk_buff_pool *pool,
 				      unsigned long attrs)
 {
@@ -198,6 +206,11 @@ static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
 {
 }
 
+static inline void xsk_pool_set_napi_id(struct xsk_buff_pool *pool,
+					unsigned int napi_id)
+{
+}
+
 static inline void xsk_pool_dma_unmap(struct xsk_buff_pool *pool,
 				      unsigned long attrs)
 {
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 647722e847b4..60775a8d1bcb 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -70,6 +70,7 @@ struct xsk_buff_pool {
 	u32 chunk_size;
 	u32 chunk_shift;
 	u32 frame_len;
+	unsigned int napi_id;
 	u8 cached_need_wakeup;
 	bool uses_need_wakeup;
 	bool dma_need_sync;
@@ -125,6 +126,7 @@ static inline void xp_init_xskb_dma(struct xdp_buff_xsk *xskb, struct xsk_buff_p
 
 /* AF_XDP ZC drivers, via xdp_sock_buff.h */
 void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq);
+void xp_set_napi_id(struct xsk_buff_pool *pool, unsigned int napi_id);
 int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 	       unsigned long attrs, struct page **pages, u32 nr_pages);
 void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index eafd512d38b1..18ac3f32a48d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -222,7 +222,6 @@ static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp)
 	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
 		return -EINVAL;
 
-	sk_mark_napi_id_once_xdp(&xs->sk, xdp);
 	return 0;
 }
 
@@ -637,11 +636,8 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
-	if (sk_can_busy_loop(sk)) {
-		if (xs->zc)
-			__sk_mark_napi_id_once(sk, xs->pool->heads[0].xdp.rxq->napi_id);
+	if (sk_can_busy_loop(sk))
 		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
-	}
 
 	if (xs->zc && xsk_no_wakeup(sk))
 		return 0;
@@ -1015,6 +1011,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	xs->dev = dev;
 	xs->zc = xs->umem->zc;
 	xs->queue_id = qid;
+	if (xs->zc)
+		xs->sk.sk_napi_id = xs->pool->napi_id;
 	xp_add_xsk(xs->pool, xs);
 
 out_unlock:
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 87bdd71c7bb6..5ec6443be3fc 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -121,6 +121,14 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
 }
 EXPORT_SYMBOL(xp_set_rxq_info);
 
+#ifdef CONFIG_NET_RX_BUSY_POLL
+void xp_set_napi_id(struct xsk_buff_pool *pool, unsigned int napi_id)
+{
+	pool->napi_id = napi_id;
+}
+EXPORT_SYMBOL(xp_set_napi_id);
+#endif
+
 static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
 {
 	struct netdev_bpf bpf;
