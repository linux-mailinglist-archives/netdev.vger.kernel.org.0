Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D09B485FE3
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 05:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiAFEbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 23:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiAFEbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 23:31:08 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B629C061212;
        Wed,  5 Jan 2022 20:31:08 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id x6so1633696iol.13;
        Wed, 05 Jan 2022 20:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bKngA3Lehfa/411JUCo6hGhkPh7NqoZY3CFgWceaWTo=;
        b=oXBigZ1R+qXY2sEoLEWDLKwMPlI63XEMGHFESnXwsVhxV1prCQc+piIjx8WHJQh0B3
         hpdLvegUOmn8VejX91EHGdjaK8q/fFriRmLf50Hr575JaI7UbRE6/hbYQkgYpB2UV7sJ
         9vgIeUx6yfey1cijVPuAZncYVCW36u+AwJyv7CwO8PKqGAv4W47+CFet/TEX3kxQ3Ctl
         s+IqnQtSaHJlru55tfYPJ5HA+nJgHVJmCUTtO6cpF+Q3cnjAlt64jgp0PEpW0qOxecPD
         thUIO3U4gb+DdfRVnmVzCEZcJMA9n4KFJZkROuwwlkzWRrRCEzUe5d48YLsineMoYaFm
         7PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bKngA3Lehfa/411JUCo6hGhkPh7NqoZY3CFgWceaWTo=;
        b=2xU2qs/Q/C+4JpUK6wDE0QTMTl05Bw78tyN8Iw6F2KDg+ScDkMs0ZY3ezl9A/1mSif
         klXkD5O1ojr0YC4VteCeTYrBwcmXv5T2FmU9syqVjI+vz2ZygteympYW8HqGcpn4Sjvm
         oYSf/HgaSmQeIheuKynQo70wX3fNPqlXsxzGDdoq6Qly46cUrnSAkDOvi6tZ1mbjZoRa
         xDYpE0HZnlNdcG9aSdK7Cnxz/+lB4QkHxhHBewswmU7Mkfwo5SIbqaeEXi4X7DXUGjpD
         zVMSje3yE+HI9HVJ53ZPBARXKb09s1AGgvq18LZEgldjUADWjPc11ktZpd8dfcSJKvZN
         PSiA==
X-Gm-Message-State: AOAM5309/k8SlPSv2jrPnlmGhjKha61yJ9FhM0ocRearDZQUe+xsRkr7
        +vb7yQidVqSwp1BDtgH0GPB7OB/a2X7xcyuMIhQ=
X-Google-Smtp-Source: ABdhPJw/Rn0aPHa6svW0WF+3UfAE6VMDyLPAyOJ4SK0m+Ay5wYhtXzCcP1fKiXNS6C5HYXxcIB07lqjVVivdNJtuJ64=
X-Received: by 2002:a02:ce8f:: with SMTP id y15mr22063715jaq.234.1641443467890;
 Wed, 05 Jan 2022 20:31:07 -0800 (PST)
MIME-Version: 1.0
References: <20220104080943.113249-1-jolsa@kernel.org> <20220104080943.113249-9-jolsa@kernel.org>
In-Reply-To: <20220104080943.113249-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Jan 2022 20:30:56 -0800
Message-ID: <CAEf4BzZ7s=Pp+2xY3qKX9u6KrPdGW9NNfoiep7nGW+=_s=JJJA@mail.gmail.com>
Subject: Re: [PATCH 08/13] bpf: Add kprobe link for attaching raw kprobes
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 12:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding new link type BPF_LINK_TYPE_KPROBE to attach kprobes
> directly through register_kprobe/kretprobe API.
>
> Adding new attach type BPF_TRACE_RAW_KPROBE that enables
> such link for kprobe program.
>
> The new link allows to create multiple kprobes link by using
> new link_create interface:
>
>   struct {
>     __aligned_u64   addrs;
>     __u32           cnt;
>     __u64           bpf_cookie;

I'm afraid bpf_cookie has to be different for each addr, otherwise
it's severely limiting. So it would be an array of cookies alongside
an array of addresses

>   } kprobe;
>
> Plus new flag BPF_F_KPROBE_RETURN for link_create.flags to
> create return probe.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf_types.h      |   1 +
>  include/uapi/linux/bpf.h       |  12 +++
>  kernel/bpf/syscall.c           | 191 ++++++++++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h |  12 +++
>  4 files changed, 211 insertions(+), 5 deletions(-)
>

[...]

> @@ -1111,6 +1113,11 @@ enum bpf_link_type {
>   */
>  #define BPF_F_SLEEPABLE                (1U << 4)
>
> +/* link_create flags used in LINK_CREATE command for BPF_TRACE_RAW_KPROBE
> + * attach type.
> + */
> +#define BPF_F_KPROBE_RETURN    (1U << 0)
> +

we have plenty of flexibility to have per-link type fields, so why not
add `bool is_retprobe` next to addrs and cnt?

>  /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
>   * the following extensions:
>   *
> @@ -1465,6 +1472,11 @@ union bpf_attr {
>                                  */
>                                 __u64           bpf_cookie;
>                         } perf_event;
> +                       struct {
> +                               __aligned_u64   addrs;
> +                               __u32           cnt;
> +                               __u64           bpf_cookie;
> +                       } kprobe;
>                 };
>         } link_create;
>

[...]
