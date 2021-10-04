Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA44217F1
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhJDTxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:53:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232319AbhJDTxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 15:53:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633377072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11osw1sJrLJ5+LcZ7sYXCHrKu+b1sDCRg6TWbiyOyyc=;
        b=eS/Rt2/cbL+QGozwnMCSfQEg7Dx4jcms1sAfnk98KX+ITJz3hlBu/ar8NZqFqophdvquZK
        Cc9/4GmSvM2EeN9c0NlTUEmWgm/gAzxYZf07GU+Ugkt7Um/Q3DzG7jV2fX0ASUP3dBtyuH
        ZQ17arfSHc1h7wu4kLRV0/yW0CKTHWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-TL9v7Lz8N_66Hwi3_0g66A-1; Mon, 04 Oct 2021 15:51:11 -0400
X-MC-Unique: TL9v7Lz8N_66Hwi3_0g66A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 294DB100C661;
        Mon,  4 Oct 2021 19:51:10 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36AAE17CF0;
        Mon,  4 Oct 2021 19:51:07 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH iproute2 v2 2/3] configure: add the --prefix option
Date:   Mon,  4 Oct 2021 21:50:31 +0200
Message-Id: <23b07323c5dab89c789c6ef7f94ddee3b65e51e4.1633369677.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633369677.git.aclaudi@redhat.com>
References: <cover.1633369677.git.aclaudi@redhat.com>
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
 configure | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/configure b/configure
index cebfda6e..f51247a8 100755
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
+			--prefix*)
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

