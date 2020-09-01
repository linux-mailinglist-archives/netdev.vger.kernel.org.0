Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80C1259DF6
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgIASSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:18:45 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43662 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgIASSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:18:44 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 081IIJdU129290;
        Tue, 1 Sep 2020 13:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598984299;
        bh=Lwpr36EMeIo7RDKJYQQHBLgJIbAH7X9PlRGuW+DsCBQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Nv5cPcLsgioS5l1vrTLAQ+yInCx63q4E/uw+foNS11imZzE67XLunt4AJWeeeeUzW
         Jtus+jTOvtXAaCrLYM5KCWGtIw3OZt3XvFrnzlIsvclMwOG6cQHFR6aETXbjEIa+Fy
         i18faZTQjyZfSB6udGu/r1zRI93LQI8eGKyuOSC0=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 081IIJJ9029682;
        Tue, 1 Sep 2020 13:18:19 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 1 Sep
 2020 13:18:19 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 1 Sep 2020 13:18:18 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 081IIIUY000741;
        Tue, 1 Sep 2020 13:18:18 -0500
Subject: Re: [PATCH v2] can: m_can: Set device to software init mode before
 closing
To:     Faiz Abbas <faiz_abbas@ti.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <mkl@pengutronix.de>,
        <wg@grandegger.com>, <sriram.dash@samsung.com>
References: <20200825055442.16994-1-faiz_abbas@ti.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <3ec0825f-9963-3687-c9f2-8280176c58aa@ti.com>
Date:   Tue, 1 Sep 2020 13:18:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200825055442.16994-1-faiz_abbas@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Faiz

On 8/25/20 12:54 AM, Faiz Abbas wrote:
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
>
> changes since v1: Rebased to latest mainline
>
>   drivers/net/can/m_can/m_can.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 02c5795b7393..d0c458f7f6e1 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1414,6 +1414,9 @@ static void m_can_stop(struct net_device *dev)
>   	/* disable all interrupts */
>   	m_can_disable_all_interrupts(cdev);
>   
> +	/* Set init mode to disengage from the network */
> +	m_can_config_endisable(cdev, true);
> +
>   	/* set the state as STOPPED */
>   	cdev->can.state = CAN_STATE_STOPPED;
>   }
Acked-by: Dan Murphy <dmurphy@ti.com>
