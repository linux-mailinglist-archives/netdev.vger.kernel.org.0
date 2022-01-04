Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364F1483BDA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 07:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiADGS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 01:18:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232933AbiADGS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 01:18:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641277106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yme3gthvDotqdj2BSsfSfVFe7NbjzfhJz1GZIqOQqEM=;
        b=QB4nXUVzfjG6YqP+lCa0hO/5TjCqdEyyrLEndxeqFAIQXTtEiRN+C96cpjI+HqOMDH4yux
        KRA+hk9H7mil39z1Ts5jcczCB2yjZMb4HDYdvXPkE1Uv4xg/kLj8HvDyfeQxdRHAvVGJ7y
        4Zgi0s8Rg5gp64lQjm7kceiboFcQMB8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-iTZ6IJ_VOGGzC8jwtVy6aA-1; Tue, 04 Jan 2022 01:18:25 -0500
X-MC-Unique: iTZ6IJ_VOGGzC8jwtVy6aA-1
Received: by mail-lf1-f69.google.com with SMTP id p19-20020a19f113000000b00425930cf042so7430730lfh.22
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 22:18:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yme3gthvDotqdj2BSsfSfVFe7NbjzfhJz1GZIqOQqEM=;
        b=G8aY8avxFJPPiD18vZuUCpGMc4GkFTOUbFBGVJDrtHxh+pCoRBsAMjCUoBiDLsv5Hd
         TrMCaJX7drTicrCpVwu392yOuEhthzwiNPKm+XqASPC8uHzO/TKrPGmBKe957wr9OX7u
         eJUPcCaqMjGy/o6sGwzrZjsud8cpf0iHmCpr4FXr0RrAHI7hGhFhGsJZfMyFhr+xAu4n
         E00udf6VcrokHBd/0PTc68lTGG/lUyguPlHg+ZEH/cnYWJClH8GCmEX7hnpvt1zoQy96
         +AfLmN+lOimIL+YP5BNAnb2oxZXEufJOLIWqYhsmCcQXQvFSY/ZrIDhLny5SoWcKNe6c
         0tuQ==
X-Gm-Message-State: AOAM530ACRoT4pouwi48HfO4IHTMH7Q07+ccLD5PIJKPb/LQD7SvrUOb
        HzyXvpN2YGHuYx3FHjywhXFeWzHO+wLuIitN/hYtIFpXLUOOLRxWak6m40OJWs4jzYIrvVts3iP
        Df2U9mJMZGsAM1XXpSPIU1Ozsp9epobJ4
X-Received: by 2002:a2e:8543:: with SMTP id u3mr34747342ljj.307.1641277104176;
        Mon, 03 Jan 2022 22:18:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdVkCgMnSgDfuPSVLPjfswxLwrUCNR4yJjqO1BySzqljdsSTjORg+r3nl0SUZygKiwSfOCt8RtgFoPS9zZDwA=
X-Received: by 2002:a2e:8543:: with SMTP id u3mr34747331ljj.307.1641277103953;
 Mon, 03 Jan 2022 22:18:23 -0800 (PST)
MIME-Version: 1.0
References: <20211228030924.3468439-1-xianting.tian@linux.alibaba.com> <8a7f84b6-8d63-0005-754b-cfd158c8952e@linux.alibaba.com>
In-Reply-To: <8a7f84b6-8d63-0005-754b-cfd158c8952e@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 4 Jan 2022 14:18:12 +0800
Message-ID: <CACGkMEsA+b_YSa7ASww7qDM3f-4q39qGEa0Gyu5qXTvTeW-odg@mail.gmail.com>
Subject: Re: [PATCH] vhost/test: fix memory leak of vhost virtqueues
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     mst <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 1:59 PM Xianting Tian
<xianting.tian@linux.alibaba.com> wrote:
>
> hi
>
> Could I get your comments for this patch?  it fixed the memleak issue.
>
> =E5=9C=A8 2021/12/28 =E4=B8=8A=E5=8D=8811:09, Xianting Tian =E5=86=99=E9=
=81=93:
> > We need free the vqs in .release(), which are allocated in .open().
> >
> > Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> > ---
> >   drivers/vhost/test.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > index a09dedc79..05740cba1 100644
> > --- a/drivers/vhost/test.c
> > +++ b/drivers/vhost/test.c
> > @@ -166,6 +166,7 @@ static int vhost_test_release(struct inode *inode, =
struct file *f)
> >       /* We do an extra flush before freeing memory,
> >        * since jobs can re-queue themselves. */
> >       vhost_test_flush(n);
> > +     kfree(n->dev.vqs);
> >       kfree(n);
> >       return 0;
> >   }
>

