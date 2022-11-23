Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA7A635F0D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbiKWNKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238096AbiKWNKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:10:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5DB6DCDD
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:53:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D77E0B81F3E
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C947C433C1;
        Wed, 23 Nov 2022 12:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207998;
        bh=dzZlgr9BhYR3HRMt5XMLhYLS0imPo3eO3J0nLZWYhY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kALjufl+xh9IR6Q8FThhCfr6QUaRtfU3LjEzTdp4cSKsmSm0tNdZJN7OfmXU9O5wb
         OdsWRVHMyfkw8VC/CFx3+kjw+qBgc9SDkwpM3AppF15psShXPsjjg2FewLkbsuPYkQ
         9TuzYtSrQbt4o1U+0K31kc/KPBy+MOHK7hg3Ktm4WMFVRe77dAWwHM1GjLdnZwUy/q
         ceIRSOin0g87v/DGWTCACKaez+PDo4ov/PoE0SC9G3P48cCUikQqQx+JWOeXeNafpW
         OpO5DU0dUDNOyZFESLsyQrVSkveefnEGBEc3Ib8xa1Nx8MeeLTg35pXEuRCmLmeB38
         u3A4JC6PPicoA==
Date:   Wed, 23 Nov 2022 14:53:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y34Xtqa+F79DCf6S@unreal>
References: <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <Y3to7FYBwfkBSZYA@unreal>
 <20221121124349.GZ704954@gauss3.secunet.de>
 <Y3t2tsHDpxjnBAb/@unreal>
 <20221122131002.GN704954@gauss3.secunet.de>
 <Y3zVVzfrR1YKL4Xd@unreal>
 <20221123083720.GM424616@gauss3.secunet.de>
 <Y33pk/3rUxFqbH2h@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y33pk/3rUxFqbH2h@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 11:36:19AM +0200, Leon Romanovsky wrote:
> On Wed, Nov 23, 2022 at 09:37:20AM +0100, Steffen Klassert wrote:
> > On Tue, Nov 22, 2022 at 03:57:43PM +0200, Leon Romanovsky wrote:
> > > On Tue, Nov 22, 2022 at 02:10:02PM +0100, Steffen Klassert wrote:
> > > > On Mon, Nov 21, 2022 at 03:01:42PM +0200, Leon Romanovsky wrote:
> > > > > On Mon, Nov 21, 2022 at 01:43:49PM +0100, Steffen Klassert wrote:
> > > > > > On Mon, Nov 21, 2022 at 02:02:52PM +0200, Leon Romanovsky wrote:
> > > > > > 
> > > > > > If policy and state do not match here, this means the lookup
> > > > > > returned the wrong state. The correct state might still sit
> > > > > > in the database. At this point, you should either have found
> > > > > > a matching state, or no state at all.
> > > > > 
> > > > > I check for "x" because of "x = NULL" above.
> > > > 
> > > > This does not change the fact that the lookup returned the wrong state.
> > > 
> > > Steffen, but this is exactly why we added this check - to catch wrong
> > > states and configurations. 
> > 
> > No, you have to adjust the lookup so that this can't happen.
> > This is not a missconfiguration, The lookup found the wrong
> > SA, this is a difference.
> > 
> > Use the offload type and dev as a lookup key and don't consider
> > SAs that don't match this in the lookup.
> > 
> > This is really not too hard to do. The thing that could be a bit
> > more difficult is that the lookup should be only adjusted when
> > we really have HW policies installed. Otherwise this affects
> > even systems that don't use this kind of offload.
> 
> Thanks for an explanation, trying it now.

Something like that?

The code is untested yet.

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 5076f9d7a752..5819023c32ba 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1115,6 +1115,19 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	rcu_read_lock();
 	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
 	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
+		if (IS_ENABLED(CONFIG_XFRM_OFFLOAD) &&
+		    pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
+			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
+				/* HW states are in the head of list, there is no need
+				 * to iterate further.
+				 */
+				break;
+
+			/* Packet offload: both policy and SA should have same device */
+			if (pol->xdo.dev != x->xso.dev)
+				continue;
+		}
+
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -1132,6 +1145,19 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 
 	h_wildcard = xfrm_dst_hash(net, daddr, &saddr_wildcard, tmpl->reqid, encap_family);
 	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
+		if (IS_ENABLED(CONFIG_XFRM_OFFLOAD) &&
+		    pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
+			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
+				/* HW states are in the head of list, there is no need
+				 * to iterate further.
+				 */
+				break;
+
+			/* Packet offload: both policy and SA should have same device */
+			if (pol->xdo.dev != x->xso.dev)
+				continue;
+		}
+
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -1185,6 +1211,17 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			goto out;
 		}
 
+		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
+			memcpy(&x->xso, &pol->xdo, sizeof(x->xso));
+			error = pol->xdo.dev->xfrmdev_ops->xdo_dev_state_add(x);
+			if (error) {
+				x->km.state = XFRM_STATE_DEAD;
+				to_put = x;
+				x = NULL;
+				goto out;
+			}
+		}
+
 		if (km_query(x, tmpl, pol) == 0) {
 			spin_lock_bh(&net->xfrm.xfrm_state_lock);
 			x->km.state = XFRM_STATE_ACQ;
