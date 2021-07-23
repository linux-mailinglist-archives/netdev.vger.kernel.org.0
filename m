Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D23D3793
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbhGWIiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhGWIiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:38:05 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3925EC061575;
        Fri, 23 Jul 2021 02:18:38 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so8077040pjb.0;
        Fri, 23 Jul 2021 02:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=diw0rjNO37BPZOtxmxuvgMZpNyIyBAENkoboIuvCn/A=;
        b=efHneWANLnX89nn22tEAJ0bYI7dwCgbSFM+VUXWclm+ksI4rIj0f1KyurjvUPQSUk9
         vywz1a5AAXjXJqEZANlwtoDoQi/8pJXdE10cr2cP8dYeAT/BAUejpIS1tYvgNxv4nrp+
         qaa1ZNP7hxSTh7SR4j0W2PKu9Wi38VPTBobRkb0x+voROBDkXrRIn6UtrY44T9FoS1aO
         +A8DFM+XMOmkWRrfNAVlwj/kn9a3Va1xzNql2oY5uJMzt0GYPBUOqXOV28HewzuFWGPC
         58Ewu/ZlQ6cpSZe6glB2303upR8IbZz/biOI+5YmFZbUC7USzRpqs0YguAFTtFmFfWlI
         RQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=diw0rjNO37BPZOtxmxuvgMZpNyIyBAENkoboIuvCn/A=;
        b=c7s4/bwli38zx9xYXyZ7wDkLiS7HHtTvgncgStJ4gcCqT9h975xk14+VrDtSA80EUb
         Gt4KgVrGOMROb9Xh5WwX9dvVCB4E+J1PnA8cIrn8obV2NJSr7oOCX4tUNcxjfN6r87gp
         U5FSvm+5fhRc+mqaWWhpW3HyOVqnlyFS3JZRHiNmUqJrKIl8h2cr4gkXpCinxA1JtsY9
         mrKs1Mena/WGTDJ1W0wcmyksSbgvNQrlC+ZGYlzFosMtEw5mBcZIbMQbl7daGM7OtP7t
         z3HXdn4lXzSEYeh8PQnBUhKQ6OTrzY/mHhuAkEpRTSArvZArnxSl/xq/TJ7eHNIWAd+F
         3COg==
X-Gm-Message-State: AOAM532KL2qpn4fVIAW1Gji+ddeq6Y9T9W1Daa09ylpmOFpRT6AR+aE2
        WIu33OFhKysH16/lDHfwwn4t8yV2ietAKBDIOH4=
X-Google-Smtp-Source: ABdhPJzOpBFhA8eXiv4Heec4cGp6G47KWY3HGOihIRQzKzA+d+QRA9QSbJYHA4GPXsQbrwXx80rZhw==
X-Received: by 2002:a65:615a:: with SMTP id o26mr4031609pgv.177.1627031917506;
        Fri, 23 Jul 2021 02:18:37 -0700 (PDT)
Received: from [10.12.169.24] (5e.8a.38a9.ip4.static.sl-reverse.com. [169.56.138.94])
        by smtp.gmail.com with ESMTPSA id x40sm33880795pfu.176.2021.07.23.02.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 02:18:37 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: free the object allocated in
 wiphy_apply_custom_regulatory
To:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>
Cc:     syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
From:   xiaoqiang zhao <zhaoxiaoqiang007@gmail.com>
Message-ID: <6fa2aecc-ab64-894d-77c2-0a19b524cc03@gmail.com>
Date:   Fri, 23 Jul 2021 17:18:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/7/23 13:09, Dongliang Mu 写道:
> The commit beee24695157 ("cfg80211: Save the regulatory domain when
> setting custom regulatory") forgets to free the newly allocated regd
> object.
> 
> Fix this by freeing the regd object in the error handling code and
> deletion function - mac80211_hwsim_del_radio.
> 
> Reported-by: syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com
> Fixes: beee24695157 ("cfg80211: Save the regulatory domain when setting custom regulatory")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index ffa894f7312a..20b870af6356 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -3404,6 +3404,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>  	debugfs_remove_recursive(data->debugfs);
>  	ieee80211_unregister_hw(data->hw);
>  failed_hw:
> +	if (param->regd)
> +		kfree_rcu(get_wiphy_regdom(data->hw->wiphy));
>  	device_release_driver(data->dev);

hw->wiphy->regd may be NULL if previous reg_copy_regd failed, so how about:
if (hw->wiphy->regd)
	rcu_free_regdom(get_wiphy_regdom(hw->wiphy))	

>  failed_bind:
>  	device_unregister(data->dev);
> @@ -3454,6 +3456,8 @@ static void mac80211_hwsim_del_radio(struct mac80211_hwsim_data *data,
>  {
>  	hwsim_mcast_del_radio(data->idx, hwname, info);
>  	debugfs_remove_recursive(data->debugfs);
> +	if (data->regd)
> +		kfree_rcu(get_wiphy_regdom(data->hw->wiphy));
this is not correct, because ieee80211_unregister_hw below will free
data->hw_wiphy->regd
>  	ieee80211_unregister_hw(data->hw);
>  	device_release_driver(data->dev);
>  	device_unregister(data->dev);
> 
