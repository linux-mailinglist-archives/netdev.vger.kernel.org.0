Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA5F11720D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLIQnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:43:42 -0500
Received: from mga05.intel.com ([192.55.52.43]:15470 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfLIQnl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 11:43:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 08:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="414130348"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006.fm.intel.com with ESMTP; 09 Dec 2019 08:43:39 -0800
Received: from andy by smile with local (Exim 4.93-RC5)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ieM8I-00017c-Mq; Mon, 09 Dec 2019 18:43:38 +0200
Date:   Mon, 9 Dec 2019 18:43:38 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        ocfs2-devel@oss.oracle.com, Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v2] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
Message-ID: <20191209164338.GO32742@smile.fi.intel.com>
References: <20190827163717.44101-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827163717.44101-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 07:37:17PM +0300, Andy Shevchenko wrote:
> There are users already and will be more of BITS_TO_BYTES() macro.
> Move it to bitops.h for wider use.
> 
> In the case of ocfs2 the replacement is identical.
> 
> As for bnx2x, there are two places where floor version is used.
> In the first case to calculate the amount of structures that can fit
> one memory page. In this case obviously the ceiling variant is correct and
> original code might have a potential bug, if amount of bits % 8 is not 0.
> In the second case the macro is used to calculate bytes transmitted in one
> microsecond. This will work for all speeds which is multiply of 1Gbps without
> any change, for the rest new code will give ceiling value, for instance 100Mbps
> will give 13 bytes, while old code gives 12 bytes and the arithmetically
> correct one is 12.5 bytes. Further the value is used to setup timer threshold
> which in any case has its own margins due to certain resolution. I don't see
> here an issue with slightly shifting thresholds for low speed connections, the
> card is supposed to utilize highest available rate, which is usually 10Gbps.

Anybody to comment on bnx2 change?
Can we survive with this applied?

> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> - described bnx2x cases in the commit message
> - appended Rb (for ocfs2)
> 
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h | 1 -
>  fs/ocfs2/dlm/dlmcommon.h                         | 4 ----
>  include/linux/bitops.h                           | 1 +
>  3 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> index 066765fbef06..0a59a09ef82f 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> @@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(struct bnx2x *bp, enum cos_mode mode,
>   *    possible, the driver should only write the valid vnics into the internal
>   *    ram according to the appropriate port mode.
>   */
> -#define BITS_TO_BYTES(x) ((x)/8)
>  
>  /* CMNG constants, as derived from system spec calculations */
>  
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index aaf24548b02a..0463dce65bb2 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -688,10 +688,6 @@ struct dlm_begin_reco
>  	__be32 pad2;
>  };
>  
> -
> -#define BITS_PER_BYTE 8
> -#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
> -
>  struct dlm_query_join_request
>  {
>  	u8 node_idx;
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index cf074bce3eb3..79d80f5ddf7b 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -5,6 +5,7 @@
>  #include <linux/bits.h>
>  
>  #define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
> +#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
>  #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
>  
>  extern unsigned int __sw_hweight8(unsigned int w);
> -- 
> 2.23.0.rc1
> 

-- 
With Best Regards,
Andy Shevchenko


