Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C1EF5C6B
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfKIAmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:42:55 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37882 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfKIAmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 19:42:53 -0500
Received: by mail-qt1-f193.google.com with SMTP id g50so8648181qtb.4;
        Fri, 08 Nov 2019 16:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4J4w1SEE54AqDXNfUf21/fjI9lr1KuVau2TR9nWF9dY=;
        b=muOSZOj2KR5L8qgj/6v2h5U1ryVbfMRvI9twvUdiZ1yjgQOWGIc9xB67o5K5Uwyg7K
         yoa1kGco2QE+bhAA9LpJ8ar+LhO/ERA2jpNeQ8LUQh/JGMKo2oOnaRFrcxSqvyU4jlC4
         YHaIdscN/J75Ykj5tN2ud/DQdyHoxIgx/otqtFzhM+NQXXzm1Ihd6hAaS6tLXM/qTKtR
         1WkgAw+oxq6FguSTcS0x32ldgdkJZI4ZpN8RHLphdFi0kYzMDH9jgZuof8v/h1YPoD3x
         ynPYBdoOL6dE5yL9kSZoCWi8PUjspDzKDbmxjpHm47PfLAFZSP2Kbrhj7HROSA1EeQ/a
         BO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4J4w1SEE54AqDXNfUf21/fjI9lr1KuVau2TR9nWF9dY=;
        b=iUpjgIrbpuwd/0kyBcz8y4RHl15Ej+piDcEf+8c9oMSui+h0Iei9x2zIovxo2Q7KKt
         QQ0JmtrETpoxoBcBj6qU35JLCZtkRIwc65gdSA70k66ZZTN3HJvJBtxpkUR8727e51Cg
         3rqQwr6Y9iAI2fhmmk9cFKUZcWc/wJbSI7GQ+Hr/2ybsf1Dy/C6Xr1VXVXFn0t7Wi3Lv
         QPTL9msSYezC+HDfq3mBnvwOvC5VeaV1nbjaD9+0lS5NMt2p4bf4N8pha9/TQImmbsID
         JAYj6sHQedn9AwEfo86WHzaDTPBqN54qWAxNrbQFT4MLL/00CuXTZ87HTpTHwmbBId5N
         zMmg==
X-Gm-Message-State: APjAAAUdcv3hCL7lh3Yps+GNF04hKm9lp8/mM5nY8KCZdo22j+5hrGot
        /zfNkPqnUirhKXhi2SRAZCwerPsiW+4dl+6+3dg=
X-Google-Smtp-Source: APXvYqxhsCS9nQXouT/9vI/4moTna50swr1GLjFRutvJWzvaVu0xzgpsD/choFbMmQ4LO9THk5xq/LxuGT1OOstT0Qw=
X-Received: by 2002:ac8:3fed:: with SMTP id v42mr13977804qtk.171.1573260172294;
 Fri, 08 Nov 2019 16:42:52 -0800 (PST)
MIME-Version: 1.0
References: <157325765467.27401.1930972466188738545.stgit@toke.dk> <157325765579.27401.11576433476621158813.stgit@toke.dk>
In-Reply-To: <157325765579.27401.11576433476621158813.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 16:42:41 -0800
Message-ID: <CAEf4Bzb9_1SUQSjiGfc6F-eybMrXBm7p90zauKtgBxj0SZPTog@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/6] libbpf: Unpin auto-pinned maps if loading fails
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 4:00 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Since the automatic map-pinning happens during load, it will leave pinned
> maps around if the load fails at a later stage. Fix this by unpinning any
> pinned maps on cleanup. To avoid unpinning pinned maps that were reused
> rather than newly pinned, add a new boolean property on struct bpf_map to
> keep track of whether that map was reused or not; and only unpin those ma=
ps
> that were not reused.
>
> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF o=
bjects")
> Acked-by: David S. Miller <davem@davemloft.net>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
