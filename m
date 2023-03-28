Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58B46CBE96
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjC1MGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjC1MGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:06:44 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAAB8A43;
        Tue, 28 Mar 2023 05:06:17 -0700 (PDT)
Received: from kandell (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPS id 5B5D91C1481;
        Tue, 28 Mar 2023 14:06:04 +0200 (CEST)
Authentication-Results: mail.nic.cz;
        none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1680005165; bh=yEJ4s07mOxgd45ojTtnpz2ZYwsSZtSkS7TxxQM1EWMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Reply-To:
         Subject:To:Cc;
        b=F3Z1VnT0PbkprI187QqXHFnS9lanGTcPSUXj80fYUbixwlxz2Y3Qhb4dujmw8qDAc
         JzHINBlNRJ4qrQ1SfVeGFOebhucIC831HhK4pBHdS45GuzDdGDus/qiIcTmKR6tW4k
         9fDad7cbX4a0GTuvqoN/Wff/YHGHBC1XT1L0LBx4=
Date:   Tue, 28 Mar 2023 14:06:04 +0200
From:   Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     Gustav Ekelund <gustav.ekelund@axis.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@axis.com,
        Gustav Ekelund <gustaek@axis.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Reset mv88e6393x watchdog
 register
Message-ID: <20230328120604.zawfeskqs4yhlze6@kandell>
References: <20230328115511.400145-1-gustav.ekelund@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328115511.400145-1-gustav.ekelund@axis.com>
X-Virus-Scanned: clamav-milter 0.103.7 at mail
X-Virus-Status: Clean
X-Rspamd-Action: no action
X-Rspamd-Server: mail
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spamd-Result: default: False [-0.10 / 20.00];
        MIME_GOOD(-0.10)[text/plain];
        TAGGED_RCPT(0.00)[];
        ARC_NA(0.00)[];
        FROM_EQ_ENVFROM(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[gmail.com];
        WHITELISTED_IP(0.00)[172.20.6.87];
        FROM_HAS_DN(0.00)[];
        MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: 5B5D91C1481
X-Spamd-Bar: /
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: WHITELISTED_IP
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 01:55:11PM +0200, Gustav Ekelund wrote:
> From: Gustav Ekelund <gustaek@axis.com>
> 
> The watchdog event bits are not cleared during SW reset in the mv88e6393x
> switch. This causes one event to be handled over and over again.
> 
> Explicitly clear the watchdog event register to 0 after the SW reset.
> 
> Signed-off-by: Gustav Ekelund <gustaek@axis.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c    |  2 +-
>  drivers/net/dsa/mv88e6xxx/global2.c | 17 +++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/global2.h |  1 +
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 30383c4f8fd0..ee22d4785e9e 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -5596,7 +5596,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
>  	 * .port_set_upstream_port method.
>  	 */
>  	.set_egress_port = mv88e6393x_set_egress_port,
> -	.watchdog_ops = &mv88e6390_watchdog_ops,
> +	.watchdog_ops = &mv88e6393x_watchdog_ops,
>  	.mgmt_rsvd2cpu = mv88e6393x_port_mgmt_rsvd2cpu,
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
> diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
> index ed3b2f88e783..bef8297d4f78 100644
> --- a/drivers/net/dsa/mv88e6xxx/global2.c
> +++ b/drivers/net/dsa/mv88e6xxx/global2.c
> @@ -943,6 +943,23 @@ const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops = {
>  	.irq_free = mv88e6390_watchdog_free,
>  };
>  
> +static int mv88e6393x_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
> +{
> +	mv88e6390_watchdog_action(chip, irq);
> +
> +	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
> +			   MV88E6390_G2_WDOG_CTL_UPDATE |
> +			   MV88E6390_G2_WDOG_CTL_PTR_EVENT);
> +
> +	return IRQ_HANDLED;
> +}

Shouldn't this update be in .irq_setup() method? In the commit message
you're saying that the problem is that bits aren't cleared with SW
reset. So I would guess that the change should be in the setup of
watchdog IRQ, not in IRQ action?

(I am not disagreeing, I am just asking because I don't have access to
documentation right now.)

Marek

> +const struct mv88e6xxx_irq_ops mv88e6393x_watchdog_ops = {
> +	.irq_action = mv88e6393x_watchdog_action,
> +	.irq_setup = mv88e6390_watchdog_setup,
> +	.irq_free = mv88e6390_watchdog_free,
> +};
> +
>  static irqreturn_t mv88e6xxx_g2_watchdog_thread_fn(int irq, void *dev_id)
>  {
>  	struct mv88e6xxx_chip *chip = dev_id;
> diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
> index e973114d6890..7e091965582b 100644
> --- a/drivers/net/dsa/mv88e6xxx/global2.h
> +++ b/drivers/net/dsa/mv88e6xxx/global2.h
> @@ -369,6 +369,7 @@ int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip, int target,
>  extern const struct mv88e6xxx_irq_ops mv88e6097_watchdog_ops;
>  extern const struct mv88e6xxx_irq_ops mv88e6250_watchdog_ops;
>  extern const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops;
> +extern const struct mv88e6xxx_irq_ops mv88e6393x_watchdog_ops;
>  
>  extern const struct mv88e6xxx_avb_ops mv88e6165_avb_ops;
>  extern const struct mv88e6xxx_avb_ops mv88e6352_avb_ops;
> -- 
> 2.30.2
> 
