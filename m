Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510B258460A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiG1Scj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiG1Scg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:32:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABC974CE8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02788B824A0
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 18:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556A5C433C1;
        Thu, 28 Jul 2022 18:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659033152;
        bh=YbOxAifgzUnXcJeCJGtYR9lYiBOYwqz2zZIaw3DBYl4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lk18GWMXn1+vMR/vN7gJY2ZHs21Mc3P9fgNtdBiPu8rzgCruqRQqO8yIdd8xTNF7x
         z/RLBMHoa8xcqTTJSFz0xPRQECVj63wcDNLtu4DEblYIRBODPjLxrwazQIY75Y/io5
         3JBzWh9UnXHqIHRXZUdj2ba36KxA//4X+ekL1fWW44kvcHCy+AVKJzdBUCTKUPlx1K
         zIC9WEwLfsVW7IVds9UuksPfY9AwQ/nmaU7yP5RupM2/V6LgXU+ibduw+yR706ML29
         ow7nOV3tpgoJ3WHua1HKf2VrW2MrYuh2P8CgSlqLytxUUDSSFwtAQBwvYAzVelnzaB
         CJ8MM9KuKQG3w==
Date:   Thu, 28 Jul 2022 11:32:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     ecree@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
Message-ID: <20220728113231.26fdfab0@kernel.org>
In-Reply-To: <8bfec647-1516-c738-5977-059448e35619@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
        <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
        <20220727201034.3a9d7c64@kernel.org>
        <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
        <20220728092008.2117846e@kernel.org>
        <8bfec647-1516-c738-5977-059448e35619@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 19:12:34 +0100 Edward Cree wrote:
> On 28/07/2022 17:20, Jakub Kicinski wrote:
> > It's set thru
> >=20
> >  devlink port function set DEV/PORT_INDEX hw_addr ADDR
> >=20
> > "port functions" is a weird object representing something=20
> > in Mellanox FW. Hopefully it makes more sense to you than
> > it does to me. =20
> Hmm that does look weird, looks like it acts on a PCI device
>  (DEV is a PCI address) and then I'm not sure what PORT_INDEX
>  is meant to mean (the man page doesn't describe it at all).
>  Possibly it doesn't have semantics as such and is just a
>  synthetic index into a list of ports=E2=80=A6
> I can't say it makes sense to me either :shrug:
>=20
> We did take a look at what nfp does, as well; they use the
>  old .ndo_set_vf_mac(), but they appear to support it both on
>  the PF and on the VF reprs =E2=80=94 meaning that (AFAICT) it allows
>  to set the MAC address of VF 0 through the repr for VF 1.
> (There is no check that I can see in nfp_app_set_vf_mac()
>  that the value of `int vf` matches the caller.)

IIRC the reprs are all linked to the PCI device of the PF in sysfs,
and OpenStack would pick a device linked to the PCI parent almost
at random. So the VF reprs needed the legacy NDOs. At least that's
what I remember being told.

I think the legacy NDOs are acceptable, devlink way is preferred
(devlink way did not exist when NFP code was written).

> Our (SN1000) approach to the problem of configuring 'remote'
>  functions (VFs in VMs, PFs on the embedded SoC) is to use
>  representors for them all (VF reps as added in this & prev
>  series, PF reps coming in the future.  Similarly, if we
>  were ever to add Subfunctions, each SF would have a
>  corresponding SF representor that would work in much the
>  same way as VF reps).  At which point you should always be
>  able to configure an object through its associated rep,
>  and there should never be a need for an 'index' parameter
>  (be that 'VF index' or 'port index').

How do you map reprs to VFs? The PCI devices of the VF may be on=20
a different system.

> While .ndo_set_mac_address() might be the Wrong Thing (if
>  we want to be able to set VF and VF-rep addresses
>  independently to different things), the Right Thing ought
>  to have the same signature (i.e. just taking a netdev and
>  a hwaddr).  Devlink seems to me like a needless
>  complication here.

But reps are like switch ports in a switch ASIC, and the PCI
device is the other side of the virtual wire. You would not be
configuring the MAC address of a peer to peer link by setting=20
the local address.

> Anyway, since the proper direction is unclear, I'll respin
>  the series without patches 10-13 in the hope of getting
>  the rest of it in before the merge window.

SG
