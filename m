Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77531127205
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 01:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfLTAI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 19:08:29 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:52250 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfLTAI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 19:08:29 -0500
Received: by mail-pj1-f68.google.com with SMTP id w23so3278262pjd.2
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 16:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X1FrBWT1p24x6uHFsr9hhNO3xRgVrIbhvVHS+TyU1LM=;
        b=HoCarn20yXBR8LN/DFVUaJyIhL0Pd6BLLx2dh+tkEwkX4wGKfIOc+LhcGAVwrmu8zL
         znPZjrGBboz9j9K6kulBB4fqtA1ZjwwAc2ekl5hEndleZbwspYWc0PDb2CQ46UvRJrpq
         hJFQnuD8+WwTJtrhxrqn4EV92t4a5Qx3In8BRF2iH1NBuxaUuJXzCHS8UfTtlPNU9WMo
         1MaBlFboMDm9oy9IYQ5PSqmEjf/bTx56n/9IUiqoG65uiTREjLNkndqFwXCK2Tg0F53O
         CjXpGKb27hYV6Y5Ln0FaA8toF7NgDLO4frQtej7ZnR1CFXhwP0TPhnjXFR4+rfvrCmaO
         whfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X1FrBWT1p24x6uHFsr9hhNO3xRgVrIbhvVHS+TyU1LM=;
        b=eCzuzCpY66Jt7149oevCV6s+ARML5PLcR8kTi1Nd8N/uSt+lW86zjTcba2W16ZIMcj
         8y2on7aG5GQt+xil/tDlPY8ouSzwTxs4RxGUw5BYwlsiJSez2OUwJC1J9PAEH1L3Znrv
         iBFHzxrnDffwsUyG1W6p4mAmAjdSq1aB0i8TU8zM7bxRyF1GHV6yufkH39HtT1rAeVD1
         kFDRAJNpGkTTqZTvMZSOnQhlXcGE5jsO/aa+1d59LjOMgx5jrIegZmciGxSIHL0NVgmN
         YcYQei8q1S2kHNwAtklYF06eX2yBNVxy3e4rbK18SdVeHnG+FaKitlScsczoxPxYyxpa
         6z2g==
X-Gm-Message-State: APjAAAW3K590T2NQnvgS03rJy3eEI9dvlQ9Kk5aOE/naXH9UmtblheQl
        6l6lbUOBlgtW+wy/ns2HZdo=
X-Google-Smtp-Source: APXvYqwR7Be3TeXX8IbUcKztjTnLxNdzJoLAYADOSPZ19sXokOHRn9TfZ2euhzGNNECWIoyjoCSYbA==
X-Received: by 2002:a17:902:b901:: with SMTP id bf1mr11874897plb.283.1576800508330;
        Thu, 19 Dec 2019 16:08:28 -0800 (PST)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id i4sm8167347pjd.19.2019.12.19.16.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 16:08:27 -0800 (PST)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon> <87fthh6ehg.fsf@toke.dk>
 <20191218181944.3ws2oy72hpyxshhb@ast-mbp.dhcp.thefacebook.com>
 <35a07230-3184-40bf-69ff-852bdfaf03c6@gmail.com> <874kxw4o4r.fsf@toke.dk>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <5eb791bf-1876-0b4b-f721-cb3c607f846c@gmail.com>
Date:   Fri, 20 Dec 2019 09:07:24 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <874kxw4o4r.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note: Resending my last response. It was not delivered to netdev list
due to some problem.

