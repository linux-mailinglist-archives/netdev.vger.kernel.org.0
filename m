Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB86621C1C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiKHSnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiKHSnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:43:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31D95985F
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:43:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E62CB81B38
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C978BC433C1;
        Tue,  8 Nov 2022 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667932984;
        bh=rt3qy5IcrI9e8hqm+WCPRkt2rVrW3Uk32XStnmMy4z4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=milU5Pt/uzeavUsyRARnhmz7R4ZvioWWoH09HiKk2W1poJlfX5vESnV3g4Vx5j5B4
         lWD79ZNmWwc8UYPK2QWamMQW4S35LrZ6Q7rTYBJHEo3qz2L04oAAZLnt3oZtWp35k8
         qAbdN+6VnIZ+W6N4lksjz/K+hSJGfcZt2tLNKpX9tQFgFTvWBb4XiclgwL0aAOHlS+
         mJNm7GTCeVEP85AbUw4/ptIl5K3HUW09SqNnxOWMushseHZ1oStpa4jp5bOPgysy78
         TTsBsCCYDDSnlh60PYDEIG/abw4tZI6fZFJ140rbm2hJeAp9ZjcGA6iaoZGdHHE/X4
         dcZenw2USyLOQ==
Date:   Tue, 8 Nov 2022 20:42:59 +0200
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
Message-ID: <Y2qjM0fWLJffS/BB@unreal>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com>
 <Y2iiNMxr3IeDgIaA@unreal>
 <DM6PR13MB3705DADE119F1895CA27EF9DFC3C9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <Y2j81dBpMXrNqPER@unreal>
 <DM6PR13MB3705D1657D48FD6C31753E04FC3F9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR13MB3705D1657D48FD6C31753E04FC3F9@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 01:28:20AM +0000, Yinjun Zhang wrote:
> On Mon, 7 Nov 2022 14:40:53 +0200, Leon Romanovsky wrote:
> > On Mon, Nov 07, 2022 at 09:46:46AM +0000, Yinjun Zhang wrote:
> > > On Mon, 7 Nov 2022 08:14:12 +0200, Leon Romanovsky wrote:
> > > <...>
> > > > > +
> > > > > +	/* General */
> > > > > +	switch (x->props.mode) {
> > > > > +	case XFRM_MODE_TUNNEL:
> > > > > +		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TUNNEL;
> > > > > +		break;
> > > > > +	case XFRM_MODE_TRANSPORT:
> > > > > +		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TRANSPORT;
> > > > > +		break;
> > > >
> > > > Why is it important for IPsec crypto? The HW logic must be the same for
> > > > all modes. There are no differences between transport and tunnel.
> > >
> > > As I mentioned above, it's differentiated in HW to support more features.
> > 
> > You are adding crypto offload, so please don't try to sneak "more" features.
> > 
> 
> No sneaking, just have to conform to the design of HW, so that things are not
> messed up.

So what is the answer to my question above "Why is it important for IPsec crypto?"?

Thanks
