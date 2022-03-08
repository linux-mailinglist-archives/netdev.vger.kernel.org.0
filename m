Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE9C4D2364
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 22:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244208AbiCHVhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 16:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiCHVhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 16:37:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18B054FAA;
        Tue,  8 Mar 2022 13:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FG9d9AQa90VpHPK3gi3B5dADoCRzSxnWl2+SRq8tFKs=; b=KW0/9ZGYCkYMYLQcraP8+6oofj
        eVm+h2/8WEuO0wGr5ofaK/fdf4Hf+aJNR4AxNrITORYe9SySewXnwvyiZWVMAEDRcKCQfe+wVfVpG
        0ZKaINWGldkk8f2OzHvIBBSHPGTPgi/LePFH8yWuaJQzPMsSqr6jizWPTcf2CAY6Y7K8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRhV3-009rWv-RP; Tue, 08 Mar 2022 22:36:09 +0100
Date:   Tue, 8 Mar 2022 22:36:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <YifMSUA/uZoPnpf1@lunn.ch>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
>  {
> -	u32 val;
> +	unsigned long time = jiffies + usecs_to_jiffies(READL_TIMEOUT_US);
> +	int ret = 0;
>  
> -	return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
> -					 QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
> -					 READL_SLEEP_US, READL_TIMEOUT_US);
> +	while (!(lan_rd(lan966x, QS_INJ_STATUS) &
> +		 QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
> +		if (time_after(jiffies, time)) {
> +			ret = -ETIMEDOUT;
> +			break;
> +		}

Did you try setting READL_SLEEP_US to 0? readx_poll_timeout_atomic()
explicitly supports that.

    Andrew
