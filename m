Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859712CFE9E
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgLET6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLET6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:58:44 -0500
Date:   Sat, 5 Dec 2020 11:58:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607198283;
        bh=ctuT/MRTaXE+JgOBz5mGwbFG8EYIjhOjKpCuOBPlhZU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y5n3PGCyh2r59TTu2uxKpMTsH3BRyrProXPAf5M68VkV97tmp0QdCtuhDoDWbYQBE
         QevQkeQqdOI7Xx65HHWBF0+4iGQqzmFAg0vFJ49WVCmSJLDOenhg8OvsxcHTYXqS0u
         1Q4F3dPpUp0lG7SNXlI9s6ncVa7DB8NLaNCp0upwxoXkaYur3uLSDtSGQsUX4DS3el
         BTjyI+HEfUL9R5JPRTbSsOwBKRU+gMk3aJGVTKNveAg8OD2Qx5D8s7n9Z2S031wy9M
         DWD1gBIR46cw1f+1zSLRWUEuBruORuNwME9B77gwvQHbd9iLjCjScCIdm6RcQlOFM3
         1V8mtPzocH+rQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, linux-imx@nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: implement .set_intf_mode() callback for
 imx8dxl
Message-ID: <20201205115802.1dc00448@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203041038.32440-1-qiangqing.zhang@nxp.com>
References: <20201203041038.32440-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Dec 2020 12:10:38 +0800 Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> Implement .set_intf_mode() callback for imx8dxl.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

Couple minor issues.

> @@ -86,7 +88,37 @@ imx8dxl_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
>  {
>  	int ret = 0;
>  
> -	/* TBD: depends on imx8dxl scu interfaces to be upstreamed */
> +	struct imx_sc_ipc *ipc_handle;
> +	int val;

Looks like you're gonna have a empty line in the middle of variable
declarations?

Please remove it and order the variable lines longest to shortest.

> +
> +	ret = imx_scu_get_handle(&ipc_handle);
> +	if (ret)
> +		return ret;
> +
> +	switch (plat_dat->interface) {
> +	case PHY_INTERFACE_MODE_MII:
> +		val = GPR_ENET_QOS_INTF_SEL_MII;
> +		break;
> +	case PHY_INTERFACE_MODE_RMII:
> +		val = GPR_ENET_QOS_INTF_SEL_RMII;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		val = GPR_ENET_QOS_INTF_SEL_RGMII;
> +		break;
> +	default:
> +		pr_debug("imx dwmac doesn't support %d interface\n",
> +			 plat_dat->interface);
> +		return -EINVAL;
> +	}
> +
> +	ret = imx_sc_misc_set_control(ipc_handle, IMX_SC_R_ENET_1,
> +				      IMX_SC_C_INTF_SEL, val >> 16);
> +	ret |= imx_sc_misc_set_control(ipc_handle, IMX_SC_R_ENET_1,
> +				       IMX_SC_C_CLK_GEN_EN, 0x1);
>  	return ret;

These calls may return different errors AFAICT.

You can't just errno values to gether the result will be meaningless.

please use the normal flow, and return the result of the second call
directly:

	ret = func1();
	if (ret)
		return ret;

	return func2();

Please also CC the maintainers of the Ethernet PHY subsystem on v2, 
to make sure there is nothing wrong with the patch from their PoV.

Thanks!
