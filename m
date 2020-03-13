Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD356184F49
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 20:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCMTaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 15:30:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48730 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgCMTaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 15:30:16 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1jCq0Z-00045G-SO; Fri, 13 Mar 2020 15:30:11 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id 02DJS3HQ003795;
        Fri, 13 Mar 2020 15:28:03 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id 02DJS3tf003794;
        Fri, 13 Mar 2020 15:28:03 -0400
Date:   Fri, 13 Mar 2020 15:28:03 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>
Subject: Re: [PATCH ethtool] ethtool: Add support for Low Latency Reed Solomon
Message-ID: <20200313192803.GB1230@tuxdriver.com>
References: <1584025923-5385-1-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584025923-5385-1-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 05:12:03PM +0200, Tariq Toukan wrote:
> From: Aya Levin <ayal@mellanox.com>
> 
> Introduce a new FEC mode LL-RS: Low Latency Reed Solomon, update print
> and initialization functions accordingly. In addition, update related
> man page.
> 
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> ---
>  ethtool-copy.h |  3 +++
>  ethtool.8.in   |  5 +++--
>  ethtool.c      | 12 +++++++++++-
>  3 files changed, 17 insertions(+), 3 deletions(-)

Hey...

Thanks for the patch! Unfortunately for you, I just merged "[PATCH
ethtool v3 01/25] move UAPI header copies to a separate directory"
from Michal Kubecek <mkubecek@suse.cz>, and that patch did this:

 ethtool-copy.h => uapi/linux/ethtool.h       | 0
 rename ethtool-copy.h => uapi/linux/ethtool.h (100%)

Could you please rework your patch against the current kernel.org tree?

Thanks!

John
 
> diff --git a/ethtool-copy.h b/ethtool-copy.h
> index 9afd2e6c5eea..a5482a91b429 100644
> --- a/ethtool-copy.h
> +++ b/ethtool-copy.h
> @@ -1319,6 +1319,7 @@ enum ethtool_fec_config_bits {
>  	ETHTOOL_FEC_OFF_BIT,
>  	ETHTOOL_FEC_RS_BIT,
>  	ETHTOOL_FEC_BASER_BIT,
> +	ETHTOOL_FEC_LLRS_BIT,
>  };
>  
>  #define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
> @@ -1326,6 +1327,7 @@ enum ethtool_fec_config_bits {
>  #define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
>  #define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
>  #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
> +#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
>  
>  /* CMDs currently supported */
>  #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
> @@ -1505,6 +1507,7 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
>  	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
>  	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
> +	ETHTOOL_LINK_MODE_FEC_LLRS_BIT                   = 74,
>  
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
> diff --git a/ethtool.8.in b/ethtool.8.in
> index 94364c626330..5d16aa27dab1 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -404,7 +404,7 @@ ethtool \- query or control network driver and hardware settings
>  .B ethtool \-\-set\-fec
>  .I devname
>  .B encoding
> -.BR auto | off | rs | baser \ [...]
> +.BR auto | off | rs | baser | ll-rs \ [...]
>  .HP
>  .B ethtool \-Q|\-\-per\-queue
>  .I devname
> @@ -1204,7 +1204,7 @@ current FEC mode, the driver or firmware must take the link down
>  administratively and report the problem in the system logs for users to correct.
>  .RS 4
>  .TP
> -.BR encoding\ auto | off | rs | baser \ [...]
> +.BR encoding\ auto | off | rs | baser | ll-rs \ [...]
>  
>  Sets the FEC encoding for the device.  Combinations of options are specified as
>  e.g.
> @@ -1217,6 +1217,7 @@ auto	Use the driver's default encoding
>  off	Turn off FEC
>  RS	Force RS-FEC encoding
>  BaseR	Force BaseR encoding
> +LL-RS	Force LL-RS-FEC encoding
>  .TE
>  .RE
>  .TP
> diff --git a/ethtool.c b/ethtool.c
> index acf183dc5586..7110b269f306 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -562,6 +562,7 @@ static void init_global_link_mode_masks(void)
>  		ETHTOOL_LINK_MODE_FEC_NONE_BIT,
>  		ETHTOOL_LINK_MODE_FEC_RS_BIT,
>  		ETHTOOL_LINK_MODE_FEC_BASER_BIT,
> +		ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
>  	};
>  	unsigned int i;
>  
> @@ -814,6 +815,12 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
>  			fprintf(stdout, " RS");
>  			fecreported = 1;
>  		}
> +		if (ethtool_link_mode_test_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
> +					       mask)) {
> +			fprintf(stdout, " LL-RS");
> +			fecreported = 1;
> +		}
> +
>  		if (!fecreported)
>  			fprintf(stdout, " Not reported");
>  		fprintf(stdout, "\n");
> @@ -1696,6 +1703,8 @@ static void dump_fec(u32 fec)
>  		fprintf(stdout, " BaseR");
>  	if (fec & ETHTOOL_FEC_RS)
>  		fprintf(stdout, " RS");
> +	if (fec & ETHTOOL_FEC_LLRS)
> +		fprintf(stdout, " LL-RS");
>  }
>  
>  #define N_SOTS 7
> @@ -5209,7 +5218,8 @@ static int fecmode_str_to_type(const char *str)
>  		return ETHTOOL_FEC_RS;
>  	if (!strcasecmp(str, "baser"))
>  		return ETHTOOL_FEC_BASER;
> -
> +	if (!strcasecmp(str, "ll-rs"))
> +		return ETHTOOL_FEC_LLRS;
>  	return 0;
>  }
>  
> -- 
> 1.8.3.1
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
