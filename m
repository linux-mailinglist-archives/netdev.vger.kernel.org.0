Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F62119445
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbfLJVOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:14:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbfLJVNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A205920828;
        Tue, 10 Dec 2019 21:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012429;
        bh=puIRiE8buRungqTMnVSyp89+O+XIRVd0ghEbEtscM90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkG3L0EGR5b1KKienflle01k5xU6LM8rE48sMxXMYidwEuqUqRnlRhFa5Gt4tfqng
         5uT9yhehGku498TcCIagYi4HDsJ4CxxJincctTDYOeOqCeYON8v8l/CzcH1Yf29o+H
         Gh7+zjH45re3sVnSp8+t1hJ+e34H72Fph6VYBPg4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 343/350] tools, bpf: Fix build for 'make -s tools/bpf O=<dir>'
Date:   Tue, 10 Dec 2019 16:07:28 -0500
Message-Id: <20191210210735.9077-304-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit a89b2cbf71d64b61e79bbe5cb7ff4664797eeaaf ]

Building selftests with 'make TARGETS=bpf kselftest' was fixed in commit
55d554f5d140 ("tools: bpf: Use !building_out_of_srctree to determine
srctree"). However, by updating $(srctree) in tools/bpf/Makefile for
in-tree builds only, we leave out the case where we pass an output
directory to build BPF tools, but $(srctree) is not set. This
typically happens for:

    $ make -s tools/bpf O=/tmp/foo
    Makefile:40: /tools/build/Makefile.feature: No such file or directory

Fix it by updating $(srctree) in the Makefile not only for out-of-tree
builds, but also if $(srctree) is empty.

Detected with test_bpftool_build.sh.

Fixes: 55d554f5d140 ("tools: bpf: Use !building_out_of_srctree to determine srctree")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Link: https://lore.kernel.org/bpf/20191119105626.21453-1-quentin.monnet@netronome.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index 5d1995fd369c6..5535650800ab2 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -16,7 +16,13 @@ CFLAGS += -D__EXPORTED_HEADERS__ -I$(srctree)/include/uapi -I$(srctree)/include
 # isn't set and when invoked from selftests build, where srctree
 # is set to ".". building_out_of_srctree is undefined for in srctree
 # builds
+ifeq ($(srctree),)
+update_srctree := 1
+endif
 ifndef building_out_of_srctree
+update_srctree := 1
+endif
+ifeq ($(update_srctree),1)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif
-- 
2.20.1

