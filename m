Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776A042D569
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhJNIxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:53:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhJNIxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634201490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qK4B9vLbE6QWrdX5HVna32If6nst1oYK4++jPMxmBXE=;
        b=iPO0VyymkzrdG1NolsnPKUETgHFuah80sl6/rgV8OQsXhARQeLUOpuOk3hI9i9dZQTM2U/
        R0YRuHn/UOFefWhiAUG/nqvDehTnfLBeC+WPNfY9wcU0G8qTQUjEHoy+QzUopoXiBOQz32
        0DAagKXRns9bRKP/Jpx+6wEtGN7LyGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-kgS0Kgp4ONK2Oj63_DOSNQ-1; Thu, 14 Oct 2021 04:51:27 -0400
X-MC-Unique: kgS0Kgp4ONK2Oj63_DOSNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC2E35074B;
        Thu, 14 Oct 2021 08:51:25 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8D007092B;
        Thu, 14 Oct 2021 08:51:23 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v5 2/7] configure: fix parsing issue on libbpf_dir option
Date:   Thu, 14 Oct 2021 10:50:50 +0200
Message-Id: <d1f024aa91c4a264c4de710f7ef04d9a3f6369dc.1634199240.git.aclaudi@redhat.com>
In-Reply-To: <cover.1634199240.git.aclaudi@redhat.com>
References: <cover.1634199240.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

configure is stuck in an endless loop if '--libbpf_dir' option is used
without a value:

$ ./configure --libbpf_dir
./configure: line 515: shift: 2: shift count out of range
./configure: line 515: shift: 2: shift count out of range
[...]

Fix it splitting 'shift 2' into two consecutive shifts, and making the
second one conditional to the number of remaining arguments.

A check is also provided after the while loop to verify the libbpf dir
exists; also, as LIBBPF_DIR does not have a default value, configure bails
out if the user does not specify a value after --libbpf_dir, thus avoiding
to produce an erroneous configuration.

Fixes: 7ae2585b865a ("configure: convert LIBBPF environment variables to command-line options")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index ea9051ab..0f304206 100755
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
@@ -506,8 +506,9 @@ else
 				INCLUDE="$1"
 				[ "$#" -gt 0 ] && shift ;;
 			--libbpf_dir)
-				LIBBPF_DIR="$2"
-				shift 2 ;;
+				shift
+				LIBBPF_DIR="$1"
+				[ "$#" -gt 0 ] && shift ;;
 			--libbpf_force)
 				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
 					usage 1
@@ -525,6 +526,9 @@ else
 fi
 
 [ -d "$INCLUDE" ] || usage 1
+if [ "${LIBBPF_DIR-unused}" != "unused" ]; then
+	[ -d "$LIBBPF_DIR" ] || usage 1
+fi
 
 echo "# Generated config based on" $INCLUDE >$CONFIG
 quiet_config >> $CONFIG
-- 
2.31.1

