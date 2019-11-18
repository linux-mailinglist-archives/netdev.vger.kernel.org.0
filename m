Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8529100245
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 11:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfKRKVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 05:21:00 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48805 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726460AbfKRKVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 05:21:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574072458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9gTRk8TWmGYv4SNEhxACmG3LEXdYr79Wjpf/AE1pfBU=;
        b=XmAgcwIgiNMj3DS8vO3ftUUcucyfDqsL/COUYvh4GIyg4+c9MNgtj915sr2eCdWrtQvnUS
        QxxMdkZxJCJUX+8yUeIHey4gxb3IaolOjSnfEMlPklGy6DMlPaqn5x5TpPTKbKFfUYqP5J
        7neTBZvq7BTuQ1cOTyDOgYzx4umwNo0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-mEBBnUW3Ph2uKDjeN2bpjQ-1; Mon, 18 Nov 2019 05:20:57 -0500
Received: by mail-lj1-f198.google.com with SMTP id x24so3149793ljj.4
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 02:20:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ERz/I9CI1l3sQIq0X1Un/+c7T/b2sOzFUsHy8nRUyCI=;
        b=LkNRHC2pBYjWtVrVcgCTUdmr4e3nHL0Bgf0viOemcCuBAAriv9eG4uVOgW7myzAza0
         X2aw6/7RpDcN722Yth7L1IPJOfOLCYOj7iCYdwqg6OqXHsP2IayPfvykCtKirfwpft60
         6Omn2uJeEfzrtY6xJZJmzUPGj/iAuNMsS7Myqu5wghrkV+iklkH09XC1H1Qy0D/BUmOD
         pkWgoGGU1e4j7Btrsv95jVAXUL0l6jnpTg4p8GEPI/mWSx8K64+T/Yo/wgfw2/uMCjt7
         FlRGZf7jP82zlBh/4QrfLbYjIHWQTaBBKk7HxPyMXQs1wZSpCiFf1KKijJ/g8NlAS/yt
         glhQ==
X-Gm-Message-State: APjAAAVBXiMcczQQgEHaNciMzQRqZM2M+iGpXAODMT9ngiK0vNe28AZJ
        RZc8WO4xCTs21I1ymUJ1H1fkGVHF0zkXmsvQNDtIyfLfuw9ynnOzavRacpVcbCVHny0sL7Kwy/2
        A2qESSrDFgJmQe/zb
X-Received: by 2002:a2e:9a0c:: with SMTP id o12mr21237737lji.141.1574072455822;
        Mon, 18 Nov 2019 02:20:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqyejSEUc1JO4u0HBWUCkc5lFW0yYK8QIvwr2O87i6R1uLztAmYIqP3FuIb1pi08NyFJFq+f1Q==
X-Received: by 2002:a2e:9a0c:: with SMTP id o12mr21237718lji.141.1574072455603;
        Mon, 18 Nov 2019 02:20:55 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id e11sm211987lfc.27.2019.11.18.02.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 02:20:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A13818190D; Mon, 18 Nov 2019 11:20:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
In-Reply-To: <6e08f714-6284-6d0d-9cbe-711c64bf97aa@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com> <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch> <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com> <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch> <87h840oese.fsf@toke.dk> <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch> <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com> <87zhhmrz7w.fsf@toke.dk> <b2ecf3e6-a8f1-cfd9-0dd3-e5f4d5360c0b@gmail.com> <87zhhhnmg8.fsf@toke.dk> <640418c3-54ba-cd62-304f-fd9f73f25a42@gmail.com> <87blthox30.fsf@toke.dk> <c1b7ff64-6574-74c7-cd6b-5aa353ec80ce@gmail.com> <87lfsiocj5.fsf@toke.dk> <6e08f714-6284-6d0d-9cbe-711c64bf97aa@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 Nov 2019 11:20:53 +0100
Message-ID: <87k17xcwoq.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: mEBBnUW3Ph2uKDjeN2bpjQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

[... trimming the context a bit ...]

>>>> Take your example of TC rules: You were proposing a flow like this:
>>>>
>>>> Userspace TC rule -> kernel rule table -> eBPF map -> generated XDP
>>>> program
>>>>
>>>> Whereas what I mean is that we could do this instead:
>>>>
>>>> Userspace TC rule -> kernel rule table
>>>>
>>>> and separately
>>>>
>>>> XDP program -> bpf helper -> lookup in kernel rule table
>>>
>>> Thanks, now I see what you mean.
>>> You expect an XDP program like this, right?
>>>
>>> int xdp_tc(struct xdp_md *ctx)
>>> {
>>> =09int act =3D bpf_xdp_tc_filter(ctx);
>>> =09return act;
>>> }
>>=20
>> Yes, basically, except that the XDP program would need to parse the
>> packet first, and bpf_xdp_tc_filter() would take a parameter struct with
>> the parsed values. See the usage of bpf_fib_lookup() in
>> bpf/samples/xdp_fwd_kern.c
>>=20
>>> But doesn't this way lose a chance to reduce/minimize the program to
>>> only use necessary features for this device?
>>=20
>> Not necessarily. Since the BPF program does the packet parsing and fills
>> in the TC filter lookup data structure, it can limit what features are
>> used that way (e.g., if I only want to do IPv6, I just parse the v6
>> header, ignore TCP/UDP, and drop everything that's not IPv6). The lookup
>> helper could also have a flag argument to disable some of the lookup
>> features.
>
> It's unclear to me how to configure that.
> Use options when attaching the program? Something like
> $ xdp_tc attach eth0 --only-with ipv6
> But can users always determine their necessary features in advance?

That's what I'm doing with xdp-filter now. But the answer to your second
question is likely to be 'probably not', so it would be good to not have
to do this :)

> Frequent manual reconfiguration when TC rules frequently changes does
> not sound nice. Or, add hook to kernel to listen any TC filter event
> on some daemon and automatically reload the attached program?

Doesn't have to be a kernel hook; we could enhance the userspace tooling
to do it. Say we integrate it into 'tc':

- Add a new command 'tc xdp_accel enable <iface> --features [ipv6,etc]'
- When adding new rules, add the following logic:
  - Check if XDP acceleration is enabled
  - If it is, check whether the rule being added fits into the current
    'feature set' loaded on that interface.
    - If the rule needs more features, reload the XDP program to one
      with the needed additional features.
    - Or, alternatively, just warn the user and let them manually
      replace it?

> Another concern is key size. If we use the TC core then TC will use
> its hash table with fixed key size. So we cannot decrease the size of
> hash table key in this way?

Here I must admit that I'm not too familiar with the tc internals.
Wouldn't it be possible to refactor the code to either dynamically size
the hash tables, or to split them up into parts based on whatever
'feature set' is required? That might even speed up rule evaluation
without XDP acceleration?

-Toke

