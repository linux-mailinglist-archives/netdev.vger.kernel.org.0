Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2BDBF2771
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfKGF54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:57:56 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35358 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfKGF54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:57:56 -0500
Received: by mail-lj1-f194.google.com with SMTP id r7so846520ljg.2;
        Wed, 06 Nov 2019 21:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JJs5JI4XZJLmO7AHqKFZCXkT3JmuCzeAIj/8/sRSIBU=;
        b=IbjCsAldHo+uwtw7wmX8ZBL+iP9eOCpE3B6+zLF03MhNscdwEdU2+Bk8CC4lZ3KGMv
         A0/8Kqm8VSCEoWze2dCzy37jUBx7DMnyDXwhJ+zB4oYv1vCaxuGScl/8JA7wVwO9pwzD
         ub2Tbh9yZjdP1aUwSjd5rcsYML33BgNq7XUY1miqWpCmGWn8El2I/rB/5IBDCpCm7jzI
         xD1NmT1w/J0xZE2O3DY/lf9SGusQ5dWx9uZvyOjhe56VWCqBkOfdWzPlxkfjZgqhwfYU
         NUu5PNckJVjnhYDdOPKacf8FkABVdqsg/SZWuT3rsUpmKQvrRD1+9LG6PcnrlBpHun5z
         TDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JJs5JI4XZJLmO7AHqKFZCXkT3JmuCzeAIj/8/sRSIBU=;
        b=Xcp8P54Vb2hZlk9A5Do+Z570XaTt5WbBL7JCH8G3LzYj8v+opl8BWzUAqva8BN3lLz
         l3U6EtHcfl3MCoMPxcNrIcnG6fULzEH2K+/iwiYzS3AiS8+D5kgobVGNtFv1ZHKzUPLH
         p6013XVa7Vi3qluZ17b0vEuofxlBoAg2XFOU5T7H0t9MjQaBhO+ogPF3jXHjlquPV8bK
         4ehhdYGF17B+R4Juwd7tZrs59YW9URMWOe4oxHXYw0unmx1aTFHBNl8y38HOqqPg3vEz
         pBs1PN8DRe+XURnhWIYe8lck9IFHOYElyXK9A9nlyGG9qB0uJGVWhV92CHcbvUAQFhHm
         IRZQ==
X-Gm-Message-State: APjAAAXAjqHHAHr5EaONWODjvU8mnjEGhbCAoc54c5+Ruby1OZbZXs1C
        KdRB1GJP9zQjpZSs5FILjP+YDBGjwOMB7zPNIcgP4w==
X-Google-Smtp-Source: APXvYqwtZHU30iPV+t9mV9rRWV3nbYK+S/jfpfA34rDRFg7BMYdUnOkBNaqu1gE5OoYlji3GkXQkgV2omyoRYy9gbXo=
X-Received: by 2002:a2e:2e10:: with SMTP id u16mr935737lju.51.1573106272501;
 Wed, 06 Nov 2019 21:57:52 -0800 (PST)
MIME-Version: 1.0
References: <20191107014639.384014-1-kafai@fb.com> <20191107014640.384083-1-kafai@fb.com>
In-Reply-To: <20191107014640.384083-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 Nov 2019 21:57:40 -0800
Message-ID: <CAADnVQJ5Q-nx4-utPCWMuVgtSsfcWbwNH5eh1TLed049MREUrg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: Account for insn->off when doing bpf_probe_read_kernel
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 5:46 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> In the bpf interpreter mode, bpf_probe_read_kernel is used to read
> from PTR_TO_BTF_ID's kernel object.  It currently missed considering
> the insn->off.  This patch fixes it.
>
> Fixes: 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied the 1st patch.
2nd and 3rd will go for 'nit' respin?
