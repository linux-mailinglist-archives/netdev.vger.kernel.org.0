Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFADD622545
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 09:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiKII0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 03:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiKII0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 03:26:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E31C13D16
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 00:26:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD9E96186A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 08:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795BDC433D6;
        Wed,  9 Nov 2022 08:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667982378;
        bh=WIkYygIzkW3p8UnfJrEhjbp74yarOoLZHnmcoT19nO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=svVKSm3rA6Vq1m2zGHksIX4nLnS6JVdCbriyEh5Pu9Q23T1j6Pt7qfEYO3/PAyi8M
         42bwpFsaUKYb0eJgaYMWQW94Fn9q0e0EMSNjbwLDLesCCmk6Z4ObSOBPambSjl6oKX
         WmOtCnof9Qf6wadg92NaGYwn9clh57FLBTCKksMC2eQuNnc3XR9maJo16guveN7iWg
         QYQY74XP2gL7i2Xkb4z010Jj+Ec/R2VgISNB36aZO464dAMB2ORbXG7f8ktXLgqinL
         DBDxgVQA7ZHCNCm+18fkMp+cOUCHj0p+0ObaC68dbWhYMyvg0UYs+e1cdez8fU1aGJ
         ZPaIU+SMSCa8g==
Date:   Wed, 9 Nov 2022 10:26:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chengtian Liu <chengtian.liu@corigine.com>,
        HuanHuan Wang <huanhuan.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Message-ID: <Y2tkJjdLLSWyTO3l@unreal>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com>
 <Y2iiNMxr3IeDgIaA@unreal>
 <DM6PR13MB3705F170F1EB28EE34F0C503FC3E9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR13MB3705F170F1EB28EE34F0C503FC3E9@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 06:58:44AM +0000, Yinjun Zhang wrote:
> On Mon, 7 Nov 2022 08:14:12 +0200, Leon Romanovsky wrote:
> > On Tue, Nov 01, 2022 at 12:02:48PM +0100, Simon Horman wrote:
> <...>
> > > +
> > > +	/* General */
> > > +	switch (x->props.mode) {
> > > +	case XFRM_MODE_TUNNEL:
> > > +		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TUNNEL;
> > > +		break;
> > > +	case XFRM_MODE_TRANSPORT:
> > > +		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TRANSPORT;
> > > +		break;
> > > +	default:
> > > +		nn_err(nn, "Unsupported mode for xfrm offload\n");
> > 
> > There are no other modes.
> 
> Sorry this comment was neglected, but I have to say this is a good practice to avoid
> newly introduced mode in future sneaking into HW while it's not supported.

There is a subtitle difference between not-existent flows and
not-supported ones. Good practice is to rely on upper level API to do
the right thing from the beginning.

Thanks
