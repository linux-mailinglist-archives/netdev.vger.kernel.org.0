Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D025708D6
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiGKRaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 13:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGKRaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 13:30:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5D525E81
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 10:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BDCB61381
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 17:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8C4C34115;
        Mon, 11 Jul 2022 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657560606;
        bh=saRDRO0gCv8PbdhVrD8zjW/nGayWKWLcvSoLkLtKkyQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sWJw1BbBKMNm8IWVjD02puIlia+TSeippk2/Lx52N8xLUYnyPbxoCiSFw5fY2AmEB
         UwivxPTTbez0YIZSoDVnxr0vv/oVqbyNdg4CgwNvhXvSHBtjr9pfb3R8RL9rrtwRqY
         /Ux/uzHt6XrdUAgC2+tktIM2DNdyZlmfOWjPjpeEN5FLdexcYa4DOb5nswEU9+l7E0
         VaphTNsEFOElrzjQT9lV1OVM3Z6GZ9opbLlGQKekXQ8S+32JvJGZoHPormJi6EEHkr
         Pod4RK1SMxlpraFtQBDxk1Btnz97QrQWIrVEQ2wCHmramE/T5ckhGI702ERHdLSfzn
         8UuLjz7JT4u4A==
Date:   Mon, 11 Jul 2022 10:29:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jiri Pirko <jiri@nvidia.com>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <20220711102957.0b278c12@kernel.org>
In-Reply-To: <YskOt0sbTI5DpFUu@nanopsycho>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
        <20220620130426.00818cbf@kernel.org>
        <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
        <20220630111327.3a951e3b@kernel.org>
        <YsbBbBt+DNvBIU2E@nanopsycho>
        <20220707131649.7302a997@kernel.org>
        <YsfcUlF9KjFEGGVW@nanopsycho>
        <20220708110535.63a2b8e9@kernel.org>
        <YskOt0sbTI5DpFUu@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Jul 2022 07:14:31 +0200 Jiri Pirko wrote:
> >I resisted the port function aberration as long as I could. It's  =20
>=20
> Why do you say "aberration"? It is a legitimate feature that is allowing
> to solve legitimate issues. Maybe I'm missing something.

=46rom netdev perspective it's an implementation detail irrelevant=20
to the user. The netdev model is complete without it.

> >a limitation of your design as far as I'm concerned. =20
>=20
> What do you mean? This is not related to us only. The need to work with
> port function (the other side of the wire) is definitelly nothing
> specific to mlx5 driver.
>
> >Switches use TC to configure egress queuing, that's our Linux model.
> >Representor is the switch side, TC qdisc on it maps to the egress
> >of the switch. =20
>=20
> Sure.
>
> >I don't understand where the disconnect between us is, you know that's
> >what mlxsw does.. =20
>=20
> No disconnect. mlxsw works like that. However, there is no VF/SF in
> mlxsw world. The other side of the wire is a different host.
>=20
> However in case of VF/SF, we also need to configure the other side of
> the wire, which we are orchestrating. That is the sole purpose of why we
> have devlink port function. And once we have such object, why is it
> incorrect to use it for the needed configuration?

So the function conversation _is_ relevant here, eh? Sad but it is what
it is.

> Okay, if you really feel that we need to reuse TC interface for this
> feature (however mismathing it might be),

Not what I said, I'm not gonna say it the fourth time.

> lets create a netdev for the port function to hook this to. But do we
> want such a beast? But to hook this to eswitch port representor seems
> to me plain wrong.

I presume you're being facetious. Extra netdev is gonna help nothing.=20

AFAIU the problem is that you want to control endpoints which are not
ndevs with this API. Is that the main or only reason? Can we agree that
it's legitimate but will result in muddying the netdev model (which in
itself is good and complete)?
