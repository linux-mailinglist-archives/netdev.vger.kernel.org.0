Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC7A2D8F40
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 19:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgLMSWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 13:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbgLMSWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 13:22:20 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB277C0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 10:21:39 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id g20so19512891ejb.1
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 10:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ls/TM45a/2TY5gXY5BjrFTwylM7rwS7H7ZnBfdEPrfA=;
        b=YOBfepvFU3U7nDxKg8TkO6s2thPhYjGsmQM55AMUvhxzW9hUBn6VwZStajlfvGXv+2
         s6BImEZLABw+W323lfg2RhCpOEhW7l9moBIRw6/cWOhCszsq3d1ZgzSkJEtHscayo7ma
         AjzI3uoNAleG0wgP5RGvpMrR6huWhbEaMmX07lM1c2BcyvuR8A2smXhaDvNX+expXUZN
         r1eKWUsYFSQrHdEiqGFU84ls8TOTolHkp5CcoBpMOkOCPOiKhFBjggMBrK2P3GKM57PR
         ojXKFcv7QBVg2ykOATU2DHMDwqTzN7XZpsC9lkH25c7bPSFNhhy2j90XU6jiXEscnCFL
         31dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ls/TM45a/2TY5gXY5BjrFTwylM7rwS7H7ZnBfdEPrfA=;
        b=EBIkRQmF7FXkm+58LghOqLEAjJezAceOfJ1VevU9v7a1LWJsPLiFxQcT8kQib262IR
         dxRZYTStzyo1ONlh3pYIfw+FTR0BIebu4GjFDpKZtMamjAw1kUslVBK3aZvxcJRF5cuG
         RoNnNmo1X83he/7r6NRs8ilN8siO6PVyZYxY/+aiPsnZv6qjBTNpjBzAtGkWCfN36DFz
         MG5m/TCos00Ztiss5UiE3zjiVVlDL9BNdRtwW1eX7U6uIUURzFRpWUXfro5EGP1Fn5N5
         WnKKZ6OxUFlkPO+IABzS6wMDvpJJOkG1dAtTY3wZbasZA4CW3Iyp5ZZfQCJUieB1Wiiy
         At2Q==
X-Gm-Message-State: AOAM5322o10mGZ+27oS4X9zCXiGyaOQjQsIun6nIhLrUlsOwtuwhrLau
        F0XyGrqIgHA4tkKMcbcOCR4=
X-Google-Smtp-Source: ABdhPJwMd6oIqdXnkYAqIinjRuXZNq3+uGiZH0+NDDPEi/blLJOIgUFkZ79xJudqlpIBQFzjEyW2xg==
X-Received: by 2002:a17:906:a8e:: with SMTP id y14mr19079272ejf.47.1607883698356;
        Sun, 13 Dec 2020 10:21:38 -0800 (PST)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id d1sm11690591eje.82.2020.12.13.10.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 10:21:37 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     David Ahern <dsahern@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-3-borisp@mellanox.com>
 <6f48fa5d-465c-5c38-ea45-704e86ba808b@gmail.com>
 <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
 <65dc5bba-13e6-110a-ddae-3d0c260aa875@gmail.com>
 <ab298844-c95e-43e6-b4bb-fe5ce78655d8@gmail.com>
 <921a110f-60fa-a711-d386-39eeca52199f@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <ca9f42e5-fa4b-1fa0-c2a8-393e577cb6c9@gmail.com>
Date:   Sun, 13 Dec 2020 20:21:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <921a110f-60fa-a711-d386-39eeca52199f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/2020 6:26, David Ahern wrote:
> On 12/9/20 1:15 AM, Boris Pismenny wrote:
>> On 09/12/2020 2:38, David Ahern wrote:
[...]
>>
>> There is more to this than TCP zerocopy that exists in userspace or
>> inside the kernel. First, please note that the patches include support for
>> CRC offload as well as data placement. Second, data-placement is not the same
> 
> Yes, the CRC offload is different, but I think it is orthogonal to the
> 'where does h/w put the data' problem.
> 

I agree

>> as zerocopy for the following reasons:
>> (1) The former places buffers *exactly* where the user requests
>> regardless of the order of response arrivals, while the latter places packets
>> in anonymous buffers according to packet arrival order. Therefore, zerocopy
>> can be implemented using data placement, but not vice versa.
> 
> Fundamentally, it is an SGL and a TCP sequence number. There is a
> starting point where seq N == sgl element 0, position 0. Presumably
> there is a hardware cursor to track where you are in filling the SGL as
> packets are processed. You abort on OOO, so it seems like a fairly
> straightfoward problem.
> 

