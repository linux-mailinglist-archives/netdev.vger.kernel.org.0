Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0044D42D568
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhJNIxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:53:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhJNIxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634201487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NLzB9se0APyAwBwQOCVmwwlYxv7R5/0WKt09vjyarSI=;
        b=PNbwIma1M78KT7D4uZv7/a/SOWyg3RsoASSAaum9ej8ZePOVJ51PxYsPLt8n7GovT9A5Ss
        9/lRNToHgGme0TdXt4XQPmKyFjvRzJQmOlfApQpQ74gkZetzW73cKpdPPVzULR1r50nkpc
        GkeWS1Bp08GwyVhZxJ+jkrg5Cvwzc0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-ReCkr1MWPKejCSSt2s7oMw-1; Thu, 14 Oct 2021 04:51:24 -0400
X-MC-Unique: ReCkr1MWPKejCSSt2s7oMw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47E158042F4;
        Thu, 14 Oct 2021 08:51:23 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 094712B0B2;
        Thu, 14 Oct 2021 08:51:20 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v5 1/7] configure: fix parsing issue on include_dir option
Date:   Thu, 14 Oct 2021 10:50:49 +0200
Message-Id: <92f2f5590ada5fb1b73004516f8a2b3a1d19ebf2.1634199240.git.aclaudi@redhat.com>
In-Reply-To: <cover.1634199240.git.aclaudi@redhat.com>
References: <cover.1634199240.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

configure is stuck in an endless loop if '--include_dir' option is used
without a value:

$ ./configure --include_dir
./configure: line 506: shift: 2: shift count out of range
./configure: line 506: shift: 2: shift count out of range
[...]

Fix it splitting 'shift 2' into two consecutive shifts, and making the
second one conditional to the number of remaining arguments.

A check is also provided after the while loop to verify the include dir
exists; this avoid to produce an erroneous configuration.

Fixes: a9c3d70d902a ("configure: add options ability")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 7f4f3bd9..ea9051ab 100755
--- a/configure
+++ b/configure
@@ -485,7 +485,7 @@ usage()
 {
 	cat <<EOF
 Usage: $0 [OPTIONS]
-	--include_dir		Path to iproute2 include dir
+	--include_dir <dir>	Path to iproute2 include dir
 	--libbpf_dir		Path to libbpf DESTDIR
 	--libbpf_force		Enable/disable libbpf by force. Available options:
 				  on: require link against libbpf, quit config if no libbpf support
@@ -502,8 +502,9 @@ else
 	while true; do
 		case "$1" in
 			--include_dir)
-				INCLUDE=$2
-				shift 2 ;;
+				shift
+				INCLUDE="$1"
+				[ "$#" -gt 0 ] && shift ;;
 			--libbpf_dir)
 				LIBBPF_DIR="$2"
 				shift 2 ;;
@@ -523,6 +524,8 @@ else
 	done
 fi
 
+[ -d "$INCLUDE" ] || usage 1
+
 echo "# Generated config based on" $INCLUDE >$CONFIG
 quiet_config >> $CONFIG
 
-- 
2.31.1

