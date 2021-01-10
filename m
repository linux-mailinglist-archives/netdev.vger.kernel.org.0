Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496C62F08F7
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbhAJSH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJSHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:07:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8A1C061786;
        Sun, 10 Jan 2021 10:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=u6YM/Go9rWjeLZQUp9bVZKFnCFrIjfrfe3cUszLi18E=; b=XVepJJqG9wK/cr+PshI30fdtE
        6deBm5m65oxGmfzcW6rWIVd2l+UEqO41ejh1YN4C6eInajANfmhw27tXl2ivG2eJ7cd5EOiah1OXD
        nIDHrM4NwbZP5DVcJC3rnas43/n80E7c7kESsezsIozrg7GYsczb50yW/GoCn22/kfErsQDUkLFFV
        BphGqWUrH6CWbz73tFZWnDgY6NQF+872eu+xcpnW1f1QIy8q6R7RgiVhD7RQiOdgX+fBsfAnvcY+x
        3kN7TPcaD+QTIsPRWV8+NYExkS7gejYGXxNSxSLWTd9BSFhfwdz960B45gzZD+jDLrNag6nPW1Pov
        /xuaBwuiQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46248)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyf6x-00064p-6n; Sun, 10 Jan 2021 18:06:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyf6w-0004Oz-JD; Sun, 10 Jan 2021 18:06:42 +0000
Date:   Sun, 10 Jan 2021 18:06:42 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH RFC net-next  11/19] net: mvpp2: add flow control RXQ and
 BM pool config callbacks
Message-ID: <20210110180642.GH1551@shell.armlinux.org.uk>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-12-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610292623-15564-12-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:30:15PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> This patch did not change any functionality.
> Added flow control RXQ and BM pool config callbacks that would be
> used to configure RXQ and BM pool thresholds.
> APIs also will disable/enable RXQ and pool Flow Control polling.
> 
> In this stage BM pool and RXQ has same stop/start thresholds
> defined in code.
> Also there are common thresholds for all RXQs.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  51 +++++-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 169 ++++++++++++++++++++
>  2 files changed, 216 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index 4d58af6..0ba0598 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -763,10 +763,53 @@
>  		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
>  
>  /* MSS Flow control */
> -#define MSS_SRAM_SIZE		0x800
> -#define FC_QUANTA		0xFFFF
> -#define FC_CLK_DIVIDER		0x140
> -#define MSS_THRESHOLD_STOP    768
> +#define MSS_SRAM_SIZE			0x800
> +#define MSS_FC_COM_REG			0
> +#define FLOW_CONTROL_ENABLE_BIT		BIT(0)
> +#define FLOW_CONTROL_UPDATE_COMMAND_BIT	BIT(31)
> +#define FC_QUANTA			0xFFFF
> +#define FC_CLK_DIVIDER			0x140
> +
> +#define MSS_BUF_POOL_BASE		0x40
> +#define MSS_BUF_POOL_OFFS		4
> +#define MSS_BUF_POOL_REG(id)		(MSS_BUF_POOL_BASE		\
> +					+ (id) * MSS_BUF_POOL_OFFS)
> +
> +#define MSS_BUF_POOL_STOP_MASK		0xFFF
> +#define MSS_BUF_POOL_START_MASK		(0xFFF << MSS_BUF_POOL_START_OFFS)
> +#define MSS_BUF_POOL_START_OFFS		12
> +#define MSS_BUF_POOL_PORTS_MASK		(0xF << MSS_BUF_POOL_PORTS_OFFS)
> +#define MSS_BUF_POOL_PORTS_OFFS		24
> +#define MSS_BUF_POOL_PORT_OFFS(id)	(0x1 <<				\
> +					((id) + MSS_BUF_POOL_PORTS_OFFS))
> +
> +#define MSS_RXQ_TRESH_BASE		0x200
> +#define MSS_RXQ_TRESH_OFFS		4
> +#define MSS_RXQ_TRESH_REG(q, fq)	(MSS_RXQ_TRESH_BASE + (((q) + (fq)) \
> +					* MSS_RXQ_TRESH_OFFS))
> +
> +#define MSS_RXQ_TRESH_START_MASK	0xFFFF
> +#define MSS_RXQ_TRESH_STOP_MASK		(0xFFFF << MSS_RXQ_TRESH_STOP_OFFS)
> +#define MSS_RXQ_TRESH_STOP_OFFS		16
> +
> +#define MSS_RXQ_ASS_BASE	0x80
> +#define MSS_RXQ_ASS_OFFS	4
> +#define MSS_RXQ_ASS_PER_REG	4
> +#define MSS_RXQ_ASS_PER_OFFS	8
> +#define MSS_RXQ_ASS_PORTID_OFFS	0
> +#define MSS_RXQ_ASS_PORTID_MASK	0x3
> +#define MSS_RXQ_ASS_HOSTID_OFFS	2
> +#define MSS_RXQ_ASS_HOSTID_MASK	0x3F
> +
> +#define MSS_RXQ_ASS_Q_BASE(q, fq) ((((q) + (fq)) % MSS_RXQ_ASS_PER_REG)	 \
> +				  * MSS_RXQ_ASS_PER_OFFS)
> +#define MSS_RXQ_ASS_PQ_BASE(q, fq) ((((q) + (fq)) / MSS_RXQ_ASS_PER_REG) \
> +				   * MSS_RXQ_ASS_OFFS)
> +#define MSS_RXQ_ASS_REG(q, fq) (MSS_RXQ_ASS_BASE + MSS_RXQ_ASS_PQ_BASE(q, fq))
> +
> +#define MSS_THRESHOLD_STOP	768
> +#define MSS_THRESHOLD_START	1024
> +
>  
>  /* RX buffer constants */
>  #define MVPP2_SKB_SHINFO_SIZE \
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index bc4b8069..19648c4 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -744,6 +744,175 @@ static void *mvpp2_buf_alloc(struct mvpp2_port *port,
>  	return data;
>  }
>  
> +/* Routine calculate single queue shares address space */
> +static int mvpp22_calc_shared_addr_space(struct mvpp2_port *port)
> +{
> +	/* If number of CPU's greater than number of threads, return last
> +	 * address space
> +	 */
> +	if (num_active_cpus() >= MVPP2_MAX_THREADS)
> +		return MVPP2_MAX_THREADS - 1;
> +
> +	return num_active_cpus();

Firstly - this can be written as:

	return min(num_active_cpus(), MVPP2_MAX_THREADS - 1);

Secondly - what if the number of active CPUs change, for example due
to hotplug activity. What if we boot with maxcpus=1 and then bring the
other CPUs online after networking has been started? The number of
active CPUs is dynamically managed via the scheduler as CPUs are
brought online or offline.

> +/* Routine enable flow control for RXQs conditon */
> +void mvpp2_rxq_enable_fc(struct mvpp2_port *port)
...
> +/* Routine disable flow control for RXQs conditon */
> +void mvpp2_rxq_disable_fc(struct mvpp2_port *port)

Nothing seems to call these in this patch, so on its own, it's not
obvious how these are being called, and therefore what remedy to
suggest for num_active_cpus().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
