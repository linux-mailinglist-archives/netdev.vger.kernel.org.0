Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1BB5123D33
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 03:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfLRClf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 21:41:35 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36449 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfLRClf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 21:41:35 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so349741ljg.3;
        Tue, 17 Dec 2019 18:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q3q4QjE40FfpigvCirQu5SPQ/jbG+luYeGcEbe9rUw8=;
        b=XOERBQKPMu/Wpni4dmx3VfZnA9RvHuABF3DeNotuSiMbotXZyCSCCRJrRnagaan1Bs
         k4L/5LbmFVZUW2MkpWuOtg/QB3d8X8vAMQ9f7wlLacVdWBN5M0p0z96xnmUNdn9g36Xi
         u78gdz8RGrZIPUeP4YQmHvO9RIHJK40kJtguQStq9RrR6zimWLHlUM0XyCH7nQxaZOYk
         lG6CQ66PQ7LMVf8rA0d7fEbYIhHpKE/CH80ydyKpDuNuq9rHqB4py6mjjIItWG8WGweD
         tsZd/q/ALWXdmzN8Kl0KQ/ng9mO9QCbPdWfWX0xX9+rz1ZgibwpdgLmMJvoP7Mx7bOZW
         PyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q3q4QjE40FfpigvCirQu5SPQ/jbG+luYeGcEbe9rUw8=;
        b=AT3R4K8vePXKPGutq6c/jl5+C0OcXe2jCb6xrqN0F73eGTUr3zG2KgYC+z+f7LUusN
         vv5e+VPh9BCHixDg7DZjf7zT7Y0+Ea39HIhegzFLM3L9jx0+yLUI/n1YqwcytmKroPrc
         6JswJmJre6hMze22tTsoSkFpGn8eauuYlv8bLq8c4G6lieS9gD5qhCwGob6ASwpmwcNj
         eigiE395Cw45L85mRRzJjsnSNR3ZVFPSXJRqMyODTWMonResGjR6evyWZnvpb9Ph3IkW
         qSEmG2p4zZr2v2chDG/PEzFgsLuhX26I9cQVvNEmc7z6DMOvU/Lg9+cczDzdFRWHIf4H
         PyCg==
X-Gm-Message-State: APjAAAUR7tRbvtS9hCdwHdwo0Cq41S2CHou+4ZvRNtAHQ9MDB/f1A9Bw
        wOtIG2jJc6fYqkaxjfPjdUV0a5RNiwiEtijpibs=
X-Google-Smtp-Source: APXvYqz4onHdu5AGdWEQRI/ynrNbDLj9quPnWdDj9TmjO/5MP4n+UD9NUMOuc67MCUJvg3m0HOp9ftx/+3+yybXEmp0=
X-Received: by 2002:a2e:89d0:: with SMTP id c16mr741305ljk.228.1576636892625;
 Tue, 17 Dec 2019 18:41:32 -0800 (PST)
MIME-Version: 1.0
References: <20191217234228.1739308-1-andriin@fb.com>
In-Reply-To: <20191217234228.1739308-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 Dec 2019 18:41:21 -0800
Message-ID: <CAADnVQJtDHv4r28Skdy1Dt8i7iMareiMz-+3O8M=1gGEG3-4GQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: reduce log level for custom section names
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

On Tue, Dec 17, 2019 at 3:42 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Libbpf is trying to recognize BPF program type based on its section name
> during bpf_object__open() phase. This is not strictly enforced and user code
> has ability to specify/override correct BPF program type after open.  But if
> BPF program is using custom section name, libbpf will still emit warnings,
> which can be quite annoying to users. This patch reduces log level of
> information messages emitted by libbpf if section name is not canonical. User
> can still get a list of all supported section names as debug-level message.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks

selftests/bpf/ build looks very nice now.
