Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358F215DD71
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388546AbgBNP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387905AbgBNP6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5697922314;
        Fri, 14 Feb 2020 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695896;
        bh=1xCCUDJRyOV29jDvyw2qulGXTvVC0OZvGv+a2Mz9d4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7QUz6EuMsCluA+o5M+c8CohyhWMERLUuBUHSK+R6s9xLPMdo0lBG3aHUfCr9XoPk
         tvfqFODvAbO3TRqQebyJsSpDIi446u71VTaPLK9fcMo7r5pgSl/kbcCrdIOcMM9ix7
         kcfqEqEG4F358uF1eRMNnpe1V+brQiaqLUvyBzr4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Down <chris@chrisdown.name>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 438/542] bpf, btf: Always output invariant hit in pahole DWARF to BTF transform
Date:   Fri, 14 Feb 2020 10:47:10 -0500
Message-Id: <20200214154854.6746-438-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Down <chris@chrisdown.name>

[ Upstream commit 2a67a6ccb01f21b854715d86ff6432a18b97adb3 ]

When trying to compile with CONFIG_DEBUG_INFO_BTF enabled, I got this
error:

    % make -s
    Failed to generate BTF for vmlinux
    Try to disable CONFIG_DEBUG_INFO_BTF
    make[3]: *** [vmlinux] Error 1

Compiling again without -s shows the true error (that pahole is
missing), but since this is fatal, we should show the error
unconditionally on stderr as well, not silence it using the `info`
function. With this patch:

    % make -s
    BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
    Failed to generate BTF for vmlinux
    Try to disable CONFIG_DEBUG_INFO_BTF
    make[3]: *** [vmlinux] Error 1

Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200122000110.GA310073@chrisdown.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 4363799403561..408b5c0b99b1b 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -108,13 +108,13 @@ gen_btf()
 	local bin_arch
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
-		info "BTF" "${1}: pahole (${PAHOLE}) is not available"
+		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
 		return 1
 	fi
 
 	pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
 	if [ "${pahole_ver}" -lt "113" ]; then
-		info "BTF" "${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
+		echo >&2 "BTF: ${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
 		return 1
 	fi
 
-- 
2.20.1

