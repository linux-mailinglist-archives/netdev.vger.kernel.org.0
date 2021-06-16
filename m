Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47E83AA713
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhFPW5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhFPW5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 18:57:03 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701C6C061760
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:54:55 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id l64so970450ioa.7
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=Rj65L+69QEh9Xq7tVVEJoiMR1gEYQNnC5Svq/jxm5BM=;
        b=UxgVJj1/xxlip0INwrnmkzYz1jvXch7BohtmzVPaldSo48lrLbezHYou4c8F2tDiZV
         J4AfmSppz970IEQi/FkJF67QIbm0koPY0+yfcpWxl612wVZQKkzuBWg05udKUXI5Xj0+
         t8eTEwpfHPGtju0EqGQ5QJxi3/K2NqBrT68jN/bALo2EpYD7jWe2jT0rCl7jPiblSQ5e
         qeineAGRh/ropUfiYQStPz+ppgYSvsQq9Kg8Tr8FYzY4+8OP7k0g0UoGEjE5LxeRRyXt
         hIjBf9ESL/L4w/XQn764Tor//fbKnUlF7ZeyclaJW9BWFURIl7k8QJnkk9bFy9kVIuQu
         SklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Rj65L+69QEh9Xq7tVVEJoiMR1gEYQNnC5Svq/jxm5BM=;
        b=s7xFPy5hi/SyqqQMDaDJkcfUDU73X5RI1saZwfYL21IXmbplpRakTppe0OML8dlc8r
         1Qqy+aM5E9nz9rP0KxAYynM9MSUR0t9uAX1ZMsJERB9e7iJnjUl0aksooPOl6naJjWc8
         2Pg6Yl9qbEfKvDdTtbIxIOx/T9ubgIu/BFY93NEgf10yupdQqplo6vnuEpfCPJ0bHBDc
         AQ9UQBTVCDu+mrILnMNxXUlFlIgH1YrSt48XtC0X68QI7jUYxqnoe27+V5Gb8J4pXZdW
         yzHWRxNgW7BvPooqa/H/z+q71jP4y3vlvRf8K7In1mo64UiL3xzc4yhNqbKqAeR2gofI
         R62w==
X-Gm-Message-State: AOAM5336QvvloEzXbhkaLqQcXg6N5Uws50amqdKyqKgR0OmWAFtTTsyj
        3y2fWudc7Tly8LgqhkQUlLA=
X-Google-Smtp-Source: ABdhPJyav9dkZi8gB7nfpKQFuH7J5o5fQ0wjgP6Rt3fwiR+s0qECg3L1Gl4PUrjEyfyN77n0Ox9y+Q==
X-Received: by 2002:a6b:8ec2:: with SMTP id q185mr1308426iod.22.1623884094886;
        Wed, 16 Jun 2021 15:54:54 -0700 (PDT)
Received: from [127.0.1.1] ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id x2sm1876977iox.15.2021.06.16.15.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 15:54:54 -0700 (PDT)
Subject: [PATCH bpf v2 0/4] BPF fixes mixed tail and bpf2bpf calls
From:   John Fastabend <john.fastabend@gmail.com>
To:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 16 Jun 2021 15:54:42 -0700
Message-ID: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We recently tried to use mixed programs that have both tail calls and
subprograms, but it needs the attached fixes.

Also added a new test case tailcall_bpf2bpf_5 that simply runs the
previous test case tailcall_bpf2bpf_4 and adds some "noise". The
noise here is just a bunch of map calls to get the verifier to insert
instructions and cause code movement plus it forces used_maps logic
to be used. Originally, I just extended bpf2bpf_4 directly, but if I
got the feedback correct it seems the preference is to have another
test case for this specifically.

With attached patches our programs are happily running with mixed
subprograms and tailcalls.

Thanks,
John

---

John Fastabend (4):
      bpf: Fix null ptr deref with mixed tail calls and subprogs
      bpf: map_poke_descriptor is being called with an unstable poke_tab[]
      bpf: track subprog poke correctly
      bpf: selftest to verify mixing bpf2bpf calls and tailcalls with insn patch


 include/linux/bpf.h                           |  1 +
 kernel/bpf/core.c                             |  6 ++--
 kernel/bpf/verifier.c                         | 36 ++++++++++++++-----
 .../selftests/bpf/prog_tests/tailcalls.c      | 36 +++++++++++++------
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   | 20 ++++++++++-
 5 files changed, 77 insertions(+), 22 deletions(-)

--

