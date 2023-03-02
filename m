Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0316E6A7F0B
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 10:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCBJ4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 04:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjCBJz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 04:55:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F96A1ACF3
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 01:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677750888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jl4deYgtYQ06Ijfay6FIS+BGHtz4sq6QUOH6s3fzXLM=;
        b=dRzBmyCVfCWFKJwGIAfbVXk52s5aFDzqkIJw0kdr6S/5LWpsu0qENizIybVInV6RJgki2d
        TOhljfpc7w6zChD9UcflF3W19wqGYdF4EWKimFKXrYVe3NfGoGWvM5viObjO/qGad/AF6K
        H0UYT983mnCZim3yhKWEVTdroVjX2ic=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-397-3ehFwYlAORatNyiEsIwWig-1; Thu, 02 Mar 2023 04:54:47 -0500
X-MC-Unique: 3ehFwYlAORatNyiEsIwWig-1
Received: by mail-qt1-f197.google.com with SMTP id g13-20020ac8124d000000b003bfba5d76a3so8174383qtj.15
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 01:54:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677750886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jl4deYgtYQ06Ijfay6FIS+BGHtz4sq6QUOH6s3fzXLM=;
        b=hTmmRyMPdkRiDpNA1R1hZVjaNZnZxs7MqR06p9GTalKveU+KW7JOpJLfX85NPkCmxj
         5m9jNtD0xyj6cWU9wP0azy8+aH0XzQ6BM6kaE/blnOJMHwrmUA4uNt33HhBu1CTdkBUF
         TIr29iHMphf9wvH7O3FsCuimvMsQ2nQhfkgC7wVABHFEciezcDFwVBiTYoKQ13tdgErz
         grQIcEwHFJuHPi+4kluKtT+51U5KDXSthjXh20DbwhebIsBdOguZsgREYk7/qqAbMwop
         87vPZ8h20/H/nT/fgsPUYZburUvrhEbu6XXb14XarRFjif9SL0dVvKGzEyi2rA5ZkPnR
         YrIg==
X-Gm-Message-State: AO0yUKXZsSTc4DRhQRD24b2IT+qgInhj+Y9785chfhtq2p8a6w2K6BzZ
        B3ofH13pnArojziCaQ/h2Jeydghl78bnRiE/1428MZueBdg+zdZyIvhqfpMOM6GqZqMinDM3+ro
        y38SDxneU535qnpU3
X-Received: by 2002:a05:6214:1c4f:b0:56e:ad32:2d66 with SMTP id if15-20020a0562141c4f00b0056ead322d66mr20116636qvb.10.1677750886511;
        Thu, 02 Mar 2023 01:54:46 -0800 (PST)
X-Google-Smtp-Source: AK7set/zHXtLONQKHsTMxBoLmedRcRQY43vgPItc+r7atw2mN0yr6/437PDMUCFGDoA9aWymkxnO/g==
X-Received: by 2002:a05:6214:1c4f:b0:56e:ad32:2d66 with SMTP id if15-20020a0562141c4f00b0056ead322d66mr20116604qvb.10.1677750885976;
        Thu, 02 Mar 2023 01:54:45 -0800 (PST)
Received: from sgarzare-redhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id q11-20020a37430b000000b00742a252ba06sm8395133qka.135.2023.03.02.01.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 01:54:45 -0800 (PST)
Date:   Thu, 2 Mar 2023 10:54:34 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net-next v3 3/3] selftests/bpf: add a test case for vsock
 sockmap
Message-ID: <20230302095434.opufchwk7efiw4dv@sgarzare-redhat>
References: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
 <20230227-vsock-sockmap-upstream-v3-3-7e7f4ce623ee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230227-vsock-sockmap-upstream-v3-3-7e7f4ce623ee@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 07:04:36PM +0000, Bobby Eshleman wrote:
>Add a test case testing the redirection from connectible AF_VSOCK
>sockets to connectible AF_UNIX sockets.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++++
> 1 file changed, 163 insertions(+)

Ditto.

For the vsock part:

Acked-by: Stefano Garzarella <sgarzare@redhat.com>

