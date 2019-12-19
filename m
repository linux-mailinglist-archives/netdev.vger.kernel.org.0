Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFE812599C
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 03:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfLSCfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 21:35:44 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40526 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfLSCfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 21:35:44 -0500
Received: by mail-pf1-f195.google.com with SMTP id q8so2303097pfh.7
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 18:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NHFdPglZoqgovshuMVdQIVAx78bof4qdZjadFvy2N8Y=;
        b=pO3eOAcgc6uw20FlAf2luUKU8uVYsJOkxtT5nTQ8XCxa4OmLgUgEzUKI2TOV85mRdE
         2N8qgvGA0OIIq2dFwA+YRBDBQ/tHZfMMKR3F7K4DirhdbYu1eqWTd7cNjxMbIlbeYmFR
         CaS7OwwRrrR+Ot0+HjAmip5mSO7MINA19BbjCs0p/kyIyfRa7vijhCXJgxxZjjCghHpT
         i2ITZ3Zn2ApYM9XPnhgDgnY0zMZrKbWiOczUqUZirGJEpmKM/yYv0cOkOpwMzzIFDxzw
         D9hW30FcLxe1qDNpnTM3Vw8KIPCQ4REvnM0SgHEg0A4ujhJ9Ugt1qjjnnYPAt2Ty83qm
         bf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NHFdPglZoqgovshuMVdQIVAx78bof4qdZjadFvy2N8Y=;
        b=pRn5aFkDZ+IRVKRaeA4DbNsasy1wshxDBpB72uYQFe23OrKrt3y4FJ9es7134pCVBJ
         zuy7D4EPdn5jfyRg0XjKxnfb//NWpO3W1sKlfPZqOlZmHl6BQV6BZY78Pg0YWMiFq7Gk
         gbv9R0Buwn/rJzsdfquC3Olv+fEW/xYL+ONxuMEo3M9rqc/mwYyk33GEeHnj5mQ3IBKw
         8jyv7t3mqr+TU3P9FxcyDHli/aYnMJqq3JnMFOYiWmqnkC8KIcH6EZMKFSqLbITcsr5d
         VrGmvqdLZX1Xayy8UHTXrHo1R2pxtXGq2V6F484Hx5Jlno7+lGIWkrOBBITIHo8Th5ck
         tuZA==
X-Gm-Message-State: APjAAAUGNxps89HwBHC0bTyRjlbXVVvX+ku3h/V+By/zXBzNonG0BFYG
        1cdYF7N9d9ODdWFcSY6zSJUplBNB
X-Google-Smtp-Source: APXvYqxRXZ0yIuiy1X5nrsLQjh59+y6qVgBDPVZnPyi3CyI+LUZmcQr/SZNEy33T0TpAtMETknFK+g==
X-Received: by 2002:aa7:8098:: with SMTP id v24mr6885738pff.33.1576722943370;
        Wed, 18 Dec 2019 18:35:43 -0800 (PST)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id n2sm4860753pgn.71.2019.12.18.18.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 18:35:42 -0800 (PST)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
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
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <35a07230-3184-40bf-69ff-852bdfaf03c6@gmail.com>
Date:   Thu, 19 Dec 2019 11:34:39 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191218181944.3ws2oy72hpyxshhb@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 3:19 AM, Alexei Starovoitov wrote:
> On Wed, Dec 18, 2019 at 12:48:59PM +0100, Toke Høiland-Jørgensen wrote:
>> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
>>
>>> On Wed, 18 Dec 2019 17:10:47 +0900
>>> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
>>>
>>>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
>>>> +			 struct xdp_frame *frame)
>>>> +{
>>>> +	struct bpf_prog *xdp_prog;
>>>> +	struct tun_page tpage;
>>>> +	struct xdp_buff xdp;
>>>> +	u32 act = XDP_PASS;
>>>> +	int flush = 0;
>>>> +
>>>> +	xdp_prog = rcu_dereference(tun->xdp_tx_prog);
>>>> +	if (xdp_prog) {
>>>> +		xdp.data_hard_start = frame->data - frame->headroom;
>>>> +		xdp.data = frame->data;
>>>> +		xdp.data_end = xdp.data + frame->len;
>>>> +		xdp.data_meta = xdp.data - frame->metasize;
>>>
>>> You have not configured xdp.rxq, thus a BPF-prog accessing this will crash.
>>>
>>> For an XDP TX hook, I want us to provide/give BPF-prog access to some
>>> more information about e.g. the current tx-queue length, or TC-q number.
>>>
>>> Question to Daniel or Alexei, can we do this and still keep BPF_PROG_TYPE_XDP?
>>> Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
>>> for XDP TX-hook ?
>>
>> I think a new program type would make the most sense. If/when we
>> introduce an XDP TX hook[0], it should have different semantics than the
>> regular XDP hook. I view the XDP TX hook as a hook that executes as the
>> very last thing before packets leave the interface. It should have
>> access to different context data as you say, but also I don't think it
>> makes sense to have XDP_TX and XDP_REDIRECT in an XDP_TX hook. And we
>> may also want to have a "throttle" return code; or maybe that could be
>> done via a helper?
>>
>> In any case, I don't think this "emulated RX hook on the other end of a
>> virtual device" model that this series introduces is the right semantics
>> for an XDP TX hook. I can see what you're trying to do, and for virtual
>> point-to-point links I think it may make sense to emulate the RX hook of
>> the "other end" on TX. However, form a UAPI perspective, I don't think
>> we should be calling this a TX hook; logically, it's still an RX hook
>> on the receive end.
>>
>> If you guys are up for evolving this design into a "proper" TX hook (as
>> outlined above an in [0]), that would be awesome, of course. But not
>> sure what constraints you have on your original problem? Do you
>> specifically need the "emulated RX hook for unmodified XDP programs"
>> semantics, or could your problem be solved with a TX hook with different
>> semantics?
> 
> I agree with above.
> It looks more like existing BPF_PROG_TYPE_XDP, but attached to egress
> of veth/tap interface. I think only attachment point makes a difference.
> May be use expected_attach_type ?
> Then there will be no need to create new program type.
> BPF_PROG_TYPE_XDP will be able to access different fields depending
> on expected_attach_type. Like rx-queue length that Jesper is suggesting
> will be available only in such case and not for all BPF_PROG_TYPE_XDP progs.
> It can be reduced too. Like if there is no xdp.rxq concept for egress side
> of virtual device the access to that field can disallowed by the verifier.
> Could you also call it XDP_EGRESS instead of XDP_TX?
> I would like to reserve XDP_TX name to what Toke describes as XDP_TX.
> 

 From the discussion over this set, it makes sense to have new type of
program. As David suggested it will make a way for changes specific
to egress path.
On the other hand, XDP offload with virtio-net implementation is based
on "emulated RX hook". How about having this special behavior with
expected_attach_type?

Thanks,
Prashant
