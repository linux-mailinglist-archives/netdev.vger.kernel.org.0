Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7920820EEA
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfEPSqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:46:47 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41085 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfEPSqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 14:46:47 -0400
Received: by mail-lj1-f196.google.com with SMTP id k8so4029604lja.8;
        Thu, 16 May 2019 11:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZeB8pqT2bxFTZLLc8OH5SCHVpehQcaxcAYjgmxC5UKw=;
        b=KXRLoe+v95HJZU+BUYnuaKn1gi6vs6vec4BdwrZxasijcYOWdLQG5xWaTmbX06aDLb
         WTWDkVn3b1vBMBplsXDOB+Zq13nUGNM4krNW/Gz4JaFQrEEzLvPjvWBHu8NM9h1FG8hT
         WozwukEYKxD2Kcw2koivxy0RLkdr+juTqpTbbh5CMa3DepyIeoiR2yOJJ7hJ9cho8smD
         0raUpI/xlv34FXIZL3DxDW4Kadb8efnwqxN0Lyu7qMJenou5eMTHdzbbZxVbWBPXyA85
         SfK54UxL5BLPYTVCqxrpDJiMq/4xOce81g8Srjjm7wAr8B9+P2+eXGMpJPHPN2iv/uvJ
         R+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZeB8pqT2bxFTZLLc8OH5SCHVpehQcaxcAYjgmxC5UKw=;
        b=bk23jiTYtcWWg1thlElo8tue8qZZXar3+xicOlUo9lzwOBpK2UbnnZ/BWAT8dmI8SK
         MCUkh3AiMrh9EJZ/iettU0DlmZtyjFig0ED0XXoSOfPJeaePgARf1Qd35iaVkq/OQ6sH
         sZxx3YM4rz4GwmX2w2cDYHe50FKXhscuilboTaLYjvaOAvIhbmYQVXg6eCHU5FuX/WdC
         ugnqsCM+0uFIx2sJEhvJ1sQh+mHsiNISDOpFUT8RGV3BdT2/8aLuHTB/5/sDhQ/zyS0n
         qNQWLbicz0F4O3635aAOKTvUtugcPeizJM0omoEeotXlTQkE+ukk46YtpXQqyySyXLKb
         r1bw==
X-Gm-Message-State: APjAAAVnhyiCH2ytX8vcZUmFTCgKkD2nmweBKqPHezWe34RIfMuasFWK
        kgSdgzsZwrB0DaALGhjkpAU/U6/ZlW0h65krklk=
X-Google-Smtp-Source: APXvYqzpSLYHtGYCPjOJ1BJndcVaop8m0hFpgOMnx8NqMiSW8qQ8ky8PGmxDH3g5Hyq8k6l/OkpsAtTdpX+yUdFUWpQ=
X-Received: by 2002:a2e:84ce:: with SMTP id q14mr25595628ljh.80.1558032404831;
 Thu, 16 May 2019 11:46:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190516171731.2320976-1-yhs@fb.com>
In-Reply-To: <20190516171731.2320976-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 May 2019 11:46:33 -0700
Message-ID: <CAADnVQL9VhTDhD-9a_2cZzHXLXW=pa9uQV4XgtDYZ-nTdLWt+A@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpftool: move set_max_rlimit() before __bpf_object__open_xattr()
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 11:31 AM Yonghong Song <yhs@fb.com> wrote:
>
> For a host which has a lower rlimit for max locked memory (e.g., 64KB),
> the following error occurs in one of our production systems:
>   # /usr/sbin/bpftool prog load /paragon/pods/52877437/home/mark.o \
>     /sys/fs/bpf/paragon_mark_21 type cgroup/skb \
>     map idx 0 pinned /sys/fs/bpf/paragon_map_21
>   libbpf: Error in bpf_object__probe_name():Operation not permitted(1).
>     Couldn't load basic 'r0 = 0' BPF program.
>   Error: failed to open object file
>
> The reason is due to low locked memory during bpf_object__probe_name()
> which probes whether program name is supported in kernel or not
> during __bpf_object__open_xattr().
>
> bpftool program load already tries to relax mlock rlimit before
> bpf_object__load(). Let us move set_max_rlimit() before
> __bpf_object__open_xattr(), which fixed the issue here.
>
> Fixes: 47eff61777c7 ("bpf, libbpf: introduce bpf_object__probe_caps to test BPF capabilities")
> Signed-off-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
