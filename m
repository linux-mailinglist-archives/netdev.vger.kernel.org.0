Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929A096EE4
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 03:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfHUB3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 21:29:08 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:52187 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfHUB3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 21:29:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07417;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Ta0VyP8_1566350944;
Received: from JosephdeMacBook-Pro.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Ta0VyP8_1566350944)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 21 Aug 2019 09:29:05 +0800
Subject: Re: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>
References: <20190820163112.50818-1-andriy.shevchenko@linux.intel.com>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <1a3e6660-10d2-e66c-2880-24af64c7f120@linux.alibaba.com>
Date:   Wed, 21 Aug 2019 09:29:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820163112.50818-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/8/21 00:31, Andy Shevchenko wrote:
> There are users already and will be more of BITS_TO_BYTES() macro.
> Move it to bitops.h for wider use.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
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
> -#define BITS_TO_BYTES(x) ((x)/8)>
I don't think this is a equivalent replace, or it is in fact
wrong before?

  
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
For ocfs2 part, it looks good to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

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
> 
