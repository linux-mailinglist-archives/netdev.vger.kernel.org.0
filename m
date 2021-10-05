Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFBF423343
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhJEWLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:11:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236844AbhJEWLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 18:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633471798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=se6Vzn8R2jh8d5TGQ4NFPjldNf0Gh0tNsZUON1pB9tM=;
        b=GNWPmRBLnHq6c/K3eGcukgl77cWQ6BVzlbHVOZeUoFGiTlsmPFzW8qxnIJ4xQyO3XOnwPi
        Ks8waBmrz60Uz57rsGfMcocjCQAcmYWz42sRtGS0Ep9k7YcGP7Aig245Qikhcyv21vV4dp
        R9cR5AvFlRrqtrN/Z94C5LAapmXQoaI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-Kklw3IAJMTefEoFyfoBfSw-1; Tue, 05 Oct 2021 18:09:57 -0400
X-MC-Unique: Kklw3IAJMTefEoFyfoBfSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 504AD100793C;
        Tue,  5 Oct 2021 22:09:45 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A882652BA;
        Tue,  5 Oct 2021 22:09:43 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH iproute2 v3 2/3] configure: add the --prefix option
Date:   Wed,  6 Oct 2021 00:08:05 +0200
Message-Id: <712dcd1a0541ab82602e775db57b178dfc78c031.1633455436.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633455436.git.aclaudi@redhat.com>
References: <cover.1633455436.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit add the '--prefix' option to the iproute2 configure script.

This mimics the '--prefix' option that autotools configure provides, and
will be used later to allow users or packagers to set the lib directory.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/configure b/configure
index d57ce0f8..8be7e40b 100755
--- a/configure
+++ b/configure
@@ -148,6 +148,15 @@ EOF
 	rm -f $TMPDIR/ipttest.c $TMPDIR/ipttest
 }
 
+check_prefix()
+{
+	if [ -n "$PREFIX" ]; then
+		prefix="$PREFIX"
+	else
+		prefix="/usr"
+	fi
+}
+
 check_ipt()
 {
 	if ! grep TC_CONFIG_XT $CONFIG > /dev/null; then
@@ -490,6 +499,7 @@ Usage: $0 [OPTIONS]
 	--libbpf_force		Enable/disable libbpf by force. Available options:
 				  on: require link against libbpf, quit config if no libbpf support
 				  off: disable libbpf probing
+	--prefix		Path prefix of the lib files to install
 	-h | --help		Show this usage info
 EOF
 	exit $1
@@ -525,6 +535,13 @@ else
 					usage 1
 				fi
 				shift ;;
+			--prefix | --prefix=*)
+				PREFIX="${1#*=}"
+				if [ "$PREFIX" == "--prefix" ]; then
+					PREFIX="$2"
+					shift
+				fi
+				shift ;;
 			-h | --help)
 				usage 0 ;;
 			"")
@@ -558,6 +575,7 @@ if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
 fi
 
 echo
+check_prefix
 if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
 	echo -n "iptables modules directory: "
 	check_ipt_lib_dir
-- 
2.31.1

