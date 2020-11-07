Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EF92AA49A
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgKGLSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:18:18 -0500
Received: from z5.mailgun.us ([104.130.96.5]:28087 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgKGLSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 06:18:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604747897; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=FrKUSxKaLyb3fOP1p83nc7xz/5CYAlq8tbYWJTFpOYM=; b=exuKBVaRcYPMbuyI4TXC41uqh7rqUDZhNKMHtzxZ4pZ9tmLWbr/uY45yo8cfRHEk898LHC9Y
 qkKA6huWqTuylDGTGzLdvTsUfndJKssoacSVUSPqtHsP1aAjGK0FLSF8P/kFyBYKMnFRi17s
 jp4E3P5X9CEnjuG9TdskFrf6kc8=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fa682787d4f16f92fc2edf5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 11:18:16
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3FD93C433F0; Sat,  7 Nov 2020 11:18:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8C58FC433C6;
        Sat,  7 Nov 2020 11:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8C58FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 08/11] ath9k: work around false-positive gcc warning
References: <20201026213040.3889546-1-arnd@kernel.org>
        <20201026213040.3889546-8-arnd@kernel.org>
        <87tuu7ohbo.fsf@codeaurora.org>
        <47b04bd1da38a2356546284eb3576156899965de.camel@sipsolutions.net>
Date:   Sat, 07 Nov 2020 13:18:10 +0200
In-Reply-To: <47b04bd1da38a2356546284eb3576156899965de.camel@sipsolutions.net>
        (Johannes Berg's message of "Mon, 02 Nov 2020 18:59:49 +0100")
Message-ID: <87tuu1fma5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2020-11-02 at 18:26 +0200, Kalle Valo wrote:
>> Arnd Bergmann <arnd@kernel.org> writes:
>> 
>> > From: Arnd Bergmann <arnd@arndb.de>
>> > 
>> > gcc-10 shows a false-positive warning with CONFIG_KASAN:
>> > 
>> > drivers/net/wireless/ath/ath9k/dynack.c: In function 'ath_dynack_sample_tx_ts':
>> > include/linux/etherdevice.h:290:14: warning: writing 4 bytes into a region of size 0 [-Wstringop-overflow=]
>> >   290 |  *(u32 *)dst = *(const u32 *)src;
>> >       |  ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
>> > 
>> > Until gcc is fixed, work around this by using memcpy() in place
>> > of ether_addr_copy(). Hopefully gcc-11 will not have this problem.
>> > 
>> > Link: https://godbolt.org/z/sab1MK
>> > Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> > ---
>> >  drivers/net/wireless/ath/ath9k/dynack.c | 6 ++++++
>> >  1 file changed, 6 insertions(+)
>> > 
>> > diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
>> > index fbeb4a739d32..e4eb96b26ca4 100644
>> > --- a/drivers/net/wireless/ath/ath9k/dynack.c
>> > +++ b/drivers/net/wireless/ath/ath9k/dynack.c
>> > @@ -247,8 +247,14 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
>> >  	ridx = ts->ts_rateindex;
>> >  
>> >  	da->st_rbf.ts[da->st_rbf.t_rb].tstamp = ts->ts_tstamp;
>> > +#if defined(CONFIG_KASAN) && (CONFIG_GCC_VERSION >= 100000) && (CONFIG_GCC_VERSION < 110000)
>> > +	/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490 */
>> > +	memcpy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1, ETH_ALEN);
>> > +	memcpy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2, ETH_ALEN);
>> > +#else
>> >  	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1);
>> >  	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2);
>> > +#endif
>> 
>> Isn't there a better way to handle this? I really would not want
>> checking for GCC versions become a common approach in drivers.
>> 
>> I even think that using memcpy() always is better than the ugly ifdef.
>
> If you put memcpy() always somebody will surely go and clean it up to
> use ether_addr_copy() soon ...

I can always add a comment and hope that the cleanup people read
comments :) I did that now in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=25cfc077bd7a798d1aa527ad2aa9932bb3284376

Does that look ok? I prefer that over the ifdef.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
