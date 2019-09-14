Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9976B2CB6
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 21:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbfINTir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 15:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731194AbfINTir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Sep 2019 15:38:47 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E1B65117D
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 19:38:47 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id z128so24707239qke.8
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 12:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KIGHcmUUN4jMJWs2R7tAQdbVbc2v6AIe7xkdq87Pa2A=;
        b=IsvXPPUnKCZ/vWFcVSwFlU0y7FQr4VVQqiPMpSabTzCCNCCiWLuoFKxbhmAwf3ZSep
         17/+kISl7lbuQnpaVEptrhJ5BLVWCwUX7E3KKKby0pr9cHlROPc7iEZQE3V/em4oQMiX
         dX7AJDdF6ClsSyM4wBTG52XwKPDt90vyHgjCCv2NkBne197C4wmZIfjdmqJMLCiZ+nbs
         cH0MTruDpF7TOTAqXjbT/d4+k/tbxDVEHHNNFy8xPaC2UEMQJufZnXceEXpYY6sM3kO3
         F6yegu8S3lUjzIVCLp0PTtFYMweHquU8e7j7JiRA3kuiOu8XFCjlKjjlKv+rXlZjpM9D
         aJ6w==
X-Gm-Message-State: APjAAAXMZbUwLjCD6qMDeCnPcAV/3LiSvxSliNuCtMwDZlGULgcx/uVr
        L42ucY/h6+gcATpkDB6ITUoVjmzWdvHOwCjUjMUTvY+XgCfutXTD28FZGUjyoL1f0NpEamXGJ1E
        A1X2Vzl52Yw2h4+oi
X-Received: by 2002:a05:620a:c:: with SMTP id j12mr49368892qki.127.1568489926543;
        Sat, 14 Sep 2019 12:38:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw7wOJHQxLUm66la0qX4SPSRkPiO4NywNevPf0TnyLpnxGz/aWmk5UQ6mtqxs1zvRBm/WQW7Q==
X-Received: by 2002:a05:620a:c:: with SMTP id j12mr49368877qki.127.1568489926312;
        Sat, 14 Sep 2019 12:38:46 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id 60sm15837153qta.77.2019.09.14.12.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 12:38:45 -0700 (PDT)
Date:   Sat, 14 Sep 2019 15:38:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] vhost: Fix compile time error
Message-ID: <20190914153325-mutt-send-email-mst@kernel.org>
References: <1568450697-16775-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568450697-16775-1-git-send-email-linux@roeck-us.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 01:44:57AM -0700, Guenter Roeck wrote:
> Building vhost on 32-bit targets results in the following error.
> 
> drivers/vhost/vhost.c: In function 'translate_desc':
> include/linux/compiler.h:549:38: error:
> 	call to '__compiletime_assert_1879' declared with attribute error:
> 	BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
> 
> Fixes: a89db445fbd7 ("vhost: block speculation of translated descriptors")
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>



> ---
>  drivers/vhost/vhost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index acabf20b069e..102a0c877007 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2074,7 +2074,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>  		_iov->iov_base = (void __user *)
>  			((unsigned long)node->userspace_addr +
>  			 array_index_nospec((unsigned long)(addr - node->start),
> -					    node->size));
> +					    (unsigned long)node->size));

Unfortunately this does not fix the case where size is actually 64 bit,
e.g. a single node with VA 0, size 2^32 is how
you cover the whole virtual address space.

this is not how qemu uses it, but it's valid.

I think it's best to just revert the patch for now.

>  		s += size;
>  		addr += size;
>  		++ret;
> -- 
> 2.7.4
