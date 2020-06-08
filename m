Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FF81F2D25
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgFHXPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbgFHXPe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E0B20801;
        Mon,  8 Jun 2020 23:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658133;
        bh=wG6r09WBZXBQHy367q4m6MyNiVwiapMtLH9N6qQ59aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emtDsbceKDXxlWniNLFFV1AzHJvI/S8gJhRkzM9ac8kiOkzW5Htug9VUSATjjUnWk
         JBM6/uG/2oeybszudsTxbD//LQtyYpiqqAjAJ9KOM4XXLqDR00btpHj4F+avme6Pvc
         f9jJakgt0PX9yel2kr3X9sFiXWJhWj96LLwO5KWA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 168/606] kbuild: Remove debug info from kallsyms linking
Date:   Mon,  8 Jun 2020 19:04:53 -0400
Message-Id: <20200608231211.3363633-168-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit af73d78bd384aa9b8789aa6e7ddbb165f971276f ]

When CONFIG_DEBUG_INFO is enabled, the two kallsyms linking steps spend
time collecting and writing the dwarf sections to the temporary output
files. kallsyms does not need this information, and leaving it off
halves their linking time. This is especially noticeable without
CONFIG_DEBUG_INFO_REDUCED. The BTF linking stage, however, does still
need those details.

Refactor the BTF and kallsyms generation stages slightly for more
regularized temporary names. Skip debug during kallsyms links.
Additionally move "info BTF" to the correct place since commit
8959e39272d6 ("kbuild: Parameterize kallsyms generation and correct
reporting"), which added "info LD ..." to vmlinux_link calls.

For a full debug info build with BTF, my link time goes from 1m06s to
0m54s, saving about 12 seconds, or 18%.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/202003031814.4AEA3351@keescook
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index dd484e92752e..ac569e197bfa 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -63,12 +63,18 @@ vmlinux_link()
 	local lds="${objtree}/${KBUILD_LDS}"
 	local output=${1}
 	local objects
+	local strip_debug
 
 	info LD ${output}
 
 	# skip output file argument
 	shift
 
+	# The kallsyms linking does not need debug symbols included.
+	if [ "$output" != "${output#.tmp_vmlinux.kallsyms}" ] ; then
+		strip_debug=-Wl,--strip-debug
+	fi
+
 	if [ "${SRCARCH}" != "um" ]; then
 		objects="--whole-archive			\
 			${KBUILD_VMLINUX_OBJS}			\
@@ -79,6 +85,7 @@ vmlinux_link()
 			${@}"
 
 		${LD} ${KBUILD_LDFLAGS} ${LDFLAGS_vmlinux}	\
+			${strip_debug#-Wl,}			\
 			-o ${output}				\
 			-T ${lds} ${objects}
 	else
@@ -91,6 +98,7 @@ vmlinux_link()
 			${@}"
 
 		${CC} ${CFLAGS_vmlinux}				\
+			${strip_debug}				\
 			-o ${output}				\
 			-Wl,-T,${lds}				\
 			${objects}				\
@@ -106,6 +114,8 @@ gen_btf()
 {
 	local pahole_ver
 	local bin_arch
+	local bin_format
+	local bin_file
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
@@ -118,8 +128,9 @@ gen_btf()
 		return 1
 	fi
 
-	info "BTF" ${2}
 	vmlinux_link ${1}
+
+	info "BTF" ${2}
 	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
 
 	# dump .BTF section into raw binary file to link with final vmlinux
@@ -127,11 +138,12 @@ gen_btf()
 		cut -d, -f1 | cut -d' ' -f2)
 	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
 		awk '{print $4}')
+	bin_file=.btf.vmlinux.bin
 	${OBJCOPY} --change-section-address .BTF=0 \
 		--set-section-flags .BTF=alloc -O binary \
-		--only-section=.BTF ${1} .btf.vmlinux.bin
+		--only-section=.BTF ${1} $bin_file
 	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
-		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
+		--rename-section .data=.BTF $bin_file ${2}
 }
 
 # Create ${2} .o file with all symbols from the ${1} object file
@@ -166,8 +178,8 @@ kallsyms()
 kallsyms_step()
 {
 	kallsymso_prev=${kallsymso}
-	kallsymso=.tmp_kallsyms${1}.o
-	kallsyms_vmlinux=.tmp_vmlinux${1}
+	kallsyms_vmlinux=.tmp_vmlinux.kallsyms${1}
+	kallsymso=${kallsyms_vmlinux}.o
 
 	vmlinux_link ${kallsyms_vmlinux} "${kallsymso_prev}" ${btf_vmlinux_bin_o}
 	kallsyms ${kallsyms_vmlinux} ${kallsymso}
@@ -190,7 +202,6 @@ cleanup()
 {
 	rm -f .btf.*
 	rm -f .tmp_System.map
-	rm -f .tmp_kallsyms*
 	rm -f .tmp_vmlinux*
 	rm -f System.map
 	rm -f vmlinux
@@ -257,9 +268,8 @@ tr '\0' '\n' < modules.builtin.modinfo | sed -n 's/^[[:alnum:]:_]*\.file=//p' |
 
 btf_vmlinux_bin_o=""
 if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
-	if gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
-		btf_vmlinux_bin_o=.btf.vmlinux.bin.o
-	else
+	btf_vmlinux_bin_o=.btf.vmlinux.bin.o
+	if ! gen_btf .tmp_vmlinux.btf $btf_vmlinux_bin_o ; then
 		echo >&2 "Failed to generate BTF for vmlinux"
 		echo >&2 "Try to disable CONFIG_DEBUG_INFO_BTF"
 		exit 1
-- 
2.25.1

