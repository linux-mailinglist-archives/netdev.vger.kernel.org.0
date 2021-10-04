Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103154217F2
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhJDTxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:53:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232319AbhJDTxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 15:53:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633377074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6tVdezFE8dC0nL7OmD05dX5kB5cHUxoCDeGNtIW5VbU=;
        b=iH211lPh/A9DEtdxGyxBLRHM7J89lsGPeRkivkEdKyEfjmXXGo3mBcRTW6g7Gm9iUedNJz
        5DBiZyluF2wX9ESbLnPuFys+jItkrEQE5Py84ALsjWpliOdTN73yLHG4gzcrUQLDTtpHl4
        D+MVTsMFY8srZty/+oaV7teddmNaeyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-IJCmVoTKOG66xyLETZRmTg-1; Mon, 04 Oct 2021 15:51:13 -0400
X-MC-Unique: IJCmVoTKOG66xyLETZRmTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AB11814313;
        Mon,  4 Oct 2021 19:51:12 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B71D25D9DE;
        Mon,  4 Oct 2021 19:51:10 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH iproute2 v2 3/3] configure: add the --libdir option
Date:   Mon,  4 Oct 2021 21:50:32 +0200
Message-Id: <c1d306f4c0f8326b7d3425a59b4b8e8c0e6878d0.1633369677.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633369677.git.aclaudi@redhat.com>
References: <cover.1633369677.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 Makefile  |  7 ++++---
 configure | 22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 5bc11477..45655ca4 100644
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
@@ -60,7 +61,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
 LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
 LDLIBS += $(LIBNETLINK)
 
-all: config
+all: config.mk
 	@set -e; \
 	for i in $(SUBDIRS); \
 	do echo; echo $$i; $(MAKE) -C $$i; done
@@ -80,7 +81,7 @@ help:
 	@echo "Make Arguments:"
 	@echo " V=[0|1]             - set build verbosity level"
 
-config:
+config.mk:
 	@if [ ! -f config.mk -o configure -nt config.mk ]; then \
 		sh configure $(KERNEL_INCLUDE); \
 	fi
diff --git a/configure b/configure
index f51247a8..38a81405 100755
--- a/configure
+++ b/configure
@@ -157,6 +157,19 @@ check_prefix()
 	fi
 }
 
+check_lib_dir()
+{
+	echo -n "lib directory: "
+	if [ -n "$LIBDIR" ]; then
+		eval echo "$LIBDIR"
+		eval echo "LIBDIR:=$LIBDIR" >> $CONFIG
+		return
+	fi
+
+	eval echo "${prefix}/lib"
+	eval echo "LIBDIR:=${prefix}/lib" >> $CONFIG
+}
+
 check_ipt()
 {
 	if ! grep TC_CONFIG_XT $CONFIG > /dev/null; then
@@ -495,6 +508,7 @@ usage()
 	cat <<EOF
 Usage: $0 [OPTIONS]
 	--include_dir		Path to iproute2 include dir
+	--libdir		Path to iproute2 lib dir
 	--libbpf_dir		Path to libbpf DESTDIR
 	--libbpf_force		Enable/disable libbpf by force. Available options:
 				  on: require link against libbpf, quit config if no libbpf support
@@ -518,6 +532,13 @@ else
 					shift
 				fi
 				shift ;;
+			--libdir*)
+				LIBDIR="${1#*=}"
+				if [ "$LIBDIR" == "--libdir" ]; then
+					LIBDIR="$2"
+					shift
+				fi
+				shift ;;
 			--libbpf_dir*)
 				LIBBPF_DIR="${1#*=}"
 				if [ "$LIBBPF_DIR" == "--libbpf_dir" ]; then
@@ -576,6 +597,7 @@ fi
 
 echo
 check_prefix
+check_lib_dir
 if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
 	echo -n "iptables modules directory: "
 	check_ipt_lib_dir
-- 
2.31.1

