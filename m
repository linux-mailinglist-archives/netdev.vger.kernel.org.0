Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E4D5FECE8
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 13:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiJNLIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 07:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiJNLIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 07:08:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5E910B43
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 04:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE14861AB9
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 11:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B09C433D6;
        Fri, 14 Oct 2022 11:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665745730;
        bh=Wa+XSvXMIQxJXBB9eF2WbJqdeXzxcRo7e2fz7ZaZvRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gW8UsOshEwAxjfOIBIzXdgnp9U+2HrhO6lbkxLSoEjL4v3PnHd3gfNVrD4lZKqT9j
         Spb1mVKVsYiSDjwu7HTQ3AxrgcTSO8t8mGdrS8aDP/c7RIBSZvk+sCsqqBVRvpVQNA
         z9xyJgVGBSIH0w8hJiYcmBw/KyNmK9JeAvc+oWlwIMdZPASI+nTmzgweO6cs1EGGsP
         I7yFPqJaSXop4kVga9TS2CtjCxljwovrTlOBDCrDkQscsPNBKcPcdqxDdu57HVR3aJ
         O0aZR4ClmyQTxO5BX7nzX/NxRrJpCYxOnf+3u0QHKfhrBY6I3PRXFPRDtcvxQb3rO2
         8UE3qfjhV2PLQ==
Date:   Fri, 14 Oct 2022 14:08:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net 3/5] macsec: fix secy->n_rx_sc accounting
Message-ID: <Y0lDPQ+mm9nD+raq@unreal>
References: <cover.1665416630.git.sd@queasysnail.net>
 <1879f6c8a7fcb5d7bb58ffb3d9fed26c8d7ec5cb.1665416630.git.sd@queasysnail.net>
 <Y0j+2J2uBqrhqRtg@unreal>
 <Y0kTLaz95PUE4uQz@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0kTLaz95PUE4uQz@hog>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 09:43:41AM +0200, Sabrina Dubroca wrote:
> 2022-10-14, 09:16:56 +0300, Leon Romanovsky wrote:
> [...]
> > > @@ -1897,15 +1899,16 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
> > >  	secy = &macsec_priv(dev)->secy;
> > >  	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
> > >  
> > > -	rx_sc = create_rx_sc(dev, sci);
> > > +
> > > +	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
> > > +		active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
> > 
> > You don't need !! to assign to bool variables and can safely omit them.
> 
> Yeah, but I'm just moving existing code, see below.

Not really, original code was "rx_sc->active = ...", but you changed to
use local value. So it is perfectly fine to fix the !! too.

Thanks
