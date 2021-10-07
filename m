Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D49425475
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbhJGNnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:43:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241655AbhJGNnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:43:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633614072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klvv3kfqavr7YnpR/CjGTpKmxzuVGLSx1u+UMDfyoYs=;
        b=A1irEnVQzAuss39yTzLLUutpKE65GCx05R5YOpq6qHs1KJ2lXu7D0dQnsGnFMrZEk/4Qq1
        SkVoVNuOA/N55uDzNUZwnu99Ya6kyvYjdmkRwldhY+R/Tg4ZapLJf/B6CAGmAeFxYFiziV
        3ef8IIiruZI2t53XmE3EiN+WqEtopiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-CH2mdepPOEKlJaKMSiL2ig-1; Thu, 07 Oct 2021 09:41:11 -0400
X-MC-Unique: CH2mdepPOEKlJaKMSiL2ig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3246319251A1;
        Thu,  7 Oct 2021 13:41:10 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E86D15D9DE;
        Thu,  7 Oct 2021 13:41:07 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v4 2/5] configure: fix parsing issue on libbpf_dir option
Date:   Thu,  7 Oct 2021 15:40:02 +0200
Message-Id: <dfe8fb26e1712f76f421506962e0b117c1f9fee2.1633612111.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633612111.git.aclaudi@redhat.com>
References: <cover.1633612111.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

configure is stuck in an endless loop if '--libbpf_dir' option is used
without a value:

$ ./configure --libbpf_dir
./configure: line 515: shift: 2: shift count out of range
./configure: line 515: shift: 2: shift count out of range
[...]

Fix it checking that a value is provided with the option.

Fixes: 7ae2585b865a ("configure: convert LIBBPF environment variables to command-line options")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 05f75437..27db3ecb 100755
--- a/configure
+++ b/configure
@@ -486,7 +486,7 @@ usage()
 	cat <<EOF
 Usage: $0 [OPTIONS]
 	--include_dir <dir>	Path to iproute2 include dir
-	--libbpf_dir		Path to libbpf DESTDIR
+	--libbpf_dir <dir>	Path to libbpf DESTDIR
 	--libbpf_force		Enable/disable libbpf by force. Available options:
 				  on: require link against libbpf, quit config if no libbpf support
 				  off: disable libbpf probing
@@ -512,6 +512,7 @@ else
 				shift 2 ;;
 			--libbpf_dir)
 				LIBBPF_DIR="$2"
+				check_value "$LIBBPF_DIR"
 				shift 2 ;;
 			--libbpf_force)
 				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
-- 
2.31.1

