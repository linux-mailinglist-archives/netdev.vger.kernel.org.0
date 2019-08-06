Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD42837C9
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfHFRVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:21:04 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40681 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHFRVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:21:04 -0400
Received: by mail-lj1-f196.google.com with SMTP id m8so49297835lji.7;
        Tue, 06 Aug 2019 10:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9AfmnpMKfG5Itu4peF+Mf6d/LvX07JWTkDxhlIBquP8=;
        b=ZJJWE5dztgw5B4Co+xGCzjWYFNKDiNHr2HT+V1llmkDjOS9CSUVarg8QWJKlfRg4Rc
         rMl/jMRMXyY9hXB+caJqkPyjtl+QpaHWXu3vlsV6hUpjIpppMhq8Ki9jKc5dRTIXQpA5
         CAI0OGxUoeuLGMSKZnNalmeTwWa82ml6oVUf0yEZdZ3GOyOelKhSgLLnq6fKp4am/ICa
         zZAdi19LAJ4+EuGv7kLLeZMFypMyLP4zjIfQKPwI+NqiQNv5t5SQflYXTpjCuA+ivenO
         iPaiQ6m94/Tpqu6sTJBrII5saOBXMHBlkjPL/S5i5cZi//cJHUkLGUADHAQyegHgstzY
         khnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9AfmnpMKfG5Itu4peF+Mf6d/LvX07JWTkDxhlIBquP8=;
        b=pNebyeacrdQJFMKFb5QI8pJiLWDk9yy/NV18nQJogBoCldMLVyzPTdAaJf1juLiY2k
         p6aM2F0qnMxrw7Gow0qt8tEm9Te2R4onQYaf6IOfkJmOPrqqEt7Whbr0MZ8WDLPxibs6
         vIDmIv/O6JMmiWhYCG+6vFbcoIfm+1/ymxioF1730mgZAH4Tort7ixBtMxIBpz33MdOT
         xECvFDu8Xf+0ac6Zc1yGc5nmwcVRR3MLc7tsWILr8GSsO7pOs29zsH89D8n7Pg4HcwCV
         4EB+sFrSmLxjI0WVWpuR4vHFuMAK4MvCm8/SO/JODwTSKcyrHjmLd/XsZwzCn2uqe4E4
         PfvA==
X-Gm-Message-State: APjAAAXIqU1n+sRJ/HNndX2Rpevo7LbrRDvKZrkW3AGagePCtDsettrN
        ZJXwLz0M/2im591Tg19ngc/uInXCMEyBNAz/luM=
X-Google-Smtp-Source: APXvYqyQfO4QAIFddTJz0BxsKY3Nv4OVV3OOuD0A/ZvT4zZKRUIG2xNZubf2E/RTHTr48rIhSq10qJo3U2wDiIerZ7Y=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr2298826ljj.17.1565112062108;
 Tue, 06 Aug 2019 10:21:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190806170901.142264-1-sdf@google.com>
In-Reply-To: <20190806170901.142264-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Aug 2019 10:20:50 -0700
Message-ID: <CAADnVQ+f9G7XgXaSn_RP=bE9OVpQaqmU6pS1p3DB6xteTB113g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/3] selftests/bpf: switch test_progs back to stdio
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 10:09 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> I was looking into converting test_sockops* to test_progs framework
> and that requires using cgroup_helpers.c which rely on stdio/stderr.
> Let's use open_memstream to override stdout into buffer during
> subtests instead of custom test_{v,}printf wrappers. That lets
> us continue to use stdio in the subtests and dump it on failure
> if required.
>
> That would also fix bpf_find_map which currently uses printf to
> signal failure (missed during test_printf conversion).
>
> Cc: Andrii Nakryiko <andriin@fb.com>

sadly test_progs -v now segfaults.
pls fix and resubmit.
