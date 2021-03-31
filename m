Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602D534F870
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 08:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhCaGAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 02:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbhCaGAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 02:00:36 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242D6C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 23:00:36 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id w8so19986265ybt.3
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 23:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yXcciB1dlGKg79VyAW3pRCuaucyV4qnEAW8KkQ5rZFE=;
        b=NZ3l34buCSDf7Dq2AXwyxDHpEYIvWcIck+cV3LD7ktZohD71qNNBfI2c9GXCkfvNMy
         3i+JkVkuS1NPFJBICXI2b2oX1yo9gDEILNhtRaVdqxXarU14R3fJVwN9IQ09rEKq60Nc
         gXfR7Shs+xBUIu99yE24r379auHUdKp0jROAk1bt8icV+U8dqYUJqzqUM0QW24hFgFnj
         e/O0eONGdZo77fMoHU1GqXJwISeYK5UZW88JGUdHuLL7dE8/Nf87Q9aejFkedX8vy3M3
         St19edyKNrWiWRZC2tb9PRL5gZKVHqlp4MeBJ0oGs3AwrNDNWCULHXxYQO3T2uNwuVxr
         om3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yXcciB1dlGKg79VyAW3pRCuaucyV4qnEAW8KkQ5rZFE=;
        b=aDa5HCBRwtQBXD/8qrZX5bVAo4KF1G7I81qwdpVFPB6C+Yl4b61GkcS7uq4cWTjr/4
         G/mmDAJl16Kv7G5woguq6Rkgr8Aoiza9Wf+R6F5m/wbOLFxRHt3d0vC6la2OXiZlDWbk
         SHwwEf47Ipf2Cd7JU7mPP4tBkZ137N3REFv1lKvqQ5QfpJwxbONt3WEsqKAYBdan2LkE
         D5FDtribFIGi+4ezB/mov3fa/cHWoyjKZSIyIjU2qVAvnVmVVqvfdUQvqLJ65qCsbFwq
         R25qkcIpcKCy7ad590lOggeBRYQ1YU2e27DHAhiUFOTxaPSN/Ycn5UGEo5sqOIo9Dce8
         siYg==
X-Gm-Message-State: AOAM531gFiEixa1FBZTZi/YV95XzPljH8zpIFWDZHCpw+yqboU9jbO87
        lIs8Y8myMjtaykTSxlSTGFPIeNrRAwUVajeRrWnWkg==
X-Google-Smtp-Source: ABdhPJysOcLyG8ZkzfyL/GURwwQtR+BrhDq3jYE3iLFzy0Lykx72H3SlYDvf9PMtJJzCUeXYPJAtlAsX3ctaVU9cA9o=
X-Received: by 2002:a25:850b:: with SMTP id w11mr2463814ybk.518.1617170435157;
 Tue, 30 Mar 2021 23:00:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210330064551.545964-1-eric.dumazet@gmail.com>
In-Reply-To: <20210330064551.545964-1-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Mar 2021 08:00:24 +0200
Message-ID: <CANn89i+YuMR6DuNk8YFZvHavxRCSNRp8MpC=rWz75N0CtN82DQ@mail.gmail.com>
Subject: Re: [PATCH net-next] ip6_tunnel: sit: proper dev_{hold|put} in
 ndo_[un]init methods
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 8:45 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Same reasons than for the previous commits :
> 6289a98f0817 ("sit: proper dev_{hold|put} in ndo_[un]init methods")
> 40cb881b5aaa ("ip6_vti: proper dev_{hold|put} in ndo_[un]init methods")
> 7f700334be9a ("ip6_gre: proper dev_{hold|put} in ndo_[un]init methods")
>
> After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
> a warning [1]
>
> Issue here is that:
>
> - all dev_put() should be paired with a corresponding prior dev_hold().
>
> - A driver doing a dev_put() in its ndo_uninit() MUST also
>   do a dev_hold() in its ndo_init(), only when ndo_init()
>   is returning 0.
>
> Otherwise, register_netdevice() would call ndo_uninit()
> in its error path and release a refcount too soon.
>
>

Note to David & Jakub

Can you merge this patch so that I can send my global fix for fallback
tunnels, with a correct Fixes: tag for this patch ?

Thanks !
