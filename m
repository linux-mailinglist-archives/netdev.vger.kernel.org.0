Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8B16E2A09
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 20:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjDNS1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 14:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjDNS1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 14:27:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9224586A2;
        Fri, 14 Apr 2023 11:27:06 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o2so19142840plg.4;
        Fri, 14 Apr 2023 11:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681496826; x=1684088826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bpftedxp8jeFPMvDMIoV1HPkN6D0PvJ16pfk4P2dQHE=;
        b=esApBxUs/84XebznSe4FFLGbRHMG4Av/upMd7S77ikHRPiq47kPV3vVuJnlk7W52J1
         PLVudqB1Xq1EB2BuMXEOhq1POOEkrtTvwrgJxpbyPL4wrWtKHL1IecEhibakkJqgyMEF
         W3WBFrkpLQH6n7NcY1lXGz7kWa3u43rKiJ2bBFuon4zTCvSqQczLa1b53z6uA7IKwx0c
         mbCO7Dx1b6axUnmBDJhYzznve4COPU/MsjcJ6RBfpa7WSAMOwNqB1yxmn1K15mKc1VR4
         DvcEUHOW9VibuDISFC7pj9igu5O0N+Z81Phc29AQer8uclch7A27Qm6ceJ9n5PSvtjL7
         vMiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681496826; x=1684088826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bpftedxp8jeFPMvDMIoV1HPkN6D0PvJ16pfk4P2dQHE=;
        b=M1uR6+kQhJ4iVnm0ciCLFmRWojAsDPqvS0d/z6TDguKnTzK6jk+lYETvfDbFSbpnQ4
         KRyf2rE02YpWm+0n/VrEGFJNlvKD9CII2xmHiD0e+fqxGnUdbu3Nhk9ftWmhB1iBQEkz
         6qUKce4q8HsIcjjPlqkDDGI1UAUJVJH8Avr3Dfor/HXDtbUlIm2ICpjGsFEY4lP3gXrn
         RXBD7NxSfuLxRjU1TS0QZywL+VQ5tBKc1iBM+4UBQ7NhMPZQh51nSY155Qeg+ZNRO98s
         tMRMUI3Fh616JbjjHo/g7tLre4I6XPtdlGF5M/O/pa7esdgTauVwl+2Y1293JtwHGRcH
         dalQ==
X-Gm-Message-State: AAQBX9d75J02O5TGiMkRJWQY4u+ETbkBzb6Q/e+BFOGqMo9DHL3UZMXe
        Yr7jId4CcaTHME1cMLrhTHOpkkPYij/TuNUj
X-Google-Smtp-Source: AKy350YIEj4rEG1EPpsminI4Kv7uGYBzXeHfnaySOOVGTGgxYWCKp7MpsXrU8m+2j6P73y+pvbmeoA==
X-Received: by 2002:a17:902:e749:b0:1a6:81b5:9137 with SMTP id p9-20020a170902e74900b001a681b59137mr4364139plf.68.1681496825708;
        Fri, 14 Apr 2023 11:27:05 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id be5-20020a170902aa0500b001a65575c13asm3356193plb.48.2023.04.14.11.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 11:27:05 -0700 (PDT)
Date:   Fri, 14 Apr 2023 11:18:40 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v2 0/4] virtio/vsock: support datagrams
Message-ID: <ZDk2kOVnUvyLMLKE@bullseye>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing Cong.

On Fri, Apr 14, 2023 at 12:25:56AM +0000, Bobby Eshleman wrote:
> Hey all!
> 
> This series introduces support for datagrams to virtio/vsock.
> 
> It is a spin-off (and smaller version) of this series from the summer: 
>   https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> 
> Please note that this is an RFC and should not be merged until
> associated changes are made to the virtio specification, which will
> follow after discussion from this series.
> 
> This series first supports datagrams in a basic form for virtio, and
> then optimizes the sendpath for all transports.
> 
> The result is a very fast datagram communication protocol that
> outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
> of multi-threaded workload samples.
> 
> For those that are curious, some summary data comparing UDP and VSOCK
> DGRAM (N=5):
> 
> 	vCPUS: 16
> 	virtio-net queues: 16
> 	payload size: 4KB
> 	Setup: bare metal + vm (non-nested)
> 
> 	UDP: 287.59 MB/s
> 	VSOCK DGRAM: 509.2 MB/s
> 
> Some notes about the implementation...
> 
> This datagram implementation forces datagrams to self-throttle according
> to the threshold set by sk_sndbuf. It behaves similar to the credits
> used by streams in its effect on throughput and memory consumption, but
> it is not influenced by the receiving socket as credits are.
> 
> The device drops packets silently. There is room for improvement by
> building into the device and driver some intelligence around how to
> reduce frequency of kicking the virtqueue when packet loss is high. I
> think there is a good discussion to be had on this.
> 
> In this series I am also proposing that fairness be reexamined as an
> issue separate from datagrams, which differs from my previous series
> that coupled these issues. After further testing and reflection on the
> design, I do not believe that these need to be coupled and I do not
> believe this implementation introduces additional unfairness or
> exacerbates pre-existing unfairness.
> 
> I attempted to characterize vsock fairness by using a pool of processes
> to stress test the shared resources while measuring the performance of a
> lone stream socket. Given unfair preference for datagrams, we would
> assume that a lone stream socket would degrade much more when a pool of
> datagram sockets was stressing the system than when a pool of stream
> sockets are stressing the system. The result, however, showed no
> significant difference between the degradation of throughput of the lone
> stream socket when using a pool of datagrams to stress the queue over
> using a pool of streams. The absolute difference in throughput actually
> favored datagrams as interfering least as the mean difference was +16%
> compared to using streams to stress test (N=7), but it was not
> statistically significant. Workloads were matched for payload size and
> buffer size (to approximate memory consumption) and process count, and
> stress workloads were configured to start before and last long after the
> lifetime of the "lone" stream socket flow to ensure that competing flows
> were continuously hot.
> 
> Given the above data, I propose that vsock fairness be addressed
> independent of datagrams and to defer its implementation to a future
> series.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
> Bobby Eshleman (3):
>       virtio/vsock: support dgram
>       virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
>       vsock: Add lockless sendmsg() support
> 
> Jiang Wang (1):
>       tests: add vsock dgram tests
> 
>  drivers/vhost/vsock.c                   |  17 +-
>  include/net/af_vsock.h                  |  20 ++-
>  include/uapi/linux/virtio_vsock.h       |   2 +
>  net/vmw_vsock/af_vsock.c                | 287 ++++++++++++++++++++++++++++----
>  net/vmw_vsock/diag.c                    |  10 +-
>  net/vmw_vsock/hyperv_transport.c        |  15 +-
>  net/vmw_vsock/virtio_transport.c        |  10 +-
>  net/vmw_vsock/virtio_transport_common.c | 221 ++++++++++++++++++++----
>  net/vmw_vsock/vmci_transport.c          |  70 ++++++--
>  tools/testing/vsock/util.c              | 105 ++++++++++++
>  tools/testing/vsock/util.h              |   4 +
>  tools/testing/vsock/vsock_test.c        | 193 +++++++++++++++++++++
>  12 files changed, 859 insertions(+), 95 deletions(-)
> ---
> base-commit: ed72bd5a6790a0c3747cb32b0427f921bd03bb71
> change-id: 20230413-b4-vsock-dgram-3b6eba6a64e5
> 
> Best regards,
> -- 
> Bobby Eshleman <bobby.eshleman@bytedance.com>
> 
