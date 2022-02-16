Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E384B86D5
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiBPLij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:38:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiBPLii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:38:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAA510337E;
        Wed, 16 Feb 2022 03:38:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2017561A09;
        Wed, 16 Feb 2022 11:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FA5C004E1;
        Wed, 16 Feb 2022 11:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645011502;
        bh=7DffMbduG+mSQAp3PRQKpFKG82iv5455JLfmGG+Ufc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rVrt/ij+CFe7lvfpOoRQ5MDqiO42KlE1ED28DyXQdxF3Uy/fRae3082mXF85Y1/a3
         /zW5dAqsMterZjc1mfh1OyD73RS04v778vT7tgtT89ugQP7ASkBEKor/SxB12QrfRi
         D0T6Sxo0ulTt5LPk4oA6tY3R/DIBpFG1FBkN0OP5EZhlMYSAMW40ZJRItc2t4rNVi7
         QfHuBQkvdMSHq/kuhyj36nj/bV2VYgvo3Kfk/NMzr7E3iyX+tP0W3ftop/LPxyGB3e
         MV3GNCQHJNwSzbvIRXo5td1Jz8r8bBcrQNSJmVxKrSVs+H4cbmHjffLPuhdOh2FqTb
         cWoxB81EeyWqg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nKIdY-008JWT-FW; Wed, 16 Feb 2022 11:38:20 +0000
MIME-Version: 1.0
Date:   Wed, 16 Feb 2022 11:38:20 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Garry <john.garry@huawei.com>, kernel-team@android.com
Subject: Re: [PATCH 2/2] net: mvpp2: Convert to managed interrupts to fix CPU
 HP issues
In-Reply-To: <20220216090845.1278114-3-maz@kernel.org>
References: <20220216090845.1278114-1-maz@kernel.org>
 <20220216090845.1278114-3-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <44983ba2bfa801543db72872b5775701@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@linuxfoundation.org, mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org, tglx@linutronix.de, john.garry@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-16 09:08, Marc Zyngier wrote:
> The MVPP2 driver uses a set of per-CPU interrupts and relies on
> each particular interrupt to fire *only* on the CPU it has been
> assigned to.
> 
> Although the affinity setting is restricted to prevent userspace
> to move interrupts around, this all falls apart when using CPU
> hotplug, as this breaks the affinity. Depending on how lucky you
> are, the interrupt will then scream on the wrong CPU, eventually
> leading to an ugly crash.
> 
> Ideally, the interrupt assigned to a given CPU would simply be left
> where it is, only masked when the CPU goes down, and brought back
> up when the CPU is alive again. As it turns out, this is the model
> used for most multi-queue devices, and we'd be better off using it
> for the MVPP2 driver.
> 
> Drop the home-baked affinity settings in favour of the ready-made
> irq_set_affinity_masks() helper, making things slightly simpler.
> 
> With this change, the driver able to sustain CPUs being taken away.
> What is still missing is a way to tell the device that it should
> stop sending traffic to a given CPU.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  1 -
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 67 ++++++++++---------
>  2 files changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index ad73a488fc5f..86f8feaf5350 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -1143,7 +1143,6 @@ struct mvpp2_queue_vector {
>  	int nrxqs;
>  	u32 pending_cause_rx;
>  	struct mvpp2_port *port;
> -	struct cpumask *mask;
>  };
> 
>  /* Internal represention of a Flow Steering rule */
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 7cdbf8b8bbf6..cdc519583e86 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -4674,49 +4674,54 @@ static void mvpp21_get_mac_address(struct
> mvpp2_port *port, unsigned char *addr)
> 
>  static int mvpp2_irqs_init(struct mvpp2_port *port)
>  {
> -	int err, i;
> +	struct irq_affinity affd = {
> +		/* No pre/post-vectors, single set */
> +	};
> +	int err, i, nvec, *irqs;
> 
> -	for (i = 0; i < port->nqvecs; i++) {
> +	for (i = nvec = 0; i < port->nqvecs; i++) {
>  		struct mvpp2_queue_vector *qv = port->qvecs + i;
> 
> -		if (qv->type == MVPP2_QUEUE_VECTOR_PRIVATE) {
> -			qv->mask = kzalloc(cpumask_size(), GFP_KERNEL);
> -			if (!qv->mask) {
> -				err = -ENOMEM;
> -				goto err;
> -			}
> +		if (qv->type == MVPP2_QUEUE_VECTOR_PRIVATE)
> +			nvec++;
> +	}
> 
> -			irq_set_status_flags(qv->irq, IRQ_NO_BALANCING);
> -		}
> +	irqs = kmalloc(sizeof(*irqs) * nvec, GFP_KERNEL);
> +	if (!irqs)
> +		return -ENOMEM;
> 
> -		err = request_irq(qv->irq, mvpp2_isr, 0, port->dev->name, qv);
> -		if (err)
> -			goto err;
> +	for (i = 0; i < port->nqvecs; i++) {
> +		struct mvpp2_queue_vector *qv = port->qvecs + i;
> 
> -		if (qv->type == MVPP2_QUEUE_VECTOR_PRIVATE) {
> -			unsigned int cpu;
> +		if (qv->type == MVPP2_QUEUE_VECTOR_PRIVATE)
> +			irqs[i] = qv->irq;
> +	}

Errr, this is broken. non-private interrupts are not accounted for
in the sizing of the irqs[] array, so using 'i' as the index is
plain wrong.

I have added this on top:

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c 
b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index cdc519583e86..518ef07a067b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4690,11 +4690,11 @@ static int mvpp2_irqs_init(struct mvpp2_port 
*port)
  	if (!irqs)
  		return -ENOMEM;

-	for (i = 0; i < port->nqvecs; i++) {
+	for (i = nvec = 0; i < port->nqvecs; i++) {
  		struct mvpp2_queue_vector *qv = port->qvecs + i;

  		if (qv->type == MVPP2_QUEUE_VECTOR_PRIVATE)
-			irqs[i] = qv->irq;
+			irqs[nvec++] = qv->irq;
  	}

  	err = irq_set_affinity_masks(&affd, irqs, nvec);

Thanks to Russell for pointing out that something was amiss.

         M.
-- 
Jazz is not dead. It just smells funny...
