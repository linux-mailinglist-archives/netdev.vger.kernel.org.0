Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355BE166CA7
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 03:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgBUCGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 21:06:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgBUCGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 21:06:41 -0500
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0DA820659;
        Fri, 21 Feb 2020 02:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582250801;
        bh=ciW7M4/rpadPpVKzgkZKDKV7BnaACSF1idCdnwPCl3o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MP9a5xmDUW5hQK1KvM9LCnP1gqsoFlDTxTQGjDAn6mQe9ELcu306poIK7AB3hClSn
         YxpaidMCtDrG5F2UIFij+4+/c1AUD7JH0dYTWJDA/UUUbNhMoTFh/DFBfAgZbnqDNg
         bXIJwM94iJgYRNxqg3hY0jMX+R9XY+sI4dwGfIQU=
Received: by mail-lj1-f169.google.com with SMTP id d10so514446ljl.9;
        Thu, 20 Feb 2020 18:06:40 -0800 (PST)
X-Gm-Message-State: APjAAAW1CwsUaqGbIhJj5whzitUuBZwkwCoKBSAC3Gz5HdcRYzNzixUv
        3IaNcosvj1HUUmnXwL2Q0U3N1q/c9Hdvddxl6nM=
X-Google-Smtp-Source: APXvYqyvqTaR0KZNS11sCSscS9XUGP/WAqsTX/fVy1NDPevEDaEcaOKeJMwiNhyPinin4nlbwpWEtyHARmacvrnpehs=
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr1708671ljq.109.1582250798788;
 Thu, 20 Feb 2020 18:06:38 -0800 (PST)
MIME-Version: 1.0
References: <20200220230546.769250-1-andriin@fb.com>
In-Reply-To: <20200220230546.769250-1-andriin@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 Feb 2020 18:06:27 -0800
X-Gmail-Original-Message-ID: <CAPhsuW60BM0JjTBLyE3mYea+W-5CFPouveMfEwkbMEwQUbNbZg@mail.gmail.com>
Message-ID: <CAPhsuW60BM0JjTBLyE3mYea+W-5CFPouveMfEwkbMEwQUbNbZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up logic
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 3:07 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Libbpf's Travis CI tests caught this issue. Ensure bpf_link and bpf_object
> clean up is performed correctly.
>
> Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines count")
> Cc: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../bpf/prog_tests/trampoline_count.c         | 25 +++++++++++++------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> index 1f6ccdaed1ac..781c8d11604b 100644
> --- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> +++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> @@ -55,31 +55,40 @@ void test_trampoline_count(void)
>         /* attach 'allowed' 40 trampoline programs */
>         for (i = 0; i < MAX_TRAMP_PROGS; i++) {
>                 obj = bpf_object__open_file(object, NULL);
> -               if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
> +               if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
> +                       obj = NULL;

I think we don't need obj and link in cleanup? Did I miss anything?