On 12/19/19 7:15 PM, Toke Høiland-Jørgensen wrote:
> Prashant Bhole <prashantbhole.linux@gmail.com> writes:
> 
>> On 12/19/19 3:19 AM, Alexei Starovoitov wrote:
>>> On Wed, Dec 18, 2019 at 12:48:59PM +0100, Toke Høiland-Jørgensen wrote:
>>>> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
>>>>
>>>>> On Wed, 18 Dec 2019 17:10:47 +0900
>>>>> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
>>>>>
>>>>>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
>>>>>> +			 struct xdp_frame *frame)
>>>>>> +{
>>>>>> +	struct bpf_prog *xdp_prog;
>>>>>> +	struct tun_page tpage;
>>>>>> +	struct xdp_buff xdp;
>>>>>> +	u32 act = XDP_PASS;
>>>>>> +	int flush = 0;
>>>>>> +
>>>>>> +	xdp_prog = rcu_dereference(tun->xdp_tx_prog);
>>>>>> +	if (xdp_prog) {
>>>>>> +		xdp.data_hard_start = frame->data - frame->headroom;
>>>>>> +		xdp.data = frame->data;
>>>>>> +		xdp.data_end = xdp.data + frame->len;
>>>>>> +		xdp.data_meta = xdp.data - frame->metasize;
>>>>>
>>>>> You have not configured xdp.rxq, thus a BPF-prog accessing this will crash.
>>>>>
>>>>> For an XDP TX hook, I want us to provide/give BPF-prog access to some
>>>>> more information about e.g. the current tx-queue length, or TC-q number.
>>>>>
>>>>> Question to Daniel or Alexei, can we do this and still keep BPF_PROG_TYPE_XDP?
>>>>> Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
>>>>> for XDP TX-hook ?
>>>>
>>>> I think a new program type would make the most sense. If/when we
>>>> introduce an XDP TX hook[0], it should have different semantics than the
>>>> regular XDP hook. I view the XDP TX hook as a hook that executes as the
>>>> very last thing before packets leave the interface. It should have
>>>> access to different context data as you say, but also I don't think it
>>>> makes sense to have XDP_TX and XDP_REDIRECT in an XDP_TX hook. And we
>>>> may also want to have a "throttle" return code; or maybe that could be
>>>> done via a helper?
>>>>
>>>> In any case, I don't think this "emulated RX hook on the other end of a
>>>> virtual device" model that this series introduces is the right semantics
>>>> for an XDP TX hook. I can see what you're trying to do, and for virtual
>>>> point-to-point links I think it may make sense to emulate the RX hook of
>>>> the "other end" on TX. However, form a UAPI perspective, I don't think
>>>> we should be calling this a TX hook; logically, it's still an RX hook
>>>> on the receive end.
>>>>
>>>> If you guys are up for evolving this design into a "proper" TX hook (as
>>>> outlined above an in [0]), that would be awesome, of course. But not
>>>> sure what constraints you have on your original problem? Do you
>>>> specifically need the "emulated RX hook for unmodified XDP programs"
>>>> semantics, or could your problem be solved with a TX hook with different
>>>> semantics?
>>>
>>> I agree with above.
>>> It looks more like existing BPF_PROG_TYPE_XDP, but attached to egress
>>> of veth/tap interface. I think only attachment point makes a difference.
>>> May be use expected_attach_type ?
>>> Then there will be no need to create new program type.
>>> BPF_PROG_TYPE_XDP will be able to access different fields depending
>>> on expected_attach_type. Like rx-queue length that Jesper is suggesting
>>> will be available only in such case and not for all BPF_PROG_TYPE_XDP progs.
>>> It can be reduced too. Like if there is no xdp.rxq concept for egress side
>>> of virtual device the access to that field can disallowed by the verifier.
>>> Could you also call it XDP_EGRESS instead of XDP_TX?
>>> I would like to reserve XDP_TX name to what Toke describes as XDP_TX.
>>>
>>
>>   From the discussion over this set, it makes sense to have new type of
>> program. As David suggested it will make a way for changes specific
>> to egress path.
>> On the other hand, XDP offload with virtio-net implementation is based
>> on "emulated RX hook". How about having this special behavior with
>> expected_attach_type?
> 
> Another thought I had re: this was that for these "special" virtual
> point-to-point devices we could extend the API to have an ATTACH_PEER
> flag. So if you have a pair of veth devices (veth0,veth1) connecting to
> each other, you could do either of:
> 
> bpf_set_link_xdp_fd(ifindex(veth0), prog_fd, 0);
> bpf_set_link_xdp_fd(ifindex(veth1), prog_fd, ATTACH_PEER);
> 
> to attach to veth0, and:
> 
> bpf_set_link_xdp_fd(ifindex(veth1), prog_fd, 0);
> bpf_set_link_xdp_fd(ifindex(veth0), prog_fd, ATTACH_PEER);
> 
> to attach to veth0.
> 
> This would allow to attach to a device without having the "other end"
> visible, and keep the "XDP runs on RX" semantics clear to userspace.
> Internally in the kernel we could then turn the "attach to peer"
> operation for a tun device into the "emulate on TX" thing you're already
> doing?
> 
> Would this work for your use case, do you think?
> 
> -Toke
> 

This is nice from UAPI point of view. It may work for veth case but
not for XDP offload with virtio-net. Please see the sequence when
a user program in the guest wants to offload a program to tun.

* User program wants to loads the program by setting offload flag and
   ifindex:

- map_offload_ops->alloc()
   virtio-net sends map info to qemu and it creates map on the host.
- prog_offload_ops->setup()
   New callback just to have a copy of unmodified program. It contains
   original map fds. We replace map fds with fds from the host side.
   Check the program for unsupported helpers calls.
- prog_offload_ops->finalize()
   Send the program to qemu and it loads the program to the host.

* User program calls bpf_set_link_xdp_fd()
   virtio-net handles XDP_PROG_SETUP_HW by sending a request to qemu.
   Qemu then attaches host side program fd to respective tun device by
   calling bpf_set_link_xdp_fd()

In above sequence there is no chance to use.

Here is how other ideas from this discussion can be used:

- Introduce BPF_PROG_TYPE_TX_XDP for egress path. Have a special
   behavior of emulating RX XDP using expected_attach_type flag.
- The emulated RX XDP will be restrictive in terms of helper calls.
- In offload case qemu will load the program BPF_PROG_TYPE_TX_XDP and
   set expected_attach_type.

What is your opinion about it? Does the driver implementing egress
XDP needs to know what kind of XDP program it is running?

Thanks,
Prashant
