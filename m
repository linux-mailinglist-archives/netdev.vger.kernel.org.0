Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC7011FC64
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 01:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLPA4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 19:56:24 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37078 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfLPA4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 19:56:24 -0500
Received: by mail-lf1-f67.google.com with SMTP id b15so2985681lfc.4;
        Sun, 15 Dec 2019 16:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=97UrfOWr0LGRI5jZ856S0euYf/lCwfuGxfqxipx3oGE=;
        b=QtdvAQQ24mbYvm0yJ+Ek27YG/tT4m7f1S9uwuyL+34bU3GjXMsCWSbbpXnLqiglkpp
         u2yGFUEJDuaa48gLVAysaBLOUe6hAnBzbWi8+Hn6ndap+vm+I4FewJn8+Hx/rng4KM3N
         x0/c9MZtXOXx9cjSUKtXO4bwQ/xClYmLCQf8MB9yR3AE/K24a+L3jzSXm6ZsG1QnqrWs
         ++ZI1SwTIBJ8L61SgSQa9FBUPF1w9mzsUzOt+1VDqsVe14sLFuIZKJMOY4q4f8l3okJo
         91IdwwHpv4WNPo2QZdtO9Nm1en3+rZNGTnqv8kTwaqCjec26DRdcYZHYDWwwzxhaYLMX
         2IKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=97UrfOWr0LGRI5jZ856S0euYf/lCwfuGxfqxipx3oGE=;
        b=a2t0XSQ04PXhAQ/MK3JJXt5JRbVCVF/cY7eM/19ErxXiHdOogDrsg1wM/3OYdlzAog
         HwpKqddzix7smYfKnagNFaQMlCSHEGokl0TCZnkwYgXUQ9wAHBMNm+9ouiCyuTnJac5U
         l0k47bm3Hds98ry6YD8dDN1nef6y1kMfErhs3KHNxaSucl9FAVAfBqexV0XwlB4upG7p
         nbtfIv1LAnqJFVxpytfpbj8heW1nbussxVZUJGY5aMakz19d6dUHwd/SPfjp4WkZWghZ
         BQrzM7AZG/eXpdAcvozPt1NPjC3R4YsbrVyKmUDI9xMXPKbSRrQBDhAmR8NNbww1+Q33
         he9A==
X-Gm-Message-State: APjAAAVVxPQ9ZnHRr8gSBJCKDVxxaBeGr87BcV1khDLHrUne3NOhWQPT
        lWyuWRJRoAk5ZSbdwoVhllgdtFI2FqZuS6Pjg9I=
X-Google-Smtp-Source: APXvYqzKTiMd3/3q+sZ19P9MaqMlBnh4R8Vm7vMJsZCJIHfc8Rzr0rVLw4f7ta26+8x7KJ4HvwgS20yosKgEIDRERyU=
X-Received: by 2002:ac2:47ec:: with SMTP id b12mr14444993lfp.162.1576457781820;
 Sun, 15 Dec 2019 16:56:21 -0800 (PST)
MIME-Version: 1.0
References: <20191215070844.1014385-1-andriin@fb.com>
In-Reply-To: <20191215070844.1014385-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 15 Dec 2019 16:56:10 -0800
Message-ID: <CAADnVQJAs882pt4AH4CTn_2m6tdkSNVXHVvGLQE3ppm2CoA1ug@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] CO-RE relocation support for flexible arrays
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 11:09 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add support for flexible array accesses in a relocatable manner in BPF CO-RE.
> It's a typical pattern in C, and kernel in particular, to provide
> a fixed-length struct with zero-sized or dimensionless array at the end. In
> such cases variable-sized array contents follows immediately after the end of
> a struct. This patch set adds support for such access pattern by allowing
> accesses to such arrays.
>
> Patch #1 adds libbpf support. Patch #2 adds few test cases for validation.

Applied. Thanks
