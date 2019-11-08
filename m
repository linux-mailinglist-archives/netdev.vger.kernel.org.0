Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A7BF5BCA
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfKHXUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:20:12 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45250 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHXUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:20:11 -0500
Received: by mail-qt1-f196.google.com with SMTP id 30so8358662qtz.12;
        Fri, 08 Nov 2019 15:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5DPLCfxYrqZoDWtkfi57iryiyhEr9b3Qer+3C1Gf8UA=;
        b=h0neZVT4wy6AePyyxZaKlOjcg8Sasr/8h216Sj0EyXPAOiX/ivEf8DHD9aAqc3wUHQ
         T3RcuSWeKdSGzGXxeD3NBFj8GS6hZGgrGsWkxyLwb32L65g1z3ZJYhYTjGR2en9dqhts
         dO+2MH0r3xgIsQhm+zjyTzTOOlY2IEVBbbwMF5lTaFMDFd/tUH5zJ3wMjQb+04KdI9Jd
         MWOOncb11lJTLsyQrFy/SnORYLdH07hUSNGPtnQ+YYO8d5Kbw8cX3lDlh4DYbKApukeq
         0rQuBET2IAv8OQn0Fi9IC2+jVs/z5xpU+e8gzoWznBAZeuHAqggLacdRLhK7iMVDbOxW
         XOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5DPLCfxYrqZoDWtkfi57iryiyhEr9b3Qer+3C1Gf8UA=;
        b=rwxFCDZdENtR07MciSooM01ivIDoyepLt/CLwAnIbD2eKnsosH3GS3bLAWPI+ksUfW
         zIAV6i26H+YDxwJ37XIsmZIpp6jBBe+481toPxHHTKK3nK9I6LcpCqfMFC1bMVpCTrLW
         cPQ4MaFnmWslWofCUQrIa/W0ymu7P7lLcaYq4rp4HTOyuFxgRZrODhneKy8d2I1/JBzH
         NH5xcpx2W6ZdKm/tZ9wWaJg0YE1Fu26FP6/8hlNBcnY4gEviHfVQvmszLAxEXOqJ4FuZ
         OT6+g8Xro8y9HfgvrQJ5DH5v+VFq7MaMVWo6Zhp+uGDrGeuXG1avYs11q836psrvMDUW
         pwVQ==
X-Gm-Message-State: APjAAAUV46M8ja2CxjnSlfcPjfCp78vgGk6lw1h5rfzUrt7UUWdHwspl
        6W+8l+ce78/DIly2U3WFj/m5aOHnvZNar//vwFY=
X-Google-Smtp-Source: APXvYqyvVKjODiYc1mEwTGjtQlZJcvH776fBZqHO3j4sKBXGjf6ueQo0nJy1Rmb+/OuzJmsJ0DMvkG9ELEC4k/l2gHk=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr13031650qtj.93.1573255210728;
 Fri, 08 Nov 2019 15:20:10 -0800 (PST)
MIME-Version: 1.0
References: <20191108042041.1549144-1-andriin@fb.com> <20191108220843.GA1449846@mini-arch>
In-Reply-To: <20191108220843.GA1449846@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 15:19:59 -0800
Message-ID: <CAEf4BzZXpEH2YaHeKya5sC6j_Pi5fnPa1DNujV4pubguw4RBRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Add support for memory-mapping BPF array maps
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 2:08 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 11/07, Andrii Nakryiko wrote:
> > This patch set adds ability to memory-map BPF array maps (single- and
> > multi-element). The primary use case is memory-mapping BPF array maps, created
> > to back global data variables, created by libbpf implicitly. This allows for
> > much better usability, along with avoiding syscalls to read or update data
> > completely.
> Just wondering: is it something that you plan to extend to other map types?

My main motivation is global data, so normal arrays are the most
important for me. If anyone has any performance-driven use cases, we
can extend others as well, if possible. Not all maps can be easily
mmap()'ed just due to nature of their data. E.g., it's hard to imagine
how hashmap can be mapped. But doing per-cpu arrays should be doable
with good kernel-userspace memory layout "contract".
