Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C53736F3E2
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 03:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhD3B7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 21:59:38 -0400
Received: from conuserg-08.nifty.com ([210.131.2.75]:49892 "EHLO
        conuserg-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhD3B7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 21:59:37 -0400
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 13U1uZEI031248;
        Fri, 30 Apr 2021 10:56:35 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 13U1uZEI031248
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1619747796;
        bh=P0Z5VUyWOF3igqssAsRaklfkEBW2Xkwtbsajr6qbxy0=;
        h=From:To:Cc:Subject:Date:From;
        b=EDpIzwKkXzPEnRrgl4oxBIpLNMjfaE59msiuW3lZTq3RKFJOBQqEBE9PqxbcZxklA
         z2JBcok6B3fwUG2NU8h2CAq3sPd/M2K4sULkz7QKBNkGkIPYNhGd0oqpMTk3eArD2J
         e++YkykMss7ySCxhUCik6/lDYVWzGBc0nJsL5fudZ+07PYVNWFmlebCYU8sfrb3cfQ
         BoGLsf4uFOvA5hfjz4V2epJWyY5rwsy9LSsZnh/OGIy1tA3uoqOq4BeD6xfBa2wA0q
         Q/eDcYs/QH+P9paWoc6xcyaUOjvgkYtauJK70G4bsVe4D/2xOInh9mfnfTxxxsjmP6
         Vo6NOuCAGy04Q==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Matthias Maennich <maennich@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH v2] kbuild: replace LANG=C with LC_ALL=C
Date:   Fri, 30 Apr 2021 10:56:27 +0900
Message-Id: <20210430015627.65738-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LANG gives a weak default to each LC_* in case it is not explicitly
defined. LC_ALL, if set, overrides all other LC_* variables.

  LANG  <  LC_CTYPE, LC_COLLATE, LC_MONETARY, LC_NUMERIC, ...  <  LC_ALL

This is why documentation such as [1] suggests to set LC_ALL in build
scripts to get the deterministic result.

LANG=C is not strong enough to override LC_* that may be set by end
users.

[1]: https://reproducible-builds.org/docs/locales/

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Reviewed-by: Matthias Maennich <maennich@google.com>
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net> (mptcp)
---

Changes in v2:
 - rebase

 arch/powerpc/boot/wrapper                          | 2 +-
 scripts/nsdeps                                     | 2 +-
 scripts/recordmcount.pl                            | 2 +-
 scripts/setlocalversion                            | 2 +-
 scripts/tags.sh                                    | 2 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 2 +-
 usr/gen_initramfs.sh                               | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index 41fa0a8715e3..cdb796b76e2e 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -191,7 +191,7 @@ if [ -z "$kernel" ]; then
     kernel=vmlinux
 fi
 
-LANG=C elfformat="`${CROSS}objdump -p "$kernel" | grep 'file format' | awk '{print $4}'`"
+LC_ALL=C elfformat="`${CROSS}objdump -p "$kernel" | grep 'file format' | awk '{print $4}'`"
 case "$elfformat" in
     elf64-powerpcle)	format=elf64lppc	;;
     elf64-powerpc)	format=elf32ppc	;;
diff --git a/scripts/nsdeps b/scripts/nsdeps
index e8ce2a4d704a..04c4b96e95ec 100644
--- a/scripts/nsdeps
+++ b/scripts/nsdeps
@@ -44,7 +44,7 @@ generate_deps() {
 		for source_file in $mod_source_files; do
 			sed '/MODULE_IMPORT_NS/Q' $source_file > ${source_file}.tmp
 			offset=$(wc -l ${source_file}.tmp | awk '{print $1;}')
-			cat $source_file | grep MODULE_IMPORT_NS | LANG=C sort -u >> ${source_file}.tmp
+			cat $source_file | grep MODULE_IMPORT_NS | LC_ALL=C sort -u >> ${source_file}.tmp
 			tail -n +$((offset +1)) ${source_file} | grep -v MODULE_IMPORT_NS >> ${source_file}.tmp
 			if ! diff -q ${source_file} ${source_file}.tmp; then
 				mv ${source_file}.tmp ${source_file}
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 867860ea57da..0a7fc9507d6f 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -497,7 +497,7 @@ sub update_funcs
 #
 # Step 2: find the sections and mcount call sites
 #
-open(IN, "LANG=C $objdump -hdr $inputfile|") || die "error running $objdump";
+open(IN, "LC_ALL=C $objdump -hdr $inputfile|") || die "error running $objdump";
 
 my $text;
 
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index bb709eda96cd..db941f6d9591 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -126,7 +126,7 @@ scm_version()
 	fi
 
 	# Check for svn and a svn repo.
-	if rev=$(LANG= LC_ALL= LC_MESSAGES=C svn info 2>/dev/null | grep '^Last Changed Rev'); then
+	if rev=$(LC_ALL=C svn info 2>/dev/null | grep '^Last Changed Rev'); then
 		rev=$(echo $rev | awk '{print $NF}')
 		printf -- '-svn%s' "$rev"
 
diff --git a/scripts/tags.sh b/scripts/tags.sh
index fd96734deff1..db8ba411860a 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -326,5 +326,5 @@ esac
 
 # Remove structure forward declarations.
 if [ -n "$remove_structs" ]; then
-    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
+    LC_ALL=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
 fi
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 9236609731b1..3c4cb72ed8a4 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -274,7 +274,7 @@ check_mptcp_disabled()
 	ip netns exec ${disabled_ns} sysctl -q net.mptcp.enabled=0
 
 	local err=0
-	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
+	LC_ALL=C ip netns exec ${disabled_ns} ./mptcp_connect -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
 		grep -q "^socket: Protocol not available$" && err=1
 	ip netns delete ${disabled_ns}
 
diff --git a/usr/gen_initramfs.sh b/usr/gen_initramfs.sh
index 8ae831657e5d..63476bb70b41 100755
--- a/usr/gen_initramfs.sh
+++ b/usr/gen_initramfs.sh
@@ -147,7 +147,7 @@ dir_filelist() {
 	header "$1"
 
 	srcdir=$(echo "$1" | sed -e 's://*:/:g')
-	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n" | LANG=C sort)
+	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n" | LC_ALL=C sort)
 
 	# If $dirlist is only one line, then the directory is empty
 	if [  "$(echo "${dirlist}" | wc -l)" -gt 1 ]; then
-- 
2.27.0

