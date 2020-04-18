Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88631AEF4E
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 16:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgDROmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 10:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgDROmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 10:42:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA30A21974;
        Sat, 18 Apr 2020 14:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220929;
        bh=vfAHXFAy/Y/q0wkxF7wa7tNLX+mcFSUdnGqu55sY0aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vusfOXdmo9YnisglNF7OfSpv+Ug3A9R0ZOI8kq6n1UGRNf4U2oPj1YMRyvaUe9nld
         F+czt9aSwtYTl8Y7K24zJKkciNBZ13xwunljfXC4aBYZqSNWAGOvZa8bv50pwirg03
         TroWXH6A/UVTQ/OPEx/EfZ4VMTBZtIqtbKBKz+Vc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 66/78] libbpf: Fix readelf output parsing on powerpc with recent binutils
Date:   Sat, 18 Apr 2020 10:40:35 -0400
Message-Id: <20200418144047.9013-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit 3464afdf11f9a1e031e7858a05351ceca1792fea ]

On powerpc with recent versions of binutils, readelf outputs an extra
field when dumping the symbols of an object file. For example:

    35: 0000000000000838    96 FUNC    LOCAL  DEFAULT [<localentry>: 8]     1 btf_is_struct

The extra "[<localentry>: 8]" prevents the GLOBAL_SYM_COUNT variable to
be computed correctly and causes the check_abi target to fail.

Fix that by looking for the symbol name in the last field instead of the
8th one. This way it should also cope with future extra fields.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/bpf/20191201195728.4161537-1-aurelien@aurel32.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 33e2638ef7f0d..122321d549227 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -145,7 +145,7 @@ PC_FILE		:= $(addprefix $(OUTPUT),$(PC_FILE))
 
 GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
-			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
+			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
@@ -217,7 +217,7 @@ check_abi: $(OUTPUT)libbpf.so
 		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
 		readelf -s --wide $(BPF_IN_SHARED) |			 \
 		    cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' |	 \
-		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
+		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf -s --wide $(OUTPUT)libbpf.so |			 \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
-- 
2.20.1

