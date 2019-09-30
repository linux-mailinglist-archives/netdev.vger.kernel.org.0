Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0AFFC220F
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 15:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731304AbfI3Nee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 09:34:34 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:36312 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbfI3Nee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 09:34:34 -0400
Received: from [10.1.8.111] (unknown [10.1.8.111])
        by uho.ysoft.cz (Postfix) with ESMTP id 5035FA48B3;
        Mon, 30 Sep 2019 15:34:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1569850471;
        bh=DkZhXLf/liSBVKh0ARKHhgcCiN6tBxU8m1QCK+EHagE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KmLhQ08Y2U16kKNbPRryKZWifG7u+VBmXUzd2Di93Q+vOSkJ5hnIRgqYW9RR+VZzL
         E5RToMy9puNOGm9AHWqo93JPxDuw84gDBj/Yy33PPWsq67I8RMosGnkUAPsmPH0sol
         xXE4tYJ9a94/BgbX3LhZS0qr4ZmIEx08QKuw3/bk=
Subject: Re: [PATCH net] net: dsa: qca8k: Use up to 7 ports for all operations
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <1569488357-31415-1-git-send-email-michal.vokac@ysoft.com>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <07dda3c6-696c-928f-b007-8cda9744b624@ysoft.com>
Date:   Mon, 30 Sep 2019 15:34:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569488357-31415-1-git-send-email-michal.vokac@ysoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26. 09. 19 10:59, Michal Vokáč wrote:
> The QCA8K family supports up to 7 ports. So use the existing
> QCA8K_NUM_PORTS define to allocate the switch structure and limit all
> operations with the switch ports.
> 
> This was not an issue until commit 0394a63acfe2 ("net: dsa: enable and
> disable all ports") disabled all unused ports. Since the unused ports 7-11
> are outside of the correct register range on this switch some registers
> were rewritten with invalid content.
> 
> Fixes: 6b93fb46480a ("net-next: dsa: add new driver for qca8xxx family")
> Fixes: a0c02161ecfc ("net: dsa: variable number of ports")
> Fixes: 0394a63acfe2 ("net: dsa: enable and disable all ports")
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>

More recent patches on the list are getting attention.
Is this one falling through the cracks?

> ---
> I am not sure which of the fixes tags should be used but this definetelly
> fixes something..
> 
> IMHO the 0394a63acfe2 ("net: dsa: enable and disable all ports") did not
> cause the issue but made it visible.
> 
>   drivers/net/dsa/qca8k.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 16f15c93a102..bbeeb8618c80 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -705,7 +705,7 @@ qca8k_setup(struct dsa_switch *ds)
>   		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_UC_DP_S);
>   
>   	/* Setup connection between CPU port & user ports */
> -	for (i = 0; i < DSA_MAX_PORTS; i++) {
> +	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
>   		/* CPU port gets connected to all user ports of the switch */
>   		if (dsa_is_cpu_port(ds, i)) {
>   			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
> @@ -1074,7 +1074,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>   	if (id != QCA8K_ID_QCA8337)
>   		return -ENODEV;
>   
> -	priv->ds = dsa_switch_alloc(&mdiodev->dev, DSA_MAX_PORTS);
> +	priv->ds = dsa_switch_alloc(&mdiodev->dev, QCA8K_NUM_PORTS);
>   	if (!priv->ds)
>   		return -ENOMEM;
>   
> 