We do not abort on OOO. Moreover, we can keep going as long as
PDU headers are not reordered.

>> (2) Data-placement supports sub-page zerocopy, unlike page-flipping
>> techniques (i.e., TCP_ZEROCOPY).
> 
> I am not pushing for or suggesting any page-flipping. I understand the
> limitations of that approach.
> 
>> (3) Page-flipping can't work for any storage initiator because the
>> destination buffer is owned by some user pagecache or process using O_DIRECT.
>> (4) Storage over TCP PDUs are not necessarily aligned to TCP packets,
>> i.e., the PDU header can be in the middle of a packet, so header-data split
>> alone isn't enough.
> 
> yes, TCP is a byte stream and you have to have a cursor marking last
> written spot in the SGL. More below.
> 
>>
>> I wish we could do the same using some simpler zerocopy mechanism,
>> it would indeed simplify things. But, unfortunately this would severely
>> restrict generality, no sub-page support and alignment between PDUs
>> and packets, and performance (ordering of PDUs).
>>
> 
> My biggest concern is that you are adding checks in the fast path for a
> very specific use case. If / when Rx zerocopy happens (and I suspect it
> has to happen soon to handle the ever increasing speeds), nothing about
> this patch set is reusable and worse more checks are needed in the fast
> path. I think it is best if you make this more generic — at least
> anything touching core code.
> 
> For example, you have an iov static key hook managed by a driver for
> generic code. There are a few ways around that. One is by adding skb
> details to the nvme code — ie., walking the skb fragments, seeing that a
> given frag is in your allocated memory and skipping the copy. This would
> offer best performance since it skips all unnecessary checks. Another
> option is to export __skb_datagram_iter, use it and define your own copy
> handler that does the address compare and skips the copy. Key point -
> only your code path is affected.

I'll submit V2 that is less invasive to core code:
IMO exporting __skb_datagram_iter and all child functions
is more generic, so we'll use that.

> 
> Similarly for the NVMe SGLs and DDP offload - a more generic solution
> allows other use cases to build on this as opposed to the checks you
> want for a special case. For example, a split at the protocol headers /
> payload boundaries would be a generic solution where kernel managed
> protocols get data in one buffer and socket data is put into a given
> SGL. I am guessing that you have to be already doing this to put PDU
> payloads into an SGL and other headers into other memory to make a
> complete packet, so this is not too far off from what you are already doing.
> 

Splitting at protocol header boundaries and placing data at socket defined
SGLs is not enough for nvme-tcp because the nvme-tcp protocol can reorder
responses. Here is an example:

the host submits the following requests:
+--------+--------+--------+
| Read 1 | Read 2 | Read 3 |
+--------+--------+--------+

the target responds with the following responses:
+--------+--------+--------+
| Resp 2 | Resp 3 | Resp 1 |
+--------+--------+--------+

Therefore, hardware must hold a mapping between PDU identifiers (command_id)
and the corresponding buffers. This interface is missing in the proposal
above, which is why it won't work for nvme-tcp.

