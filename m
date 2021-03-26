Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476BF34AE86
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhCZS0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:26:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhCZS0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:26:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616783166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VHBvQNlInr7uhqwohEYYJ6fIrcun/FjuvH6xJlp8s4Y=;
        b=dQBZHk9Sjq16ZU0xSlTJvFODOJfeFiCmNSvrTBnTgPPbXjcpyKQPSucHOIbzIFOR9I5v+t
        CXV1vTc7I310Y2vDaSwpyOAl4OcU18f0NVwInbD5rJ1NOGgsAjB+EflcUL7pPD4pMAppjZ
        dWk6gBiTqIFID9jC2Z53GVAS+n4Xq9s=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-oTbJ-9bePnyHRomZYGfEtQ-1; Fri, 26 Mar 2021 14:25:55 -0400
X-MC-Unique: oTbJ-9bePnyHRomZYGfEtQ-1
Received: by mail-ed1-f71.google.com with SMTP id h2so4841711edw.10
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:25:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VHBvQNlInr7uhqwohEYYJ6fIrcun/FjuvH6xJlp8s4Y=;
        b=jLYmVNR5lid1t0MIEmeDzUWiffpgSeuyEoTcQOZbsijTWj9C+exCJBF5pD7Zg9oY3f
         j/Y1+jmp6qBqG87HvUTlS12NLB/HdUSnClhraWd2UTQ5TOj36BjBkQ6qsCGAg4xAYtJB
         6zNb2fFZ8d4GS/IZhxG1kHnovfY9UWXYiDJANKvgd2P+f3HdQrjKtx+10N81POAKQIAe
         yooOh7mHlVuVMpBbNmvB3nNThWs9QqWG5CHHDB/e/QjWY9acVQCr24XXeVCjOkiQnoLD
         M1dHq7PKb2lkOAf3YCes4yR28IB+p6zwJB+fUgMEOp6i+q8vxfIlNLSKC8RoA/10U8+7
         SK+g==
X-Gm-Message-State: AOAM5313/fwqq0pEcd875KP75GNXCfs3EMkjCY3npT/lvk/BvIIwrf9N
        YRgEUw3S+ePZLwU9CahGrU7fGCxWNOO0mTNIxu9RVjJnllvpSD7h8/NdYzjk/ndSS8BOMUY95kl
        52G2x7sDgC+axeeYm
X-Received: by 2002:a50:ee10:: with SMTP id g16mr16193142eds.215.1616783154409;
        Fri, 26 Mar 2021 11:25:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwo9q1onPVZDjx15tDzJWa1xccA2pTrcCh71KUTRxb9IqNa6T+h3JwEblXu5DFP0NGTrT/j0w==
X-Received: by 2002:a50:ee10:: with SMTP id g16mr16193124eds.215.1616783154277;
        Fri, 26 Mar 2021 11:25:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gn19sm3987476ejc.4.2021.03.26.11.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 11:25:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0B61D1801A3; Fri, 26 Mar 2021 19:25:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf v2 2/2] bpf/selftests: test that kernel rejects a
 TCP CC with an invalid license
In-Reply-To: <CAEf4BzaucswGy+LiXQC0q_zgQEOTtRJ3GQtaeq7CwJJW9EzGig@mail.gmail.com>
References: <20210325211122.98620-1-toke@redhat.com>
 <20210325211122.98620-2-toke@redhat.com>
 <CAEf4BzaxmrWFBJ1mzzWzu0yb_iFX528cAFVbXrncPEaJBXrd2A@mail.gmail.com>
 <87lfaacks9.fsf@toke.dk>
 <CAEf4BzaucswGy+LiXQC0q_zgQEOTtRJ3GQtaeq7CwJJW9EzGig@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Mar 2021 19:25:53 +0100
Message-ID: <874kgxbwlq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:


>> Ah, thanks! I always get confused about CHECK() as well! Maybe it should
>> be renamed to ASSERT()? But that would require flipping all the if()
>> statements around them as well :/
>
> Exactly, it's the opposite of assert (ASSERT_NOT %-), that
> CHECK(!found) is "assert not not found", right?) and it throws me off
> every. single. time.

Yup, me too, I have to basically infer the right meaning from the
surrounding if statements (i.e., whether it triggers an error path or
not).

> Ideally we complete the set of ASSERT_XXX() macros and convert as much
> as possible to that. We can also have just generic ASSERT() for all
> other complicated cases.

Totally on board with that! I'll try to remember to fix any selftests I
fiddle with (and not introduce any new uses of CHECK() of course).

-Toke

