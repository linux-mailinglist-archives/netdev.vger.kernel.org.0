Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6634D33C6C0
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhCOTYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233461AbhCOTXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:23:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD21864F07;
        Mon, 15 Mar 2021 19:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615836224;
        bh=Lm9LDE6txgrr8fJKNRslHJ6LEbv/o0tOODW0mRPEkLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bSQ/yqTF/AK0Q8EIXmfARYUp+3lPcUciaByOkS08hcJ4kVmXnLYiLlclU0mn6mCLf
         ZgnlJEteTAjHCkkSAVBJX/nFfjjhJP+u8f8a6x+o88kAUJuzu+7WCsJmTpvM8e1wGR
         oTkoKIpb51XYz4JuykAM3m6H065sn4puHXTtmGB4GHj4N98Sm2ED2eBC2pozzug29f
         z3GxkR/U7WpNM4heOZdiALqxdrY5vf2tMfV2p2vzaPPsqGHN8lApdBAhMu+imBxaCz
         UFjObF9tlwn1NQ/asYeDFCwcKXIvH08G9LYZJu2C7byev9lB3+9GebKTjgHR2LIT3W
         WKIpT+tRFyLxQ==
Date:   Mon, 15 Mar 2021 12:23:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: b53: mmap: Add device tree
 support
Message-ID: <20210315122342.76b415f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210315151140.12636-1-noltari@gmail.com>
References: <20210315151140.12636-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 16:11:40 +0100 =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> Add device tree support to b53_mmap.c while keeping platform devices supp=
ort.
>=20
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> ---
>  v2: add change suggested by Florian Fainelli (less "OF-centric") and rep=
lace
>   brcm,ports property with a ports child scan.
>=20
>  drivers/net/dsa/b53/b53_mmap.c | 54 ++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
>=20
> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mma=
p.c
> index c628d0980c0b..94a4e3929ebf 100644
> --- a/drivers/net/dsa/b53/b53_mmap.c
> +++ b/drivers/net/dsa/b53/b53_mmap.c
> @@ -16,6 +16,7 @@
>   * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>   */
> =20
> +#include <linux/bits.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/io.h>
> @@ -228,11 +229,64 @@ static const struct b53_io_ops b53_mmap_ops =3D {
>  	.write64 =3D b53_mmap_write64,
>  };
> =20
> +static int b53_mmap_probe_of(struct platform_device *pdev,
> +			     struct b53_platform_data **ppdata)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct device_node *np =3D dev->of_node;
> +	struct device_node *of_ports, *of_port;
> +	struct b53_platform_data *pdata;
> +	void __iomem *mem;

reverse xmas tree? Initialize out of line if needed.

> +	mem =3D devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(mem))
> +		return PTR_ERR(mem);
> +
> +	pdata =3D devm_kzalloc(dev, sizeof(struct b53_platform_data),
> +			     GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	pdata->regs =3D mem;
> +	pdata->chip_id =3D BCM63XX_DEVICE_ID;
> +	pdata->big_endian =3D of_property_read_bool(np, "big-endian");
> +
> +	of_ports =3D of_get_child_by_name(np, "ports");

Isn't this leaking a ref on of_ports? I don't see any put.

> +	if (!of_ports) {
> +		dev_err(dev, "no ports child node found\n");
> +		return -EINVAL;
> +	}
> +
> +	for_each_available_child_of_node(of_ports, of_port) {
> +		u32 reg;
> +
> +		if (of_property_read_u32(of_port, "reg", &reg))
> +			continue;
> +
> +		if (reg < B53_CPU_PORT)
> +			pdata->enabled_ports |=3D BIT(reg);
> +	}
> +
> +	*ppdata =3D pdata;
> +
> +	return 0;
> +}
> +
>  static int b53_mmap_probe(struct platform_device *pdev)
>  {
> +	struct device_node *np =3D pdev->dev.of_node;
>  	struct b53_platform_data *pdata =3D pdev->dev.platform_data;
>  	struct b53_mmap_priv *priv;
>  	struct b53_device *dev;
> +	int ret;
> +
> +	if (!pdata && np) {
> +		ret =3D b53_mmap_probe_of(pdev, &pdata);
> +		if (ret) {
> +			dev_err(&pdev->dev, "OF probe error\n");
> +			return ret;
> +		}
> +	}
> =20
>  	if (!pdata)
>  		return -EINVAL;

