Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EFC176F2C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 07:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCCGP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 01:15:29 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34331 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgCCGP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 01:15:29 -0500
Received: by mail-lj1-f193.google.com with SMTP id x7so2194841ljc.1;
        Mon, 02 Mar 2020 22:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7afxNQvt/DolNWukaehAE3e8EEVdHHDuEOwhCMvsPm0=;
        b=YY3/CVuZ0tw5W/s6w94CK9bWDsqd5IK3b6M6w78GF5X3mGqE/Y5VUNsIqa/13h9RWg
         OVvfWH3xqyU+1EPMXYqZfN86rXOlor2jKCOjshyNawcUKdddrG4hLqojvh0RH7KW85jP
         KfVQ9tZN0rRzB/WyEzdeQ6Cf7O0FaDnn1JEskLahTvdXv7lSxnEAxPx8k1o04qNWgH8u
         fpAB8LBQWjRE1niHOUAyIV4re9V239SiGG8iZDqR+Cn/zQhf6GKBOMOLP2aONIL8NzHY
         QJpcCboG1iCzpEaImGOOkGI9aoW/t6czREx+EdtkmyZQ3vvio8fNpwCVRATaib+Bb2R2
         +FSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7afxNQvt/DolNWukaehAE3e8EEVdHHDuEOwhCMvsPm0=;
        b=Xa6MkKmbqkHhLkPe8qBmsBquwAjVkQD2ixBXt54mN0pyGgmzTYRObiv1+1+iVlHXAe
         NXNX3gckz2Ru2dZKh2jra6AhSoKSTWrOhgQ8Vo/IpwVLj3JTQxK6sp3Wj+aDZcK4jn9l
         LEPLOEvG4IcFOp5pGdj5oMcbcGoMc6Io6m298J78XnfUBtLdCrM1Hxum7SFyLRautN7t
         Bzdm1pGtzLGskU8RxrVGhHSZxGm0LcZ5esyw7QG17l95WxiTz0HGEukG/4Vp/m6lmvx1
         7pSKxuoODBAZttatTb9nhLw0iMbpUx4UYoyaBcofiYCTTfl41GWGU+tfO2fThPRWHjN7
         bDxA==
X-Gm-Message-State: ANhLgQ2EhWvfPvpIij7Sh9uRiZExPuhWQm9GsUEUvNKlAa1InSc9LokU
        VqoRo+91grOB95COuVCG1b6gotft9GwkBe6P6Wk=
X-Google-Smtp-Source: ADFU+vtY6eggRVnVN4NMp/hZRWEhBBMdFtdQ6Eav2tUhPVOJuxLghnNhvM8rV2948tk1+lPC0k3t0YF0wUbl2XmIWBA=
X-Received: by 2002:a2e:b5a2:: with SMTP id f2mr406897ljn.212.1583216127352;
 Mon, 02 Mar 2020 22:15:27 -0800 (PST)
MIME-Version: 1.0
References: <20200303043159.323675-1-andriin@fb.com>
In-Reply-To: <20200303043159.323675-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 2 Mar 2020 22:15:16 -0800
Message-ID: <CAADnVQLBrrWtJ036DpJL5H4XK0RbB08F1sWEYQ54LAkijLObAg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/3] Introduce pinnable bpf_link kernel abstraction
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

On Mon, Mar 2, 2020 at 8:32 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch series adds bpf_link abstraction, analogous to libbpf's already
> existing bpf_link abstraction. This formalizes and makes more uniform existing
> bpf_link-like BPF program link (attachment) types (raw tracepoint and tracing
> links), which are FD-based objects that are automatically detached when last
> file reference is closed. These types of BPF program links are switched to
> using bpf_link framework.
>
> FD-based bpf_link approach provides great safety guarantees, by ensuring there
> is not going to be an abandoned BPF program attached, if user process suddenly
> exits or forgets to clean up after itself. This is especially important in
> production environment and is what all the recent new BPF link types followed.
>
> One of the previously existing  inconveniences of FD-based approach, though,
> was the scenario in which user process wants to install BPF link and exit, but
> let attached BPF program run. Now, with bpf_link abstraction in place, it's
> easy to support pinning links in BPF FS, which is done as part of the same
> patch #1. This allows FD-based BPF program links to survive exit of a user
> process and original file descriptor being closed, by creating an file entry
> in BPF FS. This provides great safety by default, with simple way to opt out
> for cases where it's needed.
>
> Corresponding libbpf APIs are added in the same patch set, as well as
> selftests for this functionality.
>
> Other types of BPF program attachments (XDP, cgroup, perf_event, etc) are
> going to be converted in subsequent patches to follow similar approach.

Applied. Thanks.
