Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF5815FA06
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 23:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgBNW5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 17:57:35 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:36023 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbgBNW5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 17:57:34 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7372dea8;
        Fri, 14 Feb 2020 22:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=9r4l9OwwPvwwLfC2EiUnlQzzx
        sQ=; b=aymKURZ7NxVpXEK5/TEK06lEUa2oSSdihPyo8QAkHgIsAeBdU/nItoi8Z
        FIApIc5w9EWlvPWv/bz8zpPYtG2Xcw1VeH8BULjOyXJIPs5XnRrxKIKqzXpV0UhP
        FRCdZU2/sKiZho0fNclmSxTTWhwCIhV740Atnw6lBT3JgRiZyEwmecVPJmOgFERH
        YFOohC9qTtQAW5IyP+7sx/w/0R9iUu9MOMmnS45MEIRTUBFy1W0mm6aIBKQcZuXA
        Scn5kAkSYvUbY4Z4Tbj0X95JUf3H7PRRBzAxGbO2dES6CcUg+dMCMQoyYkhaMAoy
        rQHav1y7RIhBPUeX/37VfW8jVIMkw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 165f05c2 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 14 Feb 2020 22:55:22 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v3 net 1/4] wireguard: selftests: reduce complexity and fix make races
Date:   Fri, 14 Feb 2020 23:57:20 +0100
Message-Id: <20200214225723.63646-2-Jason@zx2c4.com>
In-Reply-To: <20200214225723.63646-1-Jason@zx2c4.com>
References: <20200214225723.63646-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This gives us fewer dependencies and shortens build time, fixes up some
hash checking race conditions, and also fixes missing directory creation
that caused issues on massively parallel builds.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 .../testing/selftests/wireguard/qemu/Makefile | 38 +++++++------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index f10aa3590adc..28d477683e8a 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -38,19 +38,17 @@ endef
 define file_download =
 $(DISTFILES_PATH)/$(1):
 	mkdir -p $(DISTFILES_PATH)
