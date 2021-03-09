Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2C6333176
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 23:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhCIWSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 17:18:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231960AbhCIWR4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 17:17:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F254A650AC;
        Tue,  9 Mar 2021 22:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615328276;
        bh=3yN0EEuV6v6QjQlZgm324hPSjzM9yE63G1GoN8AzqVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ZONvT4O3X7mG9tB+BPAHTig514bejv4EKVE2Q6fH3X9Vq3jHnjI1cQTDx8g/t8jYk
         Kx4paUrFU4gTTVCd5iLK2IxqxGg4aXze1WrwOFhlUZiTJkEYQQo+sXAL7o1hUX5HjF
         WHSH5tN/f9zbIBZlKe4oKOBQzSu+9buwvczYz+BLgeZzgOsLNrLVEmGQoKXKsdWJ3V
         exn4MJiD/cMd6t5OuABDcThtyFgCrkns3twfZ+RjX4pnP3NWS1B+nN47QYbenBcBu9
         wBR7x1XCXg+cG71jt5cPs29p2izdS1JUNveppKyN8nlHv4CfESxvdV9ojPkH3MiaAR
         FNDG6oUcz8Gdw==
Date:   Tue, 9 Mar 2021 16:17:53 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [patch 12/14] PCI: hv: Use tasklet_disable_in_atomic()
Message-ID: <20210309221753.GA1930915@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309084242.516519290@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 09:42:15AM +0100, Thomas Gleixner wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> The hv_compose_msi_msg() callback in irq_chip::irq_compose_msi_msg is
> invoked via irq_chip_compose_msi_msg(), which itself is always invoked from
> atomic contexts from the guts of the interrupt core code.
> 
> There is no way to change this w/o rewriting the whole driver, so use
> tasklet_disable_in_atomic() which allows to make tasklet_disable()
> sleepable once the remaining atomic users are addressed.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-hyperv@vger.kernel.org
> Cc: linux-pci@vger.kernel.org

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

It'd be ideal if you could merge this as a group.  Let me know if you
want me to do anything else.

> ---
>  drivers/pci/controller/pci-hyperv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -1458,7 +1458,7 @@ static void hv_compose_msi_msg(struct ir
>  	 * Prevents hv_pci_onchannelcallback() from running concurrently
>  	 * in the tasklet.
>  	 */
> -	tasklet_disable(&channel->callback_event);
> +	tasklet_disable_in_atomic(&channel->callback_event);
>  
>  	/*
>  	 * Since this function is called with IRQ locks held, can't
> 
