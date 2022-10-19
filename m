Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E7660507B
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJSTd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiJSTd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:33:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DAC1BE1C3
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=XxgzoQwgQitKmjawGJJFqMcCSZjN8NVeqJ2nuL3Ui0A=;
        t=1666208037; x=1667417637; b=K9Y70tNhy5TDZ62N6asDI9Lbyq8JP1IBYLtObgiDcO3XPYi
        A3Bf1SlYPlRiNp9hdiGy1JyBQT2PprtrTwPrzjTEQion0U8wkEESgyxpjDgRWplUQDCyYWI/PIRxT
        pCDEe1L0vdSH6ZzclhBC90YBPx/rI+aKWSR7zOxiEXhlas3iQzYmmZO4HLdDdfgjvRcomljnnA1Ko
        cNPUBuJIfA1vUYmMBzF9cNL89UJEqbI2CUgg6LUxIZTx1Ei9EyOTBBYGL199b+K/MXVL4A+kSX4z3
        OdUWdbWVLQ0fuDbvK8NR5Q1TRhyO5i4Y4WVbY5p8TCgOfLb02KE/3l4caZNG1BqQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1olEoy-00BDY1-2D;
        Wed, 19 Oct 2022 21:33:44 +0200
Message-ID: <2bc3395a3aa8f3789990b58739daaaed85d99bc0.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 04/13] genetlink: load policy based on
 validation flags
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Date:   Wed, 19 Oct 2022 21:33:43 +0200
In-Reply-To: <20221019122039.7aff557c@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-5-kuba@kernel.org>
         <4c0f8e0aa1ed0b84bf7074bd963fcaec96eff515.camel@sipsolutions.net>
         <20221019122039.7aff557c@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-10-19 at 12:20 -0700, Jakub Kicinski wrote:
> On Wed, 19 Oct 2022 10:01:04 +0200 Johannes Berg wrote:
> > On Tue, 2022-10-18 at 16:07 -0700, Jakub Kicinski wrote:
> > > Set the policy and maxattr pointers based on validation flags. =20
> >=20
> > I feel like you could have more commit message here
> >=20
> > >  	ops =3D ctx->ops;
> > > -	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
> > > -		goto no_attrs;
> > > -
> > > -	if (ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
> > > +	if (!(ops->validate & GENL_DONT_VALIDATE_DUMP) &&
> > > +	    ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
> > >  		return -EINVAL;
> > > =20
> > >  	attrs =3D genl_family_rcv_msg_attrs_parse(ctx->family, ctx->nlh, ct=
x->extack, =20
> >=20
> > especially since this actually changes things to *have* the attrs, but
> > not have *validated* them, which feels a bit strange and error-prone in
> > the future maybe?
>=20
> Do you mean that we no longer populate op->maxattr / op->policy and
> some op may be reading those? I don't see any family code looking at
> info->op.policy / maxattr.
>=20
> First thing genl_family_rcv_msg_attrs_parse() does is:
>=20
> 	if (!ops->maxattr)
> 		return NULL;
>=20
> So whether we skip it or call it - no difference.
>=20

Oh. I missed that, ok, thanks for clearing that up!

johannes
