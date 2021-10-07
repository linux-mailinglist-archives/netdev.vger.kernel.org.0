Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCC5425476
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbhJGNnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:43:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241659AbhJGNnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633614075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vN1uHcF1oVjLVWuIs+t6ltA9/hK+/MVYK89c14WatLE=;
        b=dx0Rdjct4jGWGsCyPbJTSRAo1dxxJwTB/AfdhfSojYViq+Uzy1PnMJrEz58QC4Ry95josl
        cOeuHoLqLF/8hndj8Lyi6JZrcxekpSQLNKXZw2+tb+rsuwZ47y3oQ44iC8aBgf77umJabC
        PhfeYHxFB/DcpU85ocUZ48837I+aHkA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-himycNtRNKyBdfkjvYOdQQ-1; Thu, 07 Oct 2021 09:41:14 -0400
X-MC-Unique: himycNtRNKyBdfkjvYOdQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6789284A5E0;
        Thu,  7 Oct 2021 13:41:13 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C871C5D9C6;
        Thu,  7 Oct 2021 13:41:10 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v4 3/5] configure: support --param=value style
Date:   Thu,  7 Oct 2021 15:40:03 +0200
Message-Id: <fef1422ef90f7e868a86c15d2bfb1fd35dbdd545.1633612111.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633612111.git.aclaudi@redhat.com>
References: <cover.1633612111.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit makes it possible to specify values for configure params
using the common autotools configure syntax '--param=value'.

To avoid code duplication, semantic check on libbpf_force is moved to a
dedicated function.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/configure b/configure
index 27db3ecb..08e7410b 100755
--- a/configure
+++ b/configure
@@ -485,12 +485,12 @@ usage()
 {
 	cat <<EOF
 Usage: $0 [OPTIONS]
-	--include_dir <dir>	Path to iproute2 include dir
-	--libbpf_dir <dir>	Path to libbpf DESTDIR
-	--libbpf_force		Enable/disable libbpf by force. Available options:
-				  on: require link against libbpf, quit config if no libbpf support
-				  off: disable libbpf probing
-	-h | --help		Show this usage info
+	--include_dir <dir>		Path to iproute2 include dir
+	--libbpf_dir <dir>		Path to libbpf DESTDIR
+	--libbpf_force <on|off>		Enable/disable libbpf by force.
+					  on: require link against libbpf, quit config if no libbpf support
+					  off: disable libbpf probing
+	-h | --help			Show this usage info
 EOF
 	exit $1
 }
@@ -500,6 +500,13 @@ check_value()
 	[ -z "$1" ] && usage 1
 }
 
+check_onoff()
+{
+	if [ "$1" != 'on' ] && [ "$1" != 'off' ]; then
+		usage 1
+	fi
+}
+
 # Compat with the old INCLUDE path setting method.
 if [ $# -eq 1 ] && [ "$(echo $1 | cut -c 1)" != '-' ]; then
 	INCLUDE="$1"
@@ -510,16 +517,26 @@ else
 				INCLUDE=$2
 				check_value "$INCLUDE"
 				shift 2 ;;
+			--include_dir=*)
+				INCLUDE="${1#*=}"
+				check_value "$INCLUDE"
+				shift ;;
 			--libbpf_dir)
 				LIBBPF_DIR="$2"
 				check_value "$LIBBPF_DIR"
 				shift 2 ;;
+			--libbpf_dir=*)
+				LIBBPF_DIR="${1#*=}"
+				check_value "$LIBBPF_DIR"
+				shift ;;
 			--libbpf_force)
-				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
-					usage 1
-				fi
 				LIBBPF_FORCE=$2
+				check_onoff "$LIBBPF_FORCE"
 				shift 2 ;;
+			--libbpf_force=*)
+				LIBBPF_FORCE="${1#*=}"
+				check_onoff "$LIBBPF_FORCE"
+				shift ;;
 			-h | --help)
 				usage 0 ;;
 			"")
@@ -528,6 +545,7 @@ else
 				shift 1 ;;
 		esac
 	done
+
 fi
 
 echo "# Generated config based on" $INCLUDE >$CONFIG
-- 
2.31.1

