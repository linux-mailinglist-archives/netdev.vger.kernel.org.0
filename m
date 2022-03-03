Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CE44CBF4E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 14:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiCCOAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiCCOAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:00:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27959B3E54
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 05:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646315993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EPzzRx3cg/pmzHstqnOsA2Fg9HW56H+MJYqezSg++LE=;
        b=ascQCdwo+OtH4RzhaDb5p2gIlUNrfHRczuhjVbs8+iSLP96TpGNv+BOsVTsUz8ylvD2C2x
        +IQJvCBkvplTqUGL8CvvDm4oh+w5mLxYRghH79317uT7Oqg8vobGOKS8f/QPLUxTLxmETQ
        NYLUgZ0Wyo1tHy++47deiCuXtX6k9/U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-JwcDfa6WM4eOwor95VQepA-1; Thu, 03 Mar 2022 08:59:51 -0500
X-MC-Unique: JwcDfa6WM4eOwor95VQepA-1
Received: by mail-ej1-f71.google.com with SMTP id sa7-20020a170906eda700b006d1b130d65bso2753921ejb.13
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 05:59:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EPzzRx3cg/pmzHstqnOsA2Fg9HW56H+MJYqezSg++LE=;
        b=N4bfF4HVxVF+4qRt3nxVKTPUYOB/IFN5TRsyHAMVqpmiTh4Gca6HsYNrDtUaVoj4de
         fEXxWTss80IOeC+CyrmYbecRY7N1JjpxKwqbolf43sC7mtPz7tpsZFIcWv5MuD/kKkYT
         EADukFZfwAsVt9r3Fr1YvwXIGHn2PAP9XCpIryMx4eohTfMWk1AwLbviyca+NDoUH5NX
         /L/fW8F77DviMQzKNDFlJgy1oebEH0X8QX3XbBsNIs0ALaLUmWZPjC2NNd5b+rn71xJF
         Q33pJav8IahDMP6XnGrOeGYHL5l4JSWd7Jnitv+OiDFAXzlfdSZi6A8DlUqHqh4+y5dI
         GCcA==
X-Gm-Message-State: AOAM533ctcGEOVIp9x964dA97P9N0gXJIzUeoD1wRHk68QLtSJkKMqZD
        yUGeAk5X3O3j17Am0d+LwigxaRbjs1gNh6lR1OkbW7jb00GLkojPI27taFC8euZ3u70BGFiq4hY
        +CULDrPFgLNHeeWKl
X-Received: by 2002:a17:906:5d0e:b0:6da:97a8:95bd with SMTP id g14-20020a1709065d0e00b006da97a895bdmr1380845ejt.442.1646315990028;
        Thu, 03 Mar 2022 05:59:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPnR2SJt5wIOYwF3ZPR//qWJvAOvhL8xvzO6S0xyW+z1dASzCi5+vPXcvA+rmAJGVgj2I9eQ==
X-Received: by 2002:a17:906:5d0e:b0:6da:97a8:95bd with SMTP id g14-20020a1709065d0e00b006da97a895bdmr1380809ejt.442.1646315989561;
        Thu, 03 Mar 2022 05:59:49 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t19-20020a1709060c5300b006d582121f99sm711461ejf.36.2022.03.03.05.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 05:59:48 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 78D1B13199B; Thu,  3 Mar 2022 14:59:47 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
In-Reply-To: <YiC0BwndXiwxGDNz@linutronix.de>
References: <YiC0BwndXiwxGDNz@linutronix.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 03 Mar 2022 14:59:47 +0100
Message-ID: <875yovdtm4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

> Since the commit mentioned below __xdp_reg_mem_model() can return a NULL
> pointer. This pointer is dereferenced in trace_mem_connect() which leads
> to segfault. It can be reproduced with enabled trace events during ifup.
>
> Only assign the arguments in the trace-event macro if `xa' is set.
> Otherwise set the parameters to 0.
>
> Fixes: 4a48ef70b93b8 ("xdp: Allow registering memory model without rxq reference")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Hmm, so before the commit you mention, the tracepoint wasn't triggered
at all in the code path that now sets xdp_alloc is NULL. So I'm
wondering if we should just do the same here? Is the trace event useful
in all cases?

Alternatively, if we keep it, I think the mem.id and mem.type should be
available from rxq->mem, right?

-Toke

