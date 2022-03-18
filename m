Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C334A4DE34A
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbiCRVNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241060AbiCRVNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:13:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FD32DF3CC;
        Fri, 18 Mar 2022 14:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08DFEB825AB;
        Fri, 18 Mar 2022 21:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B8BC340E8;
        Fri, 18 Mar 2022 21:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647637933;
        bh=63k8XZftRXMguFWX81BTU0yP2mywj2VvPSBftzYpSsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PTs1UXtc6PhC9dVwQo7CYei9zDB0J902uB5hkjZhnDYdVw81/+hE1chJ+3v4HYVK+
         IDwLXhAzRB32+0JyqbCb+zUQ4F94oCClztmUZ8Qx/biqQ/z0eDX7WQSixqIUQ3GJFe
         tZaJEV1L0faQ8fBEgxum9HWXdlkMpEBlYeY+YZcD9NHJ+Xm7WltituECpX4GKoNbPm
         Tep3wzErh8UUJ/SHZms+oneAFYf/7DWhkQ/kiK/ovh8qyT5BATqbAqSK8TXbP5EZxI
         kywuFEvtWGn8SZHLheV4b9VK8aB7vdGwY6czvx6ynKoxRSyt10ms7kkLV2DQwMMeuq
         raiHwmtI7TMTw==
Date:   Fri, 18 Mar 2022 14:12:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "David S . Miller" <davem@davemloft.net>,
        Toan Le <toan@os.amperecomputing.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drivers: net: xgene: Fix regression in CRC stripping
Message-ID: <20220318141207.284972b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220317144225.4005500-1-stgraber@ubuntu.com>
References: <20220317144225.4005500-1-stgraber@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Mar 2022 10:42:25 -0400 St=C3=A9phane Graber wrote:
> From: Stephane Graber <stgraber@ubuntu.com>
>=20
> All packets on ingress (except for jumbo) are terminated with a 4-bytes
> CRC checksum. It's the responsability of the driver to strip those 4
> bytes. Unfortunately a change dating back to March 2017 re-shuffled some
> code and made the CRC stripping code effectively dead.
>=20
> This change re-orders that part a bit such that the datalen is
> immediately altered if needed.
>=20
> Fixes: 4902a92270fb ("drivers: net: xgene: Add workaround for errata 10GE=
_8/ENET_11")
> Signed-off-by: Stephane Graber <stgraber@ubuntu.com>
> Tested-by: Stephane Graber <stgraber@ubuntu.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/n=
et/ethernet/apm/xgene/xgene_enet_main.c
> index ff2d099aab21..3892790f04e0 100644
> --- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> +++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> @@ -696,6 +696,12 @@ static int xgene_enet_rx_frame(struct xgene_enet_des=
c_ring *rx_ring,
>  	buf_pool->rx_skb[skb_index] =3D NULL;
> =20
>  	datalen =3D xgene_enet_get_data_len(le64_to_cpu(raw_desc->m1));
> +
> +	/* strip off CRC as HW isn't doing this */
> +	nv =3D GET_VAL(NV, le64_to_cpu(raw_desc->m0));
> +	if (!nv)
> +		datalen -=3D 4;

Alternatively we could call skb_trim() below to remove the FCS.
You call, but..

>  	skb_put(skb, datalen);
>  	prefetch(skb->data - NET_IP_ALIGN);
>  	skb->protocol =3D eth_type_trans(skb, ndev);
> @@ -717,10 +723,7 @@ static int xgene_enet_rx_frame(struct xgene_enet_des=
c_ring *rx_ring,
>  		}
>  	}
> =20
> -	nv =3D GET_VAL(NV, le64_to_cpu(raw_desc->m0));
>  	if (!nv) {
> -		/* strip off CRC as HW isn't doing this */
> -		datalen -=3D 4;
>  		goto skip_jumbo;
>  	}

If you stick to moving the datalen adjustments this if will have a
single statement so according to the kernel code style it has to lose
the brackets.

