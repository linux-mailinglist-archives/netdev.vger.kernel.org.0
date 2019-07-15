Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C5069B50
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 21:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbfGOT0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 15:26:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:37668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730002AbfGOT0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 15:26:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 440D6B019;
        Mon, 15 Jul 2019 19:26:49 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DB0C0E0148; Mon, 15 Jul 2019 21:26:46 +0200 (CEST)
Date:   Mon, 15 Jul 2019 21:26:46 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Artem Bityutskiy <dedekind1@gmail.com>,
        "John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] ethtool: igb: dump RR2DCDELAY register
Message-ID: <20190715192646.GD24551@unicorn.suse.cz>
References: <20190715065228.88377-1-artem.bityutskiy@linux.intel.com>
 <20190715105933.40924-1-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715105933.40924-1-dedekind1@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 01:59:33PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Decode 'RR2DCDELAY' register which Linux kernel provides starting from version
> 5.3. The corresponding commit in the Linux kernel is:
>     cd502a7f7c9c igb: add RR2DCDELAY to ethtool registers dump
> 
> The RR2DCDELAY register is present in I210 and I211 Intel Gigabit Ethernet
> chips and it stands for "Read Request To Data Completion Delay". Here is how
> this register is described in the I210 datasheet:
> 
> "This field captures the maximum PCIe split time in 16 ns units, which is the
> maximum delay between the read request to the first data completion. This is
> giving an estimation of the PCIe round trip time."
> 
> In practice, this register can be used to measure the time it takes the NIC to
> read data from the host memory.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  igb.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> Changelog:
> v2: Fixed a typo in the commentary.
> v1: Initial pach version.
> 
> 
> diff --git a/igb.c b/igb.c
> index e0ccef9..cb24877 100644
> --- a/igb.c
> +++ b/igb.c
> @@ -859,6 +859,18 @@ igb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
>  		"0x03430: TDFPC       (Tx data FIFO packet count)      0x%08X\n",
>  		regs_buff[550]);
>  
> +	/*
> +	 * Starting from kernel version 5.3 the registers dump buffer grew from
> +	 * 739 4-byte words to 740 words, and word 740 contains the RR2DCDELAY
> +	 * register.
> +	 */
> +	if (regs->len < 740)
> +		return 0;
> +
> +	fprintf(stdout,
> +		"0x05BF4: RR2DCDELAY  (Max. DMA read delay)            0x%08X\n",
> +		regs_buff[739]);
> +
>  	return 0;
>  }
>  

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
