Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580C84D9D6D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245343AbiCOO1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiCOO1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:27:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7D854BF0;
        Tue, 15 Mar 2022 07:25:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647354348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bP10MpKxp2H+M/GICvTgdjWhCdPc/61K93sUgprsw14=;
        b=R9dSK34+A6a4Ngrt975mHLqphrmRbJYGz1P//s/pJjXsXkKVfxFykpUze3PlZaYkUDPA8J
        3jSsx9qfMD1DVdv9rDajElQieQq/TOBBgwPOKK4trrYleKQw7/YDNaBDi2HRBPU0q8emiK
        fjtH5yTzNinXRgl/rPjKi3roPp166Rw9j9Z1CiN8Rm6b0tJlwhN6bYpQdjgxRcr0OKZYpx
        HyPrIGxxgznRVeAkqQ05qJ22+wNrUCfYgcKT02TXYwnpGftrBXzgUziCaLWyxTPZKBDaij
        6Pj59kG1tq2C5B28N/wdmQ2vRnyFXmM9vFOyk3tm+ZRdmkeLM6/Qk3L2mAhBVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647354348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bP10MpKxp2H+M/GICvTgdjWhCdPc/61K93sUgprsw14=;
        b=sgaCCUxImjUe2XSPk4Jm5E49wfVVvvbrFICQNNpmvNTk7jPlK8mm3ZROom0zll17aPyCsk
        C5Auf9mvdXKfIrCA==
To:     John Garry <john.garry@huawei.com>, Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH 1/2] genirq: Extract irq_set_affinity_masks() from
 devm_platform_get_irqs_affinity()
In-Reply-To: <eee8d4b8-6b47-d675-aa6c-b0376b693e87@huawei.com>
References: <20220216090845.1278114-1-maz@kernel.org>
 <20220216090845.1278114-2-maz@kernel.org>
 <bdfe935b-6ee0-b588-e1e8-776d85f91813@huawei.com>
 <b502141b201a68eb4896c1653b67663a@kernel.org>
 <eee8d4b8-6b47-d675-aa6c-b0376b693e87@huawei.com>
Date:   Tue, 15 Mar 2022 15:25:48 +0100
Message-ID: <871qz370nn.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18 2022 at 08:41, John Garry wrote:
> On 17/02/2022 17:17, Marc Zyngier wrote:
>>> I know you mentioned it in 2/2, but it would be interesting to see how
>>> network controller drivers can handle the problem of missing in-flight
>>> IO completions for managed irq shutdown. For storage controllers this
>>> is all now safely handled in the block layer.
>> 
>> Do you have a pointer to this? It'd be interesting to see if there is
>> a common pattern.
>
> Check blk_mq_hctx_notify_offline() and other hotplug handler friends in 
> block/blk-mq.c and also blk_mq_get_ctx()/blk_mq_map_queue()
>
> So the key steps in CPU offlining are:
> - when the last CPU in HW queue context cpumask is going offline we mark 
> the HW queue as inactive and no longer queue requests there
> - drain all in-flight requests before we allow that last CPU to go 
> offline, meaning that we always have a CPU online to service any 
> completion interrupts
>
> This scheme relies on symmetrical HW submission and completion queues 
> and also that the blk-mq HW queue context cpumask is same as the HW 
> queue's IRQ affinity mask (see blk_mq_pci_map_queues()).
>
> I am not sure how much this would fit with the networking stack or that 
> marvell driver.

The problem with networking is RX flow steering.

The driver in question initializes the RX flows in
mvpp22_port_rss_init() by default so the packets are evenly distributed
accross the RX queues.

So without actually steering the RX flow away from the RX queue which is
associated to the to be unplugged CPU, this does not really work well.

Thanks,

        tglx