> Let me walk through an example with assumptions about your hardware's
> capabilities, and you correct me where I am wrong. Assume you have a
> 'full' command response of this form:
> 
>  +------------- ... ----------------+---------+---------+--------+-----+
>  |          big data segment        | PDU hdr | TCP hdr | IP hdr | eth |
>  +------------- ... ----------------+---------+---------+--------+-----+
> 
> but it shows up to the host in 3 packets like this (ideal case):
> 
>  +-------------------------+---------+---------+--------+-----+
>  |       data - seg 1      | PDU hdr | TCP hdr | IP hdr | eth |
>  +-------------------------+---------+---------+--------+-----+
>  +-----------------------------------+---------+--------+-----+
>  |       data - seg 2                | TCP hdr | IP hdr | eth |
>  +-----------------------------------+---------+--------+-----+
>                    +-----------------+---------+--------+-----+
>                    | payload - seg 3 | TCP hdr | IP hdr | eth |
>                    +-----------------+---------+--------+-----+
> 
> 
> The hardware splits the eth/IP/tcp headers from payload like this
> (again, your hardware has to know these boundaries to accomplish what
> you want):
> 
>  +-------------------------+---------+     +---------+--------+-----+
>  |       data - seg 1      | PDU hdr |     | TCP hdr | IP hdr | eth |
>  +-------------------------+---------+     +---------+--------+-----+
> 
>  +-----------------------------------+     +---------+--------+-----+
>  |       data - seg 2                |     | TCP hdr | IP hdr | eth |
>  +-----------------------------------+     +---------+--------+-----+
> 
>                    +-----------------+     +---------+--------+-----+
>                    | payload - seg 3 |     | TCP hdr | IP hdr | eth |
>                    +-----------------+     +---------+--------+-----+
> 
> Left side goes into the SGLs posted for this socket / flow; the right
> side goes into some other memory resource made available for headers.
> This is very close to what you are doing now - with the exception of the
> PDU header being put to the right side. NVMe code then just needs to set
> the iov offset (or adjust the base_addr) to skip over the PDU header -
> standard options for an iov.
> 
> Yes, TCP is a byte stream, so the packets could very well show up like this:
> 
>  +--------------+---------+-----------+---------+--------+-----+
>  | data - seg 1 | PDU hdr | prev data | TCP hdr | IP hdr | eth |
>  +--------------+---------+-----------+---------+--------+-----+
>  +-----------------------------------+---------+--------+-----+
>  |     payload - seg 2               | TCP hdr | IP hdr | eth |
>  +-----------------------------------+---------+--------+-----+
>  +-------- +-------------------------+---------+--------+-----+
>  | PDU hdr |    payload - seg 3      | TCP hdr | IP hdr | eth |
>  +---------+-------------------------+---------+--------+-----+
> 
> If your hardware can extract the NVMe payload into a targeted SGL like
> you want in this set, then it has some logic for parsing headers and
> "snapping" an SGL to a new element. ie., it already knows 'prev data'
> goes with the in-progress PDU, sees more data, recognizes a new PDU
> header and a new payload. That means it already has to handle a
> 'snap-to-PDU' style argument where the end of the payload closes out an
> SGL element and the next PDU hdr starts in a new SGL element (ie., 'prev
> data' closes out sgl[i], and the next PDU hdr starts sgl[i+1]). So in
> this case, you want 'snap-to-PDU' but that could just as easily be 'no
> snap at all', just a byte stream and filling an SGL after the protocol
> headers.
> 
> Key point here is that this is the start of a generic header / data
> split that could work for other applications - not just NVMe. eth/IP/TCP
> headers are consumed by the Linux networking stack; data is in
> application owned, socket based SGLs to avoid copies.
> 

I think that the interface we created (tcp_ddp) is sufficiently generic
for the task at hand, which is offloading protocols that can re-order
their responses, a non-trivial task that we claim is important.

We designed it to support other protocols and not just nvme-tcp,
which is merely an example. For instance, I think that supporting iSCSI
would be natural, and that other protocols will fit nicely.

> ###
> 
> A dump of other comments about this patch set:

Thanks for reviewing! We will fix and resubmit.

> - there are a LOT of unnecessary typecasts around tcp_ddp_ctx that can
> be avoided by using container_of.
> 
> - you have an accessor tcp_ddp_get_ctx but no setter; all uses of
> tcp_ddp_get_ctx are within mlx5. why open code the set but use the
> accessor for the get? Worse, mlx5e_nvmeotcp_queue_teardown actually has
> both — uses the accessor and open codes setting icsk_ulp_ddp_data.
> 
> - the driver is storing private data on the socket. Nothing about the
> socket layer cares and the mlx5 driver is already tracking that data in
> priv->nvmeotcp->queue_hash. As I mentioned in a previous response, I
> understand the socket ops are needed for the driver level to call into
> the socket layer, but the data part does not seem to be needed.

The socket layer does care: the socket wouldn't disappear under the
driver as it will clean things up and call the driver before the socket
disappears. This part is similar to what we have in tls where
drivers store some private data per-socket to assist offload.

> 
> - nvme_tcp_offload_socket and nvme_tcp_offload_limits both return int
> yet the value is ignored
> 

This is on purpose. Users can know whether it is successful or not using
ethtool counters of the NIC. Offload is opportunistic and its failure
is non-fatal, and as nvme-tcp has no stats we intentionally ignore the
returned values for now.

> - the build robot found a number of problems (it pulls my github tree
> and I pushed this set to it to move across computers).
> 
> I think the patch set would be easier to follow if you restructured the
> patches to 1 thing only per patch -- e.g., split patch 2 into netdev
> bits and socket bits. Add the netdev feature bit and operations in 1
> patch and add the socket ops in a second patch with better commit logs
> about why each is needed and what is done.
> 
