Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C43A57A8B7
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbiGSU6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240212AbiGSU6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:58:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5386481DA
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B64D619CB
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E355C341C6;
        Tue, 19 Jul 2022 20:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658264279;
        bh=2yiZMFfw4tvzsLgtGHBOlbAARN7NZM2HFnyq27n8SCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UMLiKYW4mQmTB0UaDigAyywtoz3vZhgJX0OLFS5EqWf0mf0fTnAVhRKDM+kiLqtnv
         LW26XcAzxOZjzrmgRSx8pruRaWqmbRQondKZ2ZgucaKF89FGsI4LUIykWn3/zjqlfH
         dn0XTB2AJOtDBlcuSURX7juDQong8yUCP6fQzziy8SqhI5ydXuV7dFT83wVIvDx3qm
         /vQyowmy/7Uyl+6oqSLM5dxLJ7OhlXBRZ6cOpAXay0pGcmKGX0oZwjJ0OTyWaRgEYm
         qGZg4FZftLDh5+bFmljrCiazytM2E7FweVpCkw+F912DxRz4pk7RgijEHwVCOiL7A4
         EZOz3SZIXqO8w==
Date:   Tue, 19 Jul 2022 13:57:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next 03/14] net/mlx5e: Expose rx_oversize_pkts_buffer
 counter
Message-ID: <20220719135758.29ba0579@kernel.org>
In-Reply-To: <24bd2c21-87c2-0ca9-8f57-10dc2ae4774c@nvidia.com>
References: <20220717213352.89838-1-saeed@kernel.org>
        <20220717213352.89838-4-saeed@kernel.org>
        <20220718202504.3d189f57@kernel.org>
        <24bd2c21-87c2-0ca9-8f57-10dc2ae4774c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 14:13:39 +0300 Gal Pressman wrote:
> > Is it counted towards any of the existing stats as well? It needs=20
> > to end up in struct rtnl_link_stats64::rx_length_errors somehow. =20
>=20
> Probably makes sense to count it in rx_over_errors:
> =C2=A0*=C2=A0=C2=A0 The recommended interpretation for high speed interfa=
ces is -
> =C2=A0*=C2=A0=C2=A0 number of packets dropped because they did not fit in=
to buffers
> =C2=A0*=C2=A0=C2=A0 provided by the host, e.g. packets larger than MTU or=
 next buffer
> =C2=A0*=C2=A0=C2=A0 in the ring was not available for a scatter transfer.

I think I wrote that based on what 3c509 or some similarly ancient=20
NIC was doing. Since then I've seen too many drivers using it for
queue exhaustion to hope for the interpretation to take over.=20

But yes, not the worst choice, if you prefer that works.

> It doesn't fit the rx_length_errors (802.3) as these packets are not
> dropped on the MAC.
> Will change.

I don't think rx_length_errors says it's MAC drops anywhere. I put the
list of IEEE eth counters there as an example.
rx length errors is a catch all for length errors.
