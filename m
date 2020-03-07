Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D960717C96C
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 01:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCGAKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 19:10:38 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33124 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgCGAKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 19:10:38 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay11so1528478plb.0;
        Fri, 06 Mar 2020 16:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=SjrcOFxpufht/8OfMzLi8EQcwzvSyJ9VwN1nXbsalBw=;
        b=ZFCG7tkr4L7i6JCFMOi8u0GcXRp2RoBbzQn14R4y8ZQrkyipXea0a1vEuXzDskaJdX
         VUhdDThYzDHWumtVayM1yANOZca0ISfPFyrVxpNfNHS5LPMmLVT5uOQ6WXSxUAQbrjg5
         K/b4YkB10Dvfy6e572lRM0h7BNUZ4wrieEKntpoWJs3VSm8V3nbqpanvhSj4YAPvEtjl
         kXbkXe9nfvXAK9g41x8ysiqC0Uxc4CL5WqsSD1zoCqatGvkapxnsFBNuw2IesFWBgihK
         ZtEz8gOB0BHsyRiCU3rHjAfMynNQDgdXOc0YUxPaXct5KtRsOjvgoLt8f+ni4ndNKNdL
         d+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=SjrcOFxpufht/8OfMzLi8EQcwzvSyJ9VwN1nXbsalBw=;
        b=SebigpStW3+6KJs+vdGJdPB04W+sEOxxhmpGhNqvKfZS7CjLic0vUiTN1NkxxBmfsF
         Jwppdg04QCFwET16Yqr+rcMXDd+yXzJz/vSCl6OTAWqHl9eBhAj+VJpD30ZWS6w3+wB9
         xAP1fgNjCLZba6MkEtcMa0DvXbp1Ka4T/Mfx1+LwKU7a40q91zSW/4j1tKvi9N4lts3f
         cTrIlujaHJk6K2ztNMWAiDb16UL/Jb61OWRW6H5naMCLBbgz5NYnDylvvCsswnXRb9Be
         6F0sWyN3S8Pg8S0MFU14HO011ACJXSB3BR/9niE0ICxgaZIS3O7Id0mgIDY4yxLNqCOs
         rdYA==
X-Gm-Message-State: ANhLgQ0hNLANuIIaweSTCzF0sfXhTDO6nUpDqtvNbEyM7xXzTQR47pwd
        KuJuKB7lg28WpVtbzP1DbzUkIYk4
X-Google-Smtp-Source: ADFU+vtWidJID8I4AMN8H/u6xZOR5GN5Bp3Ulv6f+GvvcL9rT2vXVO8JTWxZGSiJqqPeJl4Kg8tibw==
X-Received: by 2002:a17:90b:11d0:: with SMTP id gv16mr5725334pjb.183.1583539836841;
        Fri, 06 Mar 2020 16:10:36 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t126sm3052707pfd.54.2020.03.06.16.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 16:10:35 -0800 (PST)
Subject: [RFC bpf PATCH 0/4] rfc for 32-bit subreg verifier tracking
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Sat, 07 Mar 2020 00:10:23 +0000
Message-ID: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds 32-bit subreg bounds support to the verifier. This is the
fallout from trying to apply patch 3/4 to fix return value refinement.
With the fix it turned out some code code that _should_ pass the
verifier no longer worked. The root cause of this (see patch 4/4 for
detailed trace) was improper tracking of the 32-bit subreg values. So
that even if a program zero'd the upper 32-bits we wouldn't actually
psas the program.

I tried various other half-measures before I decided it was best to
do proper 32-bit bounds tracking. Each time I tried to "hack" the
result I wanted in the interest of minimal code changes I ended up
with something that was both ugly and usually only matched a small
subset of patterns. Also, in general I'm against pattern matching
special cases because it ends up buggy/broken usually as soon as
we get code in the wild that doesn't do the exact thing we pattern
matched.

So end result is u32_{min|max}_value, s32_{min|max}_value,
and var32_off bounds tracking. See patch 2/4 for the details and a few
questions we should address in the RFC while I write up some more
test cases.

After this series we can do some nice cleanup in *next branch. For
example, add proper types for int return values so we can be more
precise. And flush out some additional logic in the ALU ops to
track rsh, lsh, arsh better.

Please, take a look at patch 2 for a couple design questions.

RFC because, needs a bit more review on my part, a couple cleanup
lines still in 2/4, still need to run test_progs all the way
through I missed a bunch due to missing kernel config options, and
want to write a couple verifier tests to catch the subtle cases.

I thought it would be best to get some early/quick review feedback
while I work on the tests. It does pass test_verifier though in
current state.

Thanks,
John

---

John Fastabend (4):
      bpf: verifer, refactor adjust_scalar_min_max_vals
      bpf: verifier, do explicit u32 bounds tracking
      bpf: verifier, do_refine_retval_range may clamp umin to 0 incorrectly
      bpf: selftests, bpf_get_stack return value add <0


 tools/testing/selftests/bpf/test_verifier.c        |    2 +-
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--
Signature
