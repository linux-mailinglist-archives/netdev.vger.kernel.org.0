Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874111086A
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfEANrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:47:33 -0400
Received: from conuserg-11.nifty.com ([210.131.2.78]:29860 "EHLO
        conuserg-11.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfEANrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:47:33 -0400
Received: from grover.flets-west.jp (softbank126125154137.bbtec.net [126.125.154.137]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id x41DkAqH006908;
        Wed, 1 May 2019 22:46:10 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com x41DkAqH006908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1556718371;
        bh=r0tKWu4K0FaqMQsDo16rqksf/YsVt69hJkPu3of5sNs=;
        h=From:To:Cc:Subject:Date:From;
        b=Si7Jr3+R+5NB5DAbMoi+oNJUQEhichvJc7P6ya+mg1vm6/5aK6WVp9kpY8a1C7Oth
         ILQAa6yO0t1uWDOFYJeOOHH7SZHzMgJcuFOkTdCoYNDs/C4g3v9c0bDHkWvxP++nuY
         jRuHdh627B42W8JzIZiZVjagvzZNr2yFf/B3nUtI4moG7spsHrXAueqn5F93lgsc0h
         xJLRW4w6lEA9utgwsZG49UGerJ6pkdxFhV28p/zihvr6RCKeNvozRQSh+a6rSQPhtF
         9NgzNE4qWZw0ePK4JiB+3NsmmVKr1nRVT6Qskl+EslWk5ZCxaLXzKXxzMDCS4Bj1NL
         u2EfE5O1cd7xA==
X-Nifty-SrcIP: [126.125.154.137]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sirio Balmelli <sirio@b-ad.ch>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Yonghong Song <yhs@fb.com>,
        Taeung Song <treeze.taeung@gmail.com>,
        linux-kernel@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH v2] bpftool: exclude bash-completion/bpftool from .gitignore pattern
Date:   Wed,  1 May 2019 22:45:59 +0900
Message-Id: <1556718359-1598-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tools/bpf/bpftool/.gitignore has the "bpftool" pattern, which is
intended to ignore the following build artifact:

  tools/bpf/bpftool/bpftool

However, the .gitignore entry is effective not only for the current
directory, but also for any sub-directories.

So, from the point of .gitignore grammar, the following check-in file
is also considered to be ignored:

  tools/bpf/bpftool/bash-completion/bpftool

As the manual gitignore(5) says "Files already tracked by Git are not
affected", this is not a problem as far as Git is concerned.

However, Git is not the only program that parses .gitignore because
.gitignore is useful to distinguish build artifacts from source files.

For example, tar(1) supports the --exclude-vcs-ignore option. As of
writing, this option does not work perfectly, but it intends to create
a tarball excluding files specified by .gitignore.

So, I believe it is better to fix this issue.

You can fix it by prefixing the pattern with a slash; the leading slash
means the specified pattern is relative to the current directory.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

Changes in v2:
  - Add more information to the commit log to clarify my main motivation
  - Touch "bpftool" pattern only

 tools/bpf/bpftool/.gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
index 67167e4..8248b8d 100644
--- a/tools/bpf/bpftool/.gitignore
+++ b/tools/bpf/bpftool/.gitignore
@@ -1,5 +1,5 @@
 *.d
-bpftool
+/bpftool
 bpftool*.8
 bpf-helpers.*
 FEATURE-DUMP.bpftool
-- 
2.7.4

