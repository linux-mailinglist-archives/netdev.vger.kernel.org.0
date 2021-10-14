Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F94B42D56E
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhJNIxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:53:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhJNIxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634201504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3Orayc/Iv7lzdsjDE4ghLwsLXr/CCGk7wf2HS16D2o=;
        b=BvJ7/hqs/Pb6x3TcBwpXilJDfW+UaPL9TjrYSz4kn5lAK1v/G4hkVG0PrhuoK/wyZ3GpE1
        ATMk2oCwId5j5DmfGTNZznzC6nguO+MCCfAIKbOLIo99ceSPvOe9c91QO/BVSexeR+puqK
        M2+5XQkvVQKDIRagVzIjMB20f168TtU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-lkf9urf0Ox285yF42XtQcA-1; Thu, 14 Oct 2021 04:51:40 -0400
X-MC-Unique: lkf9urf0Ox285yF42XtQcA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DE988042BD;
        Thu, 14 Oct 2021 08:51:39 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01E441B42C;
        Thu, 14 Oct 2021 08:51:36 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v5 7/7] configure: add the --libdir option
Date:   Thu, 14 Oct 2021 10:50:55 +0200
Message-Id: <62f6968cc2647685a0ef8074687ecf12c8c1f3c0.1634199240.git.aclaudi@redhat.com>
In-Reply-To: <cover.1634199240.git.aclaudi@redhat.com>
References: <cover.1634199240.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit allows users/packagers to choose a lib directory to store
iproute2 lib files.

At the moment iproute2 ship lib files in /usr/lib and offers no way to
modify this setting. However, according to the FHS, distros may choose
"one or more variants of the /lib directory on systems which support
more than one binary format" (e.g. /usr/lib64 on Fedora).

As Luca states in commit a3272b93725a ("configure: restore backward
compatibility"), packaging systems may assume that 'configure' is from
autotools, and try to pass it some parameters.

Allowing the '--libdir=/path/to/libdir' syntax, we can use this to our
advantage, and let the lib directory to be chosen by the distro
packaging system.

Note that LIBDIR uses "\${prefix}/lib" as default value because autoconf
allows this to be expanded to the --prefix value at configure runtime.
"\${prefix}" is replaced with the PREFIX value in check_lib_dir().

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 Makefile  |  7 ++++---
 configure | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 5eddd504..f6214534 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Top level Makefile for iproute2
 
+-include config.mk
+
 ifeq ("$(origin V)", "command line")
 VERBOSE = $(V)
 endif
@@ -13,7 +15,6 @@ MAKEFLAGS += --no-print-directory
 endif
 
 PREFIX?=/usr
-LIBDIR?=$(PREFIX)/lib
 SBINDIR?=/sbin
 CONFDIR?=/etc/iproute2
 NETNS_RUN_DIR?=/var/run/netns
@@ -69,7 +70,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
 LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
 LDLIBS += $(LIBNETLINK)
 
-all: config
+all: config.mk
 	@set -e; \
 	for i in $(SUBDIRS); \
 	do echo; echo $$i; $(MAKE) -C $$i; done
@@ -89,7 +90,7 @@ help:
 	@echo "Make Arguments:"
 	@echo " V=[0|1]             - set build verbosity level"
 
-config:
+config.mk:
 	@if [ ! -f config.mk -o configure -nt config.mk ]; then \
 		sh configure $(KERNEL_INCLUDE); \
 	fi
diff --git a/configure b/configure
index 05e23eff..8ddff43c 100755
--- a/configure
+++ b/configure
@@ -4,6 +4,7 @@
 
 INCLUDE="$PWD/include"
 PREFIX="/usr"
+LIBDIR="\${prefix}/lib"
 
 # Output file which is input to Makefile
 CONFIG=config.mk
@@ -149,6 +150,15 @@ EOF
 	rm -f $TMPDIR/ipttest.c $TMPDIR/ipttest
 }
 
+check_lib_dir()
+{
+	LIBDIR=$(echo $LIBDIR | sed "s|\${prefix}|$PREFIX|")
+
+	echo -n "lib directory: "
+	echo "$LIBDIR"
+	echo "LIBDIR:=$LIBDIR" >> $CONFIG
+}
+
 check_ipt()
 {
 	if ! grep TC_CONFIG_XT $CONFIG > /dev/null; then
@@ -487,6 +497,7 @@ usage()
 	cat <<EOF
 Usage: $0 [OPTIONS]
 	--include_dir <dir>		Path to iproute2 include dir
+	--libdir <dir>			Path to iproute2 lib dir
 	--libbpf_dir <dir>		Path to libbpf DESTDIR
 	--libbpf_force <on|off>		Enable/disable libbpf by force. Available options:
 					  on: require link against libbpf, quit config if no libbpf support
@@ -508,6 +519,11 @@ else
 				INCLUDE="$1" ;;
 			--include_dir=*)
 				INCLUDE="${1#*=}" ;;
+			--libdir)
+				shift
+				LIBDIR="$1" ;;
+			--libdir=*)
+				LIBDIR="${1#*=}" ;;
 			--libbpf_dir)
 				shift
 				LIBBPF_DIR="$1" ;;
@@ -544,6 +560,7 @@ if [ "${LIBBPF_FORCE-unused}" != "unused" ]; then
 	fi
 fi
 [ -z "$PREFIX" ] && usage 1
+[ -z "$LIBDIR" ] && usage 1
 
 echo "# Generated config based on" $INCLUDE >$CONFIG
 quiet_config >> $CONFIG
@@ -568,6 +585,7 @@ if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
 fi
 
 echo
+check_lib_dir
 if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
 	echo -n "iptables modules directory: "
 	check_ipt_lib_dir
-- 
2.31.1

