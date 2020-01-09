Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D56136042
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 19:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388508AbgAIShl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 13:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgAIShl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 13:37:41 -0500
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8775F2072E;
        Thu,  9 Jan 2020 18:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578595060;
        bh=AWXr9TAHgl3A++gRuJ+T9npWU4essRmA3mnfkKG1qvw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uhHNufr3hu5SCPTE7cjw0NA4hCDxiRow/r3KHLVBCzCO5mjZ7RIiuYkBasS9Ij1df
         Dv3QcbZqwabpklhWU6rOSsKkV6x9u1p1GtI5O2Kx+2+DI0XAin412EEO/BZdZ/wsyd
         asVbRO7/fyrp3ipFitf2Vl1G8DeN9oynZLLJ9c4I=
Received: by mail-qt1-f175.google.com with SMTP id g1so6660798qtr.13;
        Thu, 09 Jan 2020 10:37:40 -0800 (PST)
X-Gm-Message-State: APjAAAXeuILqAJoMgrVEf+RodLvVKoJ86rVk53Fop8XA3Jy2KD2rthft
        lvIvqTEtOHPMtHovVoHKQO6NXNIQw3JbPJo4DEc=
X-Google-Smtp-Source: APXvYqzRcyX/P/2RFqjAPRRJEmg/ICmY619JfUoJ4KfvchBl5iE7AZsl/2VQYqwqQqdntG4OJ6z/zB/lyAUyWQI+AX8=
X-Received: by 2002:aed:21b6:: with SMTP id l51mr9299539qtc.22.1578595059706;
 Thu, 09 Jan 2020 10:37:39 -0800 (PST)
MIME-Version: 1.0
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2> <157851809847.1732.8255673984543824278.stgit@ubuntu3-kvm2>
In-Reply-To: <157851809847.1732.8255673984543824278.stgit@ubuntu3-kvm2>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Jan 2020 10:37:28 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4kjsDehABaN9JWegfNcu2J3u2K+=0vbxZQCO8172gQMg@mail.gmail.com>
Message-ID: <CAPhsuW4kjsDehABaN9JWegfNcu2J3u2K+=0vbxZQCO8172gQMg@mail.gmail.com>
Subject: Re: [bpf PATCH 4/9] bpf: sockmap, skmsg helper overestimates push,
 pull, and pop bounds
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 1:15 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> In the push, pull, and pop helpers operating on skmsg objects to make
> data writable or insert/remove data we use this bounds check to ensure
> specified data is valid,
>
>  /* Bounds checks: start and pop must be inside message */
>  if (start >= offset + l || last >= msg->sg.size)
>      return -EINVAL;
>
> The problem here is offset has already included the length of the
> current element the 'l' above. So start could be past the end of
> the scatterlist element in the case where start also points into an
> offset on the last skmsg element.
>
> To fix do the accounting slightly different by adding the length of
> the previous entry to offset at the start of the iteration. And
> ensure its initialized to zero so that the first iteration does
> nothing.
>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Fixes: 6fff607e2f14b ("bpf: sk_msg program helper bpf_msg_push_data")
> Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

This is pretty tricky... But it looks right.

Acked-by: Song Liu <songliubraving@fb.com>
