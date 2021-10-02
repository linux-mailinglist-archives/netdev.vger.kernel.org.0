Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABB841FD41
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 18:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhJBQp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 12:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233659AbhJBQp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 12:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633193020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mPVKKmzJ904TlkYHJ+uR1Am9wdvn/NnuT6zIrlFo9Rk=;
        b=CXtYYNSaF3m9C1dULAJk771BeDkXqSZWVhE6HQzI8YDh6i/6UMjC80IJB4PcBVo3YOZKYK
        lnj8ceT8LdEe0XZq1yTlAQaVOWkUE0gqXXMbVMkYVa+M5egdvrWclLiLsAeUQFrUKpVDvM
        Z6696Ywa3HxkzwuiB6+bSkVGCT+0GQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-KBwS3PngOMiW53nqPj6udA-1; Sat, 02 Oct 2021 12:43:39 -0400
X-MC-Unique: KBwS3PngOMiW53nqPj6udA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11D2C1808308;
        Sat,  2 Oct 2021 16:43:38 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C04A35D740;
        Sat,  2 Oct 2021 16:43:36 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH 2/2 iproute2] configure: add the --libdir param
Date:   Sat,  2 Oct 2021 18:41:21 +0200
Message-Id: <1047327c1350db0fe3df84d7eb96bf45955fa795.1633191885.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633191885.git.aclaudi@redhat.com>
References: <cover.1633191885.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 configure | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

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
index f0c81ee1..a1b0261a 100755
--- a/configure
+++ b/configure
@@ -148,6 +148,19 @@ EOF
 	rm -f $TMPDIR/ipttest.c $TMPDIR/ipttest
 }
 
+check_lib_dir()
+{
+	echo -n "lib directory: "
+	if [ -n "$LIB_DIR" ]; then
+		echo "$LIB_DIR"
+		echo "LIBDIR:=$LIB_DIR" >> $CONFIG
+		return
+	fi
+
+	echo "/usr/lib"
+	echo "LIBDIR:=/usr/lib" >> $CONFIG
+}
+
 check_ipt()
 {
 	if ! grep TC_CONFIG_XT $CONFIG > /dev/null; then
@@ -486,6 +499,7 @@ usage()
 	cat <<EOF
 Usage: $0 [OPTIONS]
 	--include_dir		Path to iproute2 include dir
+	--libdir		Path to iproute2 lib dir
 	--libbpf_dir		Path to libbpf DESTDIR
 	--libbpf_force		Enable/disable libbpf by force. Available options:
 				  on: require link against libbpf, quit config if no libbpf support
@@ -507,6 +521,12 @@ else
 			--include_dir=*)
 				INCLUDE="${1#*=}"
 				shift ;;
+			--libdir)
+				LIB_DIR="$2"
+				shift 2 ;;
+			--libdir=*)
+				LIB_DIR="${1#*=}"
+				shift ;;
 			--libbpf_dir)
 				LIBBPF_DIR="$2"
 				shift 2 ;;
@@ -559,6 +579,7 @@ if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
 fi
 
 echo
+check_lib_dir
 if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
 	echo -n "iptables modules directory: "
 	check_ipt_lib_dir
-- 
2.31.1

