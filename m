Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A056F15F6
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 12:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345571AbjD1KoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 06:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjD1KoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 06:44:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE4B524F
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 03:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682678609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IQVmdT90OhXDpcSpwDoh82Tvt4g5mLAfat632QKI2HE=;
        b=JLgfxBfazn5EJ76Y5hSS44k4g6RrfjLFI50+HW7LMkIMk6o+n2G1oq+eyBCpfz5TSYcub7
        iM7+H/XWiyx9mEOogIV46GlWn74C2G3qj1eKgbl2v8edOe6zDG/sxtI4zyaGGXfgKlzx/r
        enwm/SqH+/geC7uiCI60kCTHEd/L3mo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-AN388D_8MeaVDCYBPU9iOQ-1; Fri, 28 Apr 2023 06:43:27 -0400
X-MC-Unique: AN388D_8MeaVDCYBPU9iOQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f080f534acso62452355e9.0
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 03:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682678604; x=1685270604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQVmdT90OhXDpcSpwDoh82Tvt4g5mLAfat632QKI2HE=;
        b=YFtOlcgLnRC2sHKE8eo5xIfrUaoOXya0FEY2wHxxbHM2VNnaIQ6zXek71NNC5CZ8rH
         vjUG6Xmwt5SuS+Yox1QsTqXCN3iOI6R0U1y4W0BaM2vuz7wMgKMyGaSLEtPcxKrbIun+
         MbWUPUr7NBdFZxRrhQE04aKU0CFyHFihPkOvhSbIeN6YdOkee4xt/YMMP7k9D4x0bp4j
         DZ0+uHmyh7w3GnlkFs0h5h5zTOrQYI8aZHG35K8oeOBZ3bq2zCTkQ2QfHAprCGi436ZS
         F0JiJVWwMWYiIaAYcdJn3q+0ZeRU7lJxEfzJmPdarO0bY21Kmjt4QMJkV3FhG9Jqg68f
         f71Q==
X-Gm-Message-State: AC+VfDzq2867YgFhQ76vzojXqAPcIF9bgWmAvYi6zKmrhWubDIcnDhIF
        bf4w71bGBBpSmsKpP0cXWkkFL0itc1AQgbV+USbX/ucgwAp31Hg0hmIaDtYvl/tybi6wc0NWxl9
        IElhwNpCzKh0pWe/H
X-Received: by 2002:a5d:63cd:0:b0:2f4:e580:a72f with SMTP id c13-20020a5d63cd000000b002f4e580a72fmr3575465wrw.45.1682678604404;
        Fri, 28 Apr 2023 03:43:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6sbbM9Zn4cTetz42fXKk9Z9F040Hk4rnRdGv4o6qnjbgUiSUoCwpa/D62xpuyoNmY1khznig==
X-Received: by 2002:a5d:63cd:0:b0:2f4:e580:a72f with SMTP id c13-20020a5d63cd000000b002f4e580a72fmr3575451wrw.45.1682678604022;
        Fri, 28 Apr 2023 03:43:24 -0700 (PDT)
Received: from sgarzare-redhat ([217.171.71.231])
        by smtp.gmail.com with ESMTPSA id s4-20020adfeb04000000b003047f7a7ad1sm11442270wrn.71.2023.04.28.03.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 03:43:23 -0700 (PDT)
Date:   Fri, 28 Apr 2023 12:43:09 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     linux-hyperv@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtio-dev@lists.oasis-open.org
Subject: Re: [PATCH RFC net-next v2 0/4] virtio/vsock: support datagrams
Message-ID: <yeu57zqwzcx33sylp565xgw7yv72qyczohkmukyex27rcdh6mr@w4x6t4enx6iu>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <ZDk2kOVnUvyLMLKE@bullseye>
 <r6oxanmhwlonb7lcrrowpitlgobivzp7pcwk7snqvfnzudi6pb@4rnio5wef3qu>
 <ZDpOq0ACuMYIUbb1@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZDpOq0ACuMYIUbb1@bullseye>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 07:13:47AM +0000, Bobby Eshleman wrote:
