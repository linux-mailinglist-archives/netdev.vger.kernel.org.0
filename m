Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2307404D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfGXUoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:44:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44362 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728632AbfGXUoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 16:44:07 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so15875437qtg.11;
        Wed, 24 Jul 2019 13:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8x/eSrRn/1psnj5/phwk+eQNpJCLfh+q8RaLejjTrHA=;
        b=UXMT3P/XWUn1AjW3fzo0KHDuPHYpxVr5FB9Fl/0VpzJy/jcpwX1rJEzvvD8n6lO59b
         hT+DBvZ06PSIoykBmd+m6nS0CG2tFwB2HR3PCkaJAM2BPybk4NmCfelmyivFWEBdToUJ
         ZguoG//HkVu0J96YiOJINpm/IxLP+1asMVU1ruCIPl2pCFEyuHgJ0IVj61SMeqQYvB9e
         nMrlUafLJSsu6AunNh9kSJsv2uHNgK5m5md0ZKJmsXbbHkpShJHzNJBdS6GkiMz+H0/8
         GK059eztF5su5q2Tbo6ffFvcM49U2B3ViJpHzv4fxKWE7ZExPvJzuUnPfy+SyIB3MjOR
         MLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8x/eSrRn/1psnj5/phwk+eQNpJCLfh+q8RaLejjTrHA=;
        b=LxfJcgV8fv2/SCrtGoNT7/7LKifC3jzEZOfvDbXQV/ja//nz6tUZ8FA2vHdZlXr3WW
         gtcLvAC+CTwiqIFvZHWQlwqx2/tjObx2kSh9BXMiCmYbw15Bt0Zn/zx11P8XyHzXSygy
         xnurieZH+uzB80iZqKC2tIuRs51WnkmfglCmZMraRGgwEje3t3yHAMAKZMFW+5AFhKnw
         C7g/awxHpnNnSSVSpfP2iHdWo0qsR0Q1bmgDDi5XUFuEqM1KrHHMZzsyNorqq+NM93L0
         hn9IueOaVztPrW57VnK+u5bZPb9Xq0vb++MZgUn3NIzLGGw8YiXwxaxEF/78mkWPaU5d
         Ssvw==
X-Gm-Message-State: APjAAAUXxdQ7ksjhbCgAhENcCzUjEdvt8VbiUXi+p/GhxGCjM8YrIj7m
        oiD5y//JpLTspqcSGU35bmRj01nROK9zdKpFbd/KLzPb
X-Google-Smtp-Source: APXvYqxdJRfVTMxPGlW88+fQZLQAZd3KGi9sIQLZtEIOXdIwaiHi/jWWk2XBGzB7s2unuFnNJhDk8gteTHZe/WcOmx4=
X-Received: by 2002:ac8:25e7:: with SMTP id f36mr59392969qtf.139.1564001046706;
 Wed, 24 Jul 2019 13:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190723220127.1815913-1-andriin@fb.com>
In-Reply-To: <20190723220127.1815913-1-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 13:43:55 -0700
Message-ID: <CAPhsuW7e9Cf69Pc7eR5iYvSo1qDzC_qYwpasfjeU6p9ygC=QwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: silence GCC8 warning about string truncation
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 7:33 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Despite a proper NULL-termination after strncpy(..., ..., IFNAMSIZ - 1),
> GCC8 still complains about *expected* string truncation:
>
>   xsk.c:330:2: error: 'strncpy' output may be truncated copying 15 bytes
>   from a string of length 15 [-Werror=stringop-truncation]
>     strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
>
> This patch gets rid of the issue altogether by using memcpy instead.
> There is no performance regression, as strncpy will still copy and fill
> all of the bytes anyway.
>
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
