Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439B161F382
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 13:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiKGMlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 07:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiKGMlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 07:41:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F59018B3F
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 04:41:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54DF4B810D6
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 12:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA83C433D6;
        Mon,  7 Nov 2022 12:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667824858;
        bh=88YfmZr0X04tnNVwTsEBzGmF7Ji7mOR3V1m4bFVghDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PGm0QTNKnpOAdNzBDK5RkNEp0zh0EXGdsAMdrZWkzM1x2WahwfBEyD1xpH1x+eesA
         OwRO3SqBAsx9L0LeMr2E2A20VgEcW8xD4y6EQKosSyf7UAKFK5gj3VgSIKbzCJpmrY
         tEYQ2YW62hLo4gxksNbIfX9hUBG838j0EO7lPQgciyMUCzc/6f9uSyhYW9JmFA1K5E
         LK4qgA2VwKckYAPd+KEQXILfoIlylUMt8BUhI2RfpOyy9+Pj0jZBXH61YcH/JQDQ+p
         6vXfVoQgGZTRDrp8LhvXDSa2V1xf4qqZHY5s4QEaxMpnDVDsWBVdfJyB9yS1jLJqXh
         Ukmh26w6bN6xg==
Date:   Mon, 7 Nov 2022 14:40:53 +0200
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
Message-ID: <Y2j81dBpMXrNqPER@unreal>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com>
 <Y2iiNMxr3IeDgIaA@unreal>
 <DM6PR13MB3705DADE119F1895CA27EF9DFC3C9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR13MB3705DADE119F1895CA27EF9DFC3C9@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 09:46:46AM +0000, Yinjun Zhang wrote:
> On Mon, 7 Nov 2022 08:14:12 +0200, Leon Romanovsky wrote:
>  <...>
> > > +	struct sa_ctrl_word {
> > > +		uint32_t hash   :4;	  /* From nfp_ipsec_sa_hash_type */
> > > +		uint32_t cimode :4;	  /* From nfp_ipsec_sa_cipher_mode */
> > > +		uint32_t cipher :4;	  /* From nfp_ipsec_sa_cipher */
> > > +		uint32_t mode   :2;	  /* From nfp_ipsec_sa_mode */
> > > +		uint32_t proto  :2;	  /* From nfp_ipsec_sa_prot */
> > > +		uint32_t dir :1;	  /* SA direction */
> > > +		uint32_t ena_arw:1;	  /* Anti-Replay Window */
> > > +		uint32_t ext_seq:1;	  /* 64-bit Sequence Num */
> > > +		uint32_t ext_arw:1;	  /* 64b Anti-Replay Window */
> > > +		uint32_t spare2 :9;	  /* Must be set to 0 */
> > > +		uint32_t encap_dsbl:1;	  /* Encap/Decap disable */
> > > +		uint32_t gen_seq:1;	  /* Firmware Generate Seq */
> > > +		uint32_t spare8 :1;	  /* Must be set to 0 */
> > > +	} ctrl_word;
> > > +	u32 spi;			  /* SPI Value */
> > > +	uint32_t pmtu_limit :16;	  /* PMTU Limit */
> > > +	uint32_t spare3     :1;
> > > +	uint32_t frag_check :1;		  /* Stateful fragment checking flag */
> > > +	uint32_t bypass_DSCP:1;		  /* Bypass DSCP Flag */
> > > +	uint32_t df_ctrl    :2;		  /* DF Control bits */
> > > +	uint32_t ipv6       :1;		  /* Outbound IPv6 addr format */
> > > +	uint32_t udp_enable :1;		  /* Add/Remove UDP header for NAT */
> > > +	uint32_t tfc_enable :1;		  /* Traffic Flow Confidentiality */
> > > +	uint32_t spare4	 :8;
> > > +	u32 soft_lifetime_byte_count;
> > > +	u32 hard_lifetime_byte_count;
> > 
> > These fields are not relevant for IPsec crypto offload. I would be more
> > than happy to see only used fields here.
> 
> They are not used currently in kernel indeed. However the HW is not designed for 
> crypto-offloading only, not for kernel only, some extensive features are supported. 
> So they're reserved here.

So mark them as reserved. If it is not supported by kernel, it shouldn't
be in the kernel.

> 
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
> > 
> > Why is it important for IPsec crypto? The HW logic must be the same for
> > all modes. There are no differences between transport and tunnel.
> 
> As I mentioned above, it's differentiated in HW to support more features.

You are adding crypto offload, so please don't try to sneak "more" features.

> 
> > 
> > > +	default:
> > > +		nn_err(nn, "Unsupported mode for xfrm offload\n");
> > 
> > There are no other modes.
> > 
> 
> <...>
> > 
> > > +	err = xa_alloc(&nn->xa_ipsec, &saidx, x,
> > > +		       XA_LIMIT(0, NFP_NET_IPSEC_MAX_SA_CNT - 1),
> > GFP_KERNEL);
> > 
> > Create XArray with XA_FLAGS_ALLOC1, it will cause to xarray skip 0.
> > See DEFINE_XARRAY_ALLOC1() for more info.
> 
> Actually 0 is a valid SA id in HW/driver, we don't want to skip 0.

NP, thanks
