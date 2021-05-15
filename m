Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E873E381AFA
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 22:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhEOUVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 16:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234840AbhEOUV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 16:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3B1C6121E;
        Sat, 15 May 2021 20:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621110014;
        bh=BaSi2kyoAY+toEVjxp2hEe/L69F4h4k5KyvrMvLI1p4=;
        h=From:To:Cc:Subject:Date:From;
        b=ka5QKENBlVuMMgyHJGRDfbBMydx/+4AjDhx9yx95jfLcmqefwDqI5dHkrCx5Cxmnr
         BsEzqnELx+AccZwkBDLH9JZZlIzCtTkniQZ5QEyk6qaj/KX/aiukL5IKmOmAh5uYty
         XWQiVuHZNJVhVhbP7udFfJHO1C6O5j+exMrvlI5PYxrAQY4tdwczYmClsxzEYbIrWu
         vYqkxqpAlye2R+q7DXQVaqT5o/dl7lcBrUEm7vYAoDsSJhl1qJO0pJA0FHq3dwo2f0
         xe++diQa1Bib/NWTLoS1aJbE5JnKVBZHz8H2UpwmHk5RhDpLuJjAAzoLpRWPYMSJPb
         dcLqVltn28wOg==
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     petr.vorel@gmail.com, heiko.thiery@gmail.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next] Rerun configure when it is newer than config.mk
Date:   Sat, 15 May 2021 14:20:09 -0600
Message-Id: <20210515202009.8904-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

config.mk needs to be re-generated any time configure is changed.
Rename the existing make target and add a check that the config.mk
file needs to exist and must be newer than configure script.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Petr Vorel <petr.vorel@gmail.com>
---
 Makefile | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 19bd163e2e04..5bc11477ab7a 100644
--- a/Makefile
+++ b/Makefile
@@ -60,7 +60,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
 LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
 LDLIBS += $(LIBNETLINK)
 
-all: config.mk
+all: config
 	@set -e; \
 	for i in $(SUBDIRS); \
 	do echo; echo $$i; $(MAKE) -C $$i; done
@@ -80,8 +80,10 @@ all: config.mk
 	@echo "Make Arguments:"
 	@echo " V=[0|1]             - set build verbosity level"
 
-config.mk:
-	sh configure $(KERNEL_INCLUDE)
+config:
+	@if [ ! -f config.mk -o configure -nt config.mk ]; then \
+		sh configure $(KERNEL_INCLUDE); \
+	fi
 
 install: all
 	install -m 0755 -d $(DESTDIR)$(SBINDIR)
-- 
2.27.0

