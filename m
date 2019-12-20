Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19FC8127690
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 08:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLTHhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 02:37:15 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46017 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725920AbfLTHhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 02:37:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576827433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nKeo/8lL/wJWxdmtcpNgzgXK5wHA3AAahncxIZDFddg=;
        b=Go8wkaip2ve3Rpx0ExWonLDLuCIjVMnJjhoXbQCfMQY2g8IRZNqp2i5D0xbG7ELXRcKWnT
        GoZBTXUZT0ONMdwaAKKgMrRyW4YdZLBXxrtVYAStJSKu5SE7DDqea4i9u1OufFMu9zVSC5
        4TcKjA04h3ojSW3AE5r0ymbAwEJ5Bbs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-2KtvYfkjNGu3RPJIe6TavQ-1; Fri, 20 Dec 2019 02:37:06 -0500
X-MC-Unique: 2KtvYfkjNGu3RPJIe6TavQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CA4810054E3;
        Fri, 20 Dec 2019 07:37:04 +0000 (UTC)
Received: from [10.72.12.141] (ovpn-12-141.pek2.redhat.com [10.72.12.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D688963B9E;
        Fri, 20 Dec 2019 07:36:52 +0000 (UTC)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
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
 <5eb791bf-1876-0b4b-f721-cb3c607f846c@gmail.com>
 <75228f98-338e-453c-3ace-b6d36b26c51c@redhat.com>
 <3654a205-b3fd-b531-80ac-42823e089b39@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <dd1f048f-3c51-79d0-73ff-a6b0c71f7925@redhat.com>
Date:   Fri, 20 Dec 2019 15:36:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3654a205-b3fd-b531-80ac-42823e089b39@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/20 =E4=B8=8B=E5=8D=8812:46, Prashant Bhole wrote:
>
>
> On 12/20/19 12:24 PM, Jason Wang wrote:
>>
>> On 2019/12/20 =E4=B8=8A=E5=8D=888:07, Prashant Bhole wrote:
>>> Note: Resending my last response. It was not delivered to netdev list
>>> due to some problem.
>>>
>>> On 12/19/19 7:15 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Prashant Bhole <prashantbhole.linux@gmail.com> writes:
>>>>
>>>>> On 12/19/19 3:19 AM, Alexei Starovoitov wrote:
>>>>>> On Wed, Dec 18, 2019 at 12:48:59PM +0100, Toke H=C3=B8iland-J=C3=B8=
rgensen=20
>>>>>> wrote:
>>>>>>> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
>>>>>>>
>>>>>>>> On Wed, 18 Dec 2019 17:10:47 +0900
>>>>>>>> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
>>>>>>>>
>>>>>>>>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct=20
>>>>>>>>> tun_file *tfile,
>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 struct xdp_frame *frame)
>>>>>>>>> +{
>>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct bpf_prog *xdp_prog;
>>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct tun_page tpage;
>>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct xdp_buff xdp;
>>>>>>>>> +=C2=A0=C2=A0=C2=A0 u32 act =3D XDP_PASS;
>>>>>>>>> +=C2=A0=C2=A0=C2=A0 int flush =3D 0;
>>>>>>>>> +
>>>>>>>>> +=C2=A0=C2=A0=C2=A0 xdp_prog =3D rcu_dereference(tun->xdp_tx_pr=
og);
>>>>>>>>> +=C2=A0=C2=A0=C2=A0 if (xdp_prog) {
>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.data_hard_start=
 =3D frame->data - frame->headroom;
>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.data =3D frame-=
>data;
>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.data_end =3D xd=
p.data + frame->len;
>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.data_meta =3D x=
dp.data - frame->metasize;
>>>>>>>>
>>>>>>>> You have not configured xdp.rxq, thus a BPF-prog accessing this=20
>>>>>>>> will crash.
>>>>>>>>
>>>>>>>> For an XDP TX hook, I want us to provide/give BPF-prog access=20
>>>>>>>> to some
>>>>>>>> more information about e.g. the current tx-queue length, or=20
>>>>>>>> TC-q number.
>>>>>>>>
>>>>>>>> Question to Daniel or Alexei, can we do this and still keep=20
>>>>>>>> BPF_PROG_TYPE_XDP?
>>>>>>>> Or is it better to introduce a new BPF prog type (enum=20
>>>>>>>> bpf_prog_type)
>>>>>>>> for XDP TX-hook ?
>>>>>>>
>>>>>>> I think a new program type would make the most sense. If/when we
>>>>>>> introduce an XDP TX hook[0], it should have different semantics=20
>>>>>>> than the
>>>>>>> regular XDP hook. I view the XDP TX hook as a hook that executes=20
>>>>>>> as the
>>>>>>> very last thing before packets leave the interface. It should hav=
e
>>>>>>> access to different context data as you say, but also I don't=20
>>>>>>> think it
>>>>>>> makes sense to have XDP_TX and XDP_REDIRECT in an XDP_TX hook.=20
>>>>>>> And we
>>>>>>> may also want to have a "throttle" return code; or maybe that=20
>>>>>>> could be
>>>>>>> done via a helper?
>>>>>>>
>>>>>>> In any case, I don't think this "emulated RX hook on the other=20
>>>>>>> end of a
>>>>>>> virtual device" model that this series introduces is the right=20
>>>>>>> semantics
>>>>>>> for an XDP TX hook. I can see what you're trying to do, and for=20
>>>>>>> virtual
>>>>>>> point-to-point links I think it may make sense to emulate the RX=20
>>>>>>> hook of
>>>>>>> the "other end" on TX. However, form a UAPI perspective, I don't=20
>>>>>>> think
>>>>>>> we should be calling this a TX hook; logically, it's still an RX=20
>>>>>>> hook
>>>>>>> on the receive end.
>>>>>>>
>>>>>>> If you guys are up for evolving this design into a "proper" TX=20
>>>>>>> hook (as
>>>>>>> outlined above an in [0]), that would be awesome, of course. But=20
>>>>>>> not
>>>>>>> sure what constraints you have on your original problem? Do you
>>>>>>> specifically need the "emulated RX hook for unmodified XDP=20
>>>>>>> programs"
>>>>>>> semantics, or could your problem be solved with a TX hook with=20
>>>>>>> different
>>>>>>> semantics?
>>>>>>
>>>>>> I agree with above.
>>>>>> It looks more like existing BPF_PROG_TYPE_XDP, but attached to=20
>>>>>> egress
>>>>>> of veth/tap interface. I think only attachment point makes a=20
>>>>>> difference.
>>>>>> May be use expected_attach_type ?
>>>>>> Then there will be no need to create new program type.
>>>>>> BPF_PROG_TYPE_XDP will be able to access different fields dependin=
g
>>>>>> on expected_attach_type. Like rx-queue length that Jesper is=20
>>>>>> suggesting
>>>>>> will be available only in such case and not for all=20
>>>>>> BPF_PROG_TYPE_XDP progs.
>>>>>> It can be reduced too. Like if there is no xdp.rxq concept for=20
>>>>>> egress side
>>>>>> of virtual device the access to that field can disallowed by the=20
>>>>>> verifier.
>>>>>> Could you also call it XDP_EGRESS instead of XDP_TX?
>>>>>> I would like to reserve XDP_TX name to what Toke describes as=20
>>>>>> XDP_TX.
>>>>>>
>>>>>
>>>>> =C2=A0 From the discussion over this set, it makes sense to have ne=
w=20
>>>>> type of
>>>>> program. As David suggested it will make a way for changes specific
>>>>> to egress path.
>>>>> On the other hand, XDP offload with virtio-net implementation is=20
>>>>> based
>>>>> on "emulated RX hook". How about having this special behavior with
>>>>> expected_attach_type?
>>>>
>>>> Another thought I had re: this was that for these "special" virtual
>>>> point-to-point devices we could extend the API to have an ATTACH_PEE=
R
>>>> flag. So if you have a pair of veth devices (veth0,veth1)=20
>>>> connecting to
>>>> each other, you could do either of:
>>>>
>>>> bpf_set_link_xdp_fd(ifindex(veth0), prog_fd, 0);
>>>> bpf_set_link_xdp_fd(ifindex(veth1), prog_fd, ATTACH_PEER);
>>>>
>>>> to attach to veth0, and:
>>>>
>>>> bpf_set_link_xdp_fd(ifindex(veth1), prog_fd, 0);
>>>> bpf_set_link_xdp_fd(ifindex(veth0), prog_fd, ATTACH_PEER);
>>>>
>>>> to attach to veth0.
>>>>
>>>> This would allow to attach to a device without having the "other end=
"
>>>> visible, and keep the "XDP runs on RX" semantics clear to userspace.
>>>> Internally in the kernel we could then turn the "attach to peer"
>>>> operation for a tun device into the "emulate on TX" thing you're=20
>>>> already
>>>> doing?
>>>>
>>>> Would this work for your use case, do you think?
>>>>
>>>> -Toke
>>>>
>>>
>>> This is nice from UAPI point of view. It may work for veth case but
>>> not for XDP offload with virtio-net. Please see the sequence when
>>> a user program in the guest wants to offload a program to tun.
>>>
>>> * User program wants to loads the program by setting offload flag and
>>> =C2=A0 ifindex:
>>>
>>> - map_offload_ops->alloc()
>>> =C2=A0 virtio-net sends map info to qemu and it creates map on the ho=
st.
>>> - prog_offload_ops->setup()
>>> =C2=A0 New callback just to have a copy of unmodified program. It con=
tains
>>> =C2=A0 original map fds. We replace map fds with fds from the host si=
de.
>>> =C2=A0 Check the program for unsupported helpers calls.
>>> - prog_offload_ops->finalize()
>>> =C2=A0 Send the program to qemu and it loads the program to the host.
>>>
>>> * User program calls bpf_set_link_xdp_fd()
>>> =C2=A0 virtio-net handles XDP_PROG_SETUP_HW by sending a request to q=
emu.
>>> =C2=A0 Qemu then attaches host side program fd to respective tun devi=
ce by
>>> =C2=A0 calling bpf_set_link_xdp_fd()
>>>
>>> In above sequence there is no chance to use.
>>
>>
>> For VM, I think what Toke meant is to consider virtio-net as a peer=20
>> of TAP and we can do something like the following in qemu:
>>
>> bpf_set_link_xdp_fd(ifindex(tap0), prog_fd, ATTACH_PEER);
>>
>> in this case. And the behavior of XDP_TX could be kept as if the XDP=20
>> was attached to the peer of TAP (actually a virtio-net inside the=20
>> guest).
>
> I think he meant actually attaching the program to the peer. Most
> probably referring the use case I mentioned in the cover letter.


Interesting, actually this is kind of XDP offloading. In the case of=20
veth, we had some discussion with Toshiaki and I remember he said it=20
doesn't help much.

Thanks


>
> "It can improve container networking where veth pair links the host and
> the container. Host can set ACL by setting tx path XDP to the veth
> iface."
>
> Toke, Can you please clarify?
>
> Thanks!
>
>>
>> Thanks
>>
>>
>>>
>>> Here is how other ideas from this discussion can be used:
>>>
>>> - Introduce BPF_PROG_TYPE_TX_XDP for egress path. Have a special
>>> =C2=A0 behavior of emulating RX XDP using expected_attach_type flag.
>>> - The emulated RX XDP will be restrictive in terms of helper calls.
>>> - In offload case qemu will load the program BPF_PROG_TYPE_TX_XDP and
>>> =C2=A0 set expected_attach_type.
>>>
>>> What is your opinion about it? Does the driver implementing egress
>>> XDP needs to know what kind of XDP program it is running?
>>>
>>> Thanks,
>>> Prashant
>>>
>>
>

