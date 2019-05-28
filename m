Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45E2CD1E
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfE1RGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:06:33 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36650 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE1RGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 13:06:33 -0400
Received: by mail-qk1-f193.google.com with SMTP id g18so1835865qkl.3;
        Tue, 28 May 2019 10:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZG+HgSvarrwF5OwHkfKyIqXqPOGoT2iGeVsxoODEAoQ=;
        b=dpPfVtcpg0pKdtA1+iO1Zeo6QSBLCLrQFuqiPYbn0W7b59LWGr/YzE1GmiX9duMd2B
         1FmuujYJAfnPlgWQ6ck2rgHnN5i+O0KJPVlyQCT9xM+kT4cww2m0mJst9cFWprTbcMe9
         BS+c9OUo1RkViKpj30EIO03ExOlhAUpPTBU2ihH8k3DhMmBPxQ9y02+Cx7jOiCsaoQ7V
         XLYRVvssyD1KOiIgEnOnjcgqZscmqrMESKhWPUCdTZUWtznAFrpYOPIm/sHa5U9E10Me
         W3RXLQETSYeewwE/ggW7MDHbfui2rIThWZ2yOLCTgBOovsqkdcYbg1dpeh/5tY0MzqO5
         VJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZG+HgSvarrwF5OwHkfKyIqXqPOGoT2iGeVsxoODEAoQ=;
        b=gYI6u+kOAA1F+0Yj9ltJ+vQp9KRqRQ1dGWqM4waUJLg53u8EqvgjxsGF/Ygy3+uaxY
         BAB0swLqF9nvwJGRS8ojrTSz1+J6P6yZksyIDx1Pg0cmqOEQQKq3m8mqd0lls/5ldo7E
         Cie5p7CKol6GkmhERsri88MvFrJNjdIthoeizSq/j4CEwHf8fgwKZLe1jYKoPujlu104
         RHIkYTcTmpzDE7gNdRECK0k5WcUD4+NFyJsPJerf9SXHxqFdUZEKvZyQYyfY73yt+V0e
         zkdGE/+vFNdr547M+b0zdgqRCKbDGAeC4BU/b/YeRidlN+V3RbD8x1WlNJ7NMXP+WnRi
         eD4Q==
X-Gm-Message-State: APjAAAUmdcL6YfO1LNK40/JecBRcqHuOQ1Illtbwl8Oh+Dv2Q4XjleLE
        LTO1EHE/lo/t2HtQUjvZzwZsePoqFgReQBy6FOhq8rL8ZJY=
X-Google-Smtp-Source: APXvYqxTuM7O4YTvuIFMdvaIwxYuA39E5SX8NMe5pW8aDcK8VnSxZkjW7cMkPYgWfSueOO0Muu/6dTaDlnZsCsB1RJM=
X-Received: by 2002:a05:620a:158c:: with SMTP id d12mr74455987qkk.33.1559063192718;
 Tue, 28 May 2019 10:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190522125353.6106-1-bjorn.topel@gmail.com> <20190522125353.6106-2-bjorn.topel@gmail.com>
 <20190522113212.68aea474@cakuba.netronome.com>
In-Reply-To: <20190522113212.68aea474@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 28 May 2019 19:06:21 +0200
Message-ID: <CAJ+HfNjFPmRuESHE0MYqQ9UUnV+szPK4du4DugUuzQJRVYWtew@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 at 20:32, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
[...]
>
> You should be able to just call install with the original flags, and
> install handler should do the right maths again to direct it either to
> drv or generic, no?
>

On a related note: I ran the test_offload.py test (thanks for pointing
that out!), and realized that my view of load flags was incorrect. To
double-check:

Given an XDP DRV capable netdev "eth0".

# ip link set dev eth0 xdp obj foo.o sec .text
# ip link set dev eth0 xdpdrv off

and

# ip link set dev eth0 xdpdrv obj foo.o sec .text
# ip link set dev eth0 xdp off

and

# ip link set dev eth0 xdpdrv obj foo.o sec .text
# ip link -force set dev eth0 xdp obj foo.o sec .text

and

# ip link set dev eth0 xdp obj foo.o sec .text
# ip link -force set dev eth0 xdpdrv obj foo.o sec .text

Should all fail. IOW, there's a distinction between explicit DRV and
auto-detected DRV? It's considered to be different flags.

Correct?

This was *not* my view. :-)


Thanks,
Bj=C3=B6rn
