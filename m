Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A002DD6A0
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgLQRyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:54:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729157AbgLQRyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 12:54:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608227573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ReBT3i840Sw/YiiTETt/Hew4ycLl9BGmcBjhM24JNYI=;
        b=HD9FDKGmDfb2nkjJMWmfwKnMjDBMjzmko1cGwlpM94gRlN/uhSw44jfg8HUuFwZ4PoZOY4
        FBFctd4uTd2B7PQDWaekQXJrA9SyvMw9tlhjngbhJqg3pvEugei7ihzS+YGyXapnZB4NCP
        PczkHPyGqRjPK8YywiLbF8FkxMqa3Wo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-njXg6M41OQqfPSBaR4dbfg-1; Thu, 17 Dec 2020 12:52:51 -0500
X-MC-Unique: njXg6M41OQqfPSBaR4dbfg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85DB9100C600;
        Thu, 17 Dec 2020 17:52:49 +0000 (UTC)
Received: from localhost (ovpn-115-234.ams2.redhat.com [10.36.115.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D710A5D9CD;
        Thu, 17 Dec 2020 17:52:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1608225791-13127-1-git-send-email-stefanc@marvell.com>
References: <1608225791-13127-1-git-send-email-stefanc@marvell.com>
From:   Antoine Tenart <atenart@redhat.com>
Cc:     thomas.petazzoni@bootlin.com, davem@davemloft.net,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, stefanc@marvell.com, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, lironh@marvell.com
To:     netdev@vger.kernel.org, stefanc@marvell.com
Subject: Re: [PATCH net] net: mvpp2: prs: fix PPPoE with ipv6 packet parse
Message-ID: <160822756622.3138.4566292085941876073@kwain.local>
Date:   Thu, 17 Dec 2020 18:52:46 +0100
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

Quoting stefanc@marvell.com (2020-12-17 18:23:11)
> From: Stefan Chulski <stefanc@marvell.com>
>=20
> Current PPPoE+IPv6 entry is jumping to 'next-hdr'
> field and not to 'DIP' field as done for IPv4.
>=20
> Fixes: db9d7d36eecc ("net: mvpp2: Split the PPv2 driver to a dedicated di=
rectory")

That's not the commit introducing the issue. You can use
`git log --follow` to go further back (or directly pointing to the old
mvpp2.c file).

Thanks!
Antoine

> Reported-by: Liron Himi <lironh@marvell.com>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net=
/ethernet/marvell/mvpp2/mvpp2_prs.c
> index b9e5b08..1a272c2 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> @@ -1655,8 +1655,9 @@ static int mvpp2_prs_pppoe_init(struct mvpp2 *priv)
>         mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP6);
>         mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP6,
>                                  MVPP2_PRS_RI_L3_PROTO_MASK);
> -       /* Skip eth_type + 4 bytes of IPv6 header */
> -       mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN + 4,
> +       /* Jump to DIP of IPV6 header */
> +       mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN + 8 +
> +                                MVPP2_MAX_L3_ADDR_SIZE,
>                                  MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
>         /* Set L3 offset */
>         mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
> --=20
> 1.9.1
>=20

