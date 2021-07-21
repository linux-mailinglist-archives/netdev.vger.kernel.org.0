Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033DF3D0613
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 02:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhGTX2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 19:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbhGTX1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 19:27:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909CAC061574;
        Tue, 20 Jul 2021 17:08:25 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id j73so284391pge.1;
        Tue, 20 Jul 2021 17:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XD+5w5d0nOB9HAnbrEPa07AhJ1PdtZ8e4Xmaj/6HQss=;
        b=kJEAV6UouwUwSMFYLIK4L7bSOwlAIolxUiQtLqrrB+6J+Q8kFbKIIxMyYGIsxnRrCP
         pMe6Ofv2hZMIpv5bSK6r8aHYwFjK9xuYLxBryjQ6zif7+2gfO4JzWGk8seswtCiUGHSW
         Gxa85GPN/qIZeuGXckTXhXuozlWUhsugwpNsVqJ69vl3sl6tCYhg5TXvRIVG5fez8eOY
         ihW1gXD+XiXkSGw1YGTaOVhyoerhYsYK5n7NHzhtlWPj2fq+XTLITySjYkU41EdNBYAJ
         OkzT4t+J04p8aPTaNmL08FvV760zCthKJo2s8tuNnhTpASn+aMFNBbH/AFhjjBtYkRU6
         gaLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XD+5w5d0nOB9HAnbrEPa07AhJ1PdtZ8e4Xmaj/6HQss=;
        b=Tkn9ZnJhJyKAe8aMahw813gIMXYkLh5ticnor7Vq+DF+DzQKL9DmkMSADnKpbn25TL
         uEysv1WB3TqvEZLHdJZ3lhot9Xcrvez/7GCmcBvj2eCsE36/ziWgSg/g/6wf2Uc/iCbg
         srocXelE0IGF5mJIgFlnqPgXrN6I3M81Kcy/Hmsx1Fz86MhoXiziEJxO1xyYA/CdzcrY
         Pb6fP3u/bWa+sGoxrLPJmLkmQlF+okKBPqySL7fBKCmLhfzrOQXLJfax+T8BvC3qCWk9
         fw668aNnki418RXASiKHf/tY7fbvA52td20yj7yYPrHRjrhovJefdMQtV7R0CChYVqfk
         jz7Q==
X-Gm-Message-State: AOAM533IKa05o/n0aPuyagQrol2n/676SZA00M553cDaJWFgtk8LzTr3
        2Q2Hp/K1zfCphwQlzcDSEmpnJZ4AHjs=
X-Google-Smtp-Source: ABdhPJzRYbviZGkvTVWQgRFPZkgYCOC/8S/Cjf5x4oO992CAfD6fAoA3vidVMw/glul0EEM9I7xbeQ==
X-Received: by 2002:a63:d84b:: with SMTP id k11mr33313928pgj.372.1626826105067;
        Tue, 20 Jul 2021 17:08:25 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:500::6:4ad3])
        by smtp.gmail.com with ESMTPSA id o91sm3830168pjo.15.2021.07.20.17.08.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Jul 2021 17:08:24 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 0/4] libbpf: Move CO-RE logic into separate file.
Date:   Tue, 20 Jul 2021 17:08:18 -0700
Message-Id: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Split CO-RE processing logic from libbpf into separate file
with an interface that doesn't dependend on libbpf internal details.
As the next step relo_core.c will be compiled with libbpf and with the kernel.
The _internal_ interface between libbpf/CO-RE and kernel/CO-RE will be:
int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
			     int insn_idx,
			     const struct bpf_core_relo *relo,
			     int relo_idx,
			     const struct btf *local_btf,
			     struct bpf_core_cand_list *cands);
where bpf_core_relo and bpf_core_cand_list are simple types
prepared by kernel and libbpf.

Though diff stat shows a lot of lines inserted/deleted they are moved lines.
Pls review with diff.colorMoved.

Alexei Starovoitov (4):
  libbpf: Cleanup the layering between CORE and bpf_program.
  libbpf: Split bpf_core_apply_relo() into bpf_program indepdent helper.
  libbpf: Move CO-RE types into relo_core.h.
  libbpf: Split CO-RE logic into relo_core.c.

 tools/lib/bpf/Build             |    2 +-
 tools/lib/bpf/libbpf.c          | 1344 +------------------------------
 tools/lib/bpf/libbpf_internal.h |   81 +-
 tools/lib/bpf/relo_core.c       | 1326 ++++++++++++++++++++++++++++++
 tools/lib/bpf/relo_core.h       |  102 +++
 5 files changed, 1473 insertions(+), 1382 deletions(-)
 create mode 100644 tools/lib/bpf/relo_core.c
 create mode 100644 tools/lib/bpf/relo_core.h

-- 
2.30.2

