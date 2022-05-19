Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C83852CB28
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiESEhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiESEg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:36:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FCF5994E
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 21:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D20C2CE2266
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 04:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7552BC385B8;
        Thu, 19 May 2022 04:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652935013;
        bh=Dj9A86uYZ14IQvHA575akmc5vbc8MvSc2cvfXn55H3g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FyI9oTvuY0/CmljbceuOsCciIdWSvzIRp5I9Dk2Y63TT7pLrVcqWf/4AbNRpB17R7
         EajQrrt94e/eSSbzkB182vFLanxGQd2IPmaafjX0pKuTxXjVVD54jFXGKyEH0Wpvfc
         lYfMqu0TGex4gQPsVdezNH523PGoQbEi9/hNYX0DG4pkYwLTc74B/LUMYDaO+svL7F
         DYQ0w8DUAMjyaot2TEhQ1tL17Aes/iqtgoT19sDc7aAgLMSVBP2YPDpoh2MXAshB4O
         8QNOfLG+isW+LcX9bay6eGjnEdLoHyz/7AkL7yNLUq7+5TJ13YRVnWyVzyWmP47y5E
         2gAzSxCuoOa6A==
Date:   Wed, 18 May 2022 21:36:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Eli Cohen <elic@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 16/16] net/mlx5: Support multiport eswitch mode
Message-ID: <20220518213652.312ffb2e@kernel.org>
In-Reply-To: <20220519042628.e2yqi37ceyks6rbv@sx1>
References: <20220518064938.128220-1-saeed@kernel.org>
        <20220518064938.128220-17-saeed@kernel.org>
        <20220518172141.6994e385@kernel.org>
        <20220519042628.e2yqi37ceyks6rbv@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 21:26:28 -0700 Saeed Mahameed wrote:
> On 18 May 17:21, Jakub Kicinski wrote:
> >On Tue, 17 May 2022 23:49:38 -0700 Saeed Mahameed wrote: =20
> >> From: Eli Cohen <elic@nvidia.com>
> >>
> >> Multiport eswitch mode is a LAG mode that allows to add rules that
> >> forward traffic to a specific physical port without being affected by =
LAG
> >> affinity configuration.
> >>
> >> This mode of operation is mutual exclusive with the other LAG modes us=
ed
> >> by multipath and bonding.
> >>
> >> To make the transition between the modes, we maintain a counter on the
> >> number of rules specifying one of the uplink representors as the target
> >> of mirred egress redirect action.
> >>
> >> An example of such rule would be:
> >>
> >> $ tc filter add dev enp8s0f0_0 prot all root flower dst_mac \
> >>   00:11:22:33:44:55 action mirred egress redirect dev enp8s0f0
> >>
> >> If the reference count just grows to one and LAG is not in use, we
> >> create the LAG in multiport eswitch mode. Other mode changes are not
> >> allowed while in this mode. When the reference count reaches zero, we
> >> destroy the LAG and let other modes be used if needed.
> >>
> >> logic also changed such that if forwarding to some uplink destination
> >> cannot be guaranteed, we fail the operation so the rule will eventually
> >> be in software and not in hardware.
> >>
> >> Signed-off-by: Eli Cohen <elic@nvidia.com>
> >> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> >> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com> =20
> >
> >GCC 12 also points out that:
> >
> >drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c: In function =E2=80=98=
mlx5_do_bond=E2=80=99:
> >drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:786:28: warning: =E2=
=80=98tracker=E2=80=99 is used uninitialized [-Wuninitialized]
> >  786 |         struct lag_tracker tracker;
> >      |                            ^~~~~~~
> >drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:786:28: note: =E2=80=
=98tracker=E2=80=99 declared here
> >  786 |         struct lag_tracker tracker;
> >      |                            ^~~~~~~ =20
>=20
> it's a false alarm, anyway clang and gcc12 are happy on my machine:

Yeah, looks like a false alarm.

> $ KCFLAGS=3D"-Wall" make W=3D1 drivers/net/ethernet/mellanox/mlx5/core/la=
g/lag.o

No extra flags, basic allmodconfig build here (well, with WERROR=3Dn).

> CALL    scripts/checksyscalls.sh
> CALL    scripts/atomic/check-atomics.sh
> DESCEND objtool
> CC      drivers/net/ethernet/mellanox/mlx5/core/lag/lag.o
>=20
> $ gcc --version
> gcc (GCC) 12.1.1 20220507 (Red Hat 12.1.1-1)

Same:

gcc (GCC) 12.1.1 20220507 (Red Hat 12.1.1-1)