-	flock -x $$@.lock -c '[ -f $$@ ] && exit 0; wget -O $$@.tmp $(MIRROR)$(1) || wget -O $$@.tmp $(2)$(1) || rm -f $$@.tmp'
-	if echo "$(3)  $$@.tmp" | sha256sum -c -; then mv $$@.tmp $$@; else rm -f $$@.tmp; exit 71; fi
+	flock -x $$@.lock -c '[ -f $$@ ] && exit 0; wget -O $$@.tmp $(MIRROR)$(1) || wget -O $$@.tmp $(2)$(1) || rm -f $$@.tmp; [ -f $$@.tmp ] || exit 1; if echo "$(3)  $$@.tmp" | sha256sum -c -; then mv $$@.tmp $$@; else rm -f $$@.tmp; exit 71; fi'
 endef
 
 $(eval $(call tar_download,MUSL,musl,1.1.24,.tar.gz,https://www.musl-libc.org/releases/,1370c9a812b2cf2a7d92802510cca0058cc37e66a7bedd70051f0a34015022a3))
-$(eval $(call tar_download,LIBMNL,libmnl,1.0.4,.tar.bz2,https://www.netfilter.org/projects/libmnl/files/,171f89699f286a5854b72b91d06e8f8e3683064c5901fb09d954a9ab6f551f81))
 $(eval $(call tar_download,IPERF,iperf,3.7,.tar.gz,https://downloads.es.net/pub/iperf/,d846040224317caf2f75c843d309a950a7db23f9b44b94688ccbe557d6d1710c))
 $(eval $(call tar_download,BASH,bash,5.0,.tar.gz,https://ftp.gnu.org/gnu/bash/,b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d))
 $(eval $(call tar_download,IPROUTE2,iproute2,5.4.0,.tar.xz,https://www.kernel.org/pub/linux/utils/net/iproute2/,fe97aa60a0d4c5ac830be18937e18dc3400ca713a33a89ad896ff1e3d46086ae))
 $(eval $(call tar_download,IPTABLES,iptables,1.8.4,.tar.bz2,https://www.netfilter.org/projects/iptables/files/,993a3a5490a544c2cbf2ef15cf7e7ed21af1845baf228318d5c36ef8827e157c))
 $(eval $(call tar_download,NMAP,nmap,7.80,.tar.bz2,https://nmap.org/dist/,fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa))
 $(eval $(call tar_download,IPUTILS,iputils,s20190709,.tar.gz,https://github.com/iputils/iputils/archive/s20190709.tar.gz/#,a15720dd741d7538dd2645f9f516d193636ae4300ff7dbc8bfca757bf166490a))
-$(eval $(call tar_download,WIREGUARD_TOOLS,wireguard-tools,1.0.20191226,.tar.xz,https://git.zx2c4.com/wireguard-tools/snapshot/,aa8af0fdc9872d369d8c890a84dbc2a2466b55795dccd5b47721b2d97644b04f))
+$(eval $(call tar_download,WIREGUARD_TOOLS,wireguard-tools,1.0.20200206,.tar.xz,https://git.zx2c4.com/wireguard-tools/snapshot/,f5207248c6a3c3e3bfc9ab30b91c1897b00802ed861e1f9faaed873366078c64))
 
 KERNEL_BUILD_PATH := $(BUILD_PATH)/kernel$(if $(findstring yes,$(DEBUG_KERNEL)),-debug)
 rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
@@ -295,21 +293,13 @@ $(IPERF_PATH)/src/iperf3: | $(IPERF_PATH)/.installed $(USERSPACE_DEPS)
 	$(MAKE) -C $(IPERF_PATH)
 	$(STRIP) -s $@
 
-$(LIBMNL_PATH)/.installed: $(LIBMNL_TAR)
-	flock -s $<.lock tar -C $(BUILD_PATH) -xf $<
-	touch $@
-
-$(LIBMNL_PATH)/src/.libs/libmnl.a: | $(LIBMNL_PATH)/.installed $(USERSPACE_DEPS)
-	cd $(LIBMNL_PATH) && ./configure --prefix=/ $(CROSS_COMPILE_FLAG) --enable-static --disable-shared
-	$(MAKE) -C $(LIBMNL_PATH)
-	sed -i 's:prefix=.*:prefix=$(LIBMNL_PATH):' $(LIBMNL_PATH)/libmnl.pc
-
 $(WIREGUARD_TOOLS_PATH)/.installed: $(WIREGUARD_TOOLS_TAR)
+	mkdir -p $(BUILD_PATH)
 	flock -s $<.lock tar -C $(BUILD_PATH) -xf $<
 	touch $@
 
-$(WIREGUARD_TOOLS_PATH)/src/wg: | $(WIREGUARD_TOOLS_PATH)/.installed $(LIBMNL_PATH)/src/.libs/libmnl.a $(USERSPACE_DEPS)
-	LDFLAGS="$(LDFLAGS) -L$(LIBMNL_PATH)/src/.libs" $(MAKE) -C $(WIREGUARD_TOOLS_PATH)/src LIBMNL_CFLAGS="-I$(LIBMNL_PATH)/include" LIBMNL_LDLIBS="-lmnl" wg
+$(WIREGUARD_TOOLS_PATH)/src/wg: | $(WIREGUARD_TOOLS_PATH)/.installed $(USERSPACE_DEPS)
+	$(MAKE) -C $(WIREGUARD_TOOLS_PATH)/src wg
 	$(STRIP) -s $@
 
 $(BUILD_PATH)/init: init.c | $(USERSPACE_DEPS)
@@ -340,17 +330,17 @@ $(BASH_PATH)/bash: | $(BASH_PATH)/.installed $(USERSPACE_DEPS)
 $(IPROUTE2_PATH)/.installed: $(IPROUTE2_TAR)
 	mkdir -p $(BUILD_PATH)
 	flock -s $<.lock tar -C $(BUILD_PATH) -xf $<
-	printf 'CC:=$(CC)\nPKG_CONFIG:=pkg-config\nTC_CONFIG_XT:=n\nTC_CONFIG_ATM:=n\nTC_CONFIG_IPSET:=n\nIP_CONFIG_SETNS:=y\nHAVE_ELF:=n\nHAVE_MNL:=y\nHAVE_BERKELEY_DB:=n\nHAVE_LATEX:=n\nHAVE_PDFLATEX:=n\nCFLAGS+=-DHAVE_SETNS -DHAVE_LIBMNL -I$(LIBMNL_PATH)/include\nLDLIBS+=-lmnl' > $(IPROUTE2_PATH)/config.mk
+	printf 'CC:=$(CC)\nPKG_CONFIG:=pkg-config\nTC_CONFIG_XT:=n\nTC_CONFIG_ATM:=n\nTC_CONFIG_IPSET:=n\nIP_CONFIG_SETNS:=y\nHAVE_ELF:=n\nHAVE_MNL:=n\nHAVE_BERKELEY_DB:=n\nHAVE_LATEX:=n\nHAVE_PDFLATEX:=n\nCFLAGS+=-DHAVE_SETNS\n' > $(IPROUTE2_PATH)/config.mk
 	printf 'lib: snapshot\n\t$$(MAKE) -C lib\nip/ip: lib\n\t$$(MAKE) -C ip ip\nmisc/ss: lib\n\t$$(MAKE) -C misc ss\n' >> $(IPROUTE2_PATH)/Makefile
 	touch $@
 
-$(IPROUTE2_PATH)/ip/ip: | $(IPROUTE2_PATH)/.installed $(LIBMNL_PATH)/src/.libs/libmnl.a $(USERSPACE_DEPS)
-	LDFLAGS="$(LDFLAGS) -L$(LIBMNL_PATH)/src/.libs" PKG_CONFIG_LIBDIR="$(LIBMNL_PATH)" $(MAKE) -C $(IPROUTE2_PATH) PREFIX=/ ip/ip
-	$(STRIP) -s $(IPROUTE2_PATH)/ip/ip
+$(IPROUTE2_PATH)/ip/ip: | $(IPROUTE2_PATH)/.installed $(USERSPACE_DEPS)
+	$(MAKE) -C $(IPROUTE2_PATH) PREFIX=/ ip/ip
+	$(STRIP) -s $@
 
-$(IPROUTE2_PATH)/misc/ss: | $(IPROUTE2_PATH)/.installed $(LIBMNL_PATH)/src/.libs/libmnl.a $(USERSPACE_DEPS)
-	LDFLAGS="$(LDFLAGS) -L$(LIBMNL_PATH)/src/.libs" PKG_CONFIG_LIBDIR="$(LIBMNL_PATH)" $(MAKE) -C $(IPROUTE2_PATH) PREFIX=/ misc/ss
-	$(STRIP) -s $(IPROUTE2_PATH)/misc/ss
+$(IPROUTE2_PATH)/misc/ss: | $(IPROUTE2_PATH)/.installed $(USERSPACE_DEPS)
+	$(MAKE) -C $(IPROUTE2_PATH) PREFIX=/ misc/ss
+	$(STRIP) -s $@
 
 $(IPTABLES_PATH)/.installed: $(IPTABLES_TAR)
 	mkdir -p $(BUILD_PATH)
@@ -358,8 +348,8 @@ $(IPTABLES_PATH)/.installed: $(IPTABLES_TAR)
 	sed -i -e "/nfnetlink=[01]/s:=[01]:=0:" -e "/nfconntrack=[01]/s:=[01]:=0:" $(IPTABLES_PATH)/configure
 	touch $@
 
-$(IPTABLES_PATH)/iptables/xtables-legacy-multi: | $(IPTABLES_PATH)/.installed $(LIBMNL_PATH)/src/.libs/libmnl.a $(USERSPACE_DEPS)
-	cd $(IPTABLES_PATH) && PKG_CONFIG_LIBDIR="$(LIBMNL_PATH)" ./configure --prefix=/ $(CROSS_COMPILE_FLAG) --enable-static --disable-shared --disable-nftables --disable-bpf-compiler --disable-nfsynproxy --disable-libipq --with-kernel=$(BUILD_PATH)/include
+$(IPTABLES_PATH)/iptables/xtables-legacy-multi: | $(IPTABLES_PATH)/.installed $(USERSPACE_DEPS)
+	cd $(IPTABLES_PATH) && ./configure --prefix=/ $(CROSS_COMPILE_FLAG) --enable-static --disable-shared --disable-nftables --disable-bpf-compiler --disable-nfsynproxy --disable-libipq --disable-connlabel --with-kernel=$(BUILD_PATH)/include
 	$(MAKE) -C $(IPTABLES_PATH)
 	$(STRIP) -s $@
 
-- 
2.25.0

