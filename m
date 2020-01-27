Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FE914A9D3
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 19:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgA0Sey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 13:34:54 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46480 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgA0Sey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 13:34:54 -0500
Received: by mail-qk1-f196.google.com with SMTP id g195so10592337qke.13;
        Mon, 27 Jan 2020 10:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f8NOrtqi23wWof9JzLK2tNTiXAqyl8GSSIKTJIqJPz4=;
        b=drVqL/qZRxOEsn3k3go1PGz1BAxaQ/dNWwYsfs8YAYYmJNdW93q71i9lqRS6gHexn8
         8eyCTJQI2+7UE8da5m/9b+tx80l6rHGxDKEcaTFUrNIn9YJzD02fz/F0GvguAmX7k5/x
         wvqm36WGzybJDlpTJKOVcfaANZJAUIlunueL1jNDt262pX6IQIlTmdcwnf1/0ZNBq37v
         JpQl7ytwWefz1w19Z3XcmshddxxUtGJkkvGMmnrS4CfIHFziCCxfVbTz9D8Tua+v0nnG
         tj6V+RT21bwJa0bAOb2/hQqDz2NRI60XVWfddXFgtUluOqC9r+b+Py4YhRpSKBBIVnNn
         kmpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f8NOrtqi23wWof9JzLK2tNTiXAqyl8GSSIKTJIqJPz4=;
        b=atudBtlsMXZlWwc7EuR2n6VbhPgznbRMUibJPuzF85Z0Vvr9xlkaFzpTfzzp7iM3OU
         jNYxARBOGQ0xlnBf872LFXCsDdTBxwPIeFwU/d7AdNA7vf8+0wlP6GHl7/UCOzV6drEA
         XQwu1Y5ItY5IcO/xGsQhOGrvg4C2ALVYzhhXi2ERhuUd/HMRDRFWvU6SyAoftooqMHMd
         KWqjghW6GWXxv1D8AeJW57aqPIsItCLMmOD5/3Hw9wnyFyobfN8vw/RD6bMkxCxXnUu/
         aKOGATbUl2uUB0rbbM/yggTo6u+av5ZjHxbuyorqbwqR4yp3qkaxujwff3hi1briSukD
         cS0A==
X-Gm-Message-State: APjAAAUsFMArx1zAUzO5tTr2RuEQWLD/usmCYJfVvY6yCT5ZTZWFhx6C
        /XgbXfBLuN3u1fYxulAfA+GVKaMRZho6nJ+LG8b5qw==
X-Google-Smtp-Source: APXvYqwooDmBqht+/JeQLNBZvtnrvnThGGPUf39rCwrugsLtLpV5ML2pDtPq9hvQWiki3xEFFWv5ViflMNnqmBzx7u4=
X-Received: by 2002:a37:e408:: with SMTP id y8mr17970935qkf.39.1580150092890;
 Mon, 27 Jan 2020 10:34:52 -0800 (PST)
MIME-Version: 1.0
References: <20200127175145.1154438-1-kafai@fb.com>
In-Reply-To: <20200127175145.1154438-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jan 2020 10:34:42 -0800
Message-ID: <CAEf4BzYONH0jpi+VV8Q72q2Uico2_MnydX0ptpcOJQLW8H+gng@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Reuse log from btf_prase_vmlinux() in btf_struct_ops_init()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 9:52 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> Instead of using a locally defined "struct bpf_verifier_log log = {}",
> btf_struct_ops_init() should reuse the "log" from its calling
> function "btf_parse_vmlinux()".  It should also resolve the
> frame-size too large compiler warning in some ARCH.
>
> Fixes: 27ae7997a661 ("bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

LGTM, but there is typo in subject (btf_prase_vmlinux).

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
