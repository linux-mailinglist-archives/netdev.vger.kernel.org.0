Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7998F4AA493
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243336AbiBDXoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:44:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbiBDXoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:44:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644018273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OG4d2yofZLex3o/TeM8Xf3ERpfuxuz16MfpWbW0GXSU=;
        b=gXCHxfASxE3Xb3jES8N2q7fj7b4M90QgIjm7SwjHUXNpKtE5Q4WJomF4D1yXsJTthun8CL
        DdfSKKmVymeLpaBrPjFrRCBUAwhP8xlVImbiQsXC/8gEzxTUl/h5XZrX+GrpcJKfb1jghU
        KITvBZrUdDYDZM2hlNlXGtiSp6oYGyw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-FHBTK7QXOkeHPFd86oED8w-1; Fri, 04 Feb 2022 18:44:32 -0500
X-MC-Unique: FHBTK7QXOkeHPFd86oED8w-1
Received: by mail-qt1-f197.google.com with SMTP id x5-20020ac84d45000000b002cf826b1a18so5870156qtv.2
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 15:44:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=OG4d2yofZLex3o/TeM8Xf3ERpfuxuz16MfpWbW0GXSU=;
        b=xw0OEa3tsx1z7mtNVOYY3JR49OSHOy3UB+vyEfxe9KBLePPaSyRyGW20O/PsJLD2pd
         rVU2vICd1zN+/HLUpXtriWHjjy1D7Pw+PbQtoVs+MVoaSt4CS2LkeQWpd/Uq+plAHMX5
         nblB8r4J0OX5Ldy6EGcf0b1yQeprwefN+d4kKXiHHqE3UEl/lTxs5IIRepZQQ8/I128k
         8gr30xA2oruiBoFno/a+casH62I7nsTgG1/LNJkveKvNZLdyRi9IDuR2fX+n+NbRNSbG
         Dvj0siDQkKv+yjdZoKRhVjk8czHqu4HABhMtIqnllk0CWgyfHoubm8rH4BVDXvbT7fnS
         7mDw==
X-Gm-Message-State: AOAM532IsjepIzOPS+GOYSWAA9DDFAQjssPlUSXbIUH9ZURHGgg/XewG
        xgL338vHvV8ZE+oYktV/QieFgV3a8tbX+vkZqmtWbWbGIVoA2/Mp9ZXPJqZx7nwwF/+fv72dKMc
        6Hj8gce88BOM+p6Y/
X-Received: by 2002:a05:620a:2546:: with SMTP id s6mr819111qko.587.1644018271304;
        Fri, 04 Feb 2022 15:44:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbXyZBjD/qSWRhtQRyOpp0HB9Uki8PNS9GPCVgMIYS3jwxv33tskEa0CcyGYgS2OEfhT8GUA==
X-Received: by 2002:a05:620a:2546:: with SMTP id s6mr819087qko.587.1644018270042;
        Fri, 04 Feb 2022 15:44:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 134sm1626369qkl.50.2022.02.04.15.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 15:44:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F1BEF101B7B; Sat,  5 Feb 2022 00:44:27 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next v2 1/3] net: dev: Remove preempt_disable() and
 get_cpu() in netif_rx_internal().
In-Reply-To: <20220204201259.1095226-2-bigeasy@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
 <20220204201259.1095226-2-bigeasy@linutronix.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 05 Feb 2022 00:44:27 +0100
Message-ID: <87bkzmb3j8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

> The preempt_disable() () section was introduced in commit
>     cece1945bffcf ("net: disable preemption before call smp_processor_id(=
)")
>
> and adds it in case this function is invoked from preemtible context and
> because get_cpu() later on as been added.
>
> The get_cpu() usage was added in commit
>     b0e28f1effd1d ("net: netif_rx() must disable preemption")
>
> because ip_dev_loopback_xmit() invoked netif_rx() with enabled preemption
> causing a warning in smp_processor_id(). The function netif_rx() should
> only be invoked from an interrupt context which implies disabled
> preemption. The commit
>    e30b38c298b55 ("ip: Fix ip_dev_loopback_xmit()")
>
> was addressing this and replaced netif_rx() with in netif_rx_ni() in
> ip_dev_loopback_xmit().
>
> Based on the discussion on the list, the former patch (b0e28f1effd1d)
> should not have been applied only the latter (e30b38c298b55).
>
> Remove get_cpu() and preempt_disable() since the function is supposed to
> be invoked from context with stable per-CPU pointers. Bottom halves have
> to be disabled at this point because the function may raise softirqs
> which need to be processed.
>
> Link: https://lkml.kernel.org/r/20100415.013347.98375530.davem@davemloft.=
net
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

