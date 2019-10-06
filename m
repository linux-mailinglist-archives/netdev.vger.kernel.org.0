Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5680CCDA4
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 03:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfJFBFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 21:05:17 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42414 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfJFBFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 21:05:17 -0400
Received: by mail-lf1-f68.google.com with SMTP id c195so6898903lfg.9;
        Sat, 05 Oct 2019 18:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hi2TQ3gnQO+4LnruDAUXH/KsUjTzayhRfdN3zee+DKM=;
        b=NsEE7Nc/YRadFRPWkLjNPDifxqJKsJkkFWG8HSBa9DDmlx72STNUpRoDOxawe9iK7P
         Oh9R04kQHmsptWmvg3Wosbcnr4hqUEGIOoos9mGPiWUPvGXwXTpqW6orLZ7fnVPn7QMp
         dzCDCjrPjTTuHlcyuECaTHo6ey4LLjyslptZzJGL+C2PoAGKvtPDDT5n8wcSTPOwQ5mw
         0I8bDl3MarMEp+/xbtAhjXG4RsFZZTQmT+pqV8nOJip8M9BEXjO+pYIg1Vt7X3Cwlb7e
         Z4lrFkWhVO/uGH0uXzLU/GM6bJUr1enck7lSYlB4F/lHAkBVBWcynt+xXztt5xLC7vi2
         GPMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hi2TQ3gnQO+4LnruDAUXH/KsUjTzayhRfdN3zee+DKM=;
        b=EnA0q7Oaa/bJMQZiCa9vDfvPPMy4XdaI19BQdiox27voTWOg5NHTvm/c6SD1tIvUww
         FGz8PYVK+qDITnibuvQoRgDVIuDB/5vw/Qth5U69pb9+Nrgy0p8Gj9LXg6z98gKzWzMG
         vJTIJ2bnLa5XMW97c851l4JN5Tw2zBJx/78SX92B3tvyHm1yaq4kgWQUundfbAK2FN7U
         xVBggS2CqHJx8/CXtTvoPTfAwo+mKJ1AcYFMsLAjnUXtUNUHZSK0A/TjoqENecXhFBG7
         IwK6x+SrRK/MW7dBHrM0Y0wNVkBAt3DXpdAWHn8+8ap+ur65JXLS6KYDThX7o8ALLBxb
         zggQ==
X-Gm-Message-State: APjAAAXCV8HN5oAohTITzozqPMJCMtKc57lKW9o3xw/Dz5PWkV+K2LXp
        3ZCcDxtNGEy2lbYlr9mIOfXWlJyi+7AQyd8vWmTmSA==
X-Google-Smtp-Source: APXvYqwy7jEyIOE7kcTNnfKVBBBdnVEuoum8v+smwyQbw1FH8x2N2KyHxZW2NgKjZ7Ft9P/AlD2oaGbks2Cu4X/KHms=
X-Received: by 2002:a19:ac45:: with SMTP id r5mr12721753lfc.6.1570323913319;
 Sat, 05 Oct 2019 18:05:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191004040211.2434033-1-andriin@fb.com>
In-Reply-To: <20191004040211.2434033-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 5 Oct 2019 18:05:01 -0700
Message-ID: <CAADnVQJ-GhhZskSjWq-rfNCZfUoNn4vMxwPHoGSRng3A5aaBsw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix BTF-defined map's __type macro
 handling of arrays
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

On Fri, Oct 4, 2019 at 1:10 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Due to a quirky C syntax of declaring pointers to array or function
> prototype, existing __type() macro doesn't work with map key/value types
> that are array or function prototype. One has to create a typedef first
> and use it to specify key/value type for a BPF map.  By using typeof(),
> pointer to type is now handled uniformly for all kinds of types. Convert
> one of self-tests as a demonstration.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
