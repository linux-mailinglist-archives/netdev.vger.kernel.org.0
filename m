Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34A0287CC2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgJHUBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:01:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729822AbgJHUBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602187261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N7ZjK4P1j2h8bXH0yXST1ACz87+diWlu/RJO8+yMMIg=;
        b=bxK79r1vP7LDirK5E9MB05lV91LHOJuqYy2a97gWoNqsqk+zBziRcXZaoxHubSNgdcmALg
        aEX/v6tY7luSzdEPBgJcsgYmAIMm+k+7Jb29h7SCf+Zu93n6Iz31nnt6nUuaUqOM385DPA
        OFTr/1EQRPOzgNPAxA+Rhw8GFSTIkPc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-92_ZoNteMlW4m2eis74d2g-1; Thu, 08 Oct 2020 16:00:58 -0400
X-MC-Unique: 92_ZoNteMlW4m2eis74d2g-1
Received: by mail-wm1-f71.google.com with SMTP id p17so3476584wmi.7
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N7ZjK4P1j2h8bXH0yXST1ACz87+diWlu/RJO8+yMMIg=;
        b=PujX1W8dTnNY5SKiVKhIkIFtMsdYLpSTszEgRLaZ3/dVPpUDy28hnlsfA/Xlt/lSMC
         rBlItMIGlFAYf7zdkv4kBFozYPpwvuCoQzrIre5dWZEtbvSgl6JC8K60QdmfG3dqjUH+
         j6ypDuQlcuYfSTLncWW69v4uxcmqkFj341Ocf/o/HyLEz/yCVSJh3IFtcBsznYfRUNT0
         OuZaIXhMbj+bc/t5y+Jn+WbKDCkL+sZKHWD9Uc0qJVx4lRtgPzd9j2sZKAUSmP0Av4eX
         DMQawf8OmuKfT84EawEaOzGZeHPmQyTuExt+CU1Tzi4Ta2603dWmCaO975V+FR6Pp1Cf
         oxVA==
X-Gm-Message-State: AOAM532FDFa+/USIewKcbtAndyFoDtOkFQlhyvcBjz8sR9pmuW/+yu6K
        cYdO9i6zYb+qW3HrpBSgm5Nn22IFWHSuS1mLZb5YpLRHC+U6Qbk6ingDErQIKP22qNMyaT3W054
        xyjzZkLLYNYLe2Cem
X-Received: by 2002:adf:8562:: with SMTP id 89mr10925394wrh.214.1602187256865;
        Thu, 08 Oct 2020 13:00:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWrfSGm9ixOxCPW8QdF5CAdI6tKiof9TUB2EwQFmEeCUUsDhhAjPVtVpxFRSxH/O9OPV7uVw==
X-Received: by 2002:adf:8562:: with SMTP id 89mr10925375wrh.214.1602187256545;
        Thu, 08 Oct 2020 13:00:56 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id w11sm8493631wrs.26.2020.10.08.13.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 13:00:55 -0700 (PDT)
Date:   Thu, 8 Oct 2020 16:00:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] vringh: fix __vringh_iov() when riov and wiov are
 different
Message-ID: <20201008160035-mutt-send-email-mst@kernel.org>
References: <20201008161311.114398-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008161311.114398-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 06:13:11PM +0200, Stefano Garzarella wrote:
> If riov and wiov are both defined and they point to different
> objects, only riov is initialized. If the wiov is not initialized
> by the caller, the function fails returning -EINVAL and printing
> "Readable desc 0x... after writable" error message.
> 
> Let's replace the 'else if' clause with 'if' to initialize both
> riov and wiov if they are not NULL.
> 
> As checkpatch pointed out, we also avoid crashing the kernel
> when riov and wiov are both NULL, replacing BUG() with WARN_ON()
> and returning -EINVAL.
> 
> Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Can you add more detail please? when does this trigger?

> ---
>  drivers/vhost/vringh.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index e059a9a47cdf..8bd8b403f087 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -284,13 +284,14 @@ __vringh_iov(struct vringh *vrh, u16 i,
>  	desc_max = vrh->vring.num;
>  	up_next = -1;
>  
> +	/* You must want something! */
> +	if (WARN_ON(!riov && !wiov))
> +		return -EINVAL;
> +
>  	if (riov)
>  		riov->i = riov->used = 0;
> -	else if (wiov)
> +	if (wiov)
>  		wiov->i = wiov->used = 0;
> -	else
> -		/* You must want something! */
> -		BUG();
>  
>  	for (;;) {
>  		void *addr;
> -- 
> 2.26.2

