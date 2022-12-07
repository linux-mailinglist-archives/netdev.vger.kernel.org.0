Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78260645D36
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLGPDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiLGPDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:03:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E1261BBF
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670425319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yAFoepezIvCP3uAHr/BFfLPVvO1u5OHDj5w9FAPQ8+I=;
        b=fhnxpz3LdGeGiKVlROS+LnrqCB3iUqJfBN+WBDafA+aFZY9/tDBpTCLSyMHZP5/RwZzw7n
        K0ZgQxriQALAvU5V915f3F6n3KOi5UXN21saV7soMxm7I3X7bXF56dFDMuPh3IIn1vihr8
        m9k9vv95MGu0cnhwIi1EnOPnOOS0hoE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-jQqxX5BGOhyITA5oWd0ifw-1; Wed, 07 Dec 2022 10:01:58 -0500
X-MC-Unique: jQqxX5BGOhyITA5oWd0ifw-1
Received: by mail-wm1-f70.google.com with SMTP id a6-20020a05600c224600b003d1f3ed49adso701029wmm.4
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 07:01:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yAFoepezIvCP3uAHr/BFfLPVvO1u5OHDj5w9FAPQ8+I=;
        b=SoW0ap7Zt+eagAzXsoPapH9p89o5SSYyMhZRsymVGb8m5CwPnYhM60Ez1BUi8zcWO1
         fC2SFC8jrWYlNU62ZetaV+dqGeulg48qXL1Rlx/i3a4uDE+4rle8i07YcNwN2dHzCPvi
         9JvPBupVRg2jA+E+FJQ+ZY6yWN/RJQn/uDQmeMsJciCnoGd0tXAMYGRKd4dqTFOarMzi
         ean/JayJD3UJ6JamRWLhHiCXFXnQ4Xrzn77pqS8Nr39bqU/if9eje00pR1m3wDAem+gu
         jXPRlQlBAQ+PTGyhPU0P+6IK1D0yKY29gwSq8Wk8M4d39oAcyfTKCmLelr4ksyYvkz/O
         xgkg==
X-Gm-Message-State: ANoB5pnC6w93Ehl/XtBR9gh8g4SXGmgs8u3yOWiQLJJxqW/eQs0hM2Qn
        Dm2d247Gs/kYD0D0B6XuDRVFz7rJjuskCl5AKjk/jGlLwzZpPlnYjTy5QqI9q4sY7F3XRrMdtH9
        UmLWuJ4OTBkzcPI8D
X-Received: by 2002:a05:6000:137a:b0:242:5b1f:3dd0 with SMTP id q26-20020a056000137a00b002425b1f3dd0mr10163868wrz.633.1670425317214;
        Wed, 07 Dec 2022 07:01:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7WjIG9s5h6WW8iRE/Pz9BUs/TQH8zSEuM+9DqTqN/19T1vpGwnC7f+e6cMwuAEoG4IwzH/4A==
X-Received: by 2002:a05:6000:137a:b0:242:5b1f:3dd0 with SMTP id q26-20020a056000137a00b002425b1f3dd0mr10163852wrz.633.1670425316889;
        Wed, 07 Dec 2022 07:01:56 -0800 (PST)
Received: from redhat.com ([2.52.154.114])
        by smtp.gmail.com with ESMTPSA id e4-20020adff344000000b00236488f62d6sm20203849wrp.79.2022.12.07.07.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:01:56 -0800 (PST)
Date:   Wed, 7 Dec 2022 10:01:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] drivers/vhost/vhost: fix overflow checks in
 vhost_overflow
Message-ID: <20221207100028-mutt-send-email-mst@kernel.org>
References: <20221207134631.907221-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207134631.907221-1-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 04:46:31PM +0300, Daniil Tatianin wrote:
> The if statement would erroneously check for > ULONG_MAX, which could
> never evaluate to true. Check for equality instead.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

It can trigger on a 32 bit system. I'd also expect more analysis
of the code flow than "this can not trigger switch to a condition
that can" to accompany a patch.

> ---
>  drivers/vhost/vhost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..8df706e7bc6c 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -730,7 +730,7 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
>  /* Make sure 64 bit math will not overflow. */
>  static bool vhost_overflow(u64 uaddr, u64 size)
>  {
> -	if (uaddr > ULONG_MAX || size > ULONG_MAX)
> +	if (uaddr == ULONG_MAX || size == ULONG_MAX)
>  		return true;
>  
>  	if (!size)
> -- 
> 2.25.1

