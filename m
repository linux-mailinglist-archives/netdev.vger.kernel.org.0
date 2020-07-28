Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE402302A4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgG1GVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:21:20 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:41496 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgG1GVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:21:08 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06S6KrVH058816;
        Tue, 28 Jul 2020 01:20:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595917253;
        bh=SAlHte2Rj/qJKt/tq4DOOPSVK0jp9XRydVDD3K/+T7k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=xlfvC9N/I/x8umGOG8XFL7hPQAv4d/b5GgL8D6F6s+TpDwli4Il/vaEi79H3Rg89m
         41yhrUDX1QnpI7+oRFXWuk4h3ZSWlwlvubbEqXS0Rqk5j+JxvhI8CUEyEa945ZNeeF
         /2cOAa2gNpu2JbJeY5Qe/W4cxRqglyNXaRCqCq/E=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06S6KruA041513
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Jul 2020 01:20:53 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 28
 Jul 2020 01:20:53 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 28 Jul 2020 01:20:53 -0500
Received: from [10.250.232.88] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06S6KnLQ066730;
        Tue, 28 Jul 2020 01:20:50 -0500
Subject: Re: [PATCH] can: m_can: Set device to software init mode before
 closing
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-can@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <mkl@pengutronix.de>,
        <wg@grandegger.com>, <sriram.dash@samsung.com>, <dmurphy@ti.com>
References: <20200716042312.26989-1-faiz_abbas@ti.com>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <1491e746-6694-1c36-4bba-ac9f61d9ae6f@ti.com>
Date:   Tue, 28 Jul 2020 11:50:48 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716042312.26989-1-faiz_abbas@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 16/07/20 9:53 am, Faiz Abbas wrote:
> There might be some requests pending in the buffer when the
> interface close sequence occurs. In some devices, these
> pending requests might lead to the module not shutting down
> properly when m_can_clk_stop() is called.
> 
> Therefore, move the device to init state before potentially
> powering it down.
> 
> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> ---
>  drivers/net/can/m_can/m_can.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 02c5795b7393..d0c458f7f6e1 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1414,6 +1414,9 @@ static void m_can_stop(struct net_device *dev)
>  	/* disable all interrupts */
>  	m_can_disable_all_interrupts(cdev);
>  
> +	/* Set init mode to disengage from the network */
> +	m_can_config_endisable(cdev, true);
> +
>  	/* set the state as STOPPED */
>  	cdev->can.state = CAN_STATE_STOPPED;
>  }
> 

Gentle ping.

Thanks,
Faiz
