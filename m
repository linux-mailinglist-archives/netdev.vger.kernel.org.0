Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA511FC9C8
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 11:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgFQJYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 05:24:44 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:27345 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgFQJYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 05:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592385883; x=1623921883;
  h=subject:to:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=nylKhov0pEX7x5ejoJx1EptQkj8WmhrNODOtlDMplxs=;
  b=N6zfB9NmEhPIc53JgE6gPeiXexFm5SG/oECrWIwqzid/YEQI6kcYfNot
   dnJ/QRr04jlaVYE4M9mQ9m9YwwWZ9r4Lku/c5W+ah4DYTweOjV6xwEHpe
   uIqJBhw+jkc78BVk6IQ80kIh+AWvQhMSt4+dH72L81a5dDOahCtKTns+G
   n3rSq3yZDaATUrqWh2RFgI8Rl9H6JOIrTfteIG1jpN8HsdaI7jJgK/1hy
   O3Ngm8dNhZHfRkBAooBTuefa2Ictr5SHmtC/IS5W177R4SvBEngmCQ4NX
   kwNT/wEhemdS5l/yZHyh1JuENyF4DcuQDAD1sy/Y31eUCX+4wr2XWDlKi
   A==;
IronPort-SDR: u4Ai0RRtCO76tM21BNwXv0WfVYZnkU7xnmI5/Jfm6Qr8OL+QnTwXOLyLZdLt0Hw/Ry7DQaJImn
 45l0SRyClisX6h7uMqeh/0LubCTS9o6NCorCyInuluixZGekI2GRaqVHywnvWORX7IVhuGgNaa
 +hJwoNzLSX4+KMkuhwboXnHlSh0sKz/QXFxRDJEK6icOTPWrYPHgjJj6inyIdbigC5sc7Db7KJ
 MrVg/giY93uNICSJPg+PmXjDFXN1FFAYtRpwymBpjKmHZHs2AEQa/iVmA7MQ0oL3UE6D/kd45O
 c+A=
X-IronPort-AV: E=Sophos;i="5.73,522,1583218800"; 
   d="scan'208";a="16088476"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2020 02:24:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Jun 2020 02:24:38 -0700
Received: from [10.171.246.62] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Jun 2020 02:24:40 -0700
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
To:     Helmut Grohne <helmut.grohne@intenta.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        <netdev@vger.kernel.org>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>
References: <20200616074955.GA9092@laureti-dev>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <42e6e3fb-0ea8-573b-eb1e-2a05ad07d5e7@microchip.com>
Date:   Wed, 17 Jun 2020 11:24:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200616074955.GA9092@laureti-dev>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/06/2020 at 09:49, Helmut Grohne wrote:
> The macb driver does not support configuring rgmii delays. At least for
> the Zynq GEM, delays are not supported by the hardware at all. However,
> the driver happily accepts and ignores any such delays.
> 
> When operating in a mac to phy connection, the delay setting applies to
> the phy. Since the MAC does not support delays, the phy must provide
> them and the only supported mode is rgmii-id.  However, in a fixed mac
> to mac connection, the delay applies to the mac itself. Therefore the
> only supported rgmii mode is rgmii.
> 
> Link: https://lore.kernel.org/netdev/20200610081236.GA31659@laureti-dev/
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
> ---
>   drivers/net/ethernet/cadence/macb_main.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 5b9d7c60eebc..bee5bf65e8b3 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -514,7 +514,7 @@ static void macb_validate(struct phylink_config *config,
>              state->interface != PHY_INTERFACE_MODE_RMII &&
>              state->interface != PHY_INTERFACE_MODE_GMII &&
>              state->interface != PHY_INTERFACE_MODE_SGMII &&
> -           !phy_interface_mode_is_rgmii(state->interface)) {
> +           state->interface != PHY_INTERFACE_MODE_RGMII_ID) {

Nitpicking: there's a comment just above, might be interesting to make 
it more precisely matching this change. It mustn't delay addition though.

>                  bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>                  return;
>          }
> @@ -694,6 +694,13 @@ static int macb_phylink_connect(struct macb *bp)
>          struct phy_device *phydev;
>          int ret;
> 
> +       if (of_phy_is_fixed_link(dn) &&
> +           phy_interface_mode_is_rgmii(bp->phy_interface) &&
> +           bp->phy_interface != PHY_INTERFACE_MODE_RGMII) {
> +               netdev_err(dev, "RGMII delays are not supported\n");
> +               return -EINVAL;
> +       }
> +

Otherwise, it looks good to me after reading the associated discussion 
link in your commit message: thanks for that!

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

>          if (dn)
>                  ret = phylink_of_phy_connect(bp->phylink, dn, 0);
> 
> --
> 2.20.1
> 


-- 
Nicolas Ferre
