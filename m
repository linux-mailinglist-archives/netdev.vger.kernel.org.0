Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CC41D4306
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgEOBiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbgEOBiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:38:51 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8E8C061A0C;
        Thu, 14 May 2020 18:38:50 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id d21so452322ljg.9;
        Thu, 14 May 2020 18:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcRLMC8AdRE/ebA3Y4wmeQqBQqJWEwlknp2rFOrxp4k=;
        b=CRURWcO8pELH4346b432h94eh4EaF6LXZkDyD1jEB7qfy2ARxL1z1CiNCxV1VMQEy3
         yFk2giKhuX2/Q+KWvhHo8nDLg6H8r7OrkL71Fis7bNSlTh/uuSdSmM91SHtm+ViDeiEA
         TpLcJmdzPKiNlHgsVfNQs2Lf3SSPXOewgTqog6kQ2hwsPZA9PvRlE63NHIYz/8bAedZJ
         eG/AvgZyG/uTYtOA/30utfFcSz4d6qEkiIVshWOrBQ4arKAZqvtp3S0xUyBR0hqMZBLF
         hSZkAdvduhhZUnMk1LoXjRRuVoWfqov97O/SgEaLHLB5IC3RvSclvCu8uf9rCq7XCgIR
         IGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcRLMC8AdRE/ebA3Y4wmeQqBQqJWEwlknp2rFOrxp4k=;
        b=TT/pNj5PY3LWXEKGJnmJU2Xy6YB7x5/4rUf4+MKkxTkIg4pX5N0rJD+dQKKSZhZkKK
         U63NaGQMrUQL7G43C/XJFBH6ZajeiF4vVBHsVoYx4U71CFqbeOgtbfDJTgDjZBs7/gLC
         +0YmOs4qqGm68nw7IS0ejh6HfUfxyP3xBEMirDn0hhRFOUVZVCG0pbLeWTTrpk1rqWqT
         dFATsaJlMUIkk8qesUNMHy+E3+BJEOuWPAQ+awTMF15SRL5Oq7dmmIU63ffIYQRF9RW5
         VoQKCh3i/Qu5DpuwhYJikYSyHmNe7g6G+aKfgTf+pFv2SgD2pB3ex365ZVSzaOthpk1E
         6N+w==
X-Gm-Message-State: AOAM530Ce2TpmzALgkx9bqJQteuICiwU3KfDCsrJtJ7XdMfrvd+kJTLl
        4yyyAKfzlVbAu+DaDW8zsqwGuBDHNK3XJY4eWRc=
X-Google-Smtp-Source: ABdhPJwuDPoLqMDwVYkuer7bPNDX4SB7xPmbLzNbASXYYAjw80+OMdipEy48L/v0diSIxQRoMsaBXJysnxJzyDSkJBU=
X-Received: by 2002:a05:651c:48a:: with SMTP id s10mr230789ljc.7.1589506729332;
 Thu, 14 May 2020 18:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200514055137.1564581-1-andriin@fb.com>
In-Reply-To: <20200514055137.1564581-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 May 2020 18:38:38 -0700
Message-ID: <CAADnVQLYt--n_Yp1_A8BVp-p17ymVkkqtzgisKm1a0JGwkhpCw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: fix bpf_iter's task iterator logic
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 10:54 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> task_seq_get_next might stop prematurely if get_pid_task() fails to get
> task_struct. Failure to do so doesn't mean that there are no more tasks with
> higher pids. Procfs's iteration algorithm (see next_tgid in fs/proc/base.c)
> does a retry in such case. After this fix, instead of stopping prematurely
> after about 300 tasks on my server, bpf_iter program now returns >4000, which
> sounds much closer to reality.
>
> Cc: Yonghong Song <yhs@fb.com>
> Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
