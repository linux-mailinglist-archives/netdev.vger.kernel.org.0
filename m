Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD47738153F
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 04:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhEOCp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 22:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhEOCp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 22:45:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E935C06174A
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 19:44:43 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 69so301755plc.5
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 19:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fqlb9FJ9bvutrCLGYYm6pgevoaNctKxTi7Wniq8GfTk=;
        b=Rndg/eYVXv3WTa6K+Mkn/S8oeeRPLE/OfMbxJzt99ZVZexECAz+wU0Htm+LVORmtn+
         qdI9HQrNquAsE8f9EU1W229nNzXCIc9qkzfdRz5XsUMdielKgS85H5d1FjREfcS6X7Pz
         Kq97crapYnA0RldeTrjXJ/nErD0uqzfpVIEuE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fqlb9FJ9bvutrCLGYYm6pgevoaNctKxTi7Wniq8GfTk=;
        b=YpIBfvRowEYej3zgTihNZi7o/VxhfgaXT2t8fNxf8Qjyb+l8xrGvGyee7yCO+a/8St
         uzzubtQ3EJzbxvAt/boiNwcTphVHBbWPmyQTqPofRBxil97R1t4OZAqt1Pv8v86uWdFi
         sKo4fOpp5aJxFX7nup6IkfmmowXHrG7VTvVgmgC4rBdnljJK/uVIkdhEY91SM/sgDuRs
         aespn9ya7AeC5uRfyrQFWfcQ9vGjye4fHRBNPzpji+K2EDHB6iKGYU58/HUUo2On7N0x
         gyuP4AznuAaUvrNRzWj2tjqvQvbKZVoZecJBHaydBuZq9wMgvLJGqU5MdTMyN5f9DXCW
         jjig==
X-Gm-Message-State: AOAM532o14MRvyi1OrPR2c9zU5xi5fBFWb+Q/02YP7Er8/e2OLtjynTE
        /Eum1K7jE0mv0OlibnCJK7eJ0g==
X-Google-Smtp-Source: ABdhPJw9SD2Oc2h0pZvNgjprvbb7tC8z3cieKby+hdx554YnmYGjXaLptF7BivZUGWfOvR/mbYMBVQ==
X-Received: by 2002:a17:90a:20b:: with SMTP id c11mr54170278pjc.44.1621046681725;
        Fri, 14 May 2021 19:44:41 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:c853:454e:e506:af89])
        by smtp.gmail.com with ESMTPSA id n18sm4851574pfa.30.2021.05.14.19.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 19:44:41 -0700 (PDT)
Date:   Fri, 14 May 2021 19:44:38 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Subject: Re: [BUG] Deadlock in _cfg80211_unregister_wdev()
Message-ID: <YJ81llg7EKFXUaIo@google.com>
References: <98392296-40ee-6300-369c-32e16cff3725@gmail.com>
 <57d41364f14ea660915b7afeebaa5912c4300541.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57d41364f14ea660915b7afeebaa5912c4300541.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 10:26:25AM +0200, Johannes Berg wrote:
> If that's all not solving the issue then please try to resolve with gdb
> what line of code "cfg80211_netdev_notifier_call+0x12a" is, and please
> also clarify exactly what (upstream!) kernel you're using.

I can reproduce on v5.12 and v5.12.4 as well. With v5.12.4, I'm at:

net/wireless/core.c:
1428			wiphy_lock(&rdev->wiphy);
include/net/cfg80211.h:
5269		mutex_lock(&wiphy->mtx);


i.e.,

static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
					 unsigned long state, void *ptr)
{
...
	case NETDEV_GOING_DOWN:
		wiphy_lock(&rdev->wiphy);  <--- right here
		cfg80211_leave(rdev, wdev);
		wiphy_unlock(&rdev->wiphy);
...

It would seem like _anyone_ that calls cfg80211_unregister_wdev() with
an interface up will hit this -- not unique to mwifiex. In fact, apart
from the fact that all his line numbers are wrong, Maximilian's original
email points out exactly where the deadlock is.
cfg80211_unregister_wdev() holds the wiphy lock, and the GOING_DOWN
notification also tries to grab it.

It does happen that in many other paths, you've already ensured that you
bring the interface down, so e.g., mac80211 drivers don't tend to hit
this. But I wouldn't be surprised if a few other cfg80211 drivers hit
this too.

The best solution I could figure was to do a similar lock dance done in
nl80211_del_interface() -- close the netdev without holding the wiphy
lock. I'll send out a patch shortly.

Brian
