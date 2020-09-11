Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFADF265E75
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 13:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgIKLB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 07:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbgIKLBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 07:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599822098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eEzg2T0c6enr/eWGZnxHCUp3/oydi5RSuwjrdD/cA9U=;
        b=ShknHyn/mL2L6p9GeG6+bowAvlx7P4qNgWuiNYrUSq9hk6FJjO8+XYqfJ4CNJjvY552Jhx
        Id9ZWhtpHcVaLkoKzeGIoymnkJir2Vn0pAXmycplieR+s90pIfE0Ofihiak3iVh5JvEDr4
        N/f8JUc2HMDQMtZSk0biShGXn1rdVQQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-xcV4fJs4NwS8cRqXZBoRrg-1; Fri, 11 Sep 2020 07:01:36 -0400
X-MC-Unique: xcV4fJs4NwS8cRqXZBoRrg-1
Received: by mail-wr1-f70.google.com with SMTP id y3so3368276wrl.21
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 04:01:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eEzg2T0c6enr/eWGZnxHCUp3/oydi5RSuwjrdD/cA9U=;
        b=U/DxYpRxNtsH7PubGxSe/KFPZXQWE1XDt0WNDJ0h7ny/qgNoM4zV1pKt/tEoOsGxfA
         tLlXf2kyw3DVjhtv7k2hl6+GvBoyr0lcf+sncDjGadEfouZHYbNZeaameUhpA1nma3kd
         aYdbKN0HqI0XDXB5IyRMfCVbtbTVoSoJBOO1udxYKopJ4DNSf1LR60Nqp7f9L1gcsS67
         KnGuVtSpKWsyNAAT1fjrrP8Pf9ecnE3vJA19HlinJJ4dLnUjkREznR1fY8FnhphrirDQ
         IrzeLqIP7IUdFMUJOk2wmB1MIIj8Xnhj4TbZrJ8JXmYfRfJehp0yt4iMz96Xv86vMvsj
         0zjg==
X-Gm-Message-State: AOAM533+YNHQdPsXCEuvDIa1MlDFJOJGSDAcRwnhaG3pRMGgDJdLgXvC
        yqw510C+A/PUIx0KrHhlPUAU3GmnAHuUI610m3YHfbc9dthf58bRX4zG3P7Ivix1AdV/+9vAOnd
        7EuWHN/3JUVgkZ0fw
X-Received: by 2002:a1c:6145:: with SMTP id v66mr1720655wmb.171.1599822095379;
        Fri, 11 Sep 2020 04:01:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwM3BfHNcabpmdvBOcrAOlm2aEokm0JjvlMdTUnLbUCGivJ2Ze6uZUWd/xwu3k9WAnNKPdp5g==
X-Received: by 2002:a1c:6145:: with SMTP id v66mr1720625wmb.171.1599822095142;
        Fri, 11 Sep 2020 04:01:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m4sm4066786wro.18.2020.09.11.04.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 04:01:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AC65E1829D4; Fri, 11 Sep 2020 13:01:33 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Adding test for arg
 dereference in extension trace
In-Reply-To: <CAEf4BzbY3zV-xYDBvCYztXOkn=MJwHxOVyAH7YRH8JH869qtDg@mail.gmail.com>
References: <20200909151115.1559418-1-jolsa@kernel.org>
 <20200909151115.1559418-2-jolsa@kernel.org>
 <CAEf4BzbY3zV-xYDBvCYztXOkn=MJwHxOVyAH7YRH8JH869qtDg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Sep 2020 13:01:33 +0200
Message-ID: <87y2lga86q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Sep 9, 2020 at 8:38 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>
>> Adding test that setup following program:
>>
>>   SEC("classifier/test_pkt_md_access")
>>   int test_pkt_md_access(struct __sk_buff *skb)
>>
>> with its extension:
>>
>>   SEC("freplace/test_pkt_md_access")
>>   int test_pkt_md_access_new(struct __sk_buff *skb)
>>
>> and tracing that extension with:
>>
>>   SEC("fentry/test_pkt_md_access_new")
>>   int BPF_PROG(fentry, struct sk_buff *skb)
>>
>> The test verifies that the tracing program can
>> dereference skb argument properly.
>>
>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Just FYI, I included this same patch in my freplace series. I didn't
change anything in the version I just resent, but I'll work with Jiri
and get an updated version of this into the next version based on your
comments here... :)

-Toke

