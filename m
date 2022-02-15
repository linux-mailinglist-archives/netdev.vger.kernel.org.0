Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7284B6046
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 02:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiBOBzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 20:55:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiBOBzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 20:55:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825AA140743;
        Mon, 14 Feb 2022 17:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C3WmD/u20vg/+pTaPesqbfH6xkJoCYNlH2hk1Ob7+ok=; b=k95U/c9IFGdG/9Uzm4uMOkdoQo
        Ygmr516ng6gU+tLTnm86LmwHGfje+I9P9MGyNJkQhK1FGUgRXzHLAqAdk+Eb4RnaG5Oeh5BMOaQrl
        ZWF7zx9e31uZZ/f5/bw49eVWMzPRIhfvYKR0zYUGey2VNccLJyBDvsFjuNHxY1Hi8xpYSd2YZpZF/
        /2UkC+sM/aRmaQcofqOZMddoux6ROhF9dfV4xnRdk5YiK2Af1dV5gM8VCNq36kG4+se8Q5hlHKNno
        0IiHGWb93EyC999i5VU7RwVC8wDJ8pHGj/dSFzJJpv6DIPRwFEhTFjJdLk6pxlQXuEjwCvdQDxXKK
        xjvfqFcw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJn3X-00HUe6-3U; Tue, 15 Feb 2022 01:55:03 +0000
Date:   Mon, 14 Feb 2022 17:55:03 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     davidcomponentone@gmail.com
Cc:     jirislaby@kernel.org, mickflemm@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] ath5k: use swap() to make code cleaner
Message-ID: <YgsH9/4LudqY0bqF@bombadil.infradead.org>
References: <2f993da5cb5d9fee93cedef852ca6eb2f9683ef0.1644839011.git.yang.guang5@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f993da5cb5d9fee93cedef852ca6eb2f9683ef0.1644839011.git.yang.guang5@zte.com.cn>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 08:51:50AM +0800, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> Signed-off-by: David Yang <davidcomponentone@gmail.com>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 00f9e347d414..7fa7ba4952db 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1562,16 +1562,13 @@ static s16
>  ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
>  {
>  	s16 sort[ATH5K_NF_CAL_HIST_MAX];
> -	s16 tmp;
>  	int i, j;
>  
>  	memcpy(sort, ah->ah_nfcal_hist.nfval, sizeof(sort));
>  	for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
>  		for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
>  			if (sort[j] > sort[j - 1]) {
> -				tmp = sort[j];
> -				sort[j] = sort[j - 1];
> -				sort[j - 1] = tmp;
> +				sort(sort[j], sort[j - 1]);
>  			}
> -- 


I see only sort, not swap above. 

  Luis
