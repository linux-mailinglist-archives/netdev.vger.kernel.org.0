Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2C540468E
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 09:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhIIHyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 03:54:21 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26607 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhIIHyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 03:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631173991; x=1662709991;
  h=subject:to:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=uFD8a+128+tOgNMGAqiJQckk8rCXeARK5pmVYW+YIS0=;
  b=q0XvIj9rko+W/F+4YTZDlnwE+qNSdrTBJt0MM+IRPB+H6Z6vwxyCqlLw
   FtZtJcw3yIBiJRsrmY2ifRM4IuGS8HHxVqF9DuVZtu1z0Dj54DcRTX0Xn
   E/k9i5n7n8RizRm1Fp8Wlnc84tNqgTx4gEdVl6aI2mkhUxbBsF3DJw3Ac
   +Bj71oMQkaMVBgFnEBj7AZ0SXkX4y7tO4heTPqUgoccSLC3mE8fHCZ5sw
   bgfY3hphW9E8NRjmISA5pXOKl6Da5d0OrV5z/XxKqtfgNi0tc77KZB+G8
   Qc+JGyZd+3uJOuyqjFrWNozI2G5EX3Ug4V09xNBd+P18A08pQVxzlCy6N
   w==;
IronPort-SDR: jcje1fa0ZdjXpeep9uu4mFXJPOZCdmyCIv1qk92Q+GY1PlmZpXPA5UFj8UI8RZA+Iw/8ecvVJm
 XRAGHK7f/ucCVQLQIrYQBGVJz9gAK4T/go9wltMRI0QfcaFnCvW+M1hsUd4q1qgG5vq//BxafU
 HybUwaQ5c8/gJMNh+5M72ymIKLRxx5GZ5GWtTZ54JNzaw/vM1O/pECS/l36UBp4RIS0cmqwk62
 P1HExpzh2rDIvd9x8RL8zcCw6H9eWb95KAuWwImigxYSjJ+M409MrCLDqto79o+HIPjX+sQHiz
 0PjJ+53ZV/D3boakTxelxfrF
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="143440117"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2021 00:53:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Sep 2021 00:53:09 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 9 Sep 2021 00:53:08 -0700
Subject: Re: [PATCH v2] net: macb: fix use after free on rmmod
To:     Tong Zhang <ztong0001@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <48b53487-a708-ec79-a993-3448f4ca6e6d@microchip.com>
 <20210908190232.573178-1-ztong0001@gmail.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <a0f3f83d-0c83-5521-a608-026423e1c69e@microchip.com>
Date:   Thu, 9 Sep 2021 09:53:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210908190232.573178-1-ztong0001@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/09/2021 at 21:02, Tong Zhang wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> plat_dev->dev->platform_data is released by platform_device_unregister(),
> use of pclk and hclk is a use-after-free. Since device unregister won't
> need a clk device we adjust the function call sequence to fix this issue.
> 
> [   31.261225] BUG: KASAN: use-after-free in macb_remove+0x77/0xc6 [macb_pci]
> [   31.275563] Freed by task 306:
> [   30.276782]  platform_device_release+0x25/0x80
> 
> Suggested-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Tong Zhang.
Regards,
   Nicolas

> ---
> v2: switch lines to fix the issue instead
> 
>   drivers/net/ethernet/cadence/macb_pci.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
> index 8b7b59908a1a..f66d22de5168 100644
> --- a/drivers/net/ethernet/cadence/macb_pci.c
> +++ b/drivers/net/ethernet/cadence/macb_pci.c
> @@ -111,9 +111,9 @@ static void macb_remove(struct pci_dev *pdev)
>          struct platform_device *plat_dev = pci_get_drvdata(pdev);
>          struct macb_platform_data *plat_data = dev_get_platdata(&plat_dev->dev);
> 
> -       platform_device_unregister(plat_dev);
>          clk_unregister(plat_data->pclk);
>          clk_unregister(plat_data->hclk);
> +       platform_device_unregister(plat_dev);
>   }
> 
>   static const struct pci_device_id dev_id_table[] = {
> --
> 2.25.1
> 


-- 
Nicolas Ferre
