Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D79B3D5025
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 23:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhGYUz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 16:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhGYUzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 16:55:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A0FC061757;
        Sun, 25 Jul 2021 14:36:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x14so3154772edr.12;
        Sun, 25 Jul 2021 14:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BaU+N0BfuToMVHnQxHJcdw1g5XT9u+x4MA4dw2dsg6w=;
        b=L4HSFfOaxMtA+pdF7zh7PH4vjhZ0Mmw7PiMvF6TtxfVhWSipsc8KPw2YgUZKHcUeTl
         7/nYv/1Qt9x5ezOKc7pF0rCgsw9MNAvHuBDucH8No1bYEj36u0JchxlLxLCKkM5mc0gW
         ZnGVM0Jpylcn74QC2QbaiKtaZVon7z90pDZb2riWAXFURz3mQL3Te2x1WwmxDQWAel3r
         dx+mUKI56CG6oCXYl1HeC+YIBqp6EeALW4wyxc4v8oLT1sbucVYBQhYc3lF22X0id4ZP
         ybAMyrXAhMdJCBHUCuPS9mImPe4RMA0neyHHD5ZpXfqC7JQhf7rAa2plFnT1UU2A4cNJ
         en6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BaU+N0BfuToMVHnQxHJcdw1g5XT9u+x4MA4dw2dsg6w=;
        b=UtOMV00qaHBB5Uz65u8Z0+iJGiKkI+AGMtDVS9K0AHzbJRTXpvhiPHUi9u0mgP7fZ/
         KL7LKLnp0T4D9eMxzDtyIYzz1aKrwtsJcGoICsN8Ndq5iFUNauilLlMOm4oktww6DaVR
         mEpph6KtCU5O6pk45GvRPovRBXNl8d7PuleeETLYIpbbrXhj2F8FEDI/f0N3GMh9am6P
         ZH1D1RR0BWotetPQMwj69TpNIubp3rBPB38pxGigRH7Sq6Zz3Sbfz3W41o4O2EFBIW3o
         Nzp2ApIGZdxDwJwqKvLJ3Vx6gS9T4olVbQub9vjVxC/Oz4ReuOocmbwSpQf7v2afGH62
         F4eA==
X-Gm-Message-State: AOAM530XLeAZs/vZVy789/EL3m0gkFPIpHyNGDgNyjcHaUa4nJce4tpd
        RueJgYasJA0aqeEi5K5xVZE4EnJla39uDyK8x9Q=
X-Google-Smtp-Source: ABdhPJw8yetmtnh4PgMNKWMDRgBgW6N2HsYtGLPuEvOBbU1oj6RsHlMK0dcTs8o2FcBDKpuf+HxbqxyUlr2SO2mx5CQ=
X-Received: by 2002:a50:fb04:: with SMTP id d4mr17730527edq.143.1627248983956;
 Sun, 25 Jul 2021 14:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
 <20210717204057.67495-6-martin.blumenstingl@googlemail.com> <1a299cd8c1be4fba8360780ef6f70f0f@realtek.com>
In-Reply-To: <1a299cd8c1be4fba8360780ef6f70f0f@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 25 Jul 2021 23:36:13 +0200
Message-ID: <CAFBinCAJNqbpoqSSFYYBJg818KHCKx5nFzsKZdR=D+sTXQj6dg@mail.gmail.com>
Subject: Re: [PATCH RFC v1 5/7] rtw88: Configure the registers from
 rtw_bf_assoc() outside the RCU lock
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke,

On Mon, Jul 19, 2021 at 7:47 AM Pkshih <pkshih@realtek.com> wrote:
[...]
> The rcu_read_lock() in this function is used to access ieee80211_find_sta() and protect 'sta'.
> A simple way is to shrink the critical section, like:
>
>         rcu_read_lock();
>
>         sta = ieee80211_find_sta(vif, bssid);
>         if (!sta) {
>                 rtw_warn(rtwdev, "failed to find station entry for bss %pM\n",
>                          bssid);
>                 rcu_read_unlock();
>         }
>
>         vht_cap = &sta->vht_cap;
>
>         rcu_read_unlock();
I agree that reducing the amount of code under the lock will help my
use-case as well
in your code-example I am wondering if we should change
  struct ieee80211_sta_vht_cap *vht_cap;
  vht_cap = &sta->vht_cap;
to
  struct ieee80211_sta_vht_cap vht_cap;
  vht_cap = sta->vht_cap;

My thinking is that ieee80211_sta may be freed in parallel to this code running.
If that cannot happen then your code will be fine.

So I am hoping that you can also share your thoughts on this one.


Thank you and best regards,
Martin
