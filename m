Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C805A1DE4
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiHZBBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiHZBBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:01:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079B8C7FB4
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 18:01:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9987E61DA2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE42DC433D7;
        Fri, 26 Aug 2022 01:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661475668;
        bh=HzoT+A5fIJpmV9MyhJEoNecFTUWq5qQwcUUpIpUYNco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s45zyiWIryew5/fUo94CrdtMI2Kd0C7O7OWOZYYZuxFkDetysz/xR6InZiWQWNcbJ
         PMV6A4paGrDK7aj68ZQGxFVcyS+hYQQZBrfqXo6k6QvG9EI7z6ImcK1m21KbeyLJqA
         jHOHF4c2N5Xk1aTb+I2PriPHByG/aD0Ov4TTDJd4WNWu7lmZr3z0fi0vw+KkeE0t1N
         nuCDJh6hLN05SOiOrcTYN6DVOr2gLADMmN3atDa9doAC7fiub7Nzhv12Y90Wq4TriI
         kNHLJL9+rhtoO1M03KNds+iJP+Hve7122riNo7VGD09NuApWDRX4XdyOQxEHMXyC+7
         3U1+ga48HZKkw==
Date:   Thu, 25 Aug 2022 18:01:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Message-ID: <20220825180107.38915c09@kernel.org>
In-Reply-To: <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
        <20220825092957.26171986@kernel.org>
        <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825103027.53fed750@kernel.org>
        <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825133425.7bfb34e9@kernel.org>
        <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 17:38:14 -0700 Jacob Keller wrote:
> On 8/25/2022 1:34 PM, Jakub Kicinski wrote:
> > Hard to get consensus if we still don't know what the FW does...
> > But if there's no new uAPI, just always enabling OFF with AUTO
> > then I guess I'd have nothing to complain about as I don't know
> > what other drivers do either.
> >  =20
> Ok. I think I have a basic summary of the situation and whats going on
> in the firmware. I'll try to summarize here:
>=20
> Firmware has a state machine that we call the Link Establishment State
> Machine. This is the state machine which will attempt to establish link.
> This state machine only applies when auto-negotiation is not used. If
> auto-negotation is used it will perform the standard auto-negotiation
> flow and set FEC through that method.
>=20
> The way this works follows this flow:
>=20
> 1) driver sends a set PHY capabilities request. This includes various
> bits including whether to automatically select FEC, and which FEC modes
> to select from. When we enable ETHTOOL_FEC_AUTO, the driver always sets
> all FEC modes with the auto FEC bit.
>=20
> 2) the firmware receives this request and begins the LESM. This starts
> with the firmware generating a list of configurations to attempt. Each
> configuration is a possible link mode combined with a bitwise AND of the
> FEC modes requested above in set PHY capabiltiies and the set of FEC
> modes supported by that link mode. The example I gave was if you plugged
> in a CA-L cable, it would try:
>=20
>   100G-CAUI4
>   50G-LAUI2
>   25G-AUI-C2C
>   10G-SFI-DA
>=20
> I'm still not 100% sure how it decides which link modes to choose for
> which cable, but I believe this is in a table stored within the firmware
> module we call the netlist.
>=20
> 2a) for older firmware, the set PHY capabiltiies interface does not have
> a bit to set for requesting No FEC. Instead, each media type has a
> determination made about whether it needed FEC of not. I was told for
> example that CA-N cables would enable No FEC as an option, but CA-L
> cables would not (even though No FEC is supported for the link modes in
> question).
>=20
> 2b) on newer firmware, the set PHY capabilities interface does have a
> bit to request No FEC. In this case, if we set the No FEC bit, then the
> firmware will be able to select No FEC as an option for cables that
> otherwise wouldn't have selected it in the old firmware (such as CA-L
> cables mentioned above).

Oh, but per the IEEE standard No FEC is _not_ an option for CA-L.
=46rom the initial reading of your series I thought that Intel NICs=20
would _never_ pick No FEC.

Sounds like we need a bit for "ignore the standard and try everything".

What about BASE-R FEC? Is the FW going to try it on the CA-L cable?

> 3) once the firmware has generated the list of possible configurations,
> it will iterate through them in a loop. Each configuration is applied,
> and then we wait some time (the timeout is also stored in the netlist
> module). If link establishes at one of these phases, we stop and use
> that configuration. Otherwise we move to the next configuration and try
> that. Each FEC mode is tried in sequence. (Unless the automatic FEC
> selection bit is *not* set. In that case, only one of the FEC modes is
> tried instead, and it is expected that software only set one bit to try.
> That would perform forced FEC selection instead).
>=20
> This process will repeat as it iterates through the configurations until
> link is established.
>=20
> As a side note, the first stage is to try auto-negotiation if enabled.
> So in the case where auto-negotiation is enabled it will first try
> auto-negotiation, then the set of forced configurations, and then loop
> back to trying auto-negotiation before trying the forced configs again.
>=20
> So from the software programming state, we currently translate
> ETHTOOL_FEC_AUTO by setting the automatic bit as well as setting every
> FEC mode bit, except the "No FEC" bit. This is a new bit which is only
> available on newer firmware.
>=20
> With the proposed change, we would add the "No FEC" bit when user
> requested both ETHTOOL_FEC_AUTO and ETHTOOL_FEC_OFF simultaneously.
>=20
> From reading your previous replies, you would prefer to just have the
> driver set the "No FEC" bit always for ETHTOOL_FEC_AUTO when its
> available/supported by firmware?

