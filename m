Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A6B445621
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 16:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhKDPSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 11:18:36 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:2918 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhKDPSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 11:18:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1636038958; x=1667574958;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bZ4tH7bxY3N/i7tJeaPbPXNGW0M5MDZHNwSM9AH0YU8=;
  b=gtnJ2B5tKvRTEQ62Yfp3wL5vJeHrnNvLglFLifQTdl1ii/H2IFaaJOQL
   f9SlF2L3vzrNCDiKKPVh7TlrXk3kgMHt2VThyYk60/z0LYu4EC45OBGSM
   idgxx8SuwoDTXEUjn3M5Ko15qLq9LgP75RkGpF+AP3zP4XWZoUdcdBV+b
   9YLgEYTMQPUUF0MEV9eBgRG7MNLlNve86bMYgMgv+nedtBDjfoTG4OYTD
   5V8/Yv/5iN9AcJ86MmxArK9BKE7Cj1Ujj1GlOKQxdutEHrkF48beYVpAi
   QRNshFiOcKYylYD7BhUIBxuhgJPCy8r0N+E1lu6KIcpYs72xdqxVvnqBc
   Q==;
IronPort-SDR: YCpnUhJv5P3ZR1JD2xV2Zpbnc3WLso4H8cPr24AZQmeZI8jZOS2ZF2XYD1RArrriSssRKw4I/a
 oNfyNoPqkrjxB0leSdvui+T4cEzb/AtIRko2qnOCtKsBlwZjGPc/H8g5w/Z3ZkyfiDvxWA6kXK
 7GY/Enke3pjazBf6dHXqvFS7Cuu8clEx4hSVZhXMvTPBD0/eA0zKvfaW7wLMxN9kcunYqUnjkp
 PzmkI1yRwoSaDlnpk8kiS/P9oeDOT6QjJaiqXpoF3BvZJrWbff1JeLZNj6SPdTiRIgev5Ht3Jp
 wyGzpAn4dWFA1CevAilFeJPQ
X-IronPort-AV: E=Sophos;i="5.87,209,1631602800"; 
   d="scan'208";a="150735507"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Nov 2021 08:15:57 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 4 Nov 2021 08:15:56 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 4 Nov 2021 08:15:54 -0700
Subject: Re: [net-next PATCH v5] net: macb: Fix several edge cases in validate
To:     Parshuram Raju Thombare <pthombar@cadence.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Milind Parab <mparab@cadence.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        "Russell King" <linux@armlinux.org.uk>
References: <20211101150422.2811030-1-sean.anderson@seco.com>
 <CY4PR07MB27576B46D37E39F9F1789A31C18C9@CY4PR07MB2757.namprd07.prod.outlook.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <5305c72d-e8f0-c4cd-3a85-2f12a0f644c8@microchip.com>
Date:   Thu, 4 Nov 2021 16:15:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CY4PR07MB27576B46D37E39F9F1789A31C18C9@CY4PR07MB2757.namprd07.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/11/2021 at 11:14, Parshuram Raju Thombare wrote:
> Hi Sean,
> 
> Thanks for this improvement.
> 
>> +      if (!macb_is_gem(bp) ||
>> +          (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
>> +              have_1g = true;
>> +              if (bp->caps & MACB_CAPS_PCS)
>> +                      have_sgmii = true;
>> +              if (bp->caps & MACB_CAPS_HIGH_SPEED)
>> +                      have_10g = true;
> 
> As I understand, MACB_CAPS_GIGABIT_MODE_AVAILABLE is used as a quirk in configs
> to prevent giga bit operation support, Nicolas should have more information about this.

That's right Parshuram.

> macb_is_gem() tells whether giga bit operations is supported by HW, MACB_CAPS_PCS indicate
> whether PCS is included in the design (needed for SGMII and 10G operation), MACB_CAPS_HIGH_SPEED
> indicate if design supports 10G operation.
> 
> I believe this should be
> 
>> +      if (macb_is_gem(bp) &&
>> +          (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
>> +              have_1g = true;
>> +              if (bp->caps & MACB_CAPS_PCS)
>> +                      have_sgmii = true;
>> +              if (bp->caps & MACB_CAPS_HIGH_SPEED)
>> +                      have_10g = true;


Regards,
   Nicolas

-- 
Nicolas Ferre
