Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503973BF619
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhGHHRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhGHHRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 03:17:30 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3236C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 00:14:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id s129so7415735ybf.3
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 00:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KYDWOG3dkMgtX/f8MCypuLl2gSc01xMgtCmbx0p223w=;
        b=pJ5cjEyY/NZNcLF6T3q3Tg5mdDTd6oY8HdgKig/Kj4YH6RUJXa/71XGtHH6UEInRLe
         Y2TYnOKzei/YbpGkrWXAgd14/0lvxRZJnAHBWDqvVudeeh177n7YqgdZNHnHUiNZLQNM
         qXtVYbPOfJVFbXVEYbG9fZEvSLlJ7VPNyxRKEKNcnG0AppFU1bd//zfrhsrTq8zNJGt/
         hHyRpH1wQfZLrpzZadfdXH+6Jc6TPgbTsMRP1l8IFoalCGAgCC10ifSPnxdsK10oKvOb
         9VQ9nFgYuKYeDYQLoeYiU7GZjRS+LBrWlRgiuN17CqXERU0H0oceplyfyhxoS0QBwZiK
         if1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KYDWOG3dkMgtX/f8MCypuLl2gSc01xMgtCmbx0p223w=;
        b=BBcubzVvPv1VO4wok+hVn6QycNi/BooyS/1dmwpy4nBPewYdVeoAN5K16i2RG+AaeH
         XQCEYWvgnnAMEj5ZhB2yRzdT6kyWddSiGj7cSrm6urgD5grIwekmigrs3oPEBXuqAnp2
         uWGNVQhmf34DraER52VRmJUcrlKMREZk96bgQR4vSjsYXym6/LrjO/XpVrk73sZs4vZQ
         TBaNS1vTJ7sWJ7aL/AtYdTJ5HmGrVnCV7dTpMJnG0/VXmH7nt/tM2omNBsuX9ra2HLES
         jmlQZVW6gJFCxSP8X1gHCljkzJ/19VlFs7ZgVw6qj4qWZHAD/bPws0xpg1lQ7oLIq2iE
         gK6A==
X-Gm-Message-State: AOAM533TwCRs4y3OL7J5hm93HzTsvYpaVDuuzheblRLjv1h+plNp61vo
        hPdh7auQIa7Lo3b1d2zfrinhyMkGhHaBHv0gdJgYlzV+Y5I=
X-Google-Smtp-Source: ABdhPJxDsJgtvLR6gu2FPnS3m/jE19Dz9UsK9beIsTVHEWxvhEGqsMgH9L3ll3TFOH9ZefkDBK0sBMowXLtzDUEd4m8=
X-Received: by 2002:a25:bec2:: with SMTP id k2mr38209048ybm.234.1625728487747;
 Thu, 08 Jul 2021 00:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210708065001.1150422-1-eric.dumazet@gmail.com> <20210708.001318.1836277281789484963.davem@davemloft.net>
In-Reply-To: <20210708.001318.1836277281789484963.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Jul 2021 09:14:36 +0200
Message-ID: <CANn89iKGNEJq-wngZzQkYiaWTjWAKh04v8LtV23CauOHhwS5zg@mail.gmail.com>
Subject: Re: [PATCH v2 net] ipv6: tcp: drop silly ICMPv6 packet too big messages
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 9:13 AM David Miller <davem@davemloft.net> wrote:
>
> tcp_mtu_to_mss needs to be exported

Arg, right you are.

Thanks !