>CC'ing virtio-dev@lists.oasis-open.org because this thread is starting
>to touch the spec.
>
>On Wed, Apr 19, 2023 at 12:00:17PM +0200, Stefano Garzarella wrote:
>> Hi Bobby,
>>
>> On Fri, Apr 14, 2023 at 11:18:40AM +0000, Bobby Eshleman wrote:
>> > CC'ing Cong.
>> >
>> > On Fri, Apr 14, 2023 at 12:25:56AM +0000, Bobby Eshleman wrote:
>> > > Hey all!
>> > >
>> > > This series introduces support for datagrams to virtio/vsock.
>>
>> Great! Thanks for restarting this work!
>>
>
>No problem!
>
>> > >
>> > > It is a spin-off (and smaller version) of this series from the summer:
>> > >   https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
>> > >
>> > > Please note that this is an RFC and should not be merged until
>> > > associated changes are made to the virtio specification, which will
>> > > follow after discussion from this series.
>> > >
>> > > This series first supports datagrams in a basic form for virtio, and
>> > > then optimizes the sendpath for all transports.
>> > >
>> > > The result is a very fast datagram communication protocol that
>> > > outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
>> > > of multi-threaded workload samples.
>> > >
>> > > For those that are curious, some summary data comparing UDP and VSOCK
>> > > DGRAM (N=5):
>> > >
>> > > 	vCPUS: 16
>> > > 	virtio-net queues: 16
>> > > 	payload size: 4KB
>> > > 	Setup: bare metal + vm (non-nested)
>> > >
>> > > 	UDP: 287.59 MB/s
>> > > 	VSOCK DGRAM: 509.2 MB/s
>> > >
>> > > Some notes about the implementation...
>> > >
>> > > This datagram implementation forces datagrams to self-throttle according
>> > > to the threshold set by sk_sndbuf. It behaves similar to the credits
>> > > used by streams in its effect on throughput and memory consumption, but
>> > > it is not influenced by the receiving socket as credits are.
>>
>> So, sk_sndbuf influece the sender and sk_rcvbuf the receiver, right?
>>
>
>Correct.
>
>> We should check if VMCI behaves the same.
>>
>> > >
>> > > The device drops packets silently. There is room for improvement by
>> > > building into the device and driver some intelligence around how to
>> > > reduce frequency of kicking the virtqueue when packet loss is high. I
>> > > think there is a good discussion to be had on this.
>>
>> Can you elaborate a bit here?
>>
>> Do you mean some mechanism to report to the sender that a destination
>> (cid, port) is full so the packet will be dropped?
>>
>
>Correct. There is also the case of there being no receiver at all for
>this address since this case isn't rejected upon connect(). Ideally,
>such a socket (which will have 100% packet loss) will be throttled
>aggressively.
>
>Before we go down too far on this path, I also want to clarify that
>using UDP over vhost/virtio-net also has this property... this can be
>observed by using tcpdump to dump the UDP packets on the bridge network
>your VM is using. UDP packets sent to a garbage address can be seen on
>the host bridge (this is the nature of UDP, how is the host supposed to
>know the address eventually goes nowhere). I mention the above because I
>think it is possible for vsock to avoid this cost, given that it
>benefits from being point-to-point and g2h/h2g.
>
>If we're okay with vsock being on par, then the current series does
>that. I propose something below that can be added later and maybe
>negotiated as a feature bit too.

I see and I agree on that, let's do it step by step.
If we can do it in the first phase is great, but I think is fine to add
this feature later.

>
>> Can we adapt the credit mechanism?
>>
>
>I've thought about this a lot because the attraction of the approach for
>me would be that we could get the wait/buffer-limiting logic for free
>and without big changes to the protocol, but the problem is that the
>unreliable nature of datagrams means that the source's free-running
>tx_cnt will become out-of-sync with the destination's fwd_cnt upon
>packet loss.

We need to understand where the packet can be lost.
If the packet always reaches the destination (vsock driver or device),
we can discard it, but also update the counters.

>
>Imagine a source that initializes and starts sending packets before a
>destination socket even is created, the source's self-throttling will be
>dysfunctional because its tx_cnt will always far exceed the
>destination's fwd_cnt.

