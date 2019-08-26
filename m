Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35D39D0CB
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbfHZNk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:40:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44439 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbfHZNk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 09:40:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so10044530plr.11;
        Mon, 26 Aug 2019 06:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rBGgnC50tEqUQpJ+f65Q91HGdjIjtC+5DlqiDSMP1/Q=;
        b=afRo5XfL1dnaButfIoJqTh3HWsWdfH0C/Pa8CA105hesfqqeFTx293NH2E4Cz/6fM7
         TNs8KLbLJ8TuBk6JUzLt22sAoN0iEg65D/pjLsW7lC2HLvTFaNZD9WE/deeC2oXMFnd9
         SS+xPJB1Q4cX2atWlPzTYPWdz478+1oaXD//7C57jtEPABMbU/XcR1iZr2iWD6HcOdEH
         KK6i/QHOcBuR2/bFt+v9+WcqZYbttAaoTy3hA0NV/J9Di4IjKIxGiVJkQ2UsMdh1y5Ch
         gTCxuVWYECdBGgmp7O5++TYOVTjO+dge+5Afttr5iBBpIlcNN04QKMRJztev0B8rIOzY
         PBpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rBGgnC50tEqUQpJ+f65Q91HGdjIjtC+5DlqiDSMP1/Q=;
        b=SzuZjg0Yqqilj0UKaeWh/bDMX61qCXZNZTXb8aO7muzAptmG8wEjaEMc7MDj/pvyF8
         OvUvfC1pOwkI2YHVDzakGpoZwaBBud8/bMS2EDUfgFLNhCy2SSEeDnz/ZiAod2jf/T0v
         g8gSgc5AzzrH4zTllkJFczvHEQ3VwcgHq2dVo/lEcVm/LYP1eRFPxN6cLfQpr2r7WUtL
         CiRa+5OXc4b0OXeqrmqpe6baO4YC6lfcqSgz4M2cDr623g/8dnePh9Qc0ExNamLX7XDY
         pihmeJSI8TjiXHp4lDjvSmW2h+9mYIwOjePKsyKCmYEBoQE6ALi4YF+0M7CzQJWuiMZd
         oMxQ==
X-Gm-Message-State: APjAAAWUm7JmxIy1n4kAz9kyIUiiHUOq1lGJg1Go61DRrrD9We44K9R9
        iKlL76o0hLouFu7Ift+ZL0c=
X-Google-Smtp-Source: APXvYqzJkaXOd2S9tFS1YwsrbYf6LHJptNMJvnaCguAQYF+y8g+Yksu0dps9YX4mGiDyLjM3HCApKA==
X-Received: by 2002:a17:902:43:: with SMTP id 61mr19425725pla.145.1566826857867;
        Mon, 26 Aug 2019 06:40:57 -0700 (PDT)
Received: from localhost ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id p5sm13565558pfg.184.2019.08.26.06.40.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Aug 2019 06:40:57 -0700 (PDT)
Date:   Mon, 26 Aug 2019 15:40:42 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Eelco Chaudron <echaudro@redhat.com>,
        William Tu <u9012063@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net v3] ixgbe: fix double clean of tx descriptors with
 xdp
Message-ID: <20190826154042.00004bfc@gmail.com>
In-Reply-To: <20190822171237.20798-1-i.maximets@samsung.com>
References: <CGME20190822171243eucas1p12213f2239d6c36be515dade41ed7470b@eucas1p1.samsung.com>
        <20190822171237.20798-1-i.maximets@samsung.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 20:12:37 +0300
Ilya Maximets <i.maximets@samsung.com> wrote:

> Tx code doesn't clear the descriptors' status after cleaning.
> So, if the budget is larger than number of used elems in a ring, some
> descriptors will be accounted twice and xsk_umem_complete_tx will move
> prod_tail far beyond the prod_head breaking the completion queue ring.
> 
> Fix that by limiting the number of descriptors to clean by the number
> of used descriptors in the tx ring.
> 
> 'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
> 'ixgbe_xsk_clean_tx_ring()' since we're allowed to directly use
> 'next_to_clean' and 'next_to_use' indexes.
> 
> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
> 
> Version 3:
>   * Reverted some refactoring made for v2.
>   * Eliminated 'budget' for tx clean.
>   * prefetch returned.
> 
> Version 2:
>   * 'ixgbe_clean_xdp_tx_irq()' refactored to look more like
>     'ixgbe_xsk_clean_tx_ring()'.
> 
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 29 ++++++++------------
>  1 file changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index 6b609553329f..a3b6d8c89127 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -633,19 +633,17 @@ static void ixgbe_clean_xdp_tx_buffer(struct ixgbe_ring *tx_ring,
>  bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>  			    struct ixgbe_ring *tx_ring, int napi_budget)

While you're at it, can you please as well remove the 'napi_budget' argument?
It wasn't used at all even before your patch.

I'm jumping late in, but I was really wondering and hesitated with taking
part in discussion since the v1 of this patch - can you elaborate why simply
clearing the DD bit wasn't sufficient?

Maciej

>  {
> +	u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
>  	unsigned int total_packets = 0, total_bytes = 0;
> -	u32 i = tx_ring->next_to_clean, xsk_frames = 0;
> -	unsigned int budget = q_vector->tx.work_limit;
>  	struct xdp_umem *umem = tx_ring->xsk_umem;
>  	union ixgbe_adv_tx_desc *tx_desc;
>  	struct ixgbe_tx_buffer *tx_bi;
> -	bool xmit_done;
> +	u32 xsk_frames = 0;
>  
> -	tx_bi = &tx_ring->tx_buffer_info[i];
> -	tx_desc = IXGBE_TX_DESC(tx_ring, i);
> -	i -= tx_ring->count;
> +	tx_bi = &tx_ring->tx_buffer_info[ntc];
> +	tx_desc = IXGBE_TX_DESC(tx_ring, ntc);
>  
> -	do {
> +	while (ntc != ntu) {
>  		if (!(tx_desc->wb.status & cpu_to_le32(IXGBE_TXD_STAT_DD)))
>  			break;
>  
> @@ -661,22 +659,18 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>  
>  		tx_bi++;
>  		tx_desc++;
> -		i++;
> -		if (unlikely(!i)) {
> -			i -= tx_ring->count;
> +		ntc++;
> +		if (unlikely(ntc == tx_ring->count)) {
> +			ntc = 0;
>  			tx_bi = tx_ring->tx_buffer_info;
>  			tx_desc = IXGBE_TX_DESC(tx_ring, 0);
>  		}
>  
>  		/* issue prefetch for next Tx descriptor */
>  		prefetch(tx_desc);
> +	}
>  
> -		/* update budget accounting */
> -		budget--;
> -	} while (likely(budget));
> -
> -	i += tx_ring->count;
> -	tx_ring->next_to_clean = i;
> +	tx_ring->next_to_clean = ntc;
>  
>  	u64_stats_update_begin(&tx_ring->syncp);
>  	tx_ring->stats.bytes += total_bytes;
> @@ -688,8 +682,7 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>  	if (xsk_frames)
>  		xsk_umem_complete_tx(umem, xsk_frames);
>  
> -	xmit_done = ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
> -	return budget > 0 && xmit_done;
> +	return ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
>  }
>  
>  int ixgbe_xsk_async_xmit(struct net_device *dev, u32 qid)

