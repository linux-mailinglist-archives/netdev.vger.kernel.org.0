Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F702271EC4
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 11:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgIUJSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 05:18:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:56720 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgIUJSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 05:18:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CF55BAC83;
        Mon, 21 Sep 2020 09:18:56 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 64A26603AF; Mon, 21 Sep 2020 11:18:20 +0200 (CEST)
Date:   Mon, 21 Sep 2020 11:18:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        andrew.gospodarek@broadcom.com
Subject: Re: [PATCH ethtool] bnxt: Add Broadcom driver support.
Message-ID: <20200921091820.hiulkidpedzgl4lz@lion.mk-sys.cz>
References: <1600670391-5533-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600670391-5533-1-git-send-email-vasundhara-v.volam@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 12:09:51PM +0530, Vasundhara Volam wrote:
> This patch adds the initial support for parsing registers dumped
> by the Broadcom driver. Currently, PXP and PCIe registers are
> parsed.
> 
> Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> ---
>  Makefile.am |  2 +-
>  bnxt.c      | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  ethtool.c   |  1 +
>  internal.h  |  3 +++
>  4 files changed, 91 insertions(+), 1 deletion(-)
>  create mode 100644 bnxt.c
> 
> diff --git a/Makefile.am b/Makefile.am
> index 0e237d0..e3e311d 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -17,7 +17,7 @@ ethtool_SOURCES += \
>  		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
>  		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
>  		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
> -		  igc.c qsfp-dd.c qsfp-dd.h
> +		  igc.c qsfp-dd.c qsfp-dd.h bnxt.c
>  endif
>  
>  if ENABLE_BASH_COMPLETION
> diff --git a/bnxt.c b/bnxt.c
> new file mode 100644
> index 0000000..91ed819
> --- /dev/null
> +++ b/bnxt.c
> @@ -0,0 +1,86 @@
> +/* Code to dump registers for NetXtreme-E/NetXtreme-C Broadcom devices.
> + *
> + * Copyright (c) 2020 Broadcom Inc.
> + */
> +#include <stdio.h>
> +#include "internal.h"
> +
> +#define BNXT_PXP_REG_LEN	0x3110
> +#define BNXT_PCIE_STATS_LEN	(12 * sizeof(u64))
> +
> +struct bnxt_pcie_stat {
> +	const char *name;
> +	u16 offset;
> +	u8 size;
> +	const char *format;
> +};
> +
> +static const struct bnxt_pcie_stat bnxt_pcie_stats[] = {
> +	{ .name = "PL Signal integrity errors     ", .offset = 0, .size = 4, .format = "%lld" },
> +	{ .name = "DL Signal integrity errors     ", .offset = 4, .size = 4, .format = "%lld" },
> +	{ .name = "TLP Signal integrity errors    ", .offset = 8, .size = 4, .format = "%lld" },
> +	{ .name = "Link integrity                 ", .offset = 12, .size = 4, .format = "%lld" },
> +	{ .name = "TX TLP traffic rate            ", .offset = 16, .size = 4, .format = "%lld" },
> +	{ .name = "RX TLP traffic rate            ", .offset = 20, .size = 4, .format = "%lld" },
> +	{ .name = "TX DLLP traffic rate           ", .offset = 24, .size = 4, .format = "%lld" },
> +	{ .name = "RX DLLP traffic rate           ", .offset = 28, .size = 4, .format = "%lld" },

Are all of these really interpreted as signed? Moreover, you are always
passing a u64 varable to printf().

> +	{ .name = "Equalization Phase 0 time(ms)  ", .offset = 33, .size = 1, .format = "0x%lx" },
> +	{ .name = "Equalization Phase 1 time(ms)  ", .offset = 32, .size = 1, .format = "0x%lx" },
> +	{ .name = "Equalization Phase 2 time(ms)  ", .offset = 35, .size = 1, .format = "0x%lx" },
> +	{ .name = "Equalization Phase 3 time(ms)  ", .offset = 34, .size = 1, .format = "0x%lx" },

Again, you are always passing a u64 variable so the format should rather
be "0x%llx".

> +	{ .name = "PHY LTSSM Histogram 0          ", .offset = 36, .size = 2, .format = "0x%llx"},
> +	{ .name = "PHY LTSSM Histogram 1          ", .offset = 38, .size = 2, .format = "0x%llx"},
> +	{ .name = "PHY LTSSM Histogram 2          ", .offset = 40, .size = 2, .format = "0x%llx"},
> +	{ .name = "PHY LTSSM Histogram 3          ", .offset = 42, .size = 2, .format = "0x%llx"},
> +	{ .name = "Recovery Histogram 0           ", .offset = 44, .size = 2, .format = "0x%llx"},
> +	{ .name = "Recovery Histogram 1           ", .offset = 46, .size = 2, .format = "0x%llx"},
> +};

