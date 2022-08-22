Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5E759B74F
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 03:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiHVBs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 21:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiHVBsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 21:48:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077E918346
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 18:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Riz8+HPQT2/Nsv2jYj22zqOPNmiP/0OOByHpfThIGRI=; b=4dLMEffpKqJlNxXIXyLKSEsLFm
        iuN+Y0VphfobV4qG193tlZwqIRQ3wiuCrysGyL7/odWSOW0QbdGTrhTU4/gTGzDMj+rv+9oMmx20y
        Be/07EhzNrEmMTiDKm2Gei00fXIOUKjJztI92wXoatNAyOHXOkJbrXpmJ9ywcH1gcHq4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oPwYR-00EAvC-Gg; Mon, 22 Aug 2022 03:48:39 +0200
Date:   Mon, 22 Aug 2022 03:48:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, mlxsw@nvidia.com,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 4/8] mlxsw: i2c: Add support for system
 interrupt handling
Message-ID: <YwLgdxKwsBONjgZf@lunn.ch>
References: <cover.1661093502.git.petrm@nvidia.com>
 <96b0d90c1ed9fa5ca2b3ba5e3ba572155ad01b87.1661093502.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96b0d90c1ed9fa5ca2b3ba5e3ba572155ad01b87.1661093502.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mlxsw_i2c_work_handler(struct work_struct *work)
> +{
> +	struct mlxsw_i2c *mlxsw_i2c;
> +
> +	mlxsw_i2c = container_of(work, struct mlxsw_i2c, irq_work);
> +	mlxsw_core_irq_event_handlers_call(mlxsw_i2c->core);
> +}
> +
> +static irqreturn_t mlxsw_i2c_irq_handler(int irq, void *dev)
> +{
> +	struct mlxsw_i2c *mlxsw_i2c = dev;
> +
> +	mlxsw_core_schedule_work(&mlxsw_i2c->irq_work);
> +
> +	/* Interrupt handler shares IRQ line with 'main' interrupt handler.
> +	 * Return here IRQ_NONE, while main handler will return IRQ_HANDLED.
> +	 */
> +	return IRQ_NONE;
> +}
> +
> +static int mlxsw_i2c_irq_init(struct mlxsw_i2c *mlxsw_i2c, u8 addr)
> +{
> +	int err;
> +
> +	/* Initialize interrupt handler if system hotplug driver is reachable,
> +	 * otherwise interrupt line is not enabled and interrupts will not be
> +	 * raised to CPU. Also request_irq() call will be not valid.
> +	 */
> +	if (!IS_REACHABLE(CONFIG_MLXREG_HOTPLUG))
> +		return 0;
> +
> +	/* Set default interrupt line. */
> +	if (mlxsw_i2c->pdata && mlxsw_i2c->pdata->irq)
> +		mlxsw_i2c->irq = mlxsw_i2c->pdata->irq;
> +	else if (addr == MLXSW_FAST_I2C_SLAVE)
> +		mlxsw_i2c->irq = MLXSW_I2C_DEFAULT_IRQ;
> +
> +	if (!mlxsw_i2c->irq)
> +		return 0;
> +
> +	INIT_WORK(&mlxsw_i2c->irq_work, mlxsw_i2c_work_handler);
> +	err = request_irq(mlxsw_i2c->irq, mlxsw_i2c_irq_handler,
> +			  IRQF_TRIGGER_FALLING | IRQF_SHARED, "mlxsw-i2c",
> +			  mlxsw_i2c);

I think you can make this simpler by using a request_threaded_irq()

  Andrew
