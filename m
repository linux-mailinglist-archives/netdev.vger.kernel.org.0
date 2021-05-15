Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DCE381AF1
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 22:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbhEOUOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 16:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231280AbhEOUOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 16:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD8216121E;
        Sat, 15 May 2021 20:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621109603;
        bh=BaSi2kyoAY+toEVjxp2hEe/L69F4h4k5KyvrMvLI1p4=;
        h=From:To:Cc:Subject:Date:From;
        b=RdcnJtpbWO22DaFnZpHLqnUV08OmIq8xmyG/GCZpVpjE9fSdCzgQ4U0KTHOOCtVAr
         mrKTwx0qyxZyqeycLn7sivC5RTIKq2aHi+qCQ0hFdihLhuaqsA+Y3NuwPfY0B4YmYu
         x7NnRQdW6nSWcHUVfUK4Yv14xuT+rv81KGOnX+TFzn5gV4sKa7PAJcRf2vJYZgXBfu
         jSburyJeynfYGpgW4K/Ay8jpCk+WlThVPWL5VJRt+XPYjginwsm0TUe5JufbTtihtE
         PGqDMDPKGxoZrzwKNdSOSVU2SYPPcXqZzEcP3mDU8PGBhtm0e0Lf372JbgS+PKgTAG
         bY1e1xViyxNkQ==
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     petr.vorel@gmail.com, heiko.thiery@gmail.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next] config.mk: Rerun configure when it is newer than config.mk
Date:   Sat, 15 May 2021 20:13:20 +0000
Message-Id: <20210515201320.7435-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.27.0
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

