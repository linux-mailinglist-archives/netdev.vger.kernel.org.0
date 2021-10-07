Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D4F425477
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241696AbhJGNnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:43:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241635AbhJGNnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:43:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633614079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpiTnn7Y1d+mwMkTdgXA5/J37cC45axULgFVdDICv7A=;
        b=WKCVbS68neUB1JLzRlN6zKyhXLcpeW1QZ4bp8jxKvbaWnLYcMg5SZ3W5R+5sBsiKJb4j89
        8bXXbHXZ7avu8Wn2PUUpQl6YGfl30Ht6NSU1Rrq5w3lTbLRBnhhCpP7O60M/1UNSTEZAIS
        Ivlm3XlEpfGHlgWv65khrNzSQ2b0ToY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-Zw01pNSNNf2saxmCrD4SIw-1; Thu, 07 Oct 2021 09:41:17 -0400
X-MC-Unique: Zw01pNSNNf2saxmCrD4SIw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 928281084683;
        Thu,  7 Oct 2021 13:41:16 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04F695D9C6;
        Thu,  7 Oct 2021 13:41:13 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v4 4/5] configure: add the --prefix option
Date:   Thu,  7 Oct 2021 15:40:04 +0200
Message-Id: <6bc05f1c06c4440aebbe433aa499d3158335af14.1633612111.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633612111.git.aclaudi@redhat.com>
References: <cover.1633612111.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit add the '--prefix' option to the iproute2 configure script.

This mimics the '--prefix' option that autotools configure provides, and
will be used later to allow users or packagers to set the lib directory.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/configure b/configure
index 08e7410b..2e5ed87e 100755
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
 	--libbpf_force <on|off>		Enable/disable libbpf by force.
 					  on: require link against libbpf, quit config if no libbpf support
 					  off: disable libbpf probing
+	--prefix <dir>			Path prefix of the lib files to install
 	-h | --help			Show this usage info
 EOF
 	exit $1
@@ -537,6 +547,14 @@ else
 				LIBBPF_FORCE="${1#*=}"
 				check_onoff "$LIBBPF_FORCE"
 				shift ;;
+			--prefix)
+				PREFIX="$2"
+				check_value "$PREFIX"
+				shift 2 ;;
+			--prefix=*)
+				PREFIX="${1#*=}"
+				check_value "$PREFIX"
+				shift ;;
 			-h | --help)
 				usage 0 ;;
 			"")
@@ -571,6 +589,7 @@ if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
 fi
 
 echo
+check_prefix
 if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
 	echo -n "iptables modules directory: "
 	check_ipt_lib_dir
-- 
2.31.1

