Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5AA1C9B32
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgEGTfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEGTfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 15:35:52 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E1AC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 12:35:51 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id t11so5491314lfe.4
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 12:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HPlr9sD2Ll9EpKLHu8EjB8MDTy97Lj8XEY2HdhdY0EU=;
        b=ZbLwYw0eulobzQcQKKwcIaJmWnD4MCQ+Op/ELdLK9vRkfZi4v1evd8jS9wtRZdWxNq
         86eGs9ZHvz9euWxbh8SuX6fABcAXK1Wrheq4MfObQKN2tN5kjeyy+sm3+2H/TmEU3skn
         GKCdu3W7Q1WKuzVSJDlo1Pr+EzUHB2EzMPz0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HPlr9sD2Ll9EpKLHu8EjB8MDTy97Lj8XEY2HdhdY0EU=;
        b=suPoFI6XW+VjQfdXKvu/K+elSBgm5Fw2598jz0dwSXR1QQcYWT82haCImJL7ft1Qg4
         aN9kjZ0jwnJ9q0Dlxsv+pnQIwG4dXnkjTCwsl1cnqNVXjS6/EAGxzmt5o+dTBPl3U7CK
         PoI28ArHBsOarMVzqRb8ca6EcOjjYUPFirAVpgmQCXYTS0dHlFgMdtQIjVGbezY66X8T
         WvbWiQQjB0NZGvsyZnB+kSoIBkConr6w0EyGYiRd3k1xhT6rhZ8pY3o5m9A+wF/lqH02
         9d3UQZRSxBdO1bGUqFl8yk0ITqucgNAN6LxachZvwAtKqPd/ZHd6cysIvl+B/mpEeWJC
         KWMA==
X-Gm-Message-State: AGi0PubkI32C+vcWhY0dxKu8dbAm4qnPfiqwCHCkVYpcdjtUii+RIqrX
        zKBAODjhpROa36gXtqNUCmgcHw==
X-Google-Smtp-Source: APiQypK1G7eBHv6bEd/Mn/OKM5ZWiktNd/ga052MYJ/8BQU+UsDbajBhXIggLYIRA/D2ni2gdnJtFg==
X-Received: by 2002:ac2:5f73:: with SMTP id c19mr9663846lfc.135.1588880149594;
        Thu, 07 May 2020 12:35:49 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 134sm2974057lfj.20.2020.05.07.12.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 12:35:48 -0700 (PDT)
Subject: Re: [Patch net v3] net: fix a potential recursive NETDEV_FEAT_CHANGE
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jann Horn <jannh@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <20200507191903.4090-1-xiyou.wangcong@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <953527d0-6b77-960d-47b9-cbbb136c902d@cumulusnetworks.com>
Date:   Thu, 7 May 2020 22:35:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507191903.4090-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2020 22:19, Cong Wang wrote:
> syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
> between bonding master and slave. I managed to find a reproducer
> for this:
> 
>   ip li set bond0 up
>   ifenslave bond0 eth0
>   brctl addbr br0
>   ethtool -K eth0 lro off
>   brctl addif br0 bond0
>   ip li set br0 up
> 
> When a NETDEV_FEAT_CHANGE event is triggered on a bonding slave,
> it captures this and calls bond_compute_features() to fixup its
> master's and other slaves' features. However, when syncing with
> its lower devices by netdev_sync_lower_features() this event is
> triggered again on slaves when the LRO feature fails to change,
> so it goes back and forth recursively until the kernel stack is
> exhausted.
> 
> Commit 17b85d29e82c intentionally lets __netdev_update_features()
> return -1 for such a failure case, so we have to just rely on
> the existing check inside netdev_sync_lower_features() and skip
> NETDEV_FEAT_CHANGE event only for this specific failure case.
> 
> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
> Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
> Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
> Cc: Jarod Wilson <jarod@redhat.com>
> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jann Horn <jannh@google.com>
> Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/core/dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 522288177bbd..6d327b7aa813 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8907,11 +8907,13 @@ static void netdev_sync_lower_features(struct net_device *upper,
>  			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
>  				   &feature, lower->name);
>  			lower->wanted_features &= ~feature;
> -			netdev_update_features(lower);
> +			__netdev_update_features(lower);
>  
>  			if (unlikely(lower->features & feature))
>  				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
>  					    &feature, lower->name);
> +			else
> +				netdev_features_change(lower);
>  		}
>  	}
>  }
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

