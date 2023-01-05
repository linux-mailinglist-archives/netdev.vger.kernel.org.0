Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B1065E26B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 02:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjAEBRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 20:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjAEBRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 20:17:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D9133D6F;
        Wed,  4 Jan 2023 17:17:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FFA2B818F2;
        Thu,  5 Jan 2023 01:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD336C433D2;
        Thu,  5 Jan 2023 01:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672881454;
        bh=ZThWZLGnE1uBHhW+ZPEz4zsyBO1cinSai+TYFDqiNKE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HhmNSmtaFYtMpL+KciBrmZKHAcW0h26OcLTrQuvdSLw8aVo19W5sGjIrekJiXuX0p
         G5UhvbqZmxt8dKISeF4skF9nt2HzXGoM1xu5glo8OB2fjxbZM9u6v28nV0edbsUug9
         VmVbHPvIsgbGxp73fCPGPpHQ/HNXYUxizqDV1054rrRIjp3gGMl751NCEob5DjxO/Y
         8phSvt+uUIfyIFRVW7RadI5XEUqAf2gHDt3aJwn+PD/gxBp/5acpvseF/UB1DDnggM
         SQsuw64DB6CaM1/0ISwYZmg+42m54Y7xLMq9qXvDaFIIwZpVJApJ6cas18qdkkYep1
         oPCed1EJYd7Uw==
Date:   Wed, 4 Jan 2023 17:17:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Message-ID: <20230104171733.5fa4638c@kernel.org>
In-Reply-To: <87bkne32ly.fsf@toke.dk>
References: <20220621175402.35327-1-gospo@broadcom.com>
        <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
        <87k0234pd6.fsf@toke.dk>
        <20230103172153.58f231ba@kernel.org>
        <Y7U8aAhdE3TuhtxH@lore-desk>
        <87bkne32ly.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Jan 2023 13:28:57 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Interesting! :) My mental model was closer to GRO by frags=20
> >> so the linear part would have no data, just headers. =20
> >
> > That is assumption as well. =20
>=20
> Right, okay, so how many headers? Only Ethernet, or all the way up to
> L4 (TCP/UDP)?

If we're speaking about guarantees or hard requirements - I think that
we can only require / guarantee the Ethernet header. Requiring more
will be defeated by tunnels (i.e. adjust_head() + redirect to a veth).

> I do seem to recall a discussion around the header/data split for TCP
> specifically, but I think I mentally put that down as "something people
> may way to do at some point in the future", which is why it hasn't made
> it into my own mental model (yet?) :)
