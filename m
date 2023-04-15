Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8332C6E8578
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 00:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbjDSW73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 18:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbjDSW71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 18:59:27 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD8126AD;
        Wed, 19 Apr 2023 15:58:54 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b57c49c4cso387675b3a.3;
        Wed, 19 Apr 2023 15:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681945121; x=1684537121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQQK9CV11yV3Ka7YlWstgN9/FXVxHhCZ+9O7M6CdT04=;
        b=YBk2Zssri4oQRU2Gl3qzZllwvlm8nfiKm0/J4zBqdz9czN414Dv6bJBFgcKcvCrhUO
         2tijCJ+X1kJG2if4wfvhznoWiY3EXfC0vo3C17Vyojc5thSmlsOO/nRcaDzmJk3GJZIg
         Fx6/ZHuCZJhUS9/wt7KuN3LbKE1nTaVkSR6wMyxrBC7sI0P/ayFDUPbEi1PnD6sBmxan
         7wG8eQZP4Qp6HlTeGgV+5OZWAc3SFjQ5Lk0m3oV9BedDLpeG/SbZnZECVKeD4PHvyP1q
         vrGxiC7nJ5WjGatZNK03StUtAc0pO1iQccJ21puYNQMGpFKTGTUvDAdies+kZhvkax7s
         ruFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681945121; x=1684537121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQQK9CV11yV3Ka7YlWstgN9/FXVxHhCZ+9O7M6CdT04=;
        b=HXTlfda958bx6a4oi3ScUJTPEivSCk9XqV4bHLEhp5o0FqZ43ERlfLZLydCwzUsiWr
         yPprsj52Kz59OVFFlYjFwE/3KPxyL7S/4qw4aJzNSO29sV7AkU154GB58gx5X5vGDwK9
         JHV02vC0LjkL/AhfOMesFEJPLSprPi0dT96Zjs+koXb964XKIGWQ2Yj0hwbZrmZkNh72
         //hTihF15yxfYssJr3UE3IOR03VXzKbFX3G5iLW74pfkCBL3mSA/EGbIyWQfyDmWFFKb
         urgXOp/PUu/HGM8xdXE/fL2PCb6eOKJy78sAmpXas4JNuFBfpRtb+iy1yg/R7D8teZWC
         KrMQ==
X-Gm-Message-State: AAQBX9emQroH0CZY+2qmyV528EnkmAb4VuVuZBYeCo10tE530tBJZoap
        ZwcxBz7dB5R+212Zll4nN1Q=
X-Google-Smtp-Source: AKy350YiLBZovZ3WeFWM7yZSJ+6ij7l5P2Xkhmusc8Uz+PvaG/di+tiz5mtT6hPli4LyxaNiOqHMSA==
X-Received: by 2002:a05:6a00:84e:b0:623:c117:f20e with SMTP id q14-20020a056a00084e00b00623c117f20emr6578835pfk.19.1681945121261;
        Wed, 19 Apr 2023 15:58:41 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id x21-20020a62fb15000000b0063d44634d8csm2138318pfm.71.2023.04.19.15.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:58:40 -0700 (PDT)
Date:   Sat, 15 Apr 2023 07:13:47 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
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
Message-ID: <ZDpOq0ACuMYIUbb1@bullseye>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <ZDk2kOVnUvyLMLKE@bullseye>
 <r6oxanmhwlonb7lcrrowpitlgobivzp7pcwk7snqvfnzudi6pb@4rnio5wef3qu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r6oxanmhwlonb7lcrrowpitlgobivzp7pcwk7snqvfnzudi6pb@4rnio5wef3qu>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing virtio-dev@lists.oasis-open.org because this thread is starting
to touch the spec.

On Wed, Apr 19, 2023 at 12:00:17PM +0200, Stefano Garzarella wrote:
> Hi Bobby,
> 
> On Fri, Apr 14, 2023 at 11:18:40AM +0000, Bobby Eshleman wrote:
> > CC'ing Cong.
> > 
> > On Fri, Apr 14, 2023 at 12:25:56AM +0000, Bobby Eshleman wrote:
> > > Hey all!
> > > 
> > > This series introduces support for datagrams to virtio/vsock.
> 
> Great! Thanks for restarting this work!
> 

No problem!

> > > 
> > > It is a spin-off (and smaller version) of this series from the summer:
> > >   https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> > > 
> > > Please note that this is an RFC and should not be merged until
> > > associated changes are made to the virtio specification, which will
> > > follow after discussion from this series.
> > > 
> > > This series first supports datagrams in a basic form for virtio, and
> > > then optimizes the sendpath for all transports.
> > > 
> > > The result is a very fast datagram communication protocol that
> > > outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
> > > of multi-threaded workload samples.
> > > 
> > > For those that are curious, some summary data comparing UDP and VSOCK
> > > DGRAM (N=5):
> > > 
> > > 	vCPUS: 16
> > > 	virtio-net queues: 16
> > > 	payload size: 4KB
> > > 	Setup: bare metal + vm (non-nested)
> > > 
> > > 	UDP: 287.59 MB/s
> > > 	VSOCK DGRAM: 509.2 MB/s
> > > 
> > > Some notes about the implementation...
> > > 
> > > This datagram implementation forces datagrams to self-throttle according
> > > to the threshold set by sk_sndbuf. It behaves similar to the credits
> > > used by streams in its effect on throughput and memory consumption, but
> > > it is not influenced by the receiving socket as credits are.
> 
> So, sk_sndbuf influece the sender and sk_rcvbuf the receiver, right?
> 

