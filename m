Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF04B31D7
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354361AbiBLASg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:18:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiBLASf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:18:35 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E619ECF9;
        Fri, 11 Feb 2022 16:18:33 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF345ED1;
        Fri, 11 Feb 2022 16:18:33 -0800 (PST)
Received: from [192.168.122.164] (U203867.austin.arm.com [10.118.30.26])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5969F3F70D;
        Fri, 11 Feb 2022 16:18:33 -0800 (PST)
Message-ID: <0e5f1807-22f1-ec5b-0b18-8bc02ad99760@arm.com>
Date:   Fri, 11 Feb 2022 18:18:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] net: mvpp2: Check for null pcs in mvpp2_acpi_start()
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
References: <20220211234235.3180025-1-jeremy.linton@arm.com>
 <Ygb2E1DGYVBO+mNP@shell.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
In-Reply-To: <Ygb2E1DGYVBO+mNP@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/11/22 17:49, Russell King (Oracle) wrote:
> On Fri, Feb 11, 2022 at 05:42:35PM -0600, Jeremy Linton wrote:
>> Booting a MACCHIATObin with 5.17 the system OOPs with
>> a null pointer deref when the network is started. This
>> is caused by the pcs->ops structure being null on this
>> particular platform/firmware.
> 
> pcs->ops should never be NULL. I'm surprised this fix results in any
> kind of working networking.
> 
> Instead, the initialilsation of port->pcs_*.ops needs to be moved out
> of the if (!mvpp2_use_acpi_compat_mode(..)) block. Please try this:

That appears to fix it as well, shall I re-post this with your fix, or 
will you?

> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index b45cc7bfcdb5..0fb65940c0a5 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -7036,6 +7036,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>   	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;
>   	dev->dev.of_node = port_node;
>   
> +	port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
> +	port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
> +
>   	if (!mvpp2_use_acpi_compat_mode(port_fwnode)) {
>   		port->phylink_config.dev = &dev->dev;
>   		port->phylink_config.type = PHYLINK_NETDEV;
> @@ -7106,9 +7109,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>   				  port->phylink_config.supported_interfaces);
>   		}
>   
> -		port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
> -		port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
> -
>   		phylink = phylink_create(&port->phylink_config, port_fwnode,
>   					 phy_mode, &mvpp2_phylink_ops);
>   		if (IS_ERR(phylink)) {
> 
> Thanks.
> 

I did a bit more testing and as a side note, it seems ethtool tosses 
these errors too.


netlink error: failed to retrieve link settings
netlink error: Unknown error 524
netlink error: failed to retrieve link settings
netlink error: Unknown error 524
Settings for enamrvl110i0:
         Link detected: no
