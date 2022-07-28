Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711CE58440C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiG1QUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbiG1QUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:20:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F265595
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 914F9B8232A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 16:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08970C433D6;
        Thu, 28 Jul 2022 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659025209;
        bh=f1GgTqHFECXge2LsMkF+w1GghD4hVdo9F9A3R2pt0wE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ny6z1SnhyM2jRZnB3H/PVyGrAlFcFo0d+6G6HpPzxMDJT0YtZBTk7byBdeVzvW1hq
         umjwMUl5nqkfhmuIW+IWicPKChFcYOCRPrNX+iVtWhRSuLbyB/+v0eJkdipFRok5NL
         fQj/HGRfPnBOpMyE51+GoS4bwHSz2S/QiCHd//No1aTBGoEawxhzTu7ZRLJiSAprjL
         +RkgdaaNFofRO9b4Hc6y9dsI8nM8OO3h/jcYwBcZ6WjSHNe4VkG5DuQZYDu9YC1Z8p
         H1pk6mObupBMYUmKlp9i/kaYlK0QJi5qtjFD3Blzw2mAJpa0l/MkFjNWEKsjJqleRF
         Qh+14pPdTP/yA==
Date:   Thu, 28 Jul 2022 09:20:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     ecree@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
Message-ID: <20220728092008.2117846e@kernel.org>
In-Reply-To: <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
        <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
        <20220727201034.3a9d7c64@kernel.org>
        <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
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

On Thu, 28 Jul 2022 16:47:36 +0100 Edward Cree wrote:
> On 28/07/2022 04:10, Jakub Kicinski wrote:
> > On Wed, 27 Jul 2022 18:46:02 +0100 ecree@xilinx.com wrote: =20
> >> When setting the VF rep's MAC address, set the provisioned MAC address
> >>  for the VF through MC_CMD_SET_CLIENT_MAC_ADDRESSES. =20
> >=20
> > Wait.. hm? The VF rep is not the VF. It's the other side of the wire.
> > Are you passing the VF rep's MAC on the VF? Ethernet packets between
> > the hypervisor and the VF would have the same SA and DA.
>=20
> Yes (but only if there's an IP stack on the repr; I think it's fine if
>  the repr is plugged straight into a bridge so any ARP picks up a
>  different DA?).
> I thought that was weird but I also thought that was 'how it's done'
>  with reps =E2=80=94 properties of the VF are set by applying them to the=
 rep.
> Is there some other way to configure VF MAC?  (Are we supposed to still
>  be using the legacy SR-IOV interface, .ndo_set_vf_mac()?  I thought
>  that was deprecated in favour of more switchdev-flavoured stuff=E2=80=A6)

It's set thru

 devlink port function set DEV/PORT_INDEX hw_addr ADDR

"port functions" is a weird object representing something=20
in Mellanox FW. Hopefully it makes more sense to you than
it does to me.
