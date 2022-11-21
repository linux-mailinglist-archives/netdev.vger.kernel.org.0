Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8D6632185
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 13:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiKUMDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 07:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiKUMDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 07:03:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDE9DE84
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 04:02:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AF85B80E95
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEB0C433D6;
        Mon, 21 Nov 2022 12:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669032177;
        bh=knALYk7ca+Q9ScCmST4hNRdBJrZp1Z/rivKIU1i/CdI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TnMxiPnCDmn0Atn7tmTpUHM2ECpf3CuOYbaOemsi89qkuz8SdofQl2WyON8ZKlhP9
         nIec4gxz+CrS4iG1pKtonh4YoxNUfxkEq40RledyfA8zV00qPWzF2L3xbemF3ZxwYt
         BFzSMcSYiQccc3lOCcq/Ei7MP+yPHiKNbeb+q/Cgyy3tIkBUxmzwoPggSBKgxaN9BM
         Y0odk0dCMlhU2V7kcBZ+cCkAkssDmw9AEFcdEtgnhWFZcbMv8nnHtfonmug2vGZcqq
         d4H0YzARlPfU+x81GQDvoKj7d/mbS3cKPvET1IqMXavrrMRvspVQkYsFDgm+tXneQv
         ry7Hcjtj+Uigg==
Date:   Mon, 21 Nov 2022 14:02:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3to7FYBwfkBSZYA@unreal>
References: <20221117121243.GJ704954@gauss3.secunet.de>
 <Y3YuVcj5uNRHS7Ek@unreal>
 <20221118104907.GR704954@gauss3.secunet.de>
 <Y3p9LvAEQMAGeaCR@unreal>
 <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3tiRnbfBcaH7bP0@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 01:34:30PM +0200, Leon Romanovsky wrote:
> On Mon, Nov 21, 2022 at 12:25:21PM +0100, Steffen Klassert wrote:
> > On Mon, Nov 21, 2022 at 01:15:36PM +0200, Leon Romanovsky wrote:
> > > On Mon, Nov 21, 2022 at 12:09:26PM +0100, Steffen Klassert wrote:
> > > > On Mon, Nov 21, 2022 at 12:27:01PM +0200, Leon Romanovsky wrote:
> > > > > On Mon, Nov 21, 2022 at 10:44:04AM +0100, Steffen Klassert wrote:
> > > > > > On Sun, Nov 20, 2022 at 09:17:02PM +0200, Leon Romanovsky wrote:
> > > > > > > On Fri, Nov 18, 2022 at 11:49:07AM +0100, Steffen Klassert wrote:
> > > > > > > > On Thu, Nov 17, 2022 at 02:51:33PM +0200, Leon Romanovsky wrote:
> > > > > > > > > On Thu, Nov 17, 2022 at 01:12:43PM +0100, Steffen Klassert wrote:
> > > > > > > > > > On Wed, Nov 09, 2022 at 02:54:34PM +0200, Leon Romanovsky wrote:
> > > > > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > > > 
> > > > > > > > > > So this raises the question how to handle acquires with this packet
> > > > > > > > > > offload. 
> > > > > > > > > 
> > > > > > > > > We handle acquires as SW policies and don't offload them.
> > > > > > > > 
> > > > > > > > We trigger acquires with states, not policies. The thing is,
> > > > > > > > we might match a HW policy but create a SW acquire state.
> > > > > > > > This will not match anymore as soon as the lookup is
> > > > > > > > implemented correctly.
> > > > > > > 
> > > > > > > For now, all such packets will be dropped as we have offlaoded
> > > > > > > policy but not SA.
> > > > > > 
> > > > > > I think you missed my point. If the HW policy does not match
> > > > > > the SW acquire state, then each packet will geneate a new
> > > > > > acquire. So you need to make sure that policy and acquire
> > > > > > state will match to send the acquire just once to userspace.
> > > > > 
> > > > > I think that I'm still missing the point.
> > > > > 
> > > > > We require both policy and SA to be offloaded. It means that once
> > > > > we hit HW policy, we must hit SA too (at least this is how mlx5 part
> > > > > is implemented).
> > > > 
> > > > Let's assume a packet hits a HW policy. Then this HW policy must match
> > > > a HW state. In case there is no matching HW state, we generate an acquire
> > > > and insert a larval state. Currently, larval states are never marked as HW.
> > > 
> > > And this is there our views are different. If HW (in RX) sees policy but
> > > doesn't have state, this packet will be dropped in HW. It won't get to
> > > stack and no acquire request will be issues.
> > 
> > This makes no sense. Acquires are always generated at TX, never at RX.
> 
> Sorry, my bad. But why can't we drop all packets that don't have HW
> state? Why do we need to add larval?

I think that something like this will do the trick.

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 5076f9d7a752..d1c9ef857755 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1090,6 +1090,28 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
        }
 }

+static bool xfrm_state_and_policy_mixed(struct xfrm_state *x,
+                                       struct xfrm_policy *p)
+{
+       /* Packet offload: both policy and SA should be offloaded */
+       if (p->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
+           x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
+               return true;
+
+       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET &&
+           x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
+               return true;
+
+       if (p->xdo.type != XFRM_DEV_OFFLOAD_PACKET)
+               return false;
+
+       /* Packet offload: both policy and SA should have same device */
+       if (p->xdo.dev != x->xso.dev)
+               return true;
+
+       return false;
+}
+
 struct xfrm_state *
 xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
                const struct flowi *fl, struct xfrm_tmpl *tmpl,
@@ -1147,7 +1169,8 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,

 found:
        x = best;
-       if (!x && !error && !acquire_in_progress) {
+       if (!x && !error && !acquire_in_progress &&
+           pol->xdo.type != XFRM_DEV_OFFLOAD_PACKET) {
                if (tmpl->id.spi &&
                    (x0 = __xfrm_state_lookup(net, mark, daddr, tmpl->id.spi,
                                              tmpl->id.proto, encap_family)) != NULL) {
@@ -1228,7 +1251,14 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
                        *err = -EAGAIN;
                        x = NULL;
                }
+               if (x && xfrm_state_and_policy_mixed(x, pol)) {
+                       *err = -EINVAL;
+                       x = NULL;
+               }
        } else {
+               if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET)
+                       error = -EINVAL;
+
                *err = acquire_in_progress ? -EAGAIN : error;
        }
        rcu_read_unlock();
(END)


> 
> > 
> > On RX, the state lookup happens first, the policy must match to the
> > decapsulated packet.
> > 
