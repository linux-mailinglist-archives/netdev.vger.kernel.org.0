Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107783D4235
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 23:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhGWUvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 16:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231724AbhGWUvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 16:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627075938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kv9vWlWNi+5ipAdY4bqeIfUHmcLrOuXxFAhQX8y8DPQ=;
        b=DaTcLh4LCWEC19YdnXYihrK0sdGoDCb5QSJ+SJ3Ubvkbd/7s3BeQ1s7x4VtNml/k4puq0Z
        pFNzHapytJtMBJDHK36kG7W88QShpe8tfqobKt4jEtiz8cZC5qrI1spnPn6G1SV1d4ViBD
        oU6R78lIlD9zmPOPZobHxWKoEyUcPro=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-kEgJDXBFOayLzha1W6758Q-1; Fri, 23 Jul 2021 17:32:17 -0400
X-MC-Unique: kEgJDXBFOayLzha1W6758Q-1
Received: by mail-ed1-f70.google.com with SMTP id dn8-20020a05640222e8b029039ef9536577so1372808edb.5
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 14:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kv9vWlWNi+5ipAdY4bqeIfUHmcLrOuXxFAhQX8y8DPQ=;
        b=jHBdsboS1VBjDiwuRxtFrOMLD3dOuHJFvA3J6cuzEZyn1NwEQ/lNB/cCy+CNTBj/5U
         YX4QT//bwNAYIqdYQctp3Rz2fcP9NfH38Rbn2Eonxc1L+0yf2BX4g9KQuTh+Ia4VJt+/
         wI9HDa4Zakttq4QzL0yxCp6wmmgdDhkbbx6bK7SI6wFE3JixxK0fMtYvrSM98Mc7dA09
         ixWwbzZuEqoQFV8ITdMCfC/vi9yceGXgMmW/+UjyJD0CcbLr0GtM0qAqVDQxqkeCAH1A
         qvJn6K3fkbEVgpoiFw8ReVVP2QwQNJxXjVCLdRu6CKo64g9Egq6i4t453BmMBkLj+bq2
         zNmQ==
X-Gm-Message-State: AOAM5334pciYQgzYm/S4sep3AkR+ihuU4IWGyPxX/1f1u18s1eiSNAsi
        u0ucd181BLekmbm23LDaGxfM1bsbzLqdl9iM5PIeYTGsBgNercOsewp78I8w0DJCVmgi5nIJ+AB
        J2agYOtWr5Jv14wIm
X-Received: by 2002:aa7:c782:: with SMTP id n2mr7835122eds.77.1627075935040;
        Fri, 23 Jul 2021 14:32:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk+CAwx+wFR9eJE+a0xcoTVTHTZIVQC6H48Hygqbj8Y8yzDFolgzjOJnf7aWLMVNRVjoqjOg==
X-Received: by 2002:aa7:c782:: with SMTP id n2mr7835098eds.77.1627075934782;
        Fri, 23 Jul 2021 14:32:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ep19sm11231563ejc.58.2021.07.23.14.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:32:14 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8BB58180325; Fri, 23 Jul 2021 23:32:13 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/8] Improve XDP samples usability and output
In-Reply-To: <20210721212833.701342-1-memxor@gmail.com>
References: <20210721212833.701342-1-memxor@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 23 Jul 2021 23:32:13 +0200
Message-ID: <87eebo7m3m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> This set revamps XDP samples related to redirection to show better output and
> implement missing features consolidating all their differences and giving them a
> consistent look and feel, by implementing common features and command line
> options.  Some of the TODO items like reporting redirect error numbers
> (ENETDOWN, EINVAL, ENOSPC, etc.) have also been implemented.
>
> Some of the features are:
> * Received packet statistics
> * xdp_redirect/xdp_redirect_map tracepoint statistics
> * xdp_redirect_err/xdp_redirect_map_err tracepoint statistics (with support for
>   showing exact errno)
> * xdp_cpumap_enqueue/xdp_cpumap_kthread tracepoint statistics
> * xdp_devmap_xmit tracepoint statistics
> * xdp_exception tracepoint statistics
> * Per ifindex pair devmap_xmit stats shown dynamically (for xdp_monitor) to
>   decompose the total.
> * Use of BPF skeleton and BPF static linking to share BPF programs.
> * Use of vmlinux.h and tp_btf for raw_tracepoint support.
> * Removal of redundant -N/--native-mode option (enforced by default now)
> * ... and massive cleanups all over the place.

I took this for a quick spin, and it's a great improvement over the
status quo; it's not immediately obvious when using xdp_redirect and it
doesn't work, and the stats output is awesome!

Today is my last day before going on vacation for three weeks, and
unfortunately I won't have time to review the code in detail before
then; but wanted to express some encouragement before signing off -
please keep at this! :)

-Toke

