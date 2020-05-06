Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4531C7B47
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgEFUbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726218AbgEFUbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:31:22 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C494EC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 13:31:20 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id a9so2489696lfb.8
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 13:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ecFrdsjNx3e7UR2exDzGBa8XTVaEvRFZTajsWLF+MdE=;
        b=agkjCTRKlDk5+y4SSZPK++OgvwDr36+gIJPbK9+S4xX6dwnAx4Va94nsXOkQt5jrUm
         mbj3KfDSH4kNn6ginBXxvmI76VrkzICXV0Mjea/GgMSIsQdfyRwFP2YP9+Ov581yc65F
         RFa6SZFeiEVRMcOSkhzpb0JcUaZtY5oy2QkxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ecFrdsjNx3e7UR2exDzGBa8XTVaEvRFZTajsWLF+MdE=;
        b=afyneUuXprxcLTcKmUzb1Ih4F9fQLhJZGNHrfSH62ZNkUKUrOyywGRZ0C5x+hbctkV
         tg8MzeV79o0LtYGMXobIsYR/uDK7+FdD0b5+yqJcmDFUDt8dDcPpMy/ZUAqkzPUO01+X
         erJUnwbhC3P0JjU0tOKuzW/bFJ0cw+RLtzXQWCtLN2cWuk0rCJF8C00TPV440cM1npix
         2ZMAF3Nj5TTGIfKH/4kqezfbvwIqR+I89V4K8vBNs6URwQPbMslmPN0fuh3OsqIlS25s
         zgAN2FKgzSK/nHJQgD93FRgKAD6baK5txctuzHfpy8UKmTVhERE+JK67WzKipN9wzFTC
         bHcA==
X-Gm-Message-State: AGi0PuY4eGbirhDs4iNz7Qm82G/+hmndUefAsO2AEXOT5zt90qv6XrWV
        sdH6LtnhIgbntHeY9PRSVi8KrQ==
X-Google-Smtp-Source: APiQypIrSJFZtGqXAiAy+aFSkksRP7ylSGsSq1byIyitILkl4TBHYMAoa0pc3486By8c1OLRiwMYKA==
X-Received: by 2002:ac2:43b2:: with SMTP id t18mr6126075lfl.69.1588797078979;
        Wed, 06 May 2020 13:31:18 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l9sm1957126lje.57.2020.05.06.13.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 13:31:18 -0700 (PDT)
Subject: Re: [Patch net v2] net: fix a potential recursive NETDEV_FEAT_CHANGE
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
References: <20200506194613.18342-1-xiyou.wangcong@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <aa811b5e-9408-a078-59ea-2a20c9bff98f@cumulusnetworks.com>
Date:   Wed, 6 May 2020 23:31:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506194613.18342-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/05/2020 22:46, Cong Wang wrote:
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
> Fixes: 17b85d29e82c ("net/core: revert "net: fix __netdev_update_features return.." and add comment")
> Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
> Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Jann Horn <jannh@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---

The patch looks good, but note that __netdev_update_features() used to return -1
before the commit in the Fixes tag above (between 6cb6a27c45ce and 00ee59271777).
It only restored that behaviour.

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

