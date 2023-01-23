Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BED678743
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjAWUKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjAWUKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:10:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C532B7A9C;
        Mon, 23 Jan 2023 12:10:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ECA96102F;
        Mon, 23 Jan 2023 20:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3070FC433D2;
        Mon, 23 Jan 2023 20:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674504600;
        bh=x79GNAYGa5nqxksUZTAo1zLvL5fVbuVje1NDQA8AE6k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OD7S+PMxqfw4XRZjqaqZ34DYR37+wyAhOxXb8NLUjsJBDaOtBKv1RFk/IkFrBsAwG
         ig3HbTZYPmN2vmtYk6OsDKzPhwcKYJ4sqfptxoKhL01szt8bU6K1VbhQ7eN8p7Too4
         9z8DpxQft9B5q/nWdQYGGp4jSBu2qow10keNqh89VlzNbj8Rd+TPg5bZsYqEN2V4RQ
         PxxGz3sgZnui3xHzaZx1OZy3P5fmSdznskDHPXUMNXQvHZ+RHp2L6YNibm4NXT5R/M
         4AqcpV7Rn54AQ2/jxkepEDovURhrx2EPthcBt0C6nfTwKi2oBY3ZXj/L+ZAqWYPxO2
         bTDr6w9YtA1rw==
Date:   Mon, 23 Jan 2023 12:09:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        niklas.soderlund@corigine.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 6/7] bpf: devmap: check XDP features in
 bpf_map_update_elem and __xdp_enqueue
Message-ID: <20230123120958.741cf5f1@kernel.org>
In-Reply-To: <Y80odbX/CVjlYalh@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
        <acc9460e6e29dfe02cf474735277e196b500d2ef.1674234430.git.lorenzo@kernel.org>
        <d0232e99-862b-3255-aeac-7c04486cb773@linux.dev>
        <Y80odbX/CVjlYalh@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Jan 2023 13:13:41 +0100 Lorenzo Bianconi wrote:
> > > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> > > index d01e4c55b376..69ceecc792df 100644
> > > --- a/kernel/bpf/devmap.c
> > > +++ b/kernel/bpf/devmap.c
> > > @@ -474,7 +474,11 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> > >   {
> > >   	int err;
> > > -	if (!dev->netdev_ops->ndo_xdp_xmit)
> > > +	if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))  
> > 
> > The current "dev->netdev_ops->ndo_xdp_xmit" check is self explaining.
> > Any plan to put some document for the NETDEV_XDP_ACT_* values?
> >   
> 
> I am not a yaml description expert but I guess we can xdp features description
> in Documentation/netlink/specs/netdev.yaml.
> 
> @Jakub: what do you think?

I've added the ability to document enums recently, so you may need
to rebase. But it should work and render the documentation as kdoc 
in the uAPI header (hopefully in a not-too-ugly way).

Example of YAML:
https://github.com/kuba-moo/ynl/blob/dpll/Documentation/netlink/specs/dpll.yaml#L27-L46

I've also talked to the iproute2-py maintainer about generating
documentation directly from YAML to Sphinx/htmldocs, hopefully 
that will happen, too. It would be good to have a few families 
to work with before we start that work, tho.
