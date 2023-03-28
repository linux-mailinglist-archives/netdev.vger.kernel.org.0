Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B8F6CB932
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjC1IUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjC1IUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:20:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D81C4494
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 01:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679991612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q3X0O+/TM7LVotJgrmc2xoQ/T0kA0UQLhsWOW/x515A=;
        b=RzcuhHor46+fs9wiO9GR7qynLKoFSYx6Gf33Y5qrck2xPn5bhkBPwLouM6p4DxViUEGEi2
        EHXmm9K2/hAv8nQVr8JdbDcsofJiarvibfgdjasHMQ5FpLuo2O5n6ZsuVp7EkQhf6Alcql
        t3wUp1ki5vjaNlEUxE1Ln7kW9WjsdJM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-JVDmRdx0Mca0ITYh3vCnTg-1; Tue, 28 Mar 2023 04:20:11 -0400
X-MC-Unique: JVDmRdx0Mca0ITYh3vCnTg-1
Received: by mail-qk1-f199.google.com with SMTP id pc36-20020a05620a842400b00742c715894bso5236970qkn.21
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 01:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679991611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3X0O+/TM7LVotJgrmc2xoQ/T0kA0UQLhsWOW/x515A=;
        b=3IWoIVRUcSLPRYb/Is24iE8yvHw6lyQ0pgc1CFaQe4txBGDyXtbo2D8ggpAJgIq/xi
         tNYpPoFmO1m+i/XT8PN86JMwKAC7hsDCGAjK6ultbIQKeMNNx6uLHtX+W5zQD1zxZRmU
         fvhdZ9Nn5Yu0sB+3QPt20mX7c+/vIj+EiEeAoWqN5AZdE9tLAkHpRnVP4EXy2N8dR8IQ
         5YmKj6wqaG0DNzXBrOhIYAogwQKC/I3LMRBzms9lQUM7U9B/Q2iht5A/U3rqDUVz5rzf
         UK7Lqidgauoo1bKlZpe9owVGrozVPaho2OnPZndXD8Gk5gBOHMXpCqMHl1Gvx4MECzR1
         mIKA==
X-Gm-Message-State: AAQBX9cqZw1HjCrSQWmzrFYkYUxFxpLdJngVCP89mJ7WjL+RNFAZ01fZ
        drJxXzdz+8hIiLfzukMVEpG5eqqSiv0I3vOLpJMuFLeFSCsIYXEodZ4slvFZOAIhezlV3HmACTf
        gpyr1uTgAa8t+7Beb
X-Received: by 2002:a05:622a:118a:b0:3e4:dcb4:162 with SMTP id m10-20020a05622a118a00b003e4dcb40162mr17628900qtk.4.1679991610925;
        Tue, 28 Mar 2023 01:20:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350bNpzeZ7gjbtIL2Ka8dMo1Bzn5V8O4UfVAoHsG5EFh/3BhzXlyah+r/S5EZ4D3ccfOazp/h+A==
X-Received: by 2002:a05:622a:118a:b0:3e4:dcb4:162 with SMTP id m10-20020a05622a118a00b003e4dcb40162mr17628888qtk.4.1679991610700;
        Tue, 28 Mar 2023 01:20:10 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id 4-20020a05620a048400b007468bf8362esm11708565qkr.66.2023.03.28.01.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 01:20:09 -0700 (PDT)
Date:   Tue, 28 Mar 2023 10:20:01 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/3] vsock: support sockmap
Message-ID: <6eyspnma2esx4nzi2kszxkbuvh3xjb2g4nuhvng6tkvtp3whn6@hpyehyt6imdn>
References: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
 <20230327-vsock-sockmap-v4-1-c62b7cd92a85@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230327-vsock-sockmap-v4-1-c62b7cd92a85@bytedance.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 07:11:51PM +0000, Bobby Eshleman wrote:
>This patch adds sockmap support for vsock sockets. It is intended to be
>usable by all transports, but only the virtio and loopback transports
>are implemented.
>
>SOCK_STREAM, SOCK_DGRAM, and SOCK_SEQPACKET are all supported.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>Acked-by: Michael S. Tsirkin <mst@redhat.com>
>---
> drivers/vhost/vsock.c                   |   1 +
> include/linux/virtio_vsock.h            |   1 +
> include/net/af_vsock.h                  |  17 ++++
> net/vmw_vsock/Makefile                  |   1 +
> net/vmw_vsock/af_vsock.c                |  64 ++++++++++--
> net/vmw_vsock/virtio_transport.c        |   2 +
> net/vmw_vsock/virtio_transport_common.c |  25 +++++
> net/vmw_vsock/vsock_bpf.c               | 174 ++++++++++++++++++++++++++++++++
> net/vmw_vsock/vsock_loopback.c          |   2 +
> 9 files changed, 281 insertions(+), 6 deletions(-)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

