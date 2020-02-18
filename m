Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4E316297F
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBRPe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:34:56 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33794 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbgBRPez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 10:34:55 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A54F6B4008C;
        Tue, 18 Feb 2020 15:34:53 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 18 Feb
 2020 15:34:49 +0000
Subject: Re: [PATCH 6/8] net: sfc: use skb_list_walk_safe helper for gso
 segments
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <20200108215909.421487-1-Jason@zx2c4.com>
 <20200108215909.421487-7-Jason@zx2c4.com>
From:   Edward Cree <ecree@solarflare.com>
CC:     <netdev@vger.kernel.org>
Message-ID: <e1e06281-16e9-edb8-dcda-7bdcf60507a7@solarflare.com>
Date:   Tue, 18 Feb 2020 15:34:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200108215909.421487-7-Jason@zx2c4.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25238.003
X-TM-AS-Result: No-10.432700-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E+HYS4ybQtcOvZvT2zYoYOwC/ExpXrHizwmwE7sgPtN9vN+
        oA4oIb1d+cJJvHsDISaQZ93QmyD758c7x4DEI6P2D3uYMxd01benZS/aYgjrztjMMV3eZDNhyJN
        a6DYLgM2XUzspP39qoCexqzGrj/vqYlldA0POS1IaPMGCcVm9Dn/rg2QvIx03QW6eCaGxKwIx6L
        WUsNtDB/gReLkdnDE2z46ntczvww06k8DwKL1tBPRUId35VCIeJeZTqzmsW8WXBXaJoB9JZ4MbH
        85DUZXyseWplitmp0j6C0ePs7A07YFInLyeDAoZh2q4EPfW6DYO6g3LRQJgDrWOxQHHWoUsmMKe
        MkiDgaxt6nh0ne7HIQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.432700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25238.003
X-MDID: 1582040094-XvmolXkbj6q9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/01/2020 21:59, Jason A. Donenfeld wrote:
> This is a straight-forward conversion case for the new function, and
> while we're at it, we can remove a null write to skb->next by replacing
> it with skb_mark_not_on_list.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/net/ethernet/sfc/tx.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> index 00c1c4402451..547692b33b4d 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -473,12 +473,9 @@ static int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue,
>  	dev_consume_skb_any(skb);
>  	skb = segments;
>  
> -	while (skb) {
> -		next = skb->next;
> -		skb->next = NULL;
> -
> +	skb_list_walk_safe(skb, skb, next) {
Could this be replaced with
    skb_list_walk_safe(segments, skb, next) {
and elide the assignment just above?
Or is there some reason I'm missing not to do that?
-ed
> +		skb_mark_not_on_list(skb);
>  		efx_enqueue_skb(tx_queue, skb);
> -		skb = next;
>  	}
>  
>  	return 0;
