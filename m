Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5656484EDA
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 08:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiAEHtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 02:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbiAEHtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 02:49:35 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74078C061761;
        Tue,  4 Jan 2022 23:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=2szDbwiVK5KeG4XhY1ZLp/nsWXXU2FYHOQjt1VACpXA=;
        t=1641368974; x=1642578574; b=nPNEOhQZAhOaTuDcCtnoWCTKHDrxygYf2jF8TiuIg/nP7qJ
        K7pRoDllpdWdL2usU2cQWVrVyWgUIf+p5uIRu+/WPiSQIwTdc9/sZ9LuXsZlIxZPXVuQzUthVNp9n
        FjdsFZMHeauxJzrw2w+m5Wm8KeWfRMPhN2LTsqjWJ7+6vj9kQ6cUBWLwY62dC/ea9deoTYK3D0Noi
        8gAra6D5mDkbdNdyLB0OubhyEdu0dzOl7MDZOYFOXlRTTE46veYtgbGGt78eNz+SYkKYuVxtY0f6E
        NzPX0k6LkZdE3G92vZS1/EOdPPkRAbLVmDZhdIu0wVRd/yTnr5mcsKjh3DgP4h9A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1n512x-0025QK-Uv;
        Wed, 05 Jan 2022 08:49:24 +0100
Message-ID: <c6e52470551dc7802a36c5080c6c61a2ad625e7f.camel@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: mlme: check for null after calling kmemdup
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 05 Jan 2022 08:49:22 +0100
In-Reply-To: <20220105013308.2011586-1-jiasheng@iscas.ac.cn>
References: <20220105013308.2011586-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-01-05 at 09:33 +0800, Jiasheng Jiang wrote:
> As the possible failure of the alloc, the ifmgd->assoc_req_ies might be
> NULL pointer returned from kmemdup().
> Therefore it might be better to free the skb and return in order to fail
> the association, like ieee80211_assoc_success().
> 
> Fixes: 4d9ec73d2b78 ("cfg80211: Report Association Request frame IEs in association events")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
> v2: Change to fail the association if kmemdup returns NULL.
> ---
>  net/mac80211/mlme.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 9bed6464c5bd..b5dfdf953286 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1058,6 +1058,11 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
>  	pos = skb_tail_pointer(skb);
>  	kfree(ifmgd->assoc_req_ies);
>  	ifmgd->assoc_req_ies = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
> +	if (!ifmgd->assoc_req_ies) {
> +		dev_kfree_skb(skb);
> +		return;
> +	}
> 

That doesn't fail, that just doesn't send the frame and will then time
out later, not very useful?

johannes
