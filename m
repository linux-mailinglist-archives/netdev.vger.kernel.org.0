Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBC42D4E34
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388953AbgLIWlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:41:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40929 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388674AbgLIWYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 17:24:52 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <seth.forshee@canonical.com>)
        id 1kn7rW-0008DJ-RU
        for netdev@vger.kernel.org; Wed, 09 Dec 2020 22:23:07 +0000
Received: by mail-il1-f200.google.com with SMTP id f19so2735015ilk.8
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 14:23:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=nCPT21aBYHK+VmSNH6RsExkU8pXC3B3JSnVf9A2XUAw=;
        b=fm6afTUueNlsgcoNwlNlgSbKKqFVjWitXgP4ugNbXE/uZrQhQEL7NAeVDoCLmsavDT
         wVsJaG+HcbuNVY4dcDerRUxFroXdjQhtQ+5k+xrGa5ycilezCiAaC4nBgy6lKHII3iq8
         eg7Wf5x8SuCj1nC3RbmwmYsSDUYXjTtshiz3pBcMSCw7o9SMCjo63p9gFqF07dR381L7
         3MvSvzfeCPIwINilpyCFWhYHgyQqznTJbPxGqsgWihmpGTPndQ1HqrR8EsXYlia/ryvl
         EZkss641lKHI61w8nG9LlvhqhoJhAnSPY3vubxYajWNKJEuK4ONicRfMrFYdHlzA2wv7
         Qlyw==
X-Gm-Message-State: AOAM532kHm7jehnzbqV5p6pkw00QazgdVPDGi0hQe+gDsBOxBhJzn3Us
        MXw7JOjHVzk/4GnuWnPxzr5iKl+hgvxe9R+HTQqH147aQ8KhWJlFNE70d76RJu87MTa4H/fVUut
        8DAkLYVWrZRnpBNanX3C0DByGtEUanR7xKw==
X-Received: by 2002:a5d:9507:: with SMTP id d7mr5636561iom.32.1607552585835;
        Wed, 09 Dec 2020 14:23:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPHEVz4M/SVZNUt1nS2IcUlOCb7v1fywa1vG7vTZjQwq6m0YhMMXsMPX3MpNt78iFWUndNBA==
X-Received: by 2002:a5d:9507:: with SMTP id d7mr5636527iom.32.1607552585581;
        Wed, 09 Dec 2020 14:23:05 -0800 (PST)
Received: from localhost ([2605:a601:ac0f:820:f6e7:e083:7e01:5905])
        by smtp.gmail.com with ESMTPSA id e1sm1528753iod.17.2020.12.09.14.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 14:23:05 -0800 (PST)
Date:   Wed, 9 Dec 2020 16:23:04 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BPF selftests build failure in 5.10-rc
Message-ID: <X9FOSImMbu0/SV5B@ubuntu-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building the BPF selftests with clang 11, I'm getting the following
error:

   CLNG-LLC [test_maps] profiler1.o
 In file included from progs/profiler1.c:6:
 progs/profiler.inc.h:260:17: error: use of unknown builtin '__builtin_preserve_enum_value' [-Wimplicit-function-declaration]
                 int cgrp_id = bpf_core_enum_value(enum cgroup_subsys_id___local,
                               ^
 /home/ubuntu/unstable/tools/testing/selftests/bpf/tools/include/bpf/bpf_core_read.h:179:2: note: expanded from macro 'bpf_core_enum_value'
         __builtin_preserve_enum_value(*(typeof(enum_type) *)enum_value, BPF_ENUMVAL_VALUE)
         ^
 1 error generated.
 llc: error: llc: <stdin>:1:1: error: expected top-level entity
 BPF obj compilation failed

I see that test_core_reloc_enumval.c takes precautions around the use of
__builtin_preserve_enum_value as it is currently only available in clang
12 nightlies. Is it possible to do something similar here? Though I see
that the use of the builtin is not nearly so neatly localized as it is
in test_core_reloc_enumval.c.

Thanks,
Seth
