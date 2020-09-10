Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2D0264EF6
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIJT3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbgIJT3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 15:29:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 077E0207DE;
        Thu, 10 Sep 2020 19:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599766159;
        bh=xdEi+nnHPoX5+tUHKLW+zfHZQoV5peod/7jyP2Gpm2M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RLBqZtOnV1AeXSaA467zCMMCU+znsxkYt803axM7g++QJ8p3fwxC9VyJmfswYrA8l
         bJOgluRzemVb3+QGs8hx+httc+U05KpcvvPbBG+aRmZjznhs0UEfOFVVHc63VY/oFO
         qLVDZhOitrvd11Sb/WFEArDcs0vQpWck4UBWDb94=
Date:   Thu, 10 Sep 2020 12:29:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo Jiaxing <luojiaxing@huawei.com>
Cc:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next] net: stmmac: Remove unused variable 'ret' at
 stmmac_rx_buf1_len()
Message-ID: <20200910122912.5792f657@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599705765-15562-1-git-send-email-luojiaxing@huawei.com>
References: <1599705765-15562-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 10:42:45 +0800 Luo Jiaxing wrote:
> Fixes the following warning when using W=3D1 to build kernel:
>=20
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3634:6: warning: variab=
le =E2=80=98ret=E2=80=99 set but not used [-Wunused-but-set-variable]
> int ret, coe =3D priv->hw->rx_csum;
>=20
> When digging stmmac_get_rx_header_len(), dwmac4_get_rx_header_len() and
> dwxgmac2_get_rx_header_len() return 0 by default. Therefore, ret do not
> need to check the error value and can be directly deleted.
>=20
> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index 89b2b34..7e95412 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -3631,15 +3631,15 @@ static unsigned int stmmac_rx_buf1_len(struct stm=
mac_priv *priv,
>  				       struct dma_desc *p,
>  				       int status, unsigned int len)
>  {
> -	int ret, coe =3D priv->hw->rx_csum;
>  	unsigned int plen =3D 0, hlen =3D 0;
> +	int coe =3D priv->hw->rx_csum;
> =20
>  	/* Not first descriptor, buffer is always zero */
>  	if (priv->sph && len)
>  		return 0;
> =20
>  	/* First descriptor, get split header length */
> -	ret =3D stmmac_get_rx_header_len(priv, p, &hlen);
> +	stmmac_get_rx_header_len(priv, p, &hlen);

This function should return void if there never are any errors to
report.

>  	if (priv->sph && hlen) {
>  		priv->xstats.rx_split_hdr_pkt_n++;
>  		return hlen;

