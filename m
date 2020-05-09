Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFEA1CC27A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 17:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEIPnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 11:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726782AbgEIPnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 11:43:49 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2CEF2063A;
        Sat,  9 May 2020 15:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589039029;
        bh=o1bX8Zql/kQ5+2VP0PxQWxTrOXX0zwKggYwZhmcqNrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DAXEZFtgE82+8ztfFy+75+0SXtIGD9rjTnRytb7gq+fU+tGx4hbaaWmS2NcxsN+Pt
         jSeaNmSSiVN2iqylQqSMRdrnQ//OygB2q713StgEDppDnCYpiSQumAGbLQaolzFh+k
         PJ9TtJmxAEV+9tAf+Z7IF89wjHUFlaKH1C2BrKBQ=
Date:   Sat, 9 May 2020 10:48:18 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] ath10k: fix gcc-10 zero-length-bounds
 warnings
Message-ID: <20200509154818.GB27779@embeddedor>
References: <20200509120707.188595-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509120707.188595-1-arnd@arndb.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd,

On Sat, May 09, 2020 at 02:06:32PM +0200, Arnd Bergmann wrote:
> gcc-10 started warning about out-of-bounds access for zero-length
> arrays:
> 
> In file included from drivers/net/wireless/ath/ath10k/core.h:18,
>                  from drivers/net/wireless/ath/ath10k/htt_rx.c:8:
> drivers/net/wireless/ath/ath10k/htt_rx.c: In function 'ath10k_htt_rx_tx_fetch_ind':
> drivers/net/wireless/ath/ath10k/htt.h:1683:17: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'struct htt_tx_fetch_record[0]' [-Wzero-length-bounds]
>  1683 |  return (void *)&ind->records[le16_to_cpu(ind->num_records)];
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/htt.h:1676:29: note: while referencing 'records'
>  1676 |  struct htt_tx_fetch_record records[0];
>       |                             ^~~~~~~
> 
> Make records[] a flexible array member to allow this, moving it behind
> the other zero-length member that is not accessed in a way that gcc
> warns about.
> 
> Fixes: 3ba225b506a2 ("treewide: Replace zero-length array with flexible-array member")

This treewide patch no longer contains changes for ath10k. I removed them
since Monday (05/04/2020). So, this "Fixes" tag does not apply.

Thanks
--
Gustavo

> Fixes: 22e6b3bc5d96 ("ath10k: add new htt definitions")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/ath/ath10k/htt.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
> index 8f3710cf28f4..aa056a186402 100644
> --- a/drivers/net/wireless/ath/ath10k/htt.h
> +++ b/drivers/net/wireless/ath/ath10k/htt.h
> @@ -1673,8 +1673,8 @@ struct htt_tx_fetch_ind {
>  	__le32 token;
>  	__le16 num_resp_ids;
>  	__le16 num_records;
> -	struct htt_tx_fetch_record records[0];
>  	__le32 resp_ids[0]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
> +	struct htt_tx_fetch_record records[];
>  } __packed;
>  
>  static inline void *
> -- 
> 2.26.0
> 