Correct.

> We should check if VMCI behaves the same.
> 
> > > 
> > > The device drops packets silently. There is room for improvement by
> > > building into the device and driver some intelligence around how to
> > > reduce frequency of kicking the virtqueue when packet loss is high. I
> > > think there is a good discussion to be had on this.
> 
> Can you elaborate a bit here?
> 
> Do you mean some mechanism to report to the sender that a destination
> (cid, port) is full so the packet will be dropped?
> 

Correct. There is also the case of there being no receiver at all for
this address since this case isn't rejected upon connect(). Ideally,
such a socket (which will have 100% packet loss) will be throttled
aggressively.

Before we go down too far on this path, I also want to clarify that
using UDP over vhost/virtio-net also has this property... this can be
observed by using tcpdump to dump the UDP packets on the bridge network
your VM is using. UDP packets sent to a garbage address can be seen on
the host bridge (this is the nature of UDP, how is the host supposed to
know the address eventually goes nowhere). I mention the above because I
think it is possible for vsock to avoid this cost, given that it
benefits from being point-to-point and g2h/h2g.

If we're okay with vsock being on par, then the current series does
that. I propose something below that can be added later and maybe
negotiated as a feature bit too.

> Can we adapt the credit mechanism?
> 

I've thought about this a lot because the attraction of the approach for
me would be that we could get the wait/buffer-limiting logic for free
and without big changes to the protocol, but the problem is that the
unreliable nature of datagrams means that the source's free-running
tx_cnt will become out-of-sync with the destination's fwd_cnt upon
packet loss.

Imagine a source that initializes and starts sending packets before a
destination socket even is created, the source's self-throttling will be
dysfunctional because its tx_cnt will always far exceed the
destination's fwd_cnt.

We could play tricks with the meaning of the CREDIT_UPDATE message and
fwd_cnt/buf_alloc fields, but I don't think we want to go down that
path.

I think that the best and simplest approach introduces a congestion
notification (VIRTIO_VSOCK_OP_CN?). When a packet is dropped, the
destination sends this notification. At a given repeated time period T,
the source can check if it has received any notifications in the last T.
If so, it halves its buffer allocation. If not, it doubles its buffer
allocation unless it is already at its max or original value.

An "invalid" socket which never has any receiver will converge towards a
rate limit of one packet per time T * log2(average pkt size). That is, a
socket with 100% packet loss will only be able to send 16 bytes every
4T. A default send buffer of MAX_UINT32 and T=5ms would hit zero within
160ms given at least one packet sent per 5ms. I have no idea if that is
a reasonable default T for vsock, I just pulled it out of a hat for the
sake of the example.

"Normal" sockets will be responsive to high loss and rebalance during
low loss. The source is trying to guess and converge on the actual
buffer state of the destination.

This would reuse the already-existing throttling mechanisms that
throttle based upon buffer allocation. The usage of sk_sndbuf would have
to be re-worked. The application using sendmsg() will see EAGAIN when
throttled, or just sleep if !MSG_DONTWAIT.

I looked at alternative schemes (like the Datagram Congestion Control
Protocol), but I do not think the added complexity is necessary in the
case of vsock (DCCP requires congestion windows, sequence numbers, batch
acknowledgements, etc...). I also looked at UDP-based application
protocols like TFTP, DHCP, and SIP over UDP which use a delay-based
backoff mechanism, but seem to require acknowledgement for those packet
types, which trigger the retries and backoffs. I think we can get away
with the simpler approach and not have to potentially kill performance
with per-packet acknowledgements.

> > > 
> > > In this series I am also proposing that fairness be reexamined as an
> > > issue separate from datagrams, which differs from my previous series
> > > that coupled these issues. After further testing and reflection on the
> > > design, I do not believe that these need to be coupled and I do not
> > > believe this implementation introduces additional unfairness or
> > > exacerbates pre-existing unfairness.
> 
> I see.
> 
> > > 
> > > I attempted to characterize vsock fairness by using a pool of processes
> > > to stress test the shared resources while measuring the performance of a
> > > lone stream socket. Given unfair preference for datagrams, we would
> > > assume that a lone stream socket would degrade much more when a pool of
> > > datagram sockets was stressing the system than when a pool of stream
> > > sockets are stressing the system. The result, however, showed no
> > > significant difference between the degradation of throughput of the lone
> > > stream socket when using a pool of datagrams to stress the queue over
> > > using a pool of streams. The absolute difference in throughput actually
> > > favored datagrams as interfering least as the mean difference was +16%
> > > compared to using streams to stress test (N=7), but it was not
> > > statistically significant. Workloads were matched for payload size and
> > > buffer size (to approximate memory consumption) and process count, and
> > > stress workloads were configured to start before and last long after the
> > > lifetime of the "lone" stream socket flow to ensure that competing flows
> > > were continuously hot.
> > > 
> > > Given the above data, I propose that vsock fairness be addressed
> > > independent of datagrams and to defer its implementation to a future
> > > series.
> 
> Makes sense to me.
> 
> I left some preliminary comments, anyway now it seems reasonable to use
> the same virtqueues, so we can go head with the spec proposal.
> 
> Thanks,
> Stefano
> 

Thanks for the review!

Best,
Bobby
