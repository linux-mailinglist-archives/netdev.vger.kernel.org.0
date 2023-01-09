Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1BE6620FC
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjAIJIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbjAIJHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:07:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF98D1AD96
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 01:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673254831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ciW9YYwTiwLOjY3s3cXAhwyZejxqMBoqkbNB9AuORqI=;
        b=GL5T2hJAMT6tm6J4LtCbIY1Dt8j3X9QpqEqscvLNPpc7sMyaUpC7oYPknKpLF8NdvvO/nM
        Chjfws+BNsFqCUoHfl6vuy7W6L/ZV4c65LpYPfSKqQq+b2ExLZO25KBDwCCRjt69yC2Zs+
        9R5Svk6rT/W7od4ArDGhVxIvjosMdBc=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-280-d532LJ3wPVGcg__T5dOQ4A-1; Mon, 09 Jan 2023 04:00:29 -0500
X-MC-Unique: d532LJ3wPVGcg__T5dOQ4A-1
Received: by mail-ot1-f71.google.com with SMTP id x26-20020a9d629a000000b0066ea531ed32so4094260otk.6
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 01:00:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ciW9YYwTiwLOjY3s3cXAhwyZejxqMBoqkbNB9AuORqI=;
        b=21Z7KjQF2LZsMayavKMNz3mRniw+MCiVPkc/i0mFaxU1+6uILkdm5HzNP1mBzNIeRT
         EfuUK5BpmPN/Kluyf45KuegmpR0jD56muLI2bnP9p1w+pZYD5fD+XBZbz8G8T5uBaBkf
         2zHn1zDWEVhcAbSvz9bNUp/gII4C6SAswE5qqjdr5czu+PoSOCC9oj+PCnBdvhR5N35g
         EkA/n2Nhj1fn2D0zTmeKwAkbmIn0NAt00TZXau2EXoLrAS5QShlyFlWDqJfm4T3PPafF
         AetRf3QEZ+WGKrAV/kpC2ZB4jG+XnfWt8Y7u/iUBMhNFkAx3JR/p61wCGLpt7v7oRrO3
         Kcbw==
X-Gm-Message-State: AFqh2kpg0Z0LiBIZvRMQCLR3WomOKVRuHmDvus4iUyiKD4Q1t6weWZ/W
        0t7GIRsfGCgfL7+apmy0Hxx17CFWzwF8bpBN5+lhNifI1CBZa6Ka+xXVZwmXpAGhnOEJf2vm/ad
        Xfv92vN7sBWVq37nUWYJZVZ+SFXMOXBTu
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id u19-20020a056870441300b00144a97b1ae2mr3397919oah.35.1673254829168;
        Mon, 09 Jan 2023 01:00:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs3r6xZeYmx2QyOOAm/OSF4k+rcH2P78FK/uye9bebpGs3wKFdyeXk7nf1guSipnglxm3zqQ43faxDfLHs0f1A=
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id
 u19-20020a056870441300b00144a97b1ae2mr3397915oah.35.1673254828989; Mon, 09
 Jan 2023 01:00:28 -0800 (PST)
MIME-Version: 1.0
References: <20230105070357.274-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20230105070357.274-1-liming.wu@jaguarmicro.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 9 Jan 2023 17:00:17 +0800
Message-ID: <CACGkMEtOAiV4v=-d1SA-wAVvD2WJyes3wWghpAJ9q0baG_aKGg@mail.gmail.com>
Subject: Re: [PATCH] vhost-test: remove meaningless debug info
To:     liming.wu@jaguarmicro.com
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 398776277@qq.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 5, 2023 at 3:04 PM <liming.wu@jaguarmicro.com> wrote:
>
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> remove printk as it is meaningless.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vhost/test.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index bc8e7fb1e635..42c955a5b211 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -333,13 +333,10 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
>                         return -EFAULT;
>                 return 0;
>         case VHOST_SET_FEATURES:
> -               printk(KERN_ERR "1\n");
>                 if (copy_from_user(&features, featurep, sizeof features))
>                         return -EFAULT;
> -               printk(KERN_ERR "2\n");
>                 if (features & ~VHOST_FEATURES)
>                         return -EOPNOTSUPP;
> -               printk(KERN_ERR "3\n");
>                 return vhost_test_set_features(n, features);
>         case VHOST_RESET_OWNER:
>                 return vhost_test_reset_owner(n);
> --
> 2.25.1
>

