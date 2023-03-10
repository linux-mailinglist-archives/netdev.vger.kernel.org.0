Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37F66B3963
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCJJBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjCJJAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:00:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087FD49DA
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678438429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nyujGqY6hbL21R7JvgsLqfIPq6KmX0JyLo05ppN+aX0=;
        b=fUXW+d1O22gy1tfbhwjDgsMSjrUMrYK5hnu1N7SEBi215FNDcfb7tP9sqAWTaCUlKE35Sv
        7DGuncRMbmeaSbVSA/C0moPOVJyUq6e52DrqmoK6mCX5LgP8oWo3NAUtRbNBYSFwLKYnRr
        WHFzOQ2hsQ1myXGb+If5olL84emhKyA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-QEqejSiAOwCDYDuotz0M9Q-1; Fri, 10 Mar 2023 03:53:45 -0500
X-MC-Unique: QEqejSiAOwCDYDuotz0M9Q-1
Received: by mail-wm1-f69.google.com with SMTP id t1-20020a7bc3c1000000b003dfe223de49so3564324wmj.5
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:53:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678438425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nyujGqY6hbL21R7JvgsLqfIPq6KmX0JyLo05ppN+aX0=;
        b=IAE0odcF2jewsksmAsWLOnM6rennxf5M6utI5eqz9nwhQOUZUPTqk6Sh0PD2Pa3xlb
         yqKbkwO7/AnrMmkA/BX7S8T8paZxxus/QRvoOCYTTKQXstl/s2chzwdu7SWEjo1evg2v
         yzCftJ3Csp+cViD65u93QVukyByc1n+3sbP03usUADKpuYewoUxOBvOR8UDpK+jATf4i
         rJt9wB6fRnCRFDnZi2m2b97ErCF9prpbyRIW2AB5qRe5tZFMbY2fg7lEc8M9OAaFeEQb
         uwpXj7t5c2va98nMWa36wls5uNsKU9CSobO+pRzJJrACZipjFgm33qr4vXcivGX9BGtL
         IXOw==
X-Gm-Message-State: AO0yUKVK5vQDwQ17nseYZbh6rvOQgGLblF8spiObI5LAzsQHgP/1crJu
        DvtJy09TcWUIDtbY4ekJmj6+EAxFmFQo4jU2xUarKX8SolmZrZK4NwCEONzXEdGuCYxJnzYHGkY
        DuaCa6uPJ0SgC7bpI
X-Received: by 2002:a05:600c:1c17:b0:3dc:557f:6123 with SMTP id j23-20020a05600c1c1700b003dc557f6123mr1946389wms.1.1678438424822;
        Fri, 10 Mar 2023 00:53:44 -0800 (PST)
X-Google-Smtp-Source: AK7set82MkObAZdWQPCWwT+eXdPJoKLSsejspunYV9KZmp0T6Zmmx7jMIADOEHFaY00hmbmSF3ENFw==
X-Received: by 2002:a05:600c:1c17:b0:3dc:557f:6123 with SMTP id j23-20020a05600c1c1700b003dc557f6123mr1946371wms.1.1678438424470;
        Fri, 10 Mar 2023 00:53:44 -0800 (PST)
Received: from redhat.com ([2.52.9.88])
        by smtp.gmail.com with ESMTPSA id y6-20020a5d6146000000b002c54fb024b2sm1553272wrt.61.2023.03.10.00.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 00:53:43 -0800 (PST)
Date:   Fri, 10 Mar 2023 03:53:37 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
Subject: Re: [PATCH net-next v3 0/3] vsock: add support for sockmap
Message-ID: <20230310035307-mutt-send-email-mst@kernel.org>
References: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 07:04:33PM +0000, Bobby Eshleman wrote:
> Add support for sockmap to vsock.
> 
> We're testing usage of vsock as a way to redirect guest-local UDS
> requests to the host and this patch series greatly improves the
> performance of such a setup.
> 
> Compared to copying packets via userspace, this improves throughput by
> 121% in basic testing.


