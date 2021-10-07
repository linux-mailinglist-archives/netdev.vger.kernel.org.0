Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B32C425474
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241644AbhJGNnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:43:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233331AbhJGNnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633614069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DgBi3Druetslx5g2ciQQaglcF4Ow88WfWN70lF9LRi4=;
        b=VUtAkB1kewmuBnxp59i8qoo04KkP3PiwpqlZNgqNapRWSqiJNDI+pInMtkrom7kbH52MuU
        UF6CCej+sqi8ULwTwrLyV523AtDuqQp7WLP8ApNcJOthTqUSXwJnkpHObtAyGvDcZKmfN+
        dgekSscuUFdXYtNpozRKQvu/iPRcKY8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-QxPrpJosNtmLbBrcEmvpWA-1; Thu, 07 Oct 2021 09:41:08 -0400
X-MC-Unique: QxPrpJosNtmLbBrcEmvpWA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F0531084691;
        Thu,  7 Oct 2021 13:41:07 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18C305D9DE;
        Thu,  7 Oct 2021 13:41:03 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v4 1/5] configure: fix parsing issue on include_dir option
Date:   Thu,  7 Oct 2021 15:40:01 +0200
Message-Id: <f988b8816d6cc1965b48953194c468f07dec7367.1633612111.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633612111.git.aclaudi@redhat.com>
References: <cover.1633612111.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

configure is stuck in an endless loop if '--include_dir' option is used
without a value:

$ ./configure --include_dir
./configure: line 506: shift: 2: shift count out of range
./configure: line 506: shift: 2: shift count out of range
[...]

Fix it checking that a value is provided with the option.
A dedicated function is used to avoid code duplication, as this check will
be needed for further options that may be introduced in the future.

Fixes: a9c3d70d902a ("configure: add options ability")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 7f4f3bd9..05f75437 100755
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
@@ -495,6 +495,11 @@ EOF
 	exit $1
 }
 
+check_value()
+{
+	[ -z "$1" ] && usage 1
+}
+
 # Compat with the old INCLUDE path setting method.
 if [ $# -eq 1 ] && [ "$(echo $1 | cut -c 1)" != '-' ]; then
 	INCLUDE="$1"
@@ -503,6 +508,7 @@ else
 		case "$1" in
 			--include_dir)
 				INCLUDE=$2
+				check_value "$INCLUDE"
 				shift 2 ;;
 			--libbpf_dir)
 				LIBBPF_DIR="$2"
-- 
2.31.1

