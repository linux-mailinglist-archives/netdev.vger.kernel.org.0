Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A30A146005
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 01:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgAWAlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 19:41:07 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38893 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWAlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 19:41:07 -0500
Received: by mail-lj1-f194.google.com with SMTP id w1so1206661ljh.5;
        Wed, 22 Jan 2020 16:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0QBEXCnWugFPxvxg/FY6E4hQni5i1IE/AZyhiO8JFt8=;
        b=Ke78RNhOpFWziu/Jz39ig6DJG3rz6VC25pOVAWgjIqDO3nWH8sqawCMALgqWzo8jW9
         UCd6YzkDRJweFhyXDofFkmes5arwCrmu9HREl3fvkzHkA29bnX9XQGX3O4uVYqbpYpd4
         OzWCIpE56XDkUnQCAXYe9+7Ik2amm3HeQIphdi4e8PQtUGdhFkIf6YlVlSj1GBzMR469
         BkdhDC8p4Z7oBS840WL6t6vqvh4nurEaeA9zPV5HJCNnGv5loyRnVqHMFPbNndCojaz2
         zQeGTHARxAFCfw6Pvy832qHIgEY2PoPUcH/bOBUv9cbwfkE3CPLGjaEtK6jyqxh0IbBd
         gzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0QBEXCnWugFPxvxg/FY6E4hQni5i1IE/AZyhiO8JFt8=;
        b=h682OK4YXl9Dlw7xEisEQuBlcXpcMipW67JfNlhgw/7vk0DqrrubkFXpVSFRMYAKnS
         fskQSgBX6dVKH0mIWXWgKPvnhXgQf7+e5RWSdTDXHP1EWZZXg6RnbsX8/dEZW7RA60oR
         fYV455BUP3GGaUOn6EDYnuKAqcjP9baJ0xVRJ6D0nq9TJJxuIPD2ZViy256I1jymYKCq
         qoE5Gb2p6Tjm19sdX1duyngdO6TTkghW/tlAqyTrTojVSwVbghg3XqooFRkUDHqOv2Sx
         E5knKxbK/f48gXadviDx2GFtVVz9x8Y0a3I4crE/IpLHYvMl7RmudsT0BJkEFASrad+Z
         mF8A==
X-Gm-Message-State: APjAAAUxkteSHb+36eiAM5kURWpcmzaFwnJ5hJJSajDxV24GZLczN75h
        ECKOMP+jPYF8ch2ULutUiu+DMm5EQeQepuBw/tI=
X-Google-Smtp-Source: APXvYqzIAO0p6YxnVjwGhOIGTQ7CAJ7k7GuUytPbAXvrSLNeySMowBXzrmDymKV+iw102cdMLBib6htqknNWe63eOj0=
X-Received: by 2002:a2e:990e:: with SMTP id v14mr20056638lji.23.1579740064770;
 Wed, 22 Jan 2020 16:41:04 -0800 (PST)
MIME-Version: 1.0
References: <20200122233639.903041-1-kafai@fb.com>
In-Reply-To: <20200122233639.903041-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Jan 2020 16:40:53 -0800
Message-ID: <CAADnVQJ1EWCJEiPRMMYF-m57FEGCTjPmzkx3XtF6gC=sDeNg1A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/3] bpf: tcp: Add bpf_cubic example
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 3:37 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This set adds bpf_cubic.c example.  It was separated from the
> earlier BPF STRUCT_OPS series.  Some highlights since the
> last post:
>
> 1. It is based on EricD recent fixes to the kernel tcp_cubic. [1]
> 2. The bpf jiffies reading helper is inlined by the verifier.
>    Different from the earlier version, it only reads jiffies alone
>    and does not do usecs/jiffies conversion.
> 3. The bpf .kconfig map is used to read CONFIG_HZ.
>
> [1]: https://patchwork.ozlabs.org/cover/1215066/
>
> v3:
> - Remove __weak from CONFIG_HZ in patch 3. (Andrii)

Applied. Thanks