Right, the other problem I see is that the socket aren't connected, so
we have 1-N relationship.

>
>We could play tricks with the meaning of the CREDIT_UPDATE message and
>fwd_cnt/buf_alloc fields, but I don't think we want to go down that
>path.
>
>I think that the best and simplest approach introduces a congestion
>notification (VIRTIO_VSOCK_OP_CN?). When a packet is dropped, the
>destination sends this notification. At a given repeated time period T,
>the source can check if it has received any notifications in the last T.
>If so, it halves its buffer allocation. If not, it doubles its buffer
>allocation unless it is already at its max or original value.
>
>An "invalid" socket which never has any receiver will converge towards a
>rate limit of one packet per time T * log2(average pkt size). That is, a
>socket with 100% packet loss will only be able to send 16 bytes every
>4T. A default send buffer of MAX_UINT32 and T=5ms would hit zero within
>160ms given at least one packet sent per 5ms. I have no idea if that is
>a reasonable default T for vsock, I just pulled it out of a hat for the
>sake of the example.
>
>"Normal" sockets will be responsive to high loss and rebalance during
>low loss. The source is trying to guess and converge on the actual
>buffer state of the destination.
>
>This would reuse the already-existing throttling mechanisms that
>throttle based upon buffer allocation. The usage of sk_sndbuf would have
>to be re-worked. The application using sendmsg() will see EAGAIN when
>throttled, or just sleep if !MSG_DONTWAIT.

I see, it looks interesting, but I think we need to share that
information between multiple sockets, since the same destination
(cid, port), can be reached by multiple sockets.

Another approach could be to have both congestion notification and
decongestion, but maybe it produces double traffic.

>
>I looked at alternative schemes (like the Datagram Congestion Control
>Protocol), but I do not think the added complexity is necessary in the
>case of vsock (DCCP requires congestion windows, sequence numbers, batch
>acknowledgements, etc...). I also looked at UDP-based application
>protocols like TFTP, DHCP, and SIP over UDP which use a delay-based
>backoff mechanism, but seem to require acknowledgement for those packet
>types, which trigger the retries and backoffs. I think we can get away
>with the simpler approach and not have to potentially kill performance
>with per-packet acknowledgements.

Yep I agree. I think our advantage is that the channel (virtqueues),
can't lose packets.

>
>> > >
>> > > In this series I am also proposing that fairness be reexamined as an
>> > > issue separate from datagrams, which differs from my previous series
>> > > that coupled these issues. After further testing and reflection on the
>> > > design, I do not believe that these need to be coupled and I do not
>> > > believe this implementation introduces additional unfairness or
>> > > exacerbates pre-existing unfairness.
>>
>> I see.
>>
>> > >
>> > > I attempted to characterize vsock fairness by using a pool of processes
>> > > to stress test the shared resources while measuring the performance of a
>> > > lone stream socket. Given unfair preference for datagrams, we would
>> > > assume that a lone stream socket would degrade much more when a pool of
>> > > datagram sockets was stressing the system than when a pool of stream
>> > > sockets are stressing the system. The result, however, showed no
>> > > significant difference between the degradation of throughput of the lone
>> > > stream socket when using a pool of datagrams to stress the queue over
>> > > using a pool of streams. The absolute difference in throughput actually
>> > > favored datagrams as interfering least as the mean difference was +16%
>> > > compared to using streams to stress test (N=7), but it was not
>> > > statistically significant. Workloads were matched for payload size and
>> > > buffer size (to approximate memory consumption) and process count, and
>> > > stress workloads were configured to start before and last long after the
>> > > lifetime of the "lone" stream socket flow to ensure that competing flows
>> > > were continuously hot.
>> > >
>> > > Given the above data, I propose that vsock fairness be addressed
>> > > independent of datagrams and to defer its implementation to a future
>> > > series.
>>
>> Makes sense to me.
>>
>> I left some preliminary comments, anyway now it seems reasonable to use
>> the same virtqueues, so we can go head with the spec proposal.
>>
>> Thanks,
>> Stefano
>>
>
>Thanks for the review!

You're welcome!

Stefano

