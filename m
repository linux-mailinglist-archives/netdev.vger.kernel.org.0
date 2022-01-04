Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE77C4842EE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiADOAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiADOAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:00:50 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8CEC061761;
        Tue,  4 Jan 2022 06:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=73qDrcF8HJ4n4L/Q4Low3qdhLg9wrOxB8G80OyB209Y=;
        t=1641304849; x=1642514449; b=tIfuhmk3ZnN0Cc5QG/CmhRQU2WDkeEThC2ZlZM9U6CA5Oe/
        0Ye4X+TtwCOj5cj9SfbDQFbUAwCnpHDFb1pKqmsb+WS4a25XrdRs3A8pL+kWgjR2+bz9SBr9ocmLK
        wQHZyuk3ct/cZVyCETvVZr14wWaPvQlWQwDS6dzm3MGK1LAC0YYlpZLoWyXiZFG1XRwtoTf1AE3Ut
        LsDBR0PO4fg10wJ3b5kMpvhUycBG4hyLNUWlzuVzxVYFQGMigpW9rcFwaXkDDQEG55bNzJ6QxkqAL
        0nS5dDPu1vW14/abPcCYXfZyYt0M+aRbApaFvm0zjotzgeghfRlDeTjAchoXQAwA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1n4kMi-001m4D-HF;
        Tue, 04 Jan 2022 15:00:40 +0100
Message-ID: <b0bdc3b69e955197d6e756e98099a9a438cb64cc.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: mlme: check for null after calling kmemdup
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 04 Jan 2022 15:00:39 +0100
In-Reply-To: <20211231100311.1964437-1-jiasheng@iscas.ac.cn>
References: <20211231100311.1964437-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-12-31 at 18:03 +0800, Jiasheng Jiang wrote:
> As the possible failure of the alloc, the ifmgd->assoc_req_ies might be
> NULL pointer and will be used by cfg80211_rx_assoc_resp() with the wrong
> length.
> Therefore it might be better to set length to 0 if fails as same as
> ieee80211_mgd_stop().
> 

That feels a bit vague, and indeed I cannot find any place that would
actually dereference the pointer if it's NULL?

Still maybe a good as a cleanup.

> Fixes: 4d9ec73d2b78 ("cfg80211: Report Association Request frame IEs in association events")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  net/mac80211/mlme.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 9bed6464c5bd..258b492c699c 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1058,7 +1058,10 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
>  	pos = skb_tail_pointer(skb);
>  	kfree(ifmgd->assoc_req_ies);
>  	ifmgd->assoc_req_ies = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
> -	ifmgd->assoc_req_ies_len = pos - ie_start;
> +	if (!ifmgd->assoc_req_ies)
> +		ifmgd->assoc_req_ies_len = 0;
> +	else
> +		ifmgd->assoc_req_ies_len = pos - ie_start;
> 

But it seems it would be better to actually fail the association in this
case? There's a reason we're reporting this, so that we can see
HT/VHT/..., and I'm sure that will be necessary in many cases.

johannes
