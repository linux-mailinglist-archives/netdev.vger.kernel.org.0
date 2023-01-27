Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAA867E7AC
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbjA0OBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbjA0OA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:00:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6525C84B47
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674827914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SdjTBVez/3ftvZX6/OLdL9ZR1SQ75cgVUwtb7qk4ZfM=;
        b=PPnp2t6x4OdXKaVDCfrbCoZ7M26hidgx0FJtni69Sqkl53JIJre+S/C/lThSGmcksA9Xls
        6IMXj6ZQzhMh14i/sS6nfwA4wWz+tXjQWNcrNPRuiybfNn4ECueoeRA+tmIbKqswJsgFgp
        EhA5egXBbSQwUSw0RFmUnbY1SNOWb4k=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-376-PPtIneO3N86IA10NXwERnw-1; Fri, 27 Jan 2023 08:58:33 -0500
X-MC-Unique: PPtIneO3N86IA10NXwERnw-1
Received: by mail-ej1-f71.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso3469542ejb.14
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:58:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SdjTBVez/3ftvZX6/OLdL9ZR1SQ75cgVUwtb7qk4ZfM=;
        b=NOq9ZJHVNVZqVCBDv4I1S2W1e/u551u8hKFyhu5v8EJhmsElyelekcQ6aDGqA0fM9H
         sv7peFhpqM+0f6T8XrNM7kQYKTqVsyozR95sy2fnHXC17E17MWG1lTUTlIzQX+5XzSNG
         rT7JSNCVFrQOzs6pXqr2ARo8/l3/ZR8aP12n/m1J6zOmpd6q9NE5VIDypa6LU9E+H6xE
         vNphmJq6s2HkxN6SnIprrJ9arUbeDoBf+IOWHRn30tlB/D+MCgIJtsH25LcAAuFiNpCW
         /MhzCcfgUy+xx8CIGhloy+0yup5esP7hH2e7g1CXZfWNbUizn/LmsBFy7h7max1lbpzk
         BGAg==
X-Gm-Message-State: AO0yUKXey76tHetr6AruEHKw4s6sLJ3i3vgJqdEQv2/Tzu/iYtElOhL7
        vNYMqogeIq6QoQPOdE1LSEkeHbWjkmHYIcSJ34IwnpLRwQpfhWYhRCMK0yOP3AB1LvHYTVxKu8h
        6AUhuDOR8aDM0EZDY
X-Received: by 2002:a17:906:6c87:b0:87b:59d9:5a03 with SMTP id s7-20020a1709066c8700b0087b59d95a03mr2515388ejr.36.1674827911097;
        Fri, 27 Jan 2023 05:58:31 -0800 (PST)
X-Google-Smtp-Source: AK7set+3UBn4OcKy5pYLNxZ0qgtJJk59jcWp2z39qXFHB5Q8CawryZtKG7DrALckbaIQUtmNvCCSKg==
X-Received: by 2002:a17:906:6c87:b0:87b:59d9:5a03 with SMTP id s7-20020a1709066c8700b0087b59d95a03mr2515303ejr.36.1674827909461;
        Fri, 27 Jan 2023 05:58:29 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w10-20020a170906d20a00b008448d273670sm2255205ejz.49.2023.01.27.05.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 05:58:28 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2266C943260; Fri, 27 Jan 2023 14:58:28 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] [PATCH bpf-next RFC V1] selftests/bpf:
 xdp_hw_metadata clear metadata when -EOPNOTSUPP
In-Reply-To: <167482734243.892262.18210955230092032606.stgit@firesoul>
References: <167482734243.892262.18210955230092032606.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 27 Jan 2023 14:58:28 +0100
Message-ID: <87cz70krjv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> The AF_XDP userspace part of xdp_hw_metadata see non-zero as a signal of
> the availability of rx_timestamp and rx_hash in data_meta area. The
> kernel-side BPF-prog code doesn't initialize these members when kernel
> returns an error e.g. -EOPNOTSUPP.  This memory area is not guaranteed to
> be zeroed, and can contain garbage/previous values, which will be read
> and interpreted by AF_XDP userspace side.
>
> Tested this on different drivers. The experiences are that for most
> packets they will have zeroed this data_meta area, but occasionally it
> will contain garbage data.
>
> Example of failure tested on ixgbe:
>  poll: 1 (0)
>  xsk_ring_cons__peek: 1
>  0x18ec788: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
>  rx_hash: 3697961069
>  rx_timestamp:  9024981991734834796 (sec:9024981991.7348)
>  0x18ec788: complete idx=8 addr=8000
>
> Converting to date:
>  date -d @9024981991
>  2255-12-28T20:26:31 CET
>
> I choose a simple fix in this patch. When kfunc fails or isn't supported
> assign zero to the corresponding struct meta value.
>
> It's up to the individual BPF-programmer to do something smarter e.g.
> that fits their use-case, like getting a software timestamp and marking
> a flag that gives the type of timestamp.
>
> Another possibility is for the behavior of kfunc's
> bpf_xdp_metadata_rx_timestamp and bpf_xdp_metadata_rx_hash to require
> clearing return value pointer.

I definitely think we should leave it up to the BPF programmer to react
to failures; that's what the return code is there for, after all :)

-Toke

