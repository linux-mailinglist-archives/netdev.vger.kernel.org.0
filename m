Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FCDD1736
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbfJIR5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:57:39 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33227 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfJIR5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 13:57:38 -0400
Received: by mail-lf1-f65.google.com with SMTP id y127so2351692lfc.0;
        Wed, 09 Oct 2019 10:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VFDJxX2oncZgIeluYYK4b3pRNw+GzOnNiwiBQ8YqNks=;
        b=LfZb5WSWS2BPcXPDKPOHglIke1qB3FEw520l5haDqQBm9+BroR6XHPmK9chEKM6qQ1
         ku6hj7wFGDdkPcwsksKCn8Y1lhHf5P6xmG0mUX1CWELKqhJTb27VgzIIF/irlMCz2/H0
         AXKW/NsBG4IIrducw4c8T3wtnEvVbKqiuScUnfXIDPAkecfHG/8PIPFYZgpX4VMa44an
         RwuYlUnjO6iKOTb9opvwqC+EB/Y08pfqNywhju2b7IkTgvdB0loWFJyG3j+L6ONX0AAx
         UPol+46TtUJYNbBF7VgoFXRhEs5l73weekS2D0e45Uy5wa+ep1btRKZnDIZvTA5cp1PY
         YQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VFDJxX2oncZgIeluYYK4b3pRNw+GzOnNiwiBQ8YqNks=;
        b=PxgPtLb4ao2dLrxA24xvD/bMJTzoGkUzOOYH1jdxLOYfnhEdOoKk+fcOlL0EALTq5C
         jskOHLR1LutPR0+G6q8/tHEOFBSjpjuS7XElbgp+taELRi1akXlzrAEJ/EimtSvvI1xt
         aRY8Q4Yh13BacO0+qCzZN33jAGMXZcqGoOSOZXiJ9LkJ3uRjOe/yiyM3L++nMDhH5jCW
         /Sn2Tbty2aAOujltacYa8mdUmDKVzO0Gup3yOn7ejrFYpU6uYiLIqwMhpCvSJUTYZErB
         H0JNWo0HpgtJIkXRfzRw595UBXHcdurWAAgVccjVSFxlmAt7fjSzaCeocNp46uYN7QI3
         EVwg==
X-Gm-Message-State: APjAAAVuikQX2+BbtFemrBTM4QxCPCTV5qaot8KLaD8cwMuCVwQyMqec
        nUMEzLRp76p105dZdZinpUP1Rwo6SVa+PbJDwJQ=
X-Google-Smtp-Source: APXvYqzCXb/YZPVL9782YNTT2aPGdnP9UK8RxFUY5krPHD31IwX2jOXP/4AFh9YMjpnVxWhBWTDUsTMypQXTzn81yew=
X-Received: by 2002:a19:f707:: with SMTP id z7mr2802202lfe.162.1570643856933;
 Wed, 09 Oct 2019 10:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1> <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
 <87sgo3lkx9.fsf@toke.dk> <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
 <20191009121955.29cad5bb@carbon>
In-Reply-To: <20191009121955.29cad5bb@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Oct 2019 10:57:25 -0700
Message-ID: <CAADnVQK-Pu3t6jStXCtG2gS6okrt+mt7KzzedGzx8Hf8CXLijQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 3:20 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
>
> The change Toke did in BPF_PROG_RUN does not introduce any measurable
> performance change, as least on high-end Intel CPUs.  This DOES satisfy
> 'no performance regressions' rule.

It adds extra load and branch in critical path of every program.
Including classic socket filters.
Not being able to measure the overhead in a microbenchmark
doesn't mean that overhead is not added.
Will 10 such branches be measurable?
What if they're not?
Then everyone will say: "It's not measurable in my setup, hence
I'm adding these branches".
tcp stack is even harder to measure. Yet, Eric will rightfully nack patches
that add such things when alternative solution is possible.
