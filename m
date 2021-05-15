Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C28F381847
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 13:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhEOL0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 07:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhEOLZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 07:25:59 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56725C061573;
        Sat, 15 May 2021 04:24:44 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so951550wmb.3;
        Sat, 15 May 2021 04:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bU14fHIHUnQmqbfvV5/2/woszMKX/5IFYRur3lrpgBY=;
        b=DOqW1hs+I5pjLJsWTiaNu1nMAot4V4H/nQbV9ZpRWM2QtQwzah8trqCKxZDnZre+qx
         +c4AY7EdZhSr2dRCJbpZBtVLA5vp+6bqN5um91YJfK5ifas1rX85++cgSG2Oa9a1atg3
         Zeb3r55kzbRHzY+H4XXeMxP6VxNiQyZ2kAeq3d57mNpYRVQ7ngU2uqpcaSCAjQX53hid
         XjqQYAsdMZMNlxBGhafKCeYMb9QXyraOoLxBH6Hnev0p3BTE6QoKBPPt31Mna0CvW95T
         aRF+9b4RNljQyslNo+7W1XC88WjWpPg2V2iwUfbXMszjYIGeMDyj65Qoyi1y2RDKnPc8
         I+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bU14fHIHUnQmqbfvV5/2/woszMKX/5IFYRur3lrpgBY=;
        b=acNWNuERrow4hYzs90X0R4xwQVJMOBD8c9hFuEGFRYmNE5vn2hfolMwg5jjTZbpDnH
         l9dDnk0LtdscHr6Of59ik5f5M5qpTv6QPyAqmsCJdvhBPT+f1AdIlRRz6qHcVfjYfAK3
         BzzlpqVNrPwq0wRyFpHaROujMJl+Cvw0swOGi7sdReJbYbIQHWWM+xTlwGvG+yKys6XE
         +GrmTHc1607FIDqS8wM12Bh9WDOLUNfawrEC/mUxTkRduBUq2GWeGLH0+VsgNgHGbxCV
         LizcvfVT0sknF2eFdhJQTq5fzh27sEmtFte6eVSt6QQV9vK79EWKilx66d2LGBrg+9zA
         DtsQ==
X-Gm-Message-State: AOAM533/jppHROoywMC0m0O+7eGo7LyR7Woz8D1jTdwqZUP9w8b0PSNM
        xD7rDsfUCh9uyKKhXKe/kqs=
X-Google-Smtp-Source: ABdhPJx3TtOTxvnVKvShiGwxOu2lbL+8U/JNi9JV3BbgtgteS+WzXroswMvXOLrEpO1q/AYibd9SAw==
X-Received: by 2002:a1c:2645:: with SMTP id m66mr5078970wmm.145.1621077883146;
        Sat, 15 May 2021 04:24:43 -0700 (PDT)
Received: from [192.168.2.202] (p5487bcad.dip0.t-ipconnect.de. [84.135.188.173])
        by smtp.gmail.com with ESMTPSA id p2sm3570181wrj.10.2021.05.15.04.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 May 2021 04:24:42 -0700 (PDT)
Subject: Re: [BUG] Deadlock in _cfg80211_unregister_wdev()
To:     Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
References: <98392296-40ee-6300-369c-32e16cff3725@gmail.com>
 <57d41364f14ea660915b7afeebaa5912c4300541.camel@sipsolutions.net>
 <YJ81llg7EKFXUaIo@google.com>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <2dfd6cc1-c69e-c643-f2e9-5d95787b09b2@gmail.com>
Date:   Sat, 15 May 2021 13:24:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YJ81llg7EKFXUaIo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/21 4:44 AM, Brian Norris wrote:
> It would seem like _anyone_ that calls cfg80211_unregister_wdev() with
> an interface up will hit this -- not unique to mwifiex. In fact, apart
> from the fact that all his line numbers are wrong, Maximilian's original
> email points out exactly where the deadlock is.
> cfg80211_unregister_wdev() holds the wiphy lock, and the GOING_DOWN
> notification also tries to grab it.
> 
> It does happen that in many other paths, you've already ensured that you
> bring the interface down, so e.g., mac80211 drivers don't tend to hit
> this. But I wouldn't be surprised if a few other cfg80211 drivers hit
> this too.
> 
> The best solution I could figure was to do a similar lock dance done in
> nl80211_del_interface() -- close the netdev without holding the wiphy
> lock. I'll send out a patch shortly.

I believe that if we're going to fix that in the individual drivers,
there should be at least some sort of warning/documentation on
cfg80211_unregister_wdev().

Also someone might want to look at other WiFi drivers calling
cfg80211_unregister_wdev(). For example, I can see a locked call in the
brcm80211 driver, but no previous dev_close() call (see [1]). Haven't
looked in detail though, so I might just be wrong.

I can't help but think that this should maybe be addressed in that
common part instead. I know too little of that subsystem to tell if that
might be infeasible though.

Regards,
Max

[1]: https://elixir.bootlin.com/linux/v5.13-rc1/source/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c#L2445