besides the small comment, looks ok. Feel free to include my ack
in v4:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

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
> 
> Changes in v3:
> - vsock/bpf: Refactor wait logic in vsock_bpf_recvmsg() to avoid
>   backwards goto
> - vsock/bpf: Check psock before acquiring slock
> - vsock/bpf: Return bool instead of int of 0 or 1
> - vsock/bpf: Wrap macro args __sk/__psock in parens
> - vsock/bpf: Place comment trailer */ on separate line
> 
> Changes in v2:
> - vsock/bpf: rename vsock_dgram_* -> vsock_*
> - vsock/bpf: change sk_psock_{get,put} and {lock,release}_sock() order
>   to minimize slock hold time
> - vsock/bpf: use "new style" wait
> - vsock/bpf: fix bug in wait log
> - vsock/bpf: add check that recvmsg sk_type is one dgram, seqpacket, or
>   stream.  Return error if not one of the three.
> - virtio/vsock: comment __skb_recv_datagram() usage
> - virtio/vsock: do not init copied in read_skb()
> - vsock/bpf: add ifdef guard around struct proto in dgram_recvmsg()
> - selftests/bpf: add vsock loopback config for aarch64
> - selftests/bpf: add vsock loopback config for s390x
> - selftests/bpf: remove vsock device from vmtest.sh qemu machine
> - selftests/bpf: remove CONFIG_VIRTIO_VSOCKETS=y from config.x86_64
> - vsock/bpf: move transport-related (e.g., if (!vsk->transport)) checks
>   out of fast path
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
> Bobby Eshleman (3):
>       vsock: support sockmap
>       selftests/bpf: add vsock to vmtest.sh
>       selftests/bpf: Add a test case for vsock sockmap
> 
>  drivers/vhost/vsock.c                              |   1 +
>  include/linux/virtio_vsock.h                       |   1 +
>  include/net/af_vsock.h                             |  17 ++
>  net/vmw_vsock/Makefile                             |   1 +
>  net/vmw_vsock/af_vsock.c                           |  55 ++++++-
>  net/vmw_vsock/virtio_transport.c                   |   2 +
>  net/vmw_vsock/virtio_transport_common.c            |  24 +++
>  net/vmw_vsock/vsock_bpf.c                          | 175 +++++++++++++++++++++
>  net/vmw_vsock/vsock_loopback.c                     |   2 +
>  tools/testing/selftests/bpf/config.aarch64         |   2 +
>  tools/testing/selftests/bpf/config.s390x           |   3 +
>  tools/testing/selftests/bpf/config.x86_64          |   3 +
>  .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++
>  13 files changed, 443 insertions(+), 6 deletions(-)
> ---
> base-commit: d83115ce337a632f996e44c9f9e18cadfcf5a094
> change-id: 20230118-support-vsock-sockmap-connectible-2e1297d2111a
> 
> Best regards,
> --
> Bobby Eshleman <bobby.eshleman@bytedance.com>
> 
> ---
> Bobby Eshleman (3):
>       vsock: support sockmap
>       selftests/bpf: add vsock to vmtest.sh
>       selftests/bpf: add a test case for vsock sockmap
> 
>  drivers/vhost/vsock.c                              |   1 +
>  include/linux/virtio_vsock.h                       |   1 +
>  include/net/af_vsock.h                             |  17 ++
>  net/vmw_vsock/Makefile                             |   1 +
>  net/vmw_vsock/af_vsock.c                           |  55 ++++++-
>  net/vmw_vsock/virtio_transport.c                   |   2 +
>  net/vmw_vsock/virtio_transport_common.c            |  25 +++
>  net/vmw_vsock/vsock_bpf.c                          | 174 +++++++++++++++++++++
>  net/vmw_vsock/vsock_loopback.c                     |   2 +
>  tools/testing/selftests/bpf/config.aarch64         |   2 +
>  tools/testing/selftests/bpf/config.s390x           |   3 +
>  tools/testing/selftests/bpf/config.x86_64          |   3 +
>  .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++
>  13 files changed, 443 insertions(+), 6 deletions(-)
> ---
> base-commit: c2ea552065e43d05bce240f53c3185fd3a066204
> change-id: 20230227-vsock-sockmap-upstream-9d65c84174a2
> 
> Best regards,
> -- 
> Bobby Eshleman <bobby.eshleman@bytedance.com>

