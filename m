Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F09239586A
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 11:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhEaJtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 05:49:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230514AbhEaJtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 05:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622454473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/Fr/fjoSkN6hA+ssp85aSJjwM3coRWpNGcJjIhPJ5Q=;
        b=dBSpUO+i/4I2JXGgqpsJPAxpY4k7evvEJRMLt3bUdAryeijD2MG3EbTiFqVqBeIeXVMFyg
        UG5p7kM3klUtQyGY3KHASA+SwFQGrQ9TG31m7N2e4mub43NhqPogcqjb0/9w9Q/239+64a
        WAJul+NCNenhffvgem4SuW8t+aLcYbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-4AyC4tPTMOG1GomIp4sl3A-1; Mon, 31 May 2021 05:47:52 -0400
X-MC-Unique: 4AyC4tPTMOG1GomIp4sl3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03DC21007CA7;
        Mon, 31 May 2021 09:47:51 +0000 (UTC)
Received: from Leo-laptop-t470s.redhat.com (ovpn-12-207.pek2.redhat.com [10.72.12.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 611515E274;
        Mon, 31 May 2021 09:47:49 +0000 (UTC)
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Hangbin Liu <haliu@redhat.com>
Subject: [PATCH iproute2-next 1/2] configure: add options ability
Date:   Mon, 31 May 2021 17:47:39 +0800
Message-Id: <20210531094740.2483122-2-haliu@redhat.com>
In-Reply-To: <20210531094740.2483122-1-haliu@redhat.com>
References: <20210531094740.2483122-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are more and more global environment variables that land everywhere
in configure, which is making user hard to know which one does what.
Using command-line options would make it easier for users to learn or
remember the config options.

This patch converts the INCLUDE variable to command option first. Check
if the first variable has '-' to compile with the old INCLUDE path
setting method.

Signed-off-by: Hangbin Liu <haliu@redhat.com>
---
 configure | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 179eae08..c58419c2 100755
--- a/configure
+++ b/configure
@@ -7,7 +7,7 @@
 #                           off: disable libbpf probing
 #   LIBBPF_DIR              Path to libbpf DESTDIR to use
 
-INCLUDE=${1:-"$PWD/include"}
+INCLUDE="$PWD/include"
 
 # Output file which is input to Makefile
 CONFIG=config.mk
@@ -486,6 +486,35 @@ endif
 EOF
 }
 
+usage()
+{
+	cat <<EOF
+Usage: $0 [OPTIONS]
+	--include_dir		Path to iproute2 include dir
+	-h | --help		Show this usage info
+EOF
+	exit $1
+}
+
+# Compat with the old INCLUDE path setting method.
+if [ $# -eq 1 ] && [ "$(echo $1 | cut -c 1)" != '-' ]; then
+	INCLUDE="$1"
+else
+	while true; do
+		case "$1" in
+			--include_dir)
+				INCLUDE=$2
+				shift 2 ;;
+			-h | --help)
+				usage 0 ;;
+			"")
+				break ;;
+			*)
+				usage 1 ;;
+		esac
+	done
+fi
+
 echo "# Generated config based on" $INCLUDE >$CONFIG
 quiet_config >> $CONFIG
 
-- 
2.26.3

