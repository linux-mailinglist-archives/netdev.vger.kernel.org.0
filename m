Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDE01384A0
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 04:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbgALDJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 22:09:24 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43535 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732025AbgALDJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 22:09:24 -0500
Received: by mail-lj1-f195.google.com with SMTP id a13so6248460ljm.10;
        Sat, 11 Jan 2020 19:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NussGT5cAZIKaccwz5P4suw1pt0jo6uznt4vhCldmXM=;
        b=drfIe5J8QkINlKQIoyA8Lu/dE5FbLBDxVpKyBdmCma15iBEqsajMmnRM6/C6PSgrdk
         SzFJnC1+ep9B+jnXqvaxfPDeY1iIo9YnzkSJe+0dY7qD0Qh5cO5SvgNlUYIbOscsUCQ2
         VM7nrjEx0A+bS8bSZ1LuvMpQWkbyO6L4yOQUxMZCO11c4dzaRe0+JQvxftroHhbY8Lcr
         je1ScBYrT175JiSuOiPvNt0D0iZ58aHdYccXTH6tB/5F5wCE3LS4SotfNp1oOjzLsRGR
         5ttPdAvmO1D7zc9Y+yOnVsmFOAeCafZ47lniaYvQcOzv1y7LXLgfBEf7znpmPE3smGdL
         jgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NussGT5cAZIKaccwz5P4suw1pt0jo6uznt4vhCldmXM=;
        b=i+OiNd/P5MGHQY4BcVsLMr75OvgFCGGHaaJQDpJFINVYh2IG6KtlNzlGDH4bToakGl
         0TJLVC/8/dfBCcLKUNrTx5dD/M/JlfYeMAyxWb7tmNjKqe3/qGnL9NpO4q18/hXJSpgV
         d9yI0SCbEl+SzP8S2sRjG0TBthyvgDH9JYj8Go1Bl4uoWmyP+9JZ1YzCvGVmic5uieIi
         gs7q38DqEqqMLFCDum/U3rwa4WOWItT+q0sfcR+SJboP7i0xBGOkW51pi7wIa6kVRFI1
         7td1KXqQc7WZKPs9qG1L2Hmmf5jP2arxGdOz37LkJK8ICNIeNvgj560+RDbIeYJ5bY1c
         /oow==
X-Gm-Message-State: APjAAAU9P3nGQKaJVE2YIw7m4QQsb6xIu8Lc1UbmzUMxFJ2NVu2d8piU
        004OwRurRp07W7srSQs8O6+zgyUuBQjW2SuEvyY=
X-Google-Smtp-Source: APXvYqzfqNr1gySwxCVkhFRpHo++EpjWek4BPjcW0RHO7PfZylCEmhga/pUVblV6azdDNvVfSIVwYxocUN2RNI2zVVI=
X-Received: by 2002:a2e:89d0:: with SMTP id c16mr7123711ljk.228.1578798561958;
 Sat, 11 Jan 2020 19:09:21 -0800 (PST)
MIME-Version: 1.0
References: <20200110231644.3484151-1-kafai@fb.com> <2e5a0dfc-6b22-4a5f-d305-da920c9a44c7@netronome.com>
In-Reply-To: <2e5a0dfc-6b22-4a5f-d305-da920c9a44c7@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 11 Jan 2020 19:09:10 -0800
Message-ID: <CAADnVQ+NrqhsB8u+Hvn2k1C=rjDgT2OdM7iDwrLNy+p3LowD1A@mail.gmail.com>
Subject: Re: [PATCH bpf] bpftool: Fix printing incorrect pointer in btf_dump_ptr
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 12:07 PM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2020-01-10 15:16 UTC-0800 ~ Martin KaFai Lau <kafai@fb.com>
> > For plain text output, it incorrectly prints the pointer value
> > "void *data".  The "void *data" is actually pointing to memory that
> > contains a bpf-map's value.  The intention is to print the content of
> > the bpf-map's value instead of printing the pointer pointing to the
> > bpf-map's value.
> >
> > In this case, a member of the bpf-map's value is a pointer type.
> > Thus, it should print the "*(void **)data".
> >
> > Fixes: 22c349e8db89 ("tools: bpftool: fix format strings and arguments for jsonw_printf()")
> > Cc: Quentin Monnet <quentin.monnet@netronome.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>
> My bad, thank you for the fix!
>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Applied to bpf tree. Thanks
