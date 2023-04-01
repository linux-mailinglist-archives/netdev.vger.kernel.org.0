Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3DD6D2C4A
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 03:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjDABGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 21:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbjDABGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 21:06:17 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612711D861;
        Fri, 31 Mar 2023 18:06:12 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o11so22981375ple.1;
        Fri, 31 Mar 2023 18:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680311172;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lptAq23Bhxck5w4z/rG8RS6tmRRir3me5yWghBfZL5w=;
        b=RciMOpzWuO92XZZ491w3Y2DRYMTk1B/OuOYYEgSqs4w2yJ0FKDEx4PyPOdLPXVASLH
         HeNugxvV6lVKFtQbAgjusSVnN9Qa3BspUavTeWaWlaIeltduRQTJSlUHWifbYgZmKH3c
         1ajobv052ByD1ZxgrIGtq1u2IKSDh1m7NdRJVyBf1RS+Ruf1FQ9wFDfES6V9whcJkHrz
         kZXHZypSh4qPhO6ZOH9F3jdQjxnrIc5h1CQas2SI7zzvi6FwmjJ87DDlt09VxHlmKZXT
         TQ5TZsq3YlPOqJ01h6OlRLwQ5bduGep0FyhfMuRNKh9+q3jDIOFIZUfrx3mzt2PnP7VJ
         5Ifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680311172;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lptAq23Bhxck5w4z/rG8RS6tmRRir3me5yWghBfZL5w=;
        b=66Kfz8TJk1gS6wOEGBMVeetRDpKMuzMUabbEpy6qUDe9J6OCemfoGi5UKdcXoYhCQ0
         2mVqd6kLREwAK18QSREAuD9Av+xnbD9O9596PcmEgnnwgigNu5t8jLDmwpEZPbGkkAGL
         8G4Ch2GGfIoSwTwo+TEO3raLEs0eLXrbttE2oCrUr0+w3LUTFzqsbBoFjQVRxA9kN4gw
         EEf1LbOjyOPviGTeVj5tseVyTRjAPyNBHE4kLw2Z9+ucLNPVjHigcE3f9d+2X62VrMlC
         2Jx0pJiNfPlUPtLwDXjcGyhkfyDR4wOuq+y2G8ThXDL1Sp3phmcisWSH2liBM7gUJyUj
         QKbg==
X-Gm-Message-State: AAQBX9cZZTPALNrjmdCbeBHjAMrGoIGwzwypOQSjS+Pt/QmRU85k+eXV
        xQvzK2VfCEy/ieXqwj8OYps=
X-Google-Smtp-Source: AKy350Z8u3DIY9zOK2GGbRh+IzTtZrAQZu687R480OVrDZT6cATs8RfxE2bQUMA6S8EqfzHYuLBzNA==
X-Received: by 2002:a17:902:fa04:b0:1a2:85f0:e747 with SMTP id la4-20020a170902fa0400b001a285f0e747mr8814999plb.41.1680311171897;
        Fri, 31 Mar 2023 18:06:11 -0700 (PDT)
Received: from localhost ([98.97.116.12])
        by smtp.gmail.com with ESMTPSA id w16-20020a63c110000000b0050f6add54fcsm2204421pgf.44.2023.03.31.18.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 18:06:11 -0700 (PDT)
Date:   Fri, 31 Mar 2023 18:06:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
        Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Message-ID: <6427838247d16_c503a2087e@john.notmuch>
In-Reply-To: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
References: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
Subject: RE: [PATCH net-next v4 0/3] Add support for sockmap to vsock.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bobby Eshleman wrote:
> We're testing usage of vsock as a way to redirect guest-local UDS
> requests to the host and this patch series greatly improves the
> performance of such a setup.
> 
> Compared to copying packets via userspace, this improves throughput by
> 121% in basic testing.
> 
> Tested as follows.
> 
> Setup: guest unix dgram sender -> guest vsock redirector -> host vsock
>        server
> Threads: 1
> Payload: 64k
> No sockmap:
> - 76.3 MB/s
> - The guest vsock redirector was
>   "socat VSOCK-CONNECT:2:1234 UNIX-RECV:/path/to/sock"
> Using sockmap (this patch):
> - 168.8 MB/s (+121%)
> - The guest redirector was a simple sockmap echo server,
>   redirecting unix ingress to vsock 2:1234 egress.
> - Same sender and server programs
> 
> *Note: these numbers are from RFC v1
> 
> Only the virtio transport has been tested. The loopback transport was
> used in writing bpf/selftests, but not thoroughly tested otherwise.
> 
> This series requires the skb patch.

Appears reasonable to me although I didn't review internals of all
the af_vsock stuff. I see it got merged great.

One nit, I have a series coming shortly to pull the tests out of
the sockmap_listen and into a sockmap_vsock because I don't think they
belong in _listen but that is just a refactor.
