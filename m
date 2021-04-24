Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC38836A0F8
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 13:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhDXLwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 07:52:38 -0400
Received: from conuserg-12.nifty.com ([210.131.2.79]:22439 "EHLO
        conuserg-12.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhDXLwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 07:52:36 -0400
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id 13OBmmYp018893;
        Sat, 24 Apr 2021 20:48:48 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com 13OBmmYp018893
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1619264929;
        bh=QZtRNPI9tcJewNEkn9qFVV65UXR5+ejTwS0WZTz9ytE=;
        h=From:To:Cc:Subject:Date:From;
        b=OgS1xS1pH9Ae7mvvS/tN0XQ1KlXN6XJGvC6a13xxxGpBWrmoZDHvSad9U/i4OE8GB
         SCxToXKcTar8y85/ZgdttfyNTyNT4QrOt9teXbme+DbWLOvA6ZrXrCO9RRSno8lrbq
         LjUaRUllsq7tNZxY6TW1P2027e2ET3kGuIHAKskUXsNQpb0WM+C5rMbvyGoCM6Ek/7
         Q/SeGxa5kazVx8r7jeV7piS2uH99EolfxgJA1jfMxcGW50i+Le9Z1lHf7UOa7+H1Z8
         9PSecdZ0jU7Sa07LWptBy+FREZsqXgLxyhpbsEsyDWHdwWRB00Ubg9Phg50IHfqaLC
         nNznHrSvYzgDQ==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthias Maennich <maennich@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mptcp@lists.01.org, netdev@vger.kernel.org
Subject: [PATCH] kbuild: replace LANG=C with LC_ALL=C
Date:   Sat, 24 Apr 2021 20:48:41 +0900
Message-Id: <20210424114841.394239-1-masahiroy@kernel.org>
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
---

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
index 10a030b53b23..1d2a6e7b877c 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -273,7 +273,7 @@ check_mptcp_disabled()
 	ip netns exec ${disabled_ns} sysctl -q net.mptcp.enabled=0
 
 	local err=0
-	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -t $timeout -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
+	LC_ALL=C ip netns exec ${disabled_ns} ./mptcp_connect -t $timeout -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
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

