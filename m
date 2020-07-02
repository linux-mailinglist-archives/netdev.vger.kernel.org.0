Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E20C213009
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 01:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgGBX0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 19:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgGBX0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 19:26:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB5AC08C5E0
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 16:26:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a9so2668902pjh.5
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 16:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dT6/5SMac3wtXA/ljYFQAKilCRwIlUvqkRFcx76hVLY=;
        b=l7b80WgP/9KVetj24VmgUT9DOBWaOm2zCIwYx6IuwWZ6c2fVCdsyBRS5aYxy0GewrX
         tKhLt5bxkJVIBNNyRvbc77SE7w3PAbsT5iDtCHwscAY1foF9ukY/uLANrAV4m+twMA+p
         Dyf5+m5g0uBTdpM8+M7uS1MDAovBBbCn8FkUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dT6/5SMac3wtXA/ljYFQAKilCRwIlUvqkRFcx76hVLY=;
        b=rLh1xh6ghLqGnFwAH3ALgDU5tccxPF7X+2ELSBd6iBFcDQQvrmPc0cn/iuQGAXm+d2
         50JotDFNw+tDu7QjM8Bz/PvkXXoySgGYTfUBCzu/Ba2oqpamdtG+rva1UrnM/oSBAyeE
         enbPk+jpQK8IULvhDhiuNTUYlWoSJndpXRrDQiHyy7mRg6LDRO6cUhHqgbqJR2r5dzo2
         jNLlb36SX7XiMlGqzFZnNJGnwgWfMVvPgZPuXi+VnShkXmyrgLcB7xKiQXW//jTOJVqD
         yZPIwlrPDzuNIyF/Zb2f92axj/JOklKaFMH4/bi7oNcJ8EOzdqFD+DHceJtA1AmN6Fdt
         GvhQ==
X-Gm-Message-State: AOAM531s95XjoOODIKTlsmY972XwxdLRjpG451Fk2FRBix5uVhcdBb5t
        S03ydd0lO78AC0o6zWnz9OQ7og==
X-Google-Smtp-Source: ABdhPJw33nr5S79BxxRlF82vDbMAVkEgPdFtkwFxNrR2snkoy7WQHNOxVKjahspezQFiRSUaOG4PGw==
X-Received: by 2002:a17:90b:488:: with SMTP id bh8mr33638518pjb.49.1593732402767;
        Thu, 02 Jul 2020 16:26:42 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g4sm9418640pfi.68.2020.07.02.16.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 16:26:41 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Dominik Czarnota <dominik.czarnota@trailofbits.com>
Cc:     Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Refactor kallsyms_show_value() users for correct cred
Date:   Thu,  2 Jul 2020 16:26:33 -0700
Message-Id: <20200702232638.2946421-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm not sure who should carry this tree (me? Greg? akpm? Linus?), but
it fixes a kernel address exposure bug reported by Dominik Czarnota,
where /sys/modules/*/sections/* contents were visible to uid-0 without
CAP_SYSLOG (e.g. in containers):

This is correct, with CAP_SYSLOG:
 # cat /sys/module/*/sections/.*text
 0xffffffffc0458000
 ...

This is broken:
 # capsh --drop=CAP_SYSLOG -- -c "cat /sys/module/*/sections/.*text"
 0xffffffffc0458000
 ...

Fixing this required refactoring of several internals, and in the process
uncovered other users of kallsyms_show_value() that were doing checks
during "read" context instead of "open" context. This fixes all of these
cases by plumbing the file->f_cred through to their ultimate checks via
kallsyms_show_value()'s new cred argument.

Testing, reviews, and acks appreciated. :)

Thanks!

-Kees


Kees Cook (5):
  kallsyms: Refactor kallsyms_show_value() to take cred
  module: Refactor section attr into bin attribute
  module: Do not expose section addresses to non-CAP_SYSLOG
  kprobes: Do not expose probe addresses to non-CAP_SYSLOG
  bpf: Check correct cred for CAP_SYSLOG in bpf_dump_raw_ok()

 include/linux/filter.h     |  4 +--
 include/linux/kallsyms.h   |  5 ++--
 kernel/bpf/syscall.c       | 37 +++++++++++++++------------
 kernel/kallsyms.c          | 17 ++++++++-----
 kernel/kprobes.c           |  4 +--
 kernel/module.c            | 51 ++++++++++++++++++++------------------
 net/core/sysctl_net_core.c |  2 +-
 7 files changed, 67 insertions(+), 53 deletions(-)

-- 
2.25.1

