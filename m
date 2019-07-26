Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC48B7699B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388892AbfGZNxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:53:12 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34302 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388284AbfGZNxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 09:53:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id k10so52705493qtq.1
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 06:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AG8g0/5+Esm5c3gfwUTGC7xBT2DUyGJWbBLEtSQE6Lo=;
        b=AtLhvXnrKCs8lMYMnz9aOAFh2heSHPwNUOPeZ8tQfpI29K8JAUWNKh44ISm9RlKSMP
         mxR4ml8DfgYJLCrPSEQ9l732QeVgfikXIGzRVY8pcJDGYDhOc/MiuNnVSh/yLFrGe6Tn
         fbtGnviDZVGnFREHGyg/9olhXMA/8ZpTOMIZsgVly28j+JOd3hShcQ6PLvN7I64y9E7P
         PxVqAtBO6GOcjtDKcJaKht7UEl1j9FyqeL/9kWf8sIzJRA+r3Jf7VS08w6HWMq3/rSzB
         JqOGaYDB5cJwN8VVjqDH7bbKjSIIDmfk+mbctJOA/HhVKr/VVWJHsfGa3LLWpOBWWgSg
         M29A==
X-Gm-Message-State: APjAAAX746WL7JNW7QYf5DygxC/xiP8/RmaCs1rUv2weUhmPo9ziSzaK
        KtOGv5bDVdpBZcwUuBunzgNjt/Y/kkHVGA==
X-Google-Smtp-Source: APXvYqydwEkRiDUhjkzyGjQfoaMf8JbYOCxKxauTFB3YoeZG49kK7ARiVn02SSH3ZF9H39y3z1BKaA==
X-Received: by 2002:a0c:b521:: with SMTP id d33mr68309462qve.239.1564149185035;
        Fri, 26 Jul 2019 06:53:05 -0700 (PDT)
Received: from redhat.com ([212.92.104.165])
        by smtp.gmail.com with ESMTPSA id v17sm30156688qtc.23.2019.07.26.06.53.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 06:53:04 -0700 (PDT)
Date:   Fri, 26 Jul 2019 09:52:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost: disable metadata prefetch optimization
Message-ID: <20190726095044-mutt-send-email-mst@kernel.org>
References: <20190726115021.7319-1-mst@redhat.com>
 <ccba99c1-7708-3e55-6fc9-7775415c77a8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccba99c1-7708-3e55-6fc9-7775415c77a8@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 07:57:25PM +0800, Jason Wang wrote:
> 
> On 2019/7/26 下午7:51, Michael S. Tsirkin wrote:
> > This seems to cause guest and host memory corruption.
> > Disable for now until we get a better handle on that.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > I put this in linux-next, we'll re-enable if we can fix
> > the outstanding issues in a short order.
> 
> 
> Btw, is this more suitable to e.g revert the
> 842aa64eddacd23adc6ecdbc69cb2030bec47122

Yes I did that too.

> and let syzbot fuzz more on the
> current code?

Current metadata direct access code is known to corrupt guest and host
memory - I don't feel we need more fuzzing.

> 
> I think we won't accept that patch eventually, so I suspect what syzbot
> reports today is a false positives.

Today's reports are real, it's a bug in my patch. But I reverted it -
the below is an easier way to make sure at least linux-next is stable
for everyone.

> 
> Thanks
> 
> 
> > 
> >   drivers/vhost/vhost.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 819296332913..42a8c2a13ab1 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -96,7 +96,7 @@ struct vhost_uaddr {
> >   };
> >   #if defined(CONFIG_MMU_NOTIFIER) && ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
> > -#define VHOST_ARCH_CAN_ACCEL_UACCESS 1
> > +#define VHOST_ARCH_CAN_ACCEL_UACCESS 0
> >   #else
> >   #define VHOST_ARCH_CAN_ACCEL_UACCESS 0
> >   #endif
