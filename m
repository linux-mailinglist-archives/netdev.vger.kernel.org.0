Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91FC68615
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbfGOJNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:13:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:45776 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729257AbfGOJNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 05:13:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E1AD2AFF0;
        Mon, 15 Jul 2019 09:13:35 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 768E8E0148; Mon, 15 Jul 2019 11:13:34 +0200 (CEST)
Date:   Mon, 15 Jul 2019 11:13:34 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc:     "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ethtool: igb: dump RR2DCDELAY register
Message-ID: <20190715091334.GB24551@unicorn.suse.cz>
References: <20190715065228.88377-1-artem.bityutskiy@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715065228.88377-1-artem.bityutskiy@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 09:52:28AM +0300, Artem Bityutskiy wrote:
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
> diff --git a/igb.c b/igb.c
> index e0ccef9..ab0896f 100644
> --- a/igb.c
> +++ b/igb.c
> @@ -859,6 +859,18 @@ igb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
>  		"0x03430: TDFPC       (Tx data FIFO packet count)      0x%08X\n",
>  		regs_buff[550]);
>  
> +	/*
> +	 * Starting from kernel version 5.3 the registers dump buffer grew from
> +	 * 739 4-byte words to 740 words, and word 740 contains the RR2DCDLAY

nit: "E" missing here:                                                    ^

> +	 * register.
> +	 */
> +	if (regs->len < 740)
> +		return 0;
> +
> +	fprintf(stdout,
> +		"0x05BF4: RR2DCDELAY  (Max. DMA read delay)            0x%08X\n",
> +		regs_buff[739]);

Showing a delay as hex number doesn't seem very user friendly but that
also applies to many existing registers so it's probably better to be
consistent and perhaps do an overall cleanup later.

Michal
