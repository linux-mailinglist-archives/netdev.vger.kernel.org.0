Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A16F4217F0
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbhJDTxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:53:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232319AbhJDTw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 15:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633377069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yIWffICX3mHAU5/5D00jA0Ixn3NQl7mBNsTu+BjI09M=;
        b=JWmvhMI6Q8auJ62yhPyp9a58JFdj0VeK8KRjQAfnucpUDJH6hLG+xtC1OShXa8o4g5j3LT
        RX4O3A2g+PzoxxqyQhojoJfbW9YDs/RrSF2NtXpnVydll4z/5XBFAA9MxtW5Oqd5Rauc6n
        nMO6OoK2tUI6R4bK/TiFVCRHk7ffoPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-f0GuKqI1PH-UmSxDutS1LA-1; Mon, 04 Oct 2021 15:51:08 -0400
X-MC-Unique: f0GuKqI1PH-UmSxDutS1LA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 760BA802935;
        Mon,  4 Oct 2021 19:51:07 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DA6D5D9DE;
        Mon,  4 Oct 2021 19:51:05 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH iproute2 v2 1/3] configure: support --param=value style
Date:   Mon,  4 Oct 2021 21:50:30 +0200
Message-Id: <189942255eec5688c214c6ff48815836b7d7e1c6.1633369677.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633369677.git.aclaudi@redhat.com>
References: <cover.1633369677.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit makes it possible to specify values for configure params
using the common autotools configure syntax '--param=value'.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/configure b/configure
index 7f4f3bd9..cebfda6e 100755
--- a/configure
+++ b/configure
@@ -501,18 +501,30 @@ if [ $# -eq 1 ] && [ "$(echo $1 | cut -c 1)" != '-' ]; then
 else
 	while true; do
 		case "$1" in
-			--include_dir)
-				INCLUDE=$2
-				shift 2 ;;
-			--libbpf_dir)
-				LIBBPF_DIR="$2"
-				shift 2 ;;
-			--libbpf_force)
-				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
+			--include_dir*)
+				INCLUDE="${1#*=}"
+				if [ "$INCLUDE" == "--include_dir" ]; then
+					INCLUDE=$2
+					shift
+				fi
+				shift ;;
+			--libbpf_dir*)
+				LIBBPF_DIR="${1#*=}"
+				if [ "$LIBBPF_DIR" == "--libbpf_dir" ]; then
+					LIBBPF_DIR="$2"
+					shift
+				fi
+				shift ;;
+			--libbpf_force*)
+				LIBBPF_FORCE="${1#*=}"
+				if [ "$LIBBPF_FORCE" == "--libbpf_force" ]; then
+					LIBBPF_FORCE="$2"
+					shift
+				fi
+				if [ "$LIBBPF_FORCE" != 'on' ] && [ "$LIBBPF_FORCE" != 'off' ]; then
 					usage 1
 				fi
-				LIBBPF_FORCE=$2
-				shift 2 ;;
+				shift ;;
 			-h | --help)
 				usage 0 ;;
 			"")
-- 
2.31.1