I don't really like the trailing spaces in register names; why don't you
use printf() format for column alignment?

> +
> +int bnxt_dump_regs(struct ethtool_drvinfo *info __maybe_unused, struct ethtool_regs *regs)
> +{
> +	const struct bnxt_pcie_stat *stats = bnxt_pcie_stats;
> +	u16 *pcie_stats;
> +	u64 pcie_stat;
> +	u32 reg, i;
> +
> +	if (regs->len < BNXT_PXP_REG_LEN) {
> +		fprintf(stdout, "Length too short, expected atleast %x\n",
> +			BNXT_PXP_REG_LEN);

This will show "...atleast 3110" which is rather confusing without the
"0x" prefix. (Also, a space is missing in "atleast".)

> +		return -1;
> +	}
> +
> +	fprintf(stdout, "PXP Registers\n");
> +	fprintf(stdout, "Offset\tValue\n");
> +	fprintf(stdout, "------\t-------\n");
> +	for (i = 0; i < BNXT_PXP_REG_LEN; i += sizeof(reg)) {
> +		memcpy(&reg, &regs->data[i], sizeof(reg));
> +		if (reg)
> +			fprintf(stdout, "0x%04x\t0x%08x\n", i, reg);
> +	}
> +	fprintf(stdout, "\n");
> +
> +	if (!regs->version)
> +		return 0;
> +
> +	if (regs->len < (BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN)) {
> +		fprintf(stdout, "Length is too short, expected %lx\n",
> +			BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN);

The same problem here, "3170" actually meaning 0x3170 or 12656.

> +		return -1;
> +	}
> +
> +	pcie_stats = (u16 *)(regs->data + BNXT_PXP_REG_LEN);
> +	fprintf(stdout, "PCIe statistics:\n");
> +	fprintf(stdout, "----------------\n");
> +	for (i = 0; i < ARRAY_SIZE(bnxt_pcie_stats); i++) {
> +		pcie_stat = 0;
> +		memcpy(&pcie_stat, &pcie_stats[stats[i].offset],
> +		       stats[i].size * sizeof(u16));

This will only work on little endian architectures.

Michal

> +
> +		fprintf(stdout, "%s", stats[i].name);
> +		fprintf(stdout, stats[i].format, pcie_stat);
> +		fprintf(stdout, "\n");
> +	}
> +
> +	fprintf(stdout, "\n");
> +	return 0;
> +}
> diff --git a/ethtool.c b/ethtool.c
> index ab9b457..89bd15c 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -1072,6 +1072,7 @@ static const struct {
>  	{ "dsa", dsa_dump_regs },
>  	{ "fec", fec_dump_regs },
>  	{ "igc", igc_dump_regs },
> +	{ "bnxt_en", bnxt_dump_regs },
>  #endif
>  };
>  
> diff --git a/internal.h b/internal.h
> index d096a28..935ebac 100644
> --- a/internal.h
> +++ b/internal.h
> @@ -396,4 +396,7 @@ int fec_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
>  /* Intel(R) Ethernet Controller I225-LM/I225-V adapter family */
>  int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
>  
> +/* Broadcom Ethernet Controller */
> +int bnxt_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
> +
>  #endif /* ETHTOOL_INTERNAL_H__ */
> -- 
> 1.8.3.1
> 
