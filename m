Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287A31955B4
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 11:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgC0KvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 06:51:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:50104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbgC0KvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 06:51:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0C805AD1E;
        Fri, 27 Mar 2020 10:51:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 03CC0E009C; Fri, 27 Mar 2020 11:51:09 +0100 (CET)
Date:   Fri, 27 Mar 2020 11:51:08 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [PATCH V3 ethtool] ethtool: Add support for Low Latency Reed
 Solomon
Message-ID: <20200327105108.GH31519@unicorn.suse.cz>
References: <20200326110929.18698-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326110929.18698-1-tariqt@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 01:09:29PM +0200, Tariq Toukan wrote:
> From: Aya Levin <ayal@mellanox.com>
> 
> Introduce a new FEC mode LLRS: Low Latency Reed Solomon, update print
> and initialization functions accordingly. In addition, update related
> man page.
> 
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> ---

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

The kernel counterpart is only in net-next at the moment so that,
technically, this should wait until after ethtool 5.6 is released.
On the other hand, having the entry in link_modes array would improve
compatibility with future kernels so that it would make sense to apply
this patch now.

Michal

>  ethtool.8.in         |  5 +++--
>  ethtool.c            | 14 ++++++++++++--
>  netlink/settings.c   |  2 ++
>  uapi/linux/ethtool.h |  3 +++
>  4 files changed, 20 insertions(+), 4 deletions(-)
> 
> v2 -> v3:
> - Removed dashes from ll-rs / LL-RS
> - Added missing llrs in .xhelp string
> 
> diff --git a/ethtool.8.in b/ethtool.8.in
> index ba85cfe4f413..08cd01419ce0 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -420,7 +420,7 @@ ethtool \- query or control network driver and hardware settings
>  .B ethtool \-\-set\-fec
>  .I devname
>  .B encoding
> -.BR auto | off | rs | baser \ [...]
> +.BR auto | off | rs | baser | llrs \ [...]
>  .HP
>  .B ethtool \-Q|\-\-per\-queue
>  .I devname
> @@ -1228,7 +1228,7 @@ current FEC mode, the driver or firmware must take the link down
>  administratively and report the problem in the system logs for users to correct.
>  .RS 4
>  .TP
> -.BR encoding\ auto | off | rs | baser \ [...]
> +.BR encoding\ auto | off | rs | baser | llrs \ [...]
>  
>  Sets the FEC encoding for the device.  Combinations of options are specified as
>  e.g.
> @@ -1241,6 +1241,7 @@ auto	Use the driver's default encoding
>  off	Turn off FEC
>  RS	Force RS-FEC encoding
>  BaseR	Force BaseR encoding
> +LLRS	Force LLRS-FEC encoding
>  .TE
>  .RE
>  .TP
> diff --git a/ethtool.c b/ethtool.c
> index 1b4e08b6e60f..854d2aa4e501 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -502,6 +502,7 @@ static void init_global_link_mode_masks(void)
>  		ETHTOOL_LINK_MODE_FEC_NONE_BIT,
>  		ETHTOOL_LINK_MODE_FEC_RS_BIT,
>  		ETHTOOL_LINK_MODE_FEC_BASER_BIT,
> +		ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
>  	};
>  	unsigned int i;
>  
> @@ -754,6 +755,12 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
>  			fprintf(stdout, " RS");
>  			fecreported = 1;
>  		}
> +		if (ethtool_link_mode_test_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
> +					       mask)) {
> +			fprintf(stdout, " LLRS");
> +			fecreported = 1;
> +		}
> +
>  		if (!fecreported)
>  			fprintf(stdout, " Not reported");
>  		fprintf(stdout, "\n");
> @@ -1562,6 +1569,8 @@ static void dump_fec(u32 fec)
>  		fprintf(stdout, " BaseR");
>  	if (fec & ETHTOOL_FEC_RS)
>  		fprintf(stdout, " RS");
> +	if (fec & ETHTOOL_FEC_LLRS)
> +		fprintf(stdout, " LLRS");
>  }
>  
>  #define N_SOTS 7
> @@ -5074,7 +5083,8 @@ static int fecmode_str_to_type(const char *str)
>  		return ETHTOOL_FEC_RS;
>  	if (!strcasecmp(str, "baser"))
>  		return ETHTOOL_FEC_BASER;
> -
> +	if (!strcasecmp(str, "llrs"))
> +		return ETHTOOL_FEC_LLRS;
>  	return 0;
>  }
>  
> @@ -5486,7 +5496,7 @@ static const struct option args[] = {
>  		.opts	= "--set-fec",
>  		.func	= do_sfec,
>  		.help	= "Set FEC settings",
> -		.xhelp	= "		[ encoding auto|off|rs|baser [...]]\n"
> +		.xhelp	= "		[ encoding auto|off|rs|baser|llrs [...]]\n"
>  	},
>  	{
>  		.opts	= "-Q|--per-queue",
> diff --git a/netlink/settings.c b/netlink/settings.c
> index c8a911d718b9..da821726e1b0 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -207,6 +207,8 @@ static const struct link_mode_info link_modes[] = {
>  		{ LM_CLASS_REAL,	400000,	DUPLEX_FULL },
>  	[ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT] =
>  		{ LM_CLASS_REAL,	400000,	DUPLEX_FULL },
> +	[ETHTOOL_LINK_MODE_FEC_LLRS_BIT] =
> +		{ LM_CLASS_FEC },
>  };
>  const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
>  
> diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
> index 16198061d723..d3dcb459195c 100644
> --- a/uapi/linux/ethtool.h
> +++ b/uapi/linux/ethtool.h
> @@ -1328,6 +1328,7 @@ enum ethtool_fec_config_bits {
>  	ETHTOOL_FEC_OFF_BIT,
>  	ETHTOOL_FEC_RS_BIT,
>  	ETHTOOL_FEC_BASER_BIT,
> +	ETHTOOL_FEC_LLRS_BIT,
>  };
>  
>  #define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
> @@ -1335,6 +1336,7 @@ enum ethtool_fec_config_bits {
>  #define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
>  #define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
>  #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
> +#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
>  
>  /* CMDs currently supported */
>  #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
> @@ -1519,6 +1521,7 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT = 71,
>  	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
>  	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
> +	ETHTOOL_LINK_MODE_FEC_LLRS_BIT                   = 74,
>  
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
> -- 
> 2.19.1
> 
