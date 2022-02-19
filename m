Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C6B4BC58A
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 06:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiBSFTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 00:19:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiBSFTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 00:19:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C1E340E5
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 21:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F11360B57
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E86C004E1;
        Sat, 19 Feb 2022 05:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645247952;
        bh=V8dO+THWkwusvgMFML9Oph27RUdMdx4gJZiKicSWldk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mV6Ukh/dFFDtelPSQToER3Ng2CdsqrA0gWiOv2dCNBX0iJ0B1VhKajNkXCEwV7MTX
         /5BiFgac9CsXYYVocplTzuwn4uPOG6mgKE8YdMxpc3tPuu7XVkw7CgieoKPwJQ7QRF
         lk0/PRQCF5PN9B7sXyDmNFA2ulloDknpmQSjlHGsO67wi3BMN265xN4HBu7Hkj+/Vo
         LMyG1A1hQ2yu8j3u+cU62gi7k8AskCXykEbFZWWII6f/xV7xjF++u00nLO/0x0xaM7
         wTpyT4anC/JRIvpeorZUZnIVPifnZOV1I4RwjTryTw1ewHNWkg9cmfyjYStKOhXKT/
         6M1336F8o2a9w==
Date:   Fri, 18 Feb 2022 21:19:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next resend 0/2] sfc: optimize RXQs count and
 affinities
Message-ID: <20220218211911.432f3811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220216094139.15989-1-ihuguet@redhat.com>
References: <20220128151922.1016841-1-ihuguet@redhat.com>
        <20220216094139.15989-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 10:41:37 +0100 =C3=8D=C3=B1igo Huguet wrote:
> In sfc driver one RX queue per physical core was allocated by default.
> Later on, IRQ affinities were set spreading the IRQs in all NUMA local
> CPUs.
>=20
> However, with that default configuration it result in a non very optimal
> configuration in many modern systems. Specifically, in systems with hyper
> threading and 2 NUMA nodes, affinities are set in a way that IRQs are
> handled by all logical cores of one same NUMA node. Handling IRQs from
> both hyper threading siblings has no benefit, and setting affinities to o=
ne
> queue per physical core is neither a very good idea because there is a
> performance penalty for moving data across nodes (I was able to check it
> with some XDP tests using pktgen).
>=20
> This patches reduce the default number of channels to one per physical
> core in the local NUMA node. Then, they set IRQ affinities to CPUs in
> the local NUMA node only. This way we save hardware resources since
> channels are limited resources. We also leave more room for XDP_TX
> channels without hitting driver's limit of 32 channels per interface.
>=20
> Running performance tests using iperf with a SFC9140 device showed no
> performance penalty for reducing the number of channels.
>=20
> RX XDP tests showed that performance can go down to less than half if
> the IRQ is handled by a CPU in a different NUMA node, which doesn't
> happen with the new defaults from this patches.

Martin, Ed, any thoughts?
