Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8C2FCCCE
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfKNSIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:08:11 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:32953 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfKNSIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:08:11 -0500
Received: by mail-il1-f196.google.com with SMTP id m5so6215289ilq.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tyz2K0hJ7UpaKZAYvg7hXb4m9hDwm3mW76wd1dnCaL0=;
        b=cbhTuSiCfaM9YXnX6tFYpadmx13g0LxYclsqzCagxiSN50TVkIfNGKg+hXXWMTQrNf
         5qE2sjxUyRFtNVlrpv7mCb9N9ARYG0UrFe71HUwlpp5xLqZc672j6Ck42klTMsUvLO0h
         BpS8E/0Vf7WglA1sxSDZZyf6F0Mk2YAKzni/9JvR3U1s8weYxE0gwOIW17MH3Re7vF8i
         kXYDSV1coM/0/lmJJfwBd9AIWTQBQzMoiPFKY7W8Gvh+oIKXnRP6/d2xIqDweL9/XzqK
         bJakSHrnstX4WTCBq2L5BewTjRSVUF6g9xL8WbCsXfBk8UHQUsqMkLe7z7GGuuaMN7Zq
         cnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tyz2K0hJ7UpaKZAYvg7hXb4m9hDwm3mW76wd1dnCaL0=;
        b=KT+lw+H+unxd+sztF9ZrET3kpe66c0j9N2OqRQP2TsZTILNIMNig+Pbk8fRcuN3YoH
         HA4OuJ24uP9rpN58xtzPvOuUG7zoX/S4hZlyiToerOMR2JnGpPtbfFLyHommnT5E43rK
         lIesIrB6sP2nZEdskejycA6er+t2Ob2tNcLBH/KmvBn2WpHVMhSPGc0euuCctPCDHqVs
         dEglEWMwzjD8d004zgyJhpZfUNsBGR/j98Yih7ubJaVZrN2viokzUCTv1RkTK57fSQ9w
         KR7G8ifoxYAshRieOK1aCuLD5vFDkjoMrotUxZFGoCfjdMZyieMMSvpT7TF8IEfhMna9
         gxyA==
X-Gm-Message-State: APjAAAUAVTHYDBOeyrLiC7JRuRqexAzCSXbgIs3me7D8GJ/NPD+f0yxP
        4aIAUmI0UgXvbxwWXqzI94UsD9W9Qd6Z5larMBYnCCTJ
X-Google-Smtp-Source: APXvYqz9cTNWeJT5+iaEnoMSq4ciLoRZNX2oo9DPCrGv2Y0inlKfNMmKtbIl/Dby1cgfzkUM4GEx3WShcZyxo3IyNzU=
X-Received: by 2002:a92:5fc2:: with SMTP id i63mr10685574ill.218.1573754889909;
 Thu, 14 Nov 2019 10:08:09 -0800 (PST)
MIME-Version: 1.0
References: <20191114175209.205382-1-ppenkov.kernel@gmail.com>
In-Reply-To: <20191114175209.205382-1-ppenkov.kernel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 14 Nov 2019 10:07:58 -0800
Message-ID: <CANn89i+hUmHk4wmAGd1z+YFFnDaSViwap2n9gB411T_d9n9T8w@mail.gmail.com>
Subject: Re: [net-next] tun: fix data-race in gro_normal_list()
To:     Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Petar Penkov <ppenkov@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 9:52 AM Petar Penkov <ppenkov.kernel@gmail.com> wrote:
>
> From: Petar Penkov <ppenkov@google.com>
>
> There is a race in the TUN driver between napi_busy_loop and
> napi_gro_frags. This commit resolves the race by adding the NAPI struct
> via netif_tx_napi_add, instead of netif_napi_add, which disables polling
> for the NAPI struct.
>
> KCSAN reported:
> BUG: KCSAN: data-race in gro_normal_list.part.0 / napi_busy_loop
> Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
> Signed-off-by: Petar Penkov <ppenkov@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
