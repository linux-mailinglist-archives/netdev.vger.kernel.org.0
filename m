Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F3C42D56D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhJNIxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:53:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230030AbhJNIxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634201498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KR8utXZyJAs2hDWoOk7IsG2TlNMunC/PZNndVTs1EAU=;
        b=cBG+YRNxiOSLa5yNO/Wx1N0LzjYqQysqiMN9WUA5cKO40AEyNK63suQj/Ilw5wShSxtdaf
        BjFlJIfcDLC28JOQmm4UzkUFHum/cewkOOfvP2Ddx9LvmC49fDOdr4p1S6zgQarJcWw7nc
        joGmna4h/rB2j/NAFsljbJWb98PFJWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-UIqNYDGwM8m13kWhxWtJcA-1; Thu, 14 Oct 2021 04:51:37 -0400
X-MC-Unique: UIqNYDGwM8m13kWhxWtJcA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43EBA1006AA3;
        Thu, 14 Oct 2021 08:51:36 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C267C1B42C;
        Thu, 14 Oct 2021 08:51:33 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v5 6/7] configure: add the --prefix option
Date:   Thu, 14 Oct 2021 10:50:54 +0200
Message-Id: <88b3ba75872cc2850e13b2e76db680551ec8e672.1634199240.git.aclaudi@redhat.com>
In-Reply-To: <cover.1634199240.git.aclaudi@redhat.com>
References: <cover.1634199240.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit add the '--prefix' option to the iproute2 configure script.

This mimics the '--prefix' option that autotools configure provides, and
will be used later to allow users or packagers to set the lib directory.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/configure b/configure
index 9a2645d9..05e23eff 100755
--- a/configure
+++ b/configure
@@ -3,6 +3,7 @@
 # This is not an autoconf generated configure
 
 INCLUDE="$PWD/include"
+PREFIX="/usr"
 
 # Output file which is input to Makefile
 CONFIG=config.mk
@@ -490,6 +491,7 @@ Usage: $0 [OPTIONS]
 	--libbpf_force <on|off>		Enable/disable libbpf by force. Available options:
 					  on: require link against libbpf, quit config if no libbpf support
 					  off: disable libbpf probing
+	--prefix <dir>			Path prefix of the lib files to install
 	-h | --help			Show this usage info
 EOF
 	exit $1
@@ -516,6 +518,11 @@ else
 				LIBBPF_FORCE="$1" ;;
 			--libbpf_force=*)
 				LIBBPF_FORCE="${1#*=}" ;;
+			--prefix)
+				shift
+				PREFIX="$1" ;;
+			--prefix=*)
+				PREFIX="${1#*=}" ;;
 			-h | --help)
 				usage 0 ;;
 			--*)
@@ -536,6 +543,7 @@ if [ "${LIBBPF_FORCE-unused}" != "unused" ]; then
 		usage 1
 	fi
 fi
+[ -z "$PREFIX" ] && usage 1
 
 echo "# Generated config based on" $INCLUDE >$CONFIG
 quiet_config >> $CONFIG
-- 
2.31.1

