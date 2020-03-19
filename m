Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84B518A9CE
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgCSAay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:30:54 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:39393 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCSAay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:30:54 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7e8ba0c1;
        Thu, 19 Mar 2020 00:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=yp2zimGz0CcoVT9CERK5CUgxI
        Ls=; b=h40VaYxLAuZfltG36INqZ/YiJsbwBZXlYGywFd7VmHURSeUjwSm/SSLXp
        86IbmJotp31KA6Bn3wnxTCYdT5fG7EGkYwCdYGV3RJPpq1PSmYaHnmmPHxuZf/nJ
        i8dQfosSeubnIh/+vyUmrCfDTAl+vftAIVNDy7xfbs4ikspSzAe0YG/IpzjVCa2X
        DGwv/bBsGGLd7ZUOduLiMORSbbFhzuReQvCpqfKK5K7qpv0AOiYWYEeqQyrxcVwP
        eYDPmBIzCkaQ6HH+Sp77TWj2lAL9328/6NEx+kToiFlMXtwMrZMnmrtQB/dmmKzb
        rlgJILiuWYYF+DCCLUvy3DicA1uwA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0ac6f413 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 00:24:26 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/5] wireguard: selftests: test using new 64-bit time_t
Date:   Wed, 18 Mar 2020 18:30:44 -0600
Message-Id: <20200319003047.113501-3-Jason@zx2c4.com>
In-Reply-To: <20200319003047.113501-1-Jason@zx2c4.com>
References: <20200319003047.113501-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case this helps expose bugs with the newer 64-bit time_t types, we do
our testing with the newer musl that supports this as well as
CONFIG_COMPAT_32BIT_TIME=n. This matters to us, since wireguard does in
fact deal with timestamps.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/Makefile      | 2 +-
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index 28d477683e8a..90598a425c18 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -41,7 +41,7 @@ $(DISTFILES_PATH)/$(1):
 	flock -x $$@.lock -c '[ -f $$@ ] && exit 0; wget -O $$@.tmp $(MIRROR)$(1) || wget -O $$@.tmp $(2)$(1) || rm -f $$@.tmp; [ -f $$@.tmp ] || exit 1; if echo "$(3)  $$@.tmp" | sha256sum -c -; then mv $$@.tmp $$@; else rm -f $$@.tmp; exit 71; fi'
 endef
 
-$(eval $(call tar_download,MUSL,musl,1.1.24,.tar.gz,https://www.musl-libc.org/releases/,1370c9a812b2cf2a7d92802510cca0058cc37e66a7bedd70051f0a34015022a3))
+$(eval $(call tar_download,MUSL,musl,1.2.0,.tar.gz,https://musl.libc.org/releases/,c6de7b191139142d3f9a7b5b702c9cae1b5ee6e7f57e582da9328629408fd4e8))
 $(eval $(call tar_download,IPERF,iperf,3.7,.tar.gz,https://downloads.es.net/pub/iperf/,d846040224317caf2f75c843d309a950a7db23f9b44b94688ccbe557d6d1710c))
 $(eval $(call tar_download,BASH,bash,5.0,.tar.gz,https://ftp.gnu.org/gnu/bash/,b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d))
 $(eval $(call tar_download,IPROUTE2,iproute2,5.4.0,.tar.xz,https://www.kernel.org/pub/linux/utils/net/iproute2/,fe97aa60a0d4c5ac830be18937e18dc3400ca713a33a89ad896ff1e3d46086ae))
diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index af9323a0b6e0..d531de13c95b 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -56,7 +56,6 @@ CONFIG_NO_HZ_IDLE=y
 CONFIG_NO_HZ_FULL=n
 CONFIG_HZ_PERIODIC=n
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_COMPAT_32BIT_TIME=y
 CONFIG_ARCH_RANDOM=y
 CONFIG_FILE_LOCKING=y
 CONFIG_POSIX_TIMERS=y
-- 
2.25.1

