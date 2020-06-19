Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A68200013
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 04:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgFSCI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 22:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgFSCI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 22:08:26 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5948AC06174E;
        Thu, 18 Jun 2020 19:08:25 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id c17so9627428lji.11;
        Thu, 18 Jun 2020 19:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=soNkQOjaxprLDPChf/O/i85nJT0zzxCisaanbV+LWSs=;
        b=jzu23rTOCzCf6n9RJ7nwyxWhrzxw46Bm6Liznb8CIvy1HlUfIBOkd6D8MOSQVnJTf9
         HEw7/eTwsZjd0KTeuqwE+Mcjy+fRoFZvPHOxnMghMMGc1BiZN2lW+aTbKePDyvn8KPBE
         4cUPd+xJUcloiKedmfQLZVMuRqQhgLuIKwVl7+QfVtPuOsjGeugR55X57FQaLWv1rNmL
         VmT1E7oQiwR4hZ9XHW4ve8IC9ZNoB/wHUyK9+DV72Ou1vclP4koodhip5vNShzuM3MoN
         uGNWdzchucf6FEKADXz3b4Qze2EwvtFr6CpZ2s0z1i/ZMfbfeFwa2b3+ZRv7omrhEq6Z
         WSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=soNkQOjaxprLDPChf/O/i85nJT0zzxCisaanbV+LWSs=;
        b=jRKeHuRF87q6v63YSUmhBzermlgjnLQEv/oIMQZxQBCK6qvRQZdjpSbmMTakV6ZPJv
         MfU7ZqW+Tefhe4GsoT7j+XiO8uExI6+jxbnjFP+1g5S+p5c7zGUj1JMIN1zi829n6ECH
         utZ7qrHcOE+7u24gSnsS1tuRu4UruYQkW6qaQiTu42QZfq0P0JTPbfvau7hH/mFSiDWs
         1X3ebtVy0bIcU9CbovRYeFeyWd6Yw+hINmUOFxMVDG6o4+eOsgQQcx0MPuJ8wYE1dXfM
         c32MUOGY9JwPwb8dUynJSONr3i+NFCi86MMm5g81VoLEiRRPwVx+GIuYnBRq/E24rtsS
         uFAg==
X-Gm-Message-State: AOAM532R6c7vunpb+qOMqkkFss2E0aUBsX98gHRv0tVXwuYGjc7PzVL/
        3SdGlHDCv2n1OelWkQOG1nqHm2ivUA45DEuUkCk=
X-Google-Smtp-Source: ABdhPJwCtUioOjsIa3oMmG1n4R4u1FcinWC7Kn7zF6alYdDnw1BJLTh0NJfiKPzHZHFE/5o23msKKW018ewUjwmECPc=
X-Received: by 2002:a2e:9187:: with SMTP id f7mr637190ljg.450.1592532503844;
 Thu, 18 Jun 2020 19:08:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-3-jolsa@kernel.org>
 <CAEf4BzaL3bc8Hmm20Y-qEqfr7kZS2s8-KeE8M6Mz9ni81CSu4w@mail.gmail.com> <F126D92D-E9D8-4895-AA4E-717B553AC45A@gmail.com>
In-Reply-To: <F126D92D-E9D8-4895-AA4E-717B553AC45A@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Jun 2020 19:08:12 -0700
Message-ID: <CAADnVQKWfRCLSUYSnnMRR6jQhF1MFCE+Xhcp30E_7uJd_Jr2sg@mail.gmail.com>
Subject: Re: [PATCH 02/11] bpf: Compile btfid tool at kernel compilation start
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 5:47 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
>
>
> On June 18, 2020 9:40:32 PM GMT-03:00, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >>
> >> The btfid tool will be used during the vmlinux linking,
> >> so it's necessary it's ready for it.
> >>
> >
> >Seeing troubles John runs into, I wonder if it maybe would be better
> >to add it to pahole instead? It's already a dependency for anything
> >BTF-related in the kernel. It has libelf, libbpf linked and set up.
> >WDYT? I've cc'ed Arnaldo as well for an opinion.
>
> I was reading this thread with a low prio, but my gut feeling was that yeah, since pahole is already there, why not have it do this?
>
> I'll try to look at this tomorrow and see if this is more than just a hunch.

I think it's better to keep it separate like Jiri did.
It is really vmlinux specific as far as I can see and can change in the future.
