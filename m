Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98336CC9FC
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 20:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjC1SVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 14:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjC1SVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 14:21:04 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB141733
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 11:21:02 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 32SIKXR6982743;
        Tue, 28 Mar 2023 20:20:34 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 32SIKXR6982743
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1680027634;
        bh=unRdJCmUTMa0kNcN9qiOuyhayKX2flpyKHOK3iJ8RCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Js9B5z25gaiDTs0N3yInJCa8lrIeCHdEGuG/7tV2XdFHw9xp8ni0z83j5uVuyNMJh
         yjJEgzFGHrrCm8F7LxDW2l/z4j23rEbGq7uNgytcl4YA8B8u6Q8G6Inp4Xc/Bc2u6G
         1joyL1ivUT2l9xVwQxS/Ol60l0UTek018St2Kfvo=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 32SIKXkV982742;
        Tue, 28 Mar 2023 20:20:33 +0200
Date:   Tue, 28 Mar 2023 20:20:33 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <20230328182033.GA982617@electric-eye.fr.zoreil.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
 <20230326072636.3507-2-ehakim@nvidia.com>
 <20230327094335.07f462f9@kernel.org>
 <IA1PR12MB6353B5E1BC80B60993267190AB889@IA1PR12MB6353.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA1PR12MB6353B5E1BC80B60993267190AB889@IA1PR12MB6353.namprd12.prod.outlook.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=3.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Emeel Hakim <ehakim@nvidia.com> :
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
[...]
> > > +#if IS_ENABLED(CONFIG_MACSEC)
> > > +#define VLAN_MACSEC_MDO(mdo) \
> > > +static int vlan_macsec_ ## mdo(struct macsec_context *ctx) \ { \
> > > +     const struct macsec_ops *ops; \
> > > +     ops =  vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops; \
> > > +     return ops ? ops->mdo_ ## mdo(ctx) : -EOPNOTSUPP; \ }
> > > +
> > > +#define VLAN_MACSEC_DECLARE_MDO(mdo) vlan_macsec_ ## mdo
> > > +
> > > +VLAN_MACSEC_MDO(add_txsa);
> > > +VLAN_MACSEC_MDO(upd_txsa);
> > > +VLAN_MACSEC_MDO(del_txsa);
> > > +
> > > +VLAN_MACSEC_MDO(add_rxsa);
> > > +VLAN_MACSEC_MDO(upd_rxsa);
> > > +VLAN_MACSEC_MDO(del_rxsa);
> > > +
> > > +VLAN_MACSEC_MDO(add_rxsc);
> > > +VLAN_MACSEC_MDO(upd_rxsc);
> > > +VLAN_MACSEC_MDO(del_rxsc);
> > > +
> > > +VLAN_MACSEC_MDO(add_secy);
> > > +VLAN_MACSEC_MDO(upd_secy);
> > > +VLAN_MACSEC_MDO(del_secy);
> > 
> > -1
> > 
> > impossible to grep for the functions :( but maybe others don't care
> 
> Thank you for bringing up the issue you noticed. However, I decided to go with this approach
> because the functions are simple and look very similar, so there wasn't much to debug.
> Using a macro allowed for cleaner code instead of having to resort to ugly code duplication.

Sometime it's also nice to be able to use such modern tools as tags and
grep.

While it still implies some duplication and it doesn't automagically
prevent wrongly mixing vlan_macsec_foo() and ops->mdo_bar(), the code
below may be considered as a trade-off:

#define _B(mdo) \
	const struct macsec_ops *ops; \
	ops = vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops; \
	return ops ? ops->mdo_ ## mdo(ctx) : -EOPNOTSUPP; \


static int vlan_macsec_add_txsa(struct macsec_context *ctx) { _B(add_txsa) }
static int vlan_macsec_upd_txsa(struct macsec_context *ctx) { _B(upd_txsa) }
[...]
#undef _B

On a tangent topic, both codes expand 12 times the accessor

vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops.

It imvho deserves an helper function so that the compiler can make some
choice.

As a final remark, VLAN_MACSEC_DECLARE_MDO above does not buy much.
Compare:

static const struct macsec_ops macsec_offload_ops = {
	.mdo_add_txsa = VLAN_MACSEC_DECLARE_MDO(add_txsa),
	.mdo_upd_txsa = VLAN_MACSEC_DECLARE_MDO(upd_txsa),
[...]

vs

static const struct macsec_ops macsec_offload_ops = {
	.mdo_add_txsa = vlan_macsec_add_txsa,
	.mdo_upd_txsa = vlan_macsec_upd_txsa,
[...]

This one could probably be:

#define _I(mdo) .mdo_ ## mdo = vlan_macsec_ ## mdo

static const struct macsec_ops macsec_offload_ops = {
	_I(add_txsa),
	_I(upd_txsa),
[...]
#undef _I

-- 
Ueimor
