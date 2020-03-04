Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BF8179AB9
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgCDVPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:15:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:51695 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgCDVPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 16:15:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 13:15:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244065689"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 13:15:54 -0800
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org
References: <20200304043354.716290-1-kuba@kernel.org>
 <20200304043354.716290-2-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <94d5f79b-2a8b-8ec8-8bf3-f765b25069e1@intel.com>
Date:   Wed, 4 Mar 2020 13:15:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304043354.716290-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/3/2020 8:33 PM, Jakub Kicinski wrote:
> Linux supports 22 different interrupt coalescing parameters.
> No driver implements them all. Some drivers just ignore the
> ones they don't support, while others have to carry a long
> list of checks to reject unsupported settings.
> > To simplify the drivers add the ability to specify inside
> ethtool_ops which parameters are supported and let the core
> reject attempts to set any other one.
> 

Nice!

Seems straight forward to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> This commit makes the mechanism an opt-in, only drivers which
> set ethtool_opts->coalesce_types to a non-zero value will have
> the checks enforced.
> 

Makes sense. We can enforce it in the future.

> The same mask is used for global and per queue settings.
> 

Seems reasonable to me. It is unlikely that per-queue and global
settings would ever be different.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/ethtool.h | 45 +++++++++++++++++++++++++++--
>  net/ethtool/ioctl.c     | 63 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 105 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 23373978cb3c..3c7328f02ba3 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -177,8 +177,44 @@ void ethtool_convert_legacy_u32_to_link_mode(unsigned long *dst,
>  bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
>  				     const unsigned long *src);
>  
> +#define ETHTOOL_COALESCE_RX_USECS		BIT(0)
> +#define ETHTOOL_COALESCE_RX_MAX_FRAMES		BIT(1)
> +#define ETHTOOL_COALESCE_RX_USECS_IRQ		BIT(2)
> +#define ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ	BIT(3)
> +#define ETHTOOL_COALESCE_TX_USECS		BIT(4)
> +#define ETHTOOL_COALESCE_TX_MAX_FRAMES		BIT(5)
> +#define ETHTOOL_COALESCE_TX_USECS_IRQ		BIT(6)
> +#define ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ	BIT(7)
> +#define ETHTOOL_COALESCE_STATS_BLOCK_USECS	BIT(8)
> +#define ETHTOOL_COALESCE_USE_ADAPTIVE_RX	BIT(9)
> +#define ETHTOOL_COALESCE_USE_ADAPTIVE_TX	BIT(10)
> +#define ETHTOOL_COALESCE_PKT_RATE_LOW		BIT(11)
> +#define ETHTOOL_COALESCE_RX_USECS_LOW		BIT(12)
> +#define ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW	BIT(13)
> +#define ETHTOOL_COALESCE_TX_USECS_LOW		BIT(14)
> +#define ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW	BIT(15)
> +#define ETHTOOL_COALESCE_PKT_RATE_HIGH		BIT(16)
> +#define ETHTOOL_COALESCE_RX_USECS_HIGH		BIT(17)
> +#define ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH	BIT(18)
> +#define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
> +#define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
> +#define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
> +
> +#define ETHTOOL_COALESCE_USECS						\
> +	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
> +#define ETHTOOL_COALESCE_MAX_FRAMES					\
> +	(ETHTOOL_COALESCE_RX_MAX_FRAMES | ETHTOOL_COALESCE_TX_MAX_FRAMES)
> +#define ETHTOOL_COALESCE_USECS_IRQ					\
> +	(ETHTOOL_COALESCE_RX_USECS_IRQ | ETHTOOL_COALESCE_TX_USECS_IRQ)
> +#define ETHTOOL_COALESCE_MAX_FRAMES_IRQ		\
> +	(ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ |	\
> +	 ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ)
> +#define ETHTOOL_COALESCE_USE_ADAPTIVE					\
> +	(ETHTOOL_COALESCE_USE_ADAPTIVE_RX | ETHTOOL_COALESCE_USE_ADAPTIVE_TX)
> +
>  /**
>   * struct ethtool_ops - optional netdev operations
> + * @coalesce_types: supported types of interrupt coalescing.
>   * @get_drvinfo: Report driver/device information.  Should only set the
>   *	@driver, @version, @fw_version and @bus_info fields.  If not
>   *	implemented, the @driver and @bus_info fields will be filled in
> @@ -207,8 +243,9 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
>   *	or zero.
>   * @get_coalesce: Get interrupt coalescing parameters.  Returns a negative
>   *	error code or zero.
> - * @set_coalesce: Set interrupt coalescing parameters.  Returns a negative
> - *	error code or zero.
> + * @set_coalesce: Set interrupt coalescing parameters.  Supported coalescing
> + *	types should be set in @coalesce_types.
> + *	Returns a negative error code or zero.
>   * @get_ringparam: Report ring sizes
>   * @set_ringparam: Set ring sizes.  Returns a negative error code or zero.
>   * @get_pauseparam: Report pause parameters
> @@ -292,7 +329,8 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
>   * @set_per_queue_coalesce: Set interrupt coalescing parameters per queue.
>   *	It must check that the given queue number is valid. If neither a RX nor
>   *	a TX queue has this number, return -EINVAL. If only a RX queue or a TX
> - *	queue has this number, ignore the inapplicable fields.
> + *	queue has this number, ignore the inapplicable fields. Supported
> + *	coalescing types should be set in @coalesce_types.
>   *	Returns a negative error code or zero.
>   * @get_link_ksettings: Get various device settings including Ethernet link
>   *	settings. The %cmd and %link_mode_masks_nwords fields should be
> @@ -323,6 +361,7 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
>   * of the generic netdev features interface.
>   */
>  struct ethtool_ops {
> +	u32	coalesce_types;

It feels weird to me to put this data in ops, but I can't think of a
better place.

Thanks,
Jake
