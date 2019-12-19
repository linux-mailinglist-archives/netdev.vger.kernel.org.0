Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620291259A4
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 03:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfLSCpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 21:45:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51753 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726463AbfLSCpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 21:45:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576723531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNaMnyaq3n9iJzIZP0DV10FdjF78BU1Q4F93AShPzpE=;
        b=D1YOo6O4QpX5hejcIbwJokw1HoCYEz9TTdAq5A5oxlE04qnqIPry1BUSh3CFnchAXJ3RvB
        Rvpt+rNvWFongmzKE2pYoIl77HWQ1Q5+bAuNbf+S7+WXYRWMZbK1lsU1hTIl9Uk0FTKveu
        MEW5ZnL3RYIade4le+reXtfb07mYPlw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-uNC0AKX3O8OWzH1odTaavQ-1; Wed, 18 Dec 2019 21:45:28 -0500
X-MC-Unique: uNC0AKX3O8OWzH1odTaavQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73881801A2B;
        Thu, 19 Dec 2019 02:45:25 +0000 (UTC)
Received: from [10.72.12.74] (ovpn-12-74.pek2.redhat.com [10.72.12.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F287F60BBA;
        Thu, 19 Dec 2019 02:44:35 +0000 (UTC)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>, Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
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
 <65eb61c0-61a6-02d1-6c7c-f950d1d037be@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f1393726-9d0a-ae49-7af1-5aafa0f6b6d2@redhat.com>
Date:   Thu, 19 Dec 2019 10:44:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <65eb61c0-61a6-02d1-6c7c-f950d1d037be@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/19 =E4=B8=8A=E5=8D=8812:33, David Ahern wrote:
> On 12/18/19 4:48 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
>>
>>> On Wed, 18 Dec 2019 17:10:47 +0900
>>> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
>>>
>>>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *t=
file,
>>>> +			 struct xdp_frame *frame)
>>>> +{
>>>> +	struct bpf_prog *xdp_prog;
>>>> +	struct tun_page tpage;
>>>> +	struct xdp_buff xdp;
>>>> +	u32 act =3D XDP_PASS;
>>>> +	int flush =3D 0;
>>>> +
>>>> +	xdp_prog =3D rcu_dereference(tun->xdp_tx_prog);
>>>> +	if (xdp_prog) {
>>>> +		xdp.data_hard_start =3D frame->data - frame->headroom;
>>>> +		xdp.data =3D frame->data;
>>>> +		xdp.data_end =3D xdp.data + frame->len;
>>>> +		xdp.data_meta =3D xdp.data - frame->metasize;
>>> You have not configured xdp.rxq, thus a BPF-prog accessing this will =
crash.
>>>
>>> For an XDP TX hook, I want us to provide/give BPF-prog access to some
>>> more information about e.g. the current tx-queue length, or TC-q numb=
er.
>>>
>>> Question to Daniel or Alexei, can we do this and still keep BPF_PROG_=
TYPE_XDP?
>>> Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
>>> for XDP TX-hook ?
>> I think a new program type would make the most sense. If/when we
>> introduce an XDP TX hook[0], it should have different semantics than t=
he
>> regular XDP hook. I view the XDP TX hook as a hook that executes as th=
e
>> very last thing before packets leave the interface. It should have
>> access to different context data as you say, but also I don't think it
>> makes sense to have XDP_TX and XDP_REDIRECT in an XDP_TX hook. And we
>> may also want to have a "throttle" return code; or maybe that could be
>> done via a helper?
> XDP_TX does not make sense in the Tx path. Jason questioned whether
> XDP_RX makes sense. There is not a clear use case just yet.


XDP_RX can chain TX XDP program and RX XDP program on the same interface.

Thanks


>
> REDIRECT is another one that would be useful as you point out below.
>
> A new program type would allow support for these to be added over time
> and not hold up the ability to do XDP_DROP in the Tx path.
>
>> In any case, I don't think this "emulated RX hook on the other end of =
a
>> virtual device" model that this series introduces is the right semanti=
cs
>> for an XDP TX hook. I can see what you're trying to do, and for virtua=
l
>> point-to-point links I think it may make sense to emulate the RX hook =
of
>> the "other end" on TX. However, form a UAPI perspective, I don't think
>> we should be calling this a TX hook; logically, it's still an RX hook
>> on the receive end.
>>
>> If you guys are up for evolving this design into a "proper" TX hook (a=
s
>> outlined above an in [0]), that would be awesome, of course. But not
>> sure what constraints you have on your original problem? Do you
>> specifically need the "emulated RX hook for unmodified XDP programs"
>> semantics, or could your problem be solved with a TX hook with differe=
nt
>> semantics?
>>
>> -Toke
>>
>>
>> [0] We've suggested this in the past, see
>> https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org=
#xdp-hook-at-tx
>>

