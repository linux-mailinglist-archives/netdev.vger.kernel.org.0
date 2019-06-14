Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B9146477
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfFNQjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:39:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37381 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfFNQjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 12:39:01 -0400
Received: by mail-qt1-f196.google.com with SMTP id y57so3202456qtk.4;
        Fri, 14 Jun 2019 09:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RUt9ZIAlHql3ePIp61CeWNBm915VyMPtcG9oqOy2n3s=;
        b=bPYxao5jSuP5FMLWnrcirDCo/l03moqmQ72TRfJYZ9AxIExYFPau6dznXulVYHHc3J
         GpDtsni8PLA7zWoGSHPAFFhHxPPqMTIg71l+deHv3/FMl/oNhflx+4FtvCjlAShqa5x0
         VR8BqzNQy6CZa+rXiDe6vIXV0ZsH0NOkLrKrv/m9qUub4PjiVpPvp8VZULvzKfLjcWIi
         QxmYVDWT2BvkbS0uxV8i+5b5L8otuu6eheU4NTCyhxf9KHG6ezm0vulllvBBqC1nxsgq
         J3WAm/wUwmTwoa1c9S24l8DOxxerbOWNUHUnTjdq8R0gFvT2RKl8yr/vLaWGGn9CwkZi
         kqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RUt9ZIAlHql3ePIp61CeWNBm915VyMPtcG9oqOy2n3s=;
        b=YPOFzE6c/1iE1Ww/WuaabgJd4ZuEbaxjvfw3CZkArorgEhRLKCNb+JxhScOGEXf5+f
         J9s1al0KBX2sI9PUW9t81tAzZxsmuIaRpajqDB6c6tBHBxpfa75MKEvOI5EjRTJ6MpKZ
         xouNBPBIuFZ/CyulJqYGIfkxIhSsBlbWDSrevzY1pKUn1XMyNQ2qbkBiF5d/WlAFYvIA
         m6+qesH2zAOK+aoi/WHWcutpMI1zQ8iMTRxP3iMLBSpvmpN9OjbBILuJD/rc7eAiDJpm
         UJGfpNqQgjAzuIfnO8HZIfYAJqF24NxK03rlwJTamVgUuUXOFN3rY/E5DT4/YJr27k/V
         ZrQA==
X-Gm-Message-State: APjAAAW4XXG0EvOsXNXMn4QqQnjbZ8lhPsztA8v4cXhjgeCIosqtKjl6
        Ronw2HDXVfkEG8qHdr5xuMgQ6/OvHk9ZzcwAF/Y=
X-Google-Smtp-Source: APXvYqx2rzfChLGmyZZ4K3hv19hsO11UhuiICP+3Oa1d6mNJh+NiSMalr1ErkVvPuzBcmlYDUkdcWnrfVovSGeELDVs=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr62712968qty.59.1560530339953;
 Fri, 14 Jun 2019 09:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190614072557.196239-1-ast@kernel.org> <20190614072557.196239-4-ast@kernel.org>
In-Reply-To: <20190614072557.196239-4-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jun 2019 09:38:48 -0700
Message-ID: <CAEf4BzZZz49_6SAtgcD+jw8BMV4fGNm+Y69QcQqxpnzknqWkfw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/9] bpf: extend is_branch_taken to registers
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:26 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> This patch extends is_branch_taken() logic from JMP+K instructions
> to JMP+X instructions.
> Conditional branches are often done when src and dst registers
> contain known scalars. In such case the verifier can follow
> the branch that is going to be taken when program executes.
> That speeds up the verification and is essential feature to support
> bounded loops.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/verifier.c | 34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)
>

Acked-by: Andrii Nakryiko <andriin@fb.com>
