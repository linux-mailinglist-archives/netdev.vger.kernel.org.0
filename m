Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7142423342
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbhJEWLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:11:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236855AbhJEWLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 18:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633471797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMjVuiQcE0V1O7GzOw8C7RAWrrBYO/rEIuNH5hSn8Gg=;
        b=gZCjgBBNgkA6ETgjiUtbvja5QOv0qoK/BnXjwlbNFtlcE8eu9U3P3cFMvVk3OSz0KfQngB
        ee7AAp6ZUIMZYIS0Wd7nMGvHcgqkIKWaK/jOM6cRMPLTuDI3CUrYYIBnr0kwR+dgGOir7K
        3LS9Kl+kegu3rkdlUx1JINMANlRYyPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-umoR-0W8NhWGtwlUnEMDEQ-1; Tue, 05 Oct 2021 18:09:56 -0400
X-MC-Unique: umoR-0W8NhWGtwlUnEMDEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2C3C18414A7;
        Tue,  5 Oct 2021 22:09:43 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 342F2652BA;
        Tue,  5 Oct 2021 22:09:42 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH iproute2 v3 1/3] configure: support --param=value style
Date:   Wed,  6 Oct 2021 00:08:04 +0200
Message-Id: <caa9b65bef41acd51d45e45e1a158edb1eeefe7d.1633455436.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633455436.git.aclaudi@redhat.com>
References: <cover.1633455436.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
index 7f4f3bd9..d57ce0f8 100755
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
+			--include_dir | --include_dir=*)
+				INCLUDE="${1#*=}"
+				if [ "$INCLUDE" == "--include_dir" ]; then
+					INCLUDE=$2
+					shift
+				fi
+				shift ;;
+			--libbpf_dir | --libbpf_dir=*)
+				LIBBPF_DIR="${1#*=}"
+				if [ "$LIBBPF_DIR" == "--libbpf_dir" ]; then
+					LIBBPF_DIR="$2"
+					shift
+				fi
+				shift ;;
+			--libbpf_force | --libbpf_force=*)
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

