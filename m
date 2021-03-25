Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BF6349B18
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 21:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhCYUi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 16:38:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhCYUiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 16:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616704693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2idg2hYEUbS7NknKTmMx0iTlWdrHDmpOpAozW5wF0Z4=;
        b=SUQqT6TwCZA3cvqpogec05lx2RlrimxqgFMPyWcLyv/Xty4couytN5/kqYKtxC4xE+H6MD
        p1jTTRxfHsVku8CPvzyoPVyJyz4y/HpcDxmLre4Z8m+5NjuXcmT/F+OZKQMIMaToacsYLv
        +me2JrkjcKs499PK1XaomZ536XJidd0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-G5SDXj79ODuX6X1Y5CpQPw-1; Thu, 25 Mar 2021 16:38:11 -0400
X-MC-Unique: G5SDXj79ODuX6X1Y5CpQPw-1
Received: by mail-ed1-f69.google.com with SMTP id o24so3267063edt.15
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 13:38:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2idg2hYEUbS7NknKTmMx0iTlWdrHDmpOpAozW5wF0Z4=;
        b=rWj9I54yH/HQy2yYO5HnKrrnkPAgmPg11rPOPLSmWelTnjuCA0TFsoNh1gh513HfU0
         WLurRBslFbx/bu79GOEXRdl0aJhK77yQ0VufIEyG6ko1f1knvk5EhOGj0uRRMH0h0GZJ
         HLkvf5oFLFeEVBN7TNB9WnqCKMHVLuW9kGfptxWxAfM1pLDSelPZhYdqGbfqDUsPvvc9
         8H1zSYAYgMd/UT1VJul/qcOCrC8lbIurCQjmbSicezi0dgH8bVtLGNKvvPA3qP/U2bUk
         wY7uW5rE3lKY7PppgKCobrba035OkOu8/ViL5uSzz7719W+mgNXQMGAHL8GhLvtnz8ck
         bEyw==
X-Gm-Message-State: AOAM531xUWHgv6aWf7zzFitvQ+B4BUV1fZFuLModMfZrThbcX3fD6UXK
        FYPDDQ5nSjud7kDcBPDLswk4HqH7QQiOvWC/Bu7zgo9+qmBYGNjJa/fIK5QAj2XNEfYaNyc84Gn
        nVS7X37vVY8mu1fpD
X-Received: by 2002:a17:906:f891:: with SMTP id lg17mr11638063ejb.69.1616704690277;
        Thu, 25 Mar 2021 13:38:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx28S7/5CpPCj2FZrE/LzzESXR3by7DATWJ6z71urIFG4guCfZEmZDCAYTtVca3h89fnXfovg==
X-Received: by 2002:a17:906:f891:: with SMTP id lg17mr11638049ejb.69.1616704690103;
        Thu, 25 Mar 2021 13:38:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f9sm3222814eds.41.2021.03.25.13.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 13:38:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 12CE21801A3; Thu, 25 Mar 2021 21:38:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf 2/2] bpf/selftests: test that kernel rejects a TCP
 CC with an invalid license
In-Reply-To: <20210325183200.jzk7dvxmkn2bj5q3@kafai-mbp.dhcp.thefacebook.com>
References: <20210325154034.85346-1-toke@redhat.com>
 <20210325154034.85346-2-toke@redhat.com>
 <20210325183200.jzk7dvxmkn2bj5q3@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 25 Mar 2021 21:38:09 +0100
Message-ID: <878s6bdl5a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Thu, Mar 25, 2021 at 04:40:34PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> This adds a selftest to check that the verifier rejects a TCP CC struct_=
ops
>> with a non-GPL license. To save having to add a whole new BPF object just
>> for this, reuse the dctcp CC, but rewrite the license field before loadi=
ng.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 31 +++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>=20
>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools=
/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>> index 37c5494a0381..613cf8a00b22 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>> @@ -227,10 +227,41 @@ static void test_dctcp(void)
>>  	bpf_dctcp__destroy(dctcp_skel);
>>  }
>>=20=20
>> +static void test_invalid_license(void)
>> +{
>> +	/* We want to check that the verifier refuses to load a non-GPL TCP CC.
>> +	 * Rather than create a whole new file+skeleton, just reuse an existing
>> +	 * object and rewrite the license in memory after loading. Sine libbpf
>> +	 * doesn't expose this, we define a struct that includes the first cou=
ple
>> +	 * of internal fields for struct bpf_object so we can overwrite the ri=
ght
>> +	 * bits. Yes, this is a bit of a hack, but it makes the test a lot sim=
pler.
>> +	 */
>> +	struct bpf_object_fragment {
>> +		char name[BPF_OBJ_NAME_LEN];
>> +		char license[64];
>> +	} *obj;
> It is fragile.  A new bpf_nogpltcp.c should be created and it does
> not have to be a full tcp-cc.  A very minimal implementation with
> only .init. Something like this (uncompiled code):
>
> char _license[] SEC("license") =3D "X";
>
> void BPF_STRUCT_OPS(nogpltcp_init, struct sock *sk)
> {
> }
>
> SEC(".struct_ops")
> struct tcp_congestion_ops bpf_nogpltcp =3D {
> 	.init           =3D (void *)nogpltcp_init,
> 	.name           =3D "bpf_nogpltcp",
> };
>
> libbpf_set_print() can also be used to look for the
> the verifier log "struct ops programs must have a GPL compatible license".

Ah, thanks for the pointers! Will fix this up as well...

-Toke

