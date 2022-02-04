Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CC34AA495
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345590AbiBDXpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:45:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37714 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbiBDXo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644018298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=843oTQdXHG4iAsy+ydoJdDhZmVNpfbb4NAzT25x56GQ=;
        b=JU7paP/+Vl+xXcuhth4nk9RRnQsijlgacWPdBvDs9QELyqk2znNoUpMi+FhcocRS8Ys8ca
        Xg1IAaxGaqZqVDeAYJ/xrk//o+p1H1ShRIyrMkzDdDbhaHabdrhJbqjCoEmte/lHzAd3i/
        i/BEB/BHmZLe7S0f77IJ9ppeAd1mksc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-uABLd2l-Mb-2Kn74UQ3FDA-1; Fri, 04 Feb 2022 18:44:57 -0500
X-MC-Unique: uABLd2l-Mb-2Kn74UQ3FDA-1
Received: by mail-qt1-f197.google.com with SMTP id a28-20020ac84d9c000000b002d05c958a84so5904184qtw.0
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 15:44:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=843oTQdXHG4iAsy+ydoJdDhZmVNpfbb4NAzT25x56GQ=;
        b=By8dCejI58LtrktkXt9aRtudnJPXLEx74aS90Jrs+YMYuG8a2MCX5JFwtxHCTjglc7
         z7NMRRv643Zk1bDVTAxLKLgOXqmgmb2h1F49gENYmyBw6Z77mpy3O+X13yEDOYpQVS60
         ARUOQKQH/l3cx32XKzHlopQacgmITHchrDd28AVTJB/nesvRgsEMIbvdA3tc//grDUmU
         EFyCLNfxFyaxtdT0SS8v+1Z3hHVoYT19p63Sfxlb0IBb02bJCsrGpGUb8Bwwbpx2W6Z/
         iKkhzTVK5M5nOyet3o7VTxO74qBuOLkR0r226wsoxtw4Fb3M0iPmP/IGwwosHnPgn8db
         ACJg==
X-Gm-Message-State: AOAM530H4oFdeGW0zIjz4uzVCkEwa9k8i8fmQYnC9nCgIPE+sk5rPxq3
        s0JYFoTSW399ChPXfoL9swiBihid4dnjrNDJq04m+0+a5lr4Yc6YanSNUlNSvKH40wFE6SmwRVt
        dd6goDxb8k/kc+B9+
X-Received: by 2002:a05:622a:3d3:: with SMTP id k19mr1087712qtx.71.1644018296457;
        Fri, 04 Feb 2022 15:44:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnJSrs6zjl6im3MO0Fk7R7GIP89qiJrDLQf24Fh5eTf/PE+ftGx05YbvIRgK64E2NyM456vw==
X-Received: by 2002:a05:622a:3d3:: with SMTP id k19mr1087683qtx.71.1644018295431;
        Fri, 04 Feb 2022 15:44:55 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j13sm1888729qko.46.2022.02.04.15.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 15:44:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CBEDF101B7D; Sat,  5 Feb 2022 00:44:53 +0100 (CET)
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
Subject: Re: [PATCH net-next v2 2/3] net: dev: Makes sure netif_rx() can be
 invoked in any context.
In-Reply-To: <20220204201259.1095226-3-bigeasy@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
 <20220204201259.1095226-3-bigeasy@linutronix.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 05 Feb 2022 00:44:53 +0100
Message-ID: <878ruqb3ii.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

> Dave suggested a while ago (eleven years by now) "Let's make netif_rx()
> work in all contexts and get rid of netif_rx_ni()". Eric agreed and
> pointed out that modern devices should use netif_receive_skb() to avoid
> the overhead.
> In the meantime someone added another variant, netif_rx_any_context(),
> which behaves as suggested.
>
> netif_rx() must be invoked with disabled bottom halves to ensure that
> pending softirqs, which were raised within the function, are handled.
> netif_rx_ni() can be invoked only from process context (bottom halves
> must be enabled) because the function handles pending softirqs without
> checking if bottom halves were disabled or not.
> netif_rx_any_context() invokes on the former functions by checking
> in_interrupts().
>
> netif_rx() could be taught to handle both cases (disabled and enabled
> bottom halves) by simply disabling bottom halves while invoking
> netif_rx_internal(). The local_bh_enable() invocation will then invoke
> pending softirqs only if the BH-disable counter drops to zero.
>
> Eric is concerned about the overhead of BH-disable+enable especially in
> regard to the loopback driver. As critical as this driver is, it will
> receive a shortcut to avoid the additional overhead which is not needed.
>
> Add a local_bh_disable() section in netif_rx() to ensure softirqs are
> handled if needed. Provide the internal bits as __netif_rx() which can
> be used by the loopback driver. This function is not exported so it
> can't be used by modules.
> Make netif_rx_ni() and netif_rx_any_context() invoke netif_rx() so they
> can be removed once they are no more users left.
>
> Link: https://lkml.kernel.org/r/20100415.020246.218622820.davem@davemloft=
.net
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

