Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8F25C17D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfGAQzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:55:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43074 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfGAQzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:55:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so15362570qto.10;
        Mon, 01 Jul 2019 09:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sILEXq6Wu9iDlc1DzMTSvixwyVTJNLn1BOUeBkszyrc=;
        b=Mnakk0rT2r+rqmxAEnjK7wBWqc218DU/QkKU5hRYxg9fxatQKzxnddWR6ug4EUE0fZ
         n+6Z6AfCKy6BhwmUmcOA97UX8VS984/VFiEFTX0h2hvlgo/BkGsG8bpL5CZnDOR4SyRf
         AVXGa2KI1CDJNlaQWQuwT8UJBjIC7e0eahhHEhEKBh+QsL7Cfgf993oJgUlf5LLOFqMB
         2LNOZtToNucf5KNyh+pKsmFaoR8GNT9U5Rzw/oQLU22D6MEN6fixBj7NioBhLPsqay25
         PIQWlozKdE8RaBHbzX42hSTbtMwiYy7QHpyngq26h3OxZnRAq3oxxueP7ytijXEU2xQq
         D/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sILEXq6Wu9iDlc1DzMTSvixwyVTJNLn1BOUeBkszyrc=;
        b=m89W7aokXTrz8e2IV6Y2B16SDky8HrG/AS3BMRCnOeYdKKJTulUzbbJQScSm5b9dTl
         UM7WIBRn95EAjCVT7O+EsDrds3BCQJrUYig9BO33rm8MCdYyuD9I2+dx0IOkooP1kL/k
         Xa5wdiSgCsMtG3AE5aKzEOkqB5CQqYwGhSYBu05WQZt6ymBhtHw4/TLKUTrztJOb0m4X
         1x9QBfJ4tLTdJPv2JZ/LxgMYvnEo5k2lAnqwfoMox9Qpddp54tDPwAmxmBBlWXY6rYbJ
         OfLPCSbD/rdS1/1fc0yZJBPbBEKWVRh0eUTysBmmKymXhVaBOF25dP1t5PdPqlMZx3vk
         i1Mw==
X-Gm-Message-State: APjAAAUgMSc3/Qy0PhWfgmwummcKk8/99v30mXLafxSEaudXNCHQ1vQ3
        JvaJUpALdaeFwCc/zSW4psAFiWTv19Y9R8nlqMk=
X-Google-Smtp-Source: APXvYqwcPyOL6coQTViezo8NBzkADSHh862klncDq6daIe6beGXUCsdrWc79YRmXCWkHnfsEFCIa7tlKQoK1PUKd6oU=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr20982938qty.59.1562000123308;
 Mon, 01 Jul 2019 09:55:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190701163103.237550-1-sdf@google.com> <20190701163103.237550-4-sdf@google.com>
In-Reply-To: <20190701163103.237550-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 09:55:12 -0700
Message-ID: <CAEf4BzY68ci9v8v6Wtsd6w3beetHipmHmqstsAh=_5GZ3TTKuA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] selftests/bpf: add verifier tests for
 wide stores
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 9:54 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Make sure that wide stores are allowed at proper (aligned) addresses.
> Note that user_ip6 is naturally aligned on 8-byte boundary, so
> correct addresses are user_ip6[0] and user_ip6[2]. msg_src_ip6 is,
> however, aligned on a 4-byte bondary, so only msg_src_ip6[1]
> can be wide-stored.
>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/test_verifier.c   | 17 +++++++--
>  .../selftests/bpf/verifier/wide_store.c       | 36 +++++++++++++++++++
>  2 files changed, 50 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c
>

<snip>
