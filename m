Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFFC1F316F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 03:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbgFIBJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 21:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgFHXGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BE9F2088E;
        Mon,  8 Jun 2020 23:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657597;
        bh=KtAe3ObSg25LYSidXIG8L8qyak2OFEVpw47b12Sn1UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDob7BstU3Fw6JHjJo6+nEU5zMwXbEQYLBfhk45mmmfmECguNkv9sqOq9C1Hgmj7R
         3KzFFwyC6Inu8MDOSJDh3F9OScaIxc3aNamUo95UMDCK5Nm68Jb67hnH/YOQ4CLWQG
         u4gR4F8xrROFoJ7Fjkcb3iQPSc2C7QJqZKFD36Zw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 023/274] selftests/bpf: Copy runqslower to OUTPUT directory
Date:   Mon,  8 Jun 2020 19:01:56 -0400
Message-Id: <20200608230607.3361041-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Veronika Kabatova <vkabatov@redhat.com>

[ Upstream commit b26d1e2b60284dc9f66ffad9ccd5c5da1100bb4b ]

$(OUTPUT)/runqslower makefile target doesn't actually create runqslower
binary in the $(OUTPUT) directory. As lib.mk expects all
TEST_GEN_PROGS_EXTENDED (which runqslower is a part of) to be present in
the OUTPUT directory, this results in an error when running e.g. `make
install`:

rsync: link_stat "tools/testing/selftests/bpf/runqslower" failed: No
       such file or directory (2)

Copy the binary into the OUTPUT directory after building it to fix the
error.

Fixes: 3a0d3092a4ed ("selftests/bpf: Build runqslower from selftests")
Signed-off-by: Veronika Kabatova <vkabatov@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200428173742.2988395-1-vkabatov@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 7729892e0b04..4e654d41c7af 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -141,7 +141,8 @@ VMLINUX_BTF := $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
 $(OUTPUT)/runqslower: $(BPFOBJ)
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	\
 		    OUTPUT=$(SCRATCH_DIR)/ VMLINUX_BTF=$(VMLINUX_BTF)   \
-		    BPFOBJ=$(BPFOBJ) BPF_INCLUDE=$(INCLUDE_DIR)
+		    BPFOBJ=$(BPFOBJ) BPF_INCLUDE=$(INCLUDE_DIR) &&	\
+		    cp $(SCRATCH_DIR)/runqslower $@
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
 
-- 
2.25.1

