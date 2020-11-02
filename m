Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC7C2A2FC4
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgKBQ1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:27:19 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:10706 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgKBQ1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 11:27:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604334438; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=9EbglJUVZ4bi/re4PUXJJtXP6+9xKrG6cwTTB0fB9Nw=; b=bsWTPIn6ZN24lI+PI2s4pqugn4E17q1iZ7VyyhMpb/FuzSY0ZM+su2yRipLcgwysEsY1eVt3
 76SpOjbD2lkZ+dtwygS7VvhBqPKhTdDxSr67bXOOx465cVVawzHNIYwApqRJJBIMt9KQd9Of
 WIxiXRGhvVATxcEpHACcrT2yK/U=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fa033518646b0f26839e588 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Nov 2020 16:26:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5145AC433F0; Mon,  2 Nov 2020 16:26:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6CF09C433C9;
        Mon,  2 Nov 2020 16:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6CF09C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 08/11] ath9k: work around false-positive gcc warning
References: <20201026213040.3889546-1-arnd@kernel.org>
        <20201026213040.3889546-8-arnd@kernel.org>
Date:   Mon, 02 Nov 2020 18:26:51 +0200
In-Reply-To: <20201026213040.3889546-8-arnd@kernel.org> (Arnd Bergmann's
        message of "Mon, 26 Oct 2020 22:29:55 +0100")
Message-ID: <87tuu7ohbo.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> gcc-10 shows a false-positive warning with CONFIG_KASAN:
>
> drivers/net/wireless/ath/ath9k/dynack.c: In function 'ath_dynack_sample_tx_ts':
> include/linux/etherdevice.h:290:14: warning: writing 4 bytes into a region of size 0 [-Wstringop-overflow=]
>   290 |  *(u32 *)dst = *(const u32 *)src;
>       |  ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
>
> Until gcc is fixed, work around this by using memcpy() in place
> of ether_addr_copy(). Hopefully gcc-11 will not have this problem.
>
> Link: https://godbolt.org/z/sab1MK
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/ath/ath9k/dynack.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
> index fbeb4a739d32..e4eb96b26ca4 100644
> --- a/drivers/net/wireless/ath/ath9k/dynack.c
> +++ b/drivers/net/wireless/ath/ath9k/dynack.c
> @@ -247,8 +247,14 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
>  	ridx = ts->ts_rateindex;
>  
>  	da->st_rbf.ts[da->st_rbf.t_rb].tstamp = ts->ts_tstamp;
> +#if defined(CONFIG_KASAN) && (CONFIG_GCC_VERSION >= 100000) && (CONFIG_GCC_VERSION < 110000)
> +	/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490 */
> +	memcpy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1, ETH_ALEN);
> +	memcpy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2, ETH_ALEN);
> +#else
>  	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1);
>  	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2);
> +#endif

Isn't there a better way to handle this? I really would not want
checking for GCC versions become a common approach in drivers.

I even think that using memcpy() always is better than the ugly ifdef.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
