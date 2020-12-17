Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA942DD6C4
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgLQSEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:04:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727723AbgLQSEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:04:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608228204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uan0eMRuAZ1Sud/IaX1o1QuveN2aWjh6xE24nQjtJJ0=;
        b=C0c5ZfBNFz/FgvtUH/ecevd5g1ayUWJJbzLlVSMKUBQNVcFDFLE/jWnv3PJAosEDZt3FXn
        TzlmgnF3vhY49vmb2Ene3edpf5Zoa2oAiTETQfuHH0QWmOWPd2niFnI8XNqe8H4pEJJY+V
        4sQ5GvMdkAMM1C0gClkLHUmQxNrqclU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-0vQb9rE5Mk-iYFfUVH0m4A-1; Thu, 17 Dec 2020 13:03:19 -0500
X-MC-Unique: 0vQb9rE5Mk-iYFfUVH0m4A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21347193EB62;
        Thu, 17 Dec 2020 18:01:38 +0000 (UTC)
Received: from localhost (ovpn-115-234.ams2.redhat.com [10.36.115.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB8B857;
        Thu, 17 Dec 2020 18:01:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1608227106-21394-1-git-send-email-stefanc@marvell.com>
References: <1608227106-21394-1-git-send-email-stefanc@marvell.com>
Subject: Re: [PATCH net] net: mvpp2: Add TCAM entry to drop flow control pause frames
To:     netdev@vger.kernel.org, stefanc@marvell.com
From:   Antoine Tenart <atenart@redhat.com>
Cc:     thomas.petazzoni@bootlin.com, davem@davemloft.net,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, stefanc@marvell.com, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org
Message-ID: <160822809533.1452357.10722693725960219998@kwain.local>
Date:   Thu, 17 Dec 2020 19:01:35 +0100
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting stefanc@marvell.com (2020-12-17 18:45:06)
> From: Stefan Chulski <stefanc@marvell.com>
>=20
> Issue:
> Flow control frame used to pause GoP(MAC) was delivered to the CPU
> and created a load on the CPU. Since XOFF/XON frames are used only
> by MAC, these frames should be dropped inside MAC.
>=20
> Fix:
> According to 802.3-2012 - IEEE Standard for Ethernet pause frame
> has unique destination MAC address 01-80-C2-00-00-01.
> Add TCAM parser entry to track and drop pause frames by destination MAC.
>=20
> Fixes: db9d7d36eecc ("net: mvpp2: Split the PPv2 driver to a dedicated di=
rectory")

Same here, you should go further in the git history.

Also, was that introduced when the TCAM support landed in (overriding
its default configuration?)? Or is that the behaviour since the
beginning? I'm asking because while this could very be a fix, it could
also fall in the improvements category.

Thanks!
Antoine

> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 34 ++++++++++++++++++++=
++++++
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h |  2 +-
>  2 files changed, 35 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net=
/ethernet/marvell/mvpp2/mvpp2_prs.c
> index 1a272c2..3a9c747 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> @@ -405,6 +405,39 @@ static int mvpp2_prs_tcam_first_free(struct mvpp2 *p=
riv, unsigned char start,
>         return -EINVAL;
>  }
> =20
> +/* Drop flow control pause frames */
> +static void mvpp2_prs_drop_fc(struct mvpp2 *priv)
> +{
> +       struct mvpp2_prs_entry pe;
> +       unsigned int len;
> +       unsigned char da[ETH_ALEN] =3D {
> +                       0x01, 0x80, 0xC2, 0x00, 0x00, 0x01 };
> +
> +       memset(&pe, 0, sizeof(pe));
> +
> +       /* For all ports - drop flow control frames */
> +       pe.index =3D MVPP2_PE_FC_DROP;
> +       mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_MAC);
> +
> +       /* Set match on DA */
> +       len =3D ETH_ALEN;
> +       while (len--)
> +               mvpp2_prs_tcam_data_byte_set(&pe, len, da[len], 0xff);
> +
> +       mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_DROP_MASK,
> +                                MVPP2_PRS_RI_DROP_MASK);
> +
> +       mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
> +       mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
> +
> +       /* Mask all ports */
> +       mvpp2_prs_tcam_port_map_set(&pe, MVPP2_PRS_PORT_MASK);
> +
> +       /* Update shadow table and hw entry */
> +       mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_MAC);
> +       mvpp2_prs_hw_write(priv, &pe);
> +}
> +
>  /* Enable/disable dropping all mac da's */
>  static void mvpp2_prs_mac_drop_all_set(struct mvpp2 *priv, int port, boo=
l add)
>  {
> @@ -1168,6 +1201,7 @@ static void mvpp2_prs_mac_init(struct mvpp2 *priv)
>         mvpp2_prs_hw_write(priv, &pe);
> =20
>         /* Create dummy entries for drop all and promiscuous modes */
> +       mvpp2_prs_drop_fc(priv);
>         mvpp2_prs_mac_drop_all_set(priv, 0, false);
>         mvpp2_prs_mac_promisc_set(priv, 0, MVPP2_PRS_L2_UNI_CAST, false);
>         mvpp2_prs_mac_promisc_set(priv, 0, MVPP2_PRS_L2_MULTI_CAST, false=
);
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h b/drivers/net=
/ethernet/marvell/mvpp2/mvpp2_prs.h
> index e22f6c8..4b68dd3 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
> @@ -129,7 +129,7 @@
>  #define MVPP2_PE_VID_EDSA_FLTR_DEFAULT (MVPP2_PRS_TCAM_SRAM_SIZE - 7)
>  #define MVPP2_PE_VLAN_DBL              (MVPP2_PRS_TCAM_SRAM_SIZE - 6)
>  #define MVPP2_PE_VLAN_NONE             (MVPP2_PRS_TCAM_SRAM_SIZE - 5)
> -/* reserved */
> +#define MVPP2_PE_FC_DROP               (MVPP2_PRS_TCAM_SRAM_SIZE - 4)
>  #define MVPP2_PE_MAC_MC_PROMISCUOUS    (MVPP2_PRS_TCAM_SRAM_SIZE - 3)
>  #define MVPP2_PE_MAC_UC_PROMISCUOUS    (MVPP2_PRS_TCAM_SRAM_SIZE - 2)
>  #define MVPP2_PE_MAC_NON_PROMISCUOUS   (MVPP2_PRS_TCAM_SRAM_SIZE - 1)
> --=20
> 1.9.1
>=20

