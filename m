Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5FA52C88F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiESAVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiESAVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:21:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1625F958F
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 17:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3016B82256
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D617C385AA;
        Thu, 19 May 2022 00:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652919703;
        bh=ZlnZBTC2l1ljZ2Wuvxk2phfK88Lean4S40HhlqEsZMQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uFJKFStsa0MRN/QdFYyW0RYJoZAX+oGmLzUzeiJpSlYqURGzFvj/hZWYbNoGc5Lcl
         VdZY7+jd0Z34ml/8UgESQAJ9MaTnZZavzYE3d0caqZoJZiZHGRUsdliZ6oTJ/DbyPT
         xB/CUPRe5/MMQDM7Mg9KYSzZ8RcrlIVwmxYNTvAVufB0P6yFFCHqEzyAE2dyIMcQph
         sHWDbAL4opGpKppY7hhR+z8gXYunxIbaVfkyjiVjiO9DI46xHKwoL0J8qYCUVd6Gzs
         YZkRf5C5bZyL0uaXq4ekocX2JNc3AwIvS1Dv3l4m6SFpCMTZzl4Vi3DxbIiCWAkvXJ
         BhiI0QqM5IJJQ==
Date:   Wed, 18 May 2022 17:21:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Eli Cohen <elic@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 16/16] net/mlx5: Support multiport eswitch mode
Message-ID: <20220518172141.6994e385@kernel.org>
In-Reply-To: <20220518064938.128220-17-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
        <20220518064938.128220-17-saeed@kernel.org>
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

On Tue, 17 May 2022 23:49:38 -0700 Saeed Mahameed wrote:
> From: Eli Cohen <elic@nvidia.com>
>=20
> Multiport eswitch mode is a LAG mode that allows to add rules that
> forward traffic to a specific physical port without being affected by LAG
> affinity configuration.
>=20
> This mode of operation is mutual exclusive with the other LAG modes used
> by multipath and bonding.
>=20
> To make the transition between the modes, we maintain a counter on the
> number of rules specifying one of the uplink representors as the target
> of mirred egress redirect action.
>=20
> An example of such rule would be:
>=20
> $ tc filter add dev enp8s0f0_0 prot all root flower dst_mac \
>   00:11:22:33:44:55 action mirred egress redirect dev enp8s0f0
>=20
> If the reference count just grows to one and LAG is not in use, we
> create the LAG in multiport eswitch mode. Other mode changes are not
> allowed while in this mode. When the reference count reaches zero, we
> destroy the LAG and let other modes be used if needed.
>=20
> logic also changed such that if forwarding to some uplink destination
> cannot be guaranteed, we fail the operation so the rule will eventually
> be in software and not in hardware.
>=20
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

GCC 12 also points out that:

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c: In function =E2=80=98mlx=
5_do_bond=E2=80=99:
drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:786:28: warning: =E2=80=
=98tracker=E2=80=99 is used uninitialized [-Wuninitialized]
  786 |         struct lag_tracker tracker;
      |                            ^~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:786:28: note: =E2=80=98tr=
acker=E2=80=99 declared here
  786 |         struct lag_tracker tracker;
      |                            ^~~~~~~
