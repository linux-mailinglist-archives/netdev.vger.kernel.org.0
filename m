Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8877646EC73
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbhLIQFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:05:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233176AbhLIQFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639065710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DMOLQnLQOQwX+LhsWwxzYnmW04C3MxXMPmF4Qj3Bnm4=;
        b=Si4ps0WFk9zKj2f494fUqIURMPUXUHrwgyznICYSsc7pBgYVTnb0m/bSsuqqbgI4nEgCuq
        dZtdocF1CchfjJ/QPDmYd84vwX3KaYrPpUTUjLxa2OYz+4Rcf715cu6GqgaR4nP4ZWmbaG
        6H2IJiR0G/OD8pbIKTqFFjUdxLCKa4s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-iHUpWXrYPiahRUHtN23qZA-1; Thu, 09 Dec 2021 11:01:48 -0500
X-MC-Unique: iHUpWXrYPiahRUHtN23qZA-1
Received: by mail-ed1-f70.google.com with SMTP id v22-20020a50a456000000b003e7cbfe3dfeso5658242edb.11
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 08:01:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DMOLQnLQOQwX+LhsWwxzYnmW04C3MxXMPmF4Qj3Bnm4=;
        b=e0QBRAMLyJcXWWnEUI1UjG6w4nxlTwiDGy0Yx7Pxa8TLAT4BeFGPn5x8ONzhn4IqnM
         vNyZlI3FsfOgXa+DeteTYbtdsSKDOqeX9AVTXuFupgVpf0eKUTyxXBKHsdEnpfMxw9Wl
         IKog6D490cpUQLRami//xSoY8oO02AspImDwcSc1UaMy2ONKFiOQi8Py+BGpDZ2YKqQ1
         NCcIXEW2KdKevLXJwPXDfh6HZX7gqAtJuVKEuRnu4xfNGKL4PJgRFGg7Pt+oyf8xvECa
         joXwzTjMyLK3EFtaeBUwuhazhKJMtZ/GhuXrc9bBwTuRVPYtSJi6Uep8xxzuA35ozAWR
         uysQ==
X-Gm-Message-State: AOAM5302T5KPEhfIdztjxmgR7HdAOlCs4q43Mcjrju0jWKMyaFvmmW48
        JYaQLoQCL8LNSxJlvGyM4+8Mtn2mOPTrrAKsxb9nAa06GHg8rsNxmA7fIMQpe/4SyFlAvjG0hKb
        BVtfiYToWJmI+qC4X
X-Received: by 2002:a50:d543:: with SMTP id f3mr29416768edj.56.1639065704839;
        Thu, 09 Dec 2021 08:01:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwylutzyFvKj5zJNOCt6IH1BS0Ay01kR/7iIdF3/D51uHG8DQC8wvoSNftLuhffs4oCBeqY+w==
X-Received: by 2002:a50:d543:: with SMTP id f3mr29416705edj.56.1639065704434;
        Thu, 09 Dec 2021 08:01:44 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id dp16sm184689ejc.34.2021.12.09.08.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 08:01:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0A822180471; Thu,  9 Dec 2021 17:01:42 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: RE: [PATCH bpf-next 0/8] Add support for transmitting packets using
 XDP in bpf_prog_run()
In-Reply-To: <61b153ad856bb_9795720857@john.notmuch>
References: <20211202000232.380824-1-toke@redhat.com>
 <61b153ad856bb_9795720857@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 09 Dec 2021 17:01:41 +0100
Message-ID: <871r2lydga.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> This series adds support for transmitting packets using XDP in
>> bpf_prog_run(), by enabling the xdp_do_redirect() callback so XDP progra=
ms
>> can perform "real" redirects to devices or maps, using an opt-in flag wh=
en
>> executing the program.
>>=20
>> The primary use case for this is testing the redirect map types and the
>> ndo_xdp_xmit driver operation without generating external traffic. But it
>> turns out to also be useful for creating a programmable traffic generato=
r.
>> The last patch adds a sample traffic generator to bpf/samples, which
>> can transmit up to 11.5 Mpps/core on my test machine.
>>=20
>> To transmit the frames, the new mode instantiates a page_pool structure =
in
>> bpf_prog_run() and initialises the pages with the data passed in by
>> userspace. These pages can then be redirected using the normal redirecti=
on
>> mechanism, and the existing page_pool code takes care of returning and
>> recycling them. The setup is optimised for high performance with a high
>> number of repetitions to support stress testing and the traffic generator
>> use case; see patch 6 for details.
>>=20
>> The series is structured as follows: Patches 1-2 adds a few features to
>> page_pool that are needed for the usage in bpf_prog_run(). Similarly,
>> patches 3-5 performs a couple of preparatory refactorings of the XDP
>> redirect and memory management code. Patch 6 adds the support to
>> bpf_prog_run() itself, patch 7 adds a selftest, and patch 8 adds the
>> traffic generator example to samples/bpf.
>
> Overall looks pretty good. Couple questions in the series though.

Yay! Thank you for the review! Will reply to each of those...

-Toke

