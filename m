Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDC1E4141
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 03:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389479AbfJYBru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 21:47:50 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40892 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389214AbfJYBru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 21:47:50 -0400
Received: by mail-lf1-f68.google.com with SMTP id i15so313854lfo.7;
        Thu, 24 Oct 2019 18:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/I/Iq8VXvm0UwQiulgADEMSKcfpgrehFgjobcylNDOM=;
        b=I+tSU7wcAHPxxizaia0JfBmh0YAhZyey9V1j3LBZHHIzNm2mwgRb8a3obRhkXEh5Wj
         qepBpjf5MTfPJL/KoHJo3odUNlA4ZPBCO6OHBSo50y4qE+Oeu098YQbzy1HDWFPcsSOS
         S7kHDmeTqrCuei1XKa81GwWrmrkRqKQCpyV6qnKlWa/YEawVEIviI9FltFvfJdk3WtLU
         63dCMzibhBR21mUWWJxmycSJzIa0HQIlnfXYwt1KEdJApbGPgER+NYIMKM/zQaw5AAZQ
         6lp8bNZceKL2fI3usEThVjiIQ8n/SH3z3LTunaedt0u41b6vWf1pFvum6g/IK2uRMYas
         poBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/I/Iq8VXvm0UwQiulgADEMSKcfpgrehFgjobcylNDOM=;
        b=Q9Eg4AlvvQp9fOURlGbIMSVsfEOk9a8NYHyGltsmd7vYvvTCA4BP5OA7zd1ONt7aPs
         Yu6Hf33nPfAB8lQwqBOGw81aT9zVFOYptLIaHIy96Rkj0NOZNWGlyNBczlgVP7HJC3SU
         xbH5pi0Y8M1Gbb5vfRDvWwCt/QTygtq+iQBkkfXjv/soJSViPCin7iTzPMldGMW9Rk1X
         GnWP9xZ3dKnsldCIzbGDi3S6VwcyNyeeLmPHru5WCytIQuWi7ReuFMZEi3XfxpHyff5C
         ctFSrYRnqBgis+AcwMuahgmirC4yhLRwPEQVL+uxx8pM6UFkOH54JJuQ6QxK0oxGQgr0
         2uEg==
X-Gm-Message-State: APjAAAU4TkQG9ierqi4IPQ9lTCAykBKOshr6H5Gs3hmsC4JwXV1kdbRC
        fxrQQdAaQbBf901QOg78VUWJTRH2A7jXjax/XZPACQ==
X-Google-Smtp-Source: APXvYqy9aI8lQnEcD87DEEvajRu4YglzZbNgw5ZpUHMa3oR0Hq073BWGsitbvJUkEy0utoCxKKHsBmXzaVP8rK7np/0=
X-Received: by 2002:ac2:5627:: with SMTP id b7mr700649lff.6.1571968067896;
 Thu, 24 Oct 2019 18:47:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191025001811.1718491-1-kafai@fb.com>
In-Reply-To: <20191025001811.1718491-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 24 Oct 2019 18:47:36 -0700
Message-ID: <CAADnVQKVtRcOex-2Gw7Gg1ut6SBnYCNxE+F2gj9oN604hV1wLw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: Prepare btf_ctx_access for non raw_tp
 use case
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

On Thu, Oct 24, 2019 at 5:18 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch makes a few changes to btf_ctx_access() to prepare
> it for non raw_tp use case where the attach_btf_id is not
> necessary a BTF_KIND_TYPEDEF.
>
> It moves the "btf_trace_" prefix check and typedef-follow logic to a new
> function "check_attach_btf_id()" which is called only once during
> bpf_check().  btf_ctx_access() only operates on a BTF_KIND_FUNC_PROTO
> type now. That should also be more efficient since it is done only
> one instead of every-time check_ctx_access() is called.
>
> "check_attach_btf_id()" needs to find the func_proto type from
> the attach_btf_id.  It needs to store the result into the
> newly added prog->aux->attach_func_proto.  func_proto
> btf type has no name, so a proper name should be stored into
> "attach_func_name" also.
>
> v2:
> - Move the "btf_trace_" check to an earlier verifier phase (Alexei)
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Thank you for sending it early. It's right in the place that I'm
hacking as well.
I'll refactor my work to base on this.
Applied. Thanks.
