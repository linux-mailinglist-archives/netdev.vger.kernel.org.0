Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA85DB4CC
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394797AbfJQRvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:51:06 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35495 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfJQRvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:51:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id m15so4888406qtq.2;
        Thu, 17 Oct 2019 10:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1hl6OgV6noHwYetx1+iUn4b2S7F69/Ln6vk7zwwufhs=;
        b=VCRcIQwG87S3TMpx9Mugsu1Qst+9IZpwoFxvM8sNVpPVncFFcM3PoyHsoHEvtFO034
         9cCAmgNyeXLVPaIIPLMe5yzxUIz+iNEukHyO+RyWbGNVXhwdN2rLUd6W7AvGg9x0/wNO
         tbOvmK1HtH27c9R/+ASUseyrRAwe2MYP/HKWwznEgTEX3xvP/uEzMM37eL0W+SZILGva
         LKjHF3PkxHtDVjgsDXlc1MJAiMDF3qxgjKQSuxNC6TrDWJhodlRftrI0ZPTX7O5ijtqs
         9P81bPnklfGyvSzGO4zsEKLjWnku5IKq0ae9aQcsfzyL8PEydvcMM5BNPLbS6wCZRPiL
         0gfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1hl6OgV6noHwYetx1+iUn4b2S7F69/Ln6vk7zwwufhs=;
        b=D3Vc+B/7W/oBE26Na/RVFYLuBrkYoJB1Iq8QcO5KzEmXGN4BQ8XhFUT3Mmo0cDvpXO
         h/yLETrWVgSvLjFpq/2Ncb8ToIzaEmz3znPW1zvF7xHwjvDeo2zRdOEwD4iNPXwB9eI0
         vBGh9xcj+5TGj1+FHUaEGmKQ4av4HSw6/1FB7cOY0cA95UopUW5E4gOPPv1yA2ddgQIu
         HArOkaequheEyjCj3ozfk+zDkvQw0RNAgmSICaxToASx/Gw3AF0KjiUJMt53m5f7eS7i
         rDyFlnxiPfUaCWBDKLsYAfLAkkUpA9gVuAIdb5+NCsiphkyR+0yI0renhzrMEdsJGL2o
         uf8w==
X-Gm-Message-State: APjAAAUZlcSk0T552Y24m+qDWcUIPUpF0J9Ibvfcglj+27I+NyPerlkv
        iRg4HslvXEAwBzskof05CuWXQ3Nem6c5RWz+iqbUbwxt
X-Google-Smtp-Source: APXvYqyon+04XeS+uljGzQacjsGJBfDlCaMPpgbh7bNkv5QWlDArLtZFYhdLZq374TszTR1GlD+DEUOBEBHGTnsZCag=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr5140604qtn.117.1571334665362;
 Thu, 17 Oct 2019 10:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191016060051.2024182-1-andriin@fb.com> <20191016060051.2024182-6-andriin@fb.com>
In-Reply-To: <20191016060051.2024182-6-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Oct 2019 10:50:54 -0700
Message-ID: <CAEf4BzZvNQwcn3=sUHjnVfGzAMkfECpiJ7=YEDWSnLFZD7xeCA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/7] selftests/bpf: replace test_progs and
 test_maps w/ general rule
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 11:01 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Define test runner generation meta-rule that codifies dependencies
> between test runner, its tests, and its dependent BPF programs. Use that
> for defining test_progs and test_maps test-runners. Also additionally define
> 2 flavors of test_progs:
> - alu32, which builds BPF programs with 32-bit registers codegen;
> - bpf_gcc, which build BPF programs using GCC, if it supports BPF target.
>
> Overall, this is accomplished through $(eval)'ing a set of generic
> rules, which defines Makefile targets dynamically at runtime. See
> comments explaining the need for 2 $(evals), though.
>
> For each test runner we have (test_maps and test_progs, currently), and,
> optionally, their flavors, the logic of build process is modeled as
> follows (using test_progs as an example):
> - all BPF objects are in progs/:
>   - BPF object's .o file is built into output directory from
>     corresponding progs/.c file;
>   - all BPF objects in progs/*.c depend on all progs/*.h headers;
>   - all BPF objects depend on bpf_*.h helpers from libbpf (but not
>     libbpf archive). There is an extra rule to trigger bpf_helper_defs.h
>     (re-)build, if it's not present/outdated);
>   - build recipe for BPF object can be re-defined per test runner/flavor;
> - test files are built from prog_tests/*.c:
>   - all such test file objects are built on individual file basis;
>   - currently, every single test file depends on all BPF object files;
>     this might be improved in follow up patches to do 1-to-1 dependency,
>     but allowing to customize this per each individual test;
>   - each test runner definition can specify a list of extra .c and .h
>     files to be built along test files and test runner binary; all such
>     headers are becoming automatic dependency of each test .c file;
>   - due to test files sometimes embedding (using .incbin assembly
>     directive) contents of some BPF objects at compilation time, which are
>     expected to be in CWD of compiler, compilation for test file object does
>     cd into test runner's output directory; to support this mode all the
>     include paths are turned into absolute paths using $(abspath) make
>     function;
> - prog_tests/test.h is automatically (re-)generated with an entry for
>   each .c file in prog_tests/;
> - final test runner binary is linked together from test object files and
>   extra object files, linking together libbpf's archive as well;
> - it's possible to specify extra "resource" files/targets, which will be
>   copied into test runner output directory, if it differes from
>   Makefile-wide $(OUTPUT). This is used to ensure btf_dump test cases and
>   urandom_read binary is put into a test runner's CWD for tests to find
>   them in runtime.
>
> For flavored test runners, their output directory is a subdirectory of
> common Makefile-wide $(OUTPUT) directory with flavor name used as
> subdirectory name.
>
> BPF objects targets might be reused between different test runners, so
> extra checks are employed to not double-define them. Similarly, we have
> redefinition guards for output directories and test headers.
>
> test_verifier follows slightly different patterns and is simple enough
> to not justify generalizing TEST_RUNNER_DEFINE/TEST_RUNNER_DEFINE_RULES
> further to accomodate these differences. Instead, rules for
> test_verifier are minimized and simplified, while preserving correctness
> of dependencies.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

BTW, if correctness and DRY-ness argument is not strong enough, these
changes makes clean rebuild from scratch about 2x faster for me:

BEFORE: `make clean && time make -j50` is 14-15 seconds
AFTER: `make clean && time make -j50` is 7-8 seconds


[...]
