Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389605846C6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiG1UEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiG1UEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:04:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 612397647A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659038659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQLnq+worBZxlDN3OYzyNr7eSx33Wdw0DnSni4EUIHo=;
        b=dwvFc3COBUtYwEWE+/nOTBT7p+b4VykqUmTeqxZXrWSF3m8KZbk/SW+Nvx6YfWh0aD+UNa
        or/uVA4QEyoZBTPBfISoDU6W6P9VzhNDxfMhnVeuAbbQgPQ+20/Ce8PzYXGHw8PFcGh/eZ
        3ncwxbkcYatwRNxtIXaqX8WOyUTlmTM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-0dLkJxe1Nce_qBPrVWwGGg-1; Thu, 28 Jul 2022 16:04:17 -0400
X-MC-Unique: 0dLkJxe1Nce_qBPrVWwGGg-1
Received: by mail-wm1-f71.google.com with SMTP id ay19-20020a05600c1e1300b003a315c2c1c0so2905967wmb.7
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=RQLnq+worBZxlDN3OYzyNr7eSx33Wdw0DnSni4EUIHo=;
        b=yYX6ex+XEvbXEZwB4/bCadvwnGYSsnRQVHjDa6Zny0YusEsNcXOCbI2+Tw5hE43iqL
         oljIOIGukN98lVpnyN8IPOWitMABs2c3hSeCKDeT6wEHVyYHXXxtoyZumGXOVqsxjIBx
         Bmypxi1mKtF9KdMKRnCC4dM7WkrAiPTiFKeumsH/RE7vF9z00GG3e9M3UCJePX9fa4Ix
         pY1IVm8EBMq5adK/DkutjakX51BAU6IlnFL/yzAWejKt0iK8x5o1BBOl1zCNl219h+lV
         6GpMYI2irKjGLDEJhFyJy51F3l1wlsF6lFn/kLJyl3FUlndrvpLMSCErwak+e40kEg/H
         n4Cg==
X-Gm-Message-State: AJIora+04VKJwRUjAfBmnLZQE4ITW280MPoG7HMJeXZ/+l6B0ULhp+Hh
        pS4FpDfe8wgo5NolCLCToPyKDjg4FUhPHV30TrcU/MUe/lrKPXyeEhGOLD4iN7pvpnnHihA9O+2
        OeKxlf0ygKfiv1A6h
X-Received: by 2002:a1c:7c0d:0:b0:3a3:5e3f:497e with SMTP id x13-20020a1c7c0d000000b003a35e3f497emr610226wmc.135.1659038656244;
        Thu, 28 Jul 2022 13:04:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vBs0yJGIS/HtA02tBgvXgZfProACwicE3Eh+ZcOHa3n3b0v1Bp2c7t4LrMXHM7ltY6q6o7tQ==
X-Received: by 2002:a1c:7c0d:0:b0:3a3:5e3f:497e with SMTP id x13-20020a1c7c0d000000b003a35e3f497emr610208wmc.135.1659038655931;
        Thu, 28 Jul 2022 13:04:15 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id f4-20020a1c6a04000000b0039c96b97359sm2121189wmc.37.2022.07.28.13.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 13:04:15 -0700 (PDT)
Message-ID: <0daf062cb59776a19b142eeb48b46db0878cc353.camel@redhat.com>
Subject: Re: [PATCH net-next 2/4] tls: rx: don't consider sock_rcvtimeo()
 cumulative
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru
Date:   Thu, 28 Jul 2022 22:04:13 +0200
In-Reply-To: <20220728084244.7c654a6e@kernel.org>
References: <20220727031524.358216-1-kuba@kernel.org>
         <20220727031524.358216-3-kuba@kernel.org>
         <e70b924a0a2ef69c4744a23862258ebb23b60907.camel@redhat.com>
         <20220728084244.7c654a6e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-07-28 at 08:42 -0700, Jakub Kicinski wrote:
> On Thu, 28 Jul 2022 15:50:03 +0200 Paolo Abeni wrote:
> > I have a possibly dumb question: this patch seems to introduce a change
> > of behavior (timeo re-arming after every progress vs a comulative one),
> > while re-reading the thread linked above it I (mis?)understand that the
> > timeo re-arming is the current behavior?
> > 
> > Could you please clarify/help me understand this better?
> 
> There're two places we use timeo - waiting for the exclusive reader 
> lock and waiting for data. Currently (net-next as of now) we behave
> cumulatively in the former and re-arm in the latter.

I see it now, thanks for the pointers.
> 
> That's to say if we have a timeo of 50ms, and spend 10ms on the lock,
> the wait for each new data record must be shorter than 40ms.
> 
> Does that make more sense?

Yes.

For the records, I feared a change of behavior that could break
existing user-space applications expecting/dependending on blocking
recvmsg() completing in ~timeo (yep, modulo timer precision - which is
reasonably good for "short" timers), but it looks like there is no
actual overall behaviour change.

So I'm fine with this patch.

Thanks!

Paolo

