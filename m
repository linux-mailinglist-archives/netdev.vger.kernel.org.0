Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45558584684
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiG1T1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiG1T1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:27:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EC36A4A8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80DC461C33
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 19:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1605C433D7;
        Thu, 28 Jul 2022 19:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659036466;
        bh=xLoazBxQABTb1qclykQVYHVJsP3YT0b/1TwHvOdNVPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J/cwPBn4mFC6q0IckOjvC8Yftx/Z5yaVhHwPyF81OO7tnnlgF28uEa22iKGe0M57B
         ODJplVAWtlgSsR1qwW6XvUmFGeyxLxGZFYhhpa3h07QbKxAweXlSTdZCXvY4DRLWf5
         G4LzIXtAaF3jXAlk5LtC2LXQx/flwlYdmiJXWf8bhx7IwRqr+c2OQqDbMH52q88Vxr
         GgxQs7DplIrdK2r4+L1ZL5HATkK938HkmT6PVDgCzoVC+xiZ0hzJWkAgx34ixahVNR
         jrxNYwBG9GbXTYOqfH/ozSjdpVaQOaURCctPeUyaMZiESnMfg8Mj+t4Z3OhkgnzygI
         JKANXjLalOvzQ==
Date:   Thu, 28 Jul 2022 12:27:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     ecree@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
Message-ID: <20220728122745.4cf0f860@kernel.org>
In-Reply-To: <bfc03b98-53ce-077a-4627-6c8d51a29e08@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
        <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
        <20220727201034.3a9d7c64@kernel.org>
        <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
        <20220728092008.2117846e@kernel.org>
        <8bfec647-1516-c738-5977-059448e35619@gmail.com>
        <20220728113231.26fdfab0@kernel.org>
        <bfc03b98-53ce-077a-4627-6c8d51a29e08@gmail.com>
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

On Thu, 28 Jul 2022 19:54:21 +0100 Edward Cree wrote:
> On 28/07/2022 19:32, Jakub Kicinski wrote:
> > How do you map reprs to VFs? The PCI devices of the VF may be on=20
> > a different system. =20
> That's what the client ID from patch #10 is for.  We ask the FW for
>  a handle to "caller's PCIe controller =E2=86=92 caller's PF =E2=86=92 VF=
 number
>  efv->idx", and that handle is what we store in efv->clid, and later
>  pass to MC_CMD_SET_CLIENT_MAC_ADDRESSES in patch #12.
>=20
> The user determines which repr corresponds to which VF by looking in
>  /sys/class/net/$VFREP/phys_port_name (e.g. "p0pf0vf0").

.. and that would also most likely be what the devlink port ID would be.

> > But reps are like switch ports in a switch ASIC, and the PCI
> > device is the other side of the virtual wire. You would not be
> > configuring the MAC address of a peer to peer link by setting=20
> > the local address. =20
> Indeed.  I agree that .ndo_set_mac_address() is the wrong interface.
> But the interface I have in mind would be something like
>     int (*ndo_set_partner_mac_address)(struct net_device *, void *);
>  and would only be implemented by representor netdevs.
> Idk what the uAPI/UI for that would be; probably a new `ip link set`
>  parameter.

Yup... If only you were there during the fight over this uAPI.
Now it's the devlink "port function" thing.
