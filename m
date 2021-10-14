Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DDB42D56B
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhJNIxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:53:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhJNIxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:53:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634201494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FLZ7Ij3NqbATBxy/KiQWc7hvqxuolcXOo/ULfFaaS6s=;
        b=CHQvWT1a/BSGbIkHa8m+qgvXAfgiuMw3gp+IFdaFtyvNfmkMGkN9MHWNzl8Sc8D1CBBNL1
        N+GP70ZEvjzcbdpupS4akwqESALphHhSVgaAYTsGrjiezLRil2xBPRVDimM3yXv/MDfs/k
        GhDCfDmMEMvfKlMQnqz2AH3Kh9zf78s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-pIcxSXs5PLSki4Wd_C0a7w-1; Thu, 14 Oct 2021 04:51:31 -0400
X-MC-Unique: pIcxSXs5PLSki4Wd_C0a7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BD3119200C0;
        Thu, 14 Oct 2021 08:51:30 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DEF45BAF8;
        Thu, 14 Oct 2021 08:51:28 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v5 4/7] configure: simplify options parsing
Date:   Thu, 14 Oct 2021 10:50:52 +0200
Message-Id: <3be488a28f2df84264890b030052c6cafc8700ec.1634199240.git.aclaudi@redhat.com>
In-Reply-To: <cover.1634199240.git.aclaudi@redhat.com>
References: <cover.1634199240.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit simplifies options parsing moving all the code not related to
parsing out of the case statement.

- The conditional shift after the assignments is moved right after the
  case, reducing code duplication.
- The semantic checks on the LIBBPF_FORCE value is moved after the loop
  like we already did for INCLUDE and LIBBPF_DIR.
- Finally, the loop condition is changed to check remaining arguments, thus
  making it possible to get rid of the null string case break.

As a bonus, now the help message states that on or off should follow
--libbpf_force

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/configure b/configure
index 9ec19a5b..26e06eb8 100755
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
+	--libbpf_force <on|off>		Enable/disable libbpf by force. Available options:
+					  on: require link against libbpf, quit config if no libbpf support
+					  off: disable libbpf probing
+	-h | --help			Show this usage info
 EOF
 	exit $1
 }
@@ -499,31 +499,25 @@ EOF
 if [ $# -eq 1 ] && [ "$(echo $1 | cut -c 1)" != '-' ]; then
 	INCLUDE="$1"
 else
-	while true; do
+	while [ "$#" -gt 0 ]; do
 		case "$1" in
 			--include_dir)
 				shift
-				INCLUDE="$1"
-				[ "$#" -gt 0 ] && shift ;;
+				INCLUDE="$1" ;;
 			--libbpf_dir)
 				shift
-				LIBBPF_DIR="$1"
-				[ "$#" -gt 0 ] && shift ;;
+				LIBBPF_DIR="$1" ;;
 			--libbpf_force)
-				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
-					usage 1
-				fi
-				LIBBPF_FORCE=$2
-				shift 2 ;;
+				shift
+				LIBBPF_FORCE="$1" ;;
 			-h | --help)
 				usage 0 ;;
 			--*)
-				shift ;;
-			"")
-				break ;;
+				;;
 			*)
 				usage 1 ;;
 		esac
+		[ "$#" -gt 0 ] && shift
 	done
 fi
 
@@ -531,6 +525,11 @@ fi
 if [ "${LIBBPF_DIR-unused}" != "unused" ]; then
 	[ -d "$LIBBPF_DIR" ] || usage 1
 fi
+if [ "${LIBBPF_FORCE-unused}" != "unused" ]; then
+	if [ "$LIBBPF_FORCE" != 'on' ] && [ "$LIBBPF_FORCE" != 'off' ]; then
+		usage 1
+	fi
+fi
 
 echo "# Generated config based on" $INCLUDE >$CONFIG
 quiet_config >> $CONFIG
-- 
2.31.1

