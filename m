Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4AF1B03D
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 08:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfEMGWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 02:22:41 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:39928 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbfEMGWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 02:22:40 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id x4D6MKMH031944;
        Mon, 13 May 2019 15:22:24 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com x4D6MKMH031944
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1557728546;
        bh=OfIIhemlSrlQXaNMkfHqX67qd7jBRMPIHtESheuz9Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGuNVM4HIJn3sGkIzCx0NaTE96qTKfhXUc4a/D58K2M1iRkcFfX8P2tF8AE2NGZJD
         D1PPv7MLc7uTQo3h9ng9GAWKckObeJnnAPN+WGFJitVDzWkSRysrBoEYGdk1wYvmRM
         s+c8yRHquRkzlJyY2Q8AsnOGT4QmMNN5w7lGIZxrOpE9wzZjEsHc2L6bHsceL2e8fs
         v6DK5RAoFJy+JbCP/d0RwDMMph4APDu82HpeTu5xqXz39PlzCgg0FEmID4TWt4M8+4
         K78FqMrTdboC53WryiUe08oETiyFMjLTjiEQzHDUYJscz5eI8NbjZl7ETLQjC04Ubo
         NF2HmL3+14c4g==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 4/4] kbuild: remove 'addtree' and 'flags' magic for header search paths
Date:   Mon, 13 May 2019 15:22:17 +0900
Message-Id: <20190513062217.20750-5-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190513062217.20750-1-yamada.masahiro@socionext.com>
References: <20190513062217.20750-1-yamada.masahiro@socionext.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'addtree' and 'flags' in scripts/Kbuild.include are so compilecated
and ugly.

As I mentioned in [1], Kbuild should stop automatic prefixing of header
search path options.

Instead, in-kernel Makefiles should explicitly add $(srctree)/ to
the search paths in the srctree.

Kbuild still caters to add $(srctree)/$(src) and $(objtree)/$(obj)
to the header search path for O= building, but never touches extra
compiler options from ccflags-y etc.

Going forward, in-kernel Makefiles should explicitly specify
$(srctree)/ if extra search paths are needed.

 Example)    ccflags-y += -I $(srctree)/foo/bar

You do not have to change external module Makefiles because $(src)
is already an absolute path for external modules.

 Example)    ccflags-y += -I $(src)/foo/bar

[1]: https://patchwork.kernel.org/patch/9632347/

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 scripts/Kbuild.include |  8 --------
 scripts/Makefile.host  | 12 +++++-------
 scripts/Makefile.lib   | 26 ++++++++------------------
 3 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 7484b9d8272f..a675ce11a573 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -192,14 +192,6 @@ clean := -f $(srctree)/scripts/Makefile.clean obj
 # $(Q)$(MAKE) $(hdr-inst)=dir
 hdr-inst := -f $(srctree)/scripts/Makefile.headersinst obj
 
-# Prefix -I with $(srctree) if it is not an absolute path.
-# skip if -I has no parameter
-addtree = $(if $(patsubst -I%,%,$(1)), \
-$(if $(filter-out -I/% -I./% -I../%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1)),$(1))
-
-# Find all -I options and call addtree
-flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
-
 # echo command.
 # Short version is used, if $(quiet) equals `quiet_', otherwise full one.
 echo-cmd = $(if $($(quiet)cmd_$(1)),\
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 73b804197fca..b6a54bdf0965 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -67,18 +67,16 @@ _hostc_flags   = $(KBUILD_HOSTCFLAGS)   $(HOST_EXTRACFLAGS)   \
 _hostcxx_flags = $(KBUILD_HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
                  $(HOSTCXXFLAGS_$(basetarget).o)
 
-__hostc_flags	= $(_hostc_flags)
-__hostcxx_flags	= $(_hostcxx_flags)
-
+# $(objtree)/$(obj) for including generated headers from checkin source files
 ifeq ($(KBUILD_EXTMOD),)
 ifneq ($(srctree),.)
-__hostc_flags	= -I$(obj) $(call flags,_hostc_flags)
-__hostcxx_flags	= -I$(obj) $(call flags,_hostcxx_flags)
+_hostc_flags   += -I $(objtree)/$(obj)
+_hostcxx_flags += -I $(objtree)/$(obj)
 endif
 endif
 
-hostc_flags    = -Wp,-MD,$(depfile) $(__hostc_flags)
-hostcxx_flags  = -Wp,-MD,$(depfile) $(__hostcxx_flags)
+hostc_flags    = -Wp,-MD,$(depfile) $(_hostc_flags)
+hostcxx_flags  = -Wp,-MD,$(depfile) $(_hostcxx_flags)
 
 #####
 # Compile programs on the host
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 41e98fa66b91..1b412d4394ae 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -137,36 +137,26 @@ _c_flags += $(if $(patsubst n%,, \
 	$(CFLAGS_KCOV))
 endif
 
-__c_flags	= $(_c_flags)
-__a_flags	= $(_a_flags)
-__cpp_flags     = $(_cpp_flags)
-
-# If building the kernel in a separate objtree expand all occurrences
-# of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
+# $(srctree)/$(src) for including checkin headers from generated source files
+# $(objtree)/$(obj) for including generated headers from checkin source files
 ifeq ($(KBUILD_EXTMOD),)
 ifneq ($(srctree),.)
-
-# -I$(obj) locates generated .h files
-# $(call addtree,-I$(obj)) locates .h files in srctree, from generated .c files
-#   and locates generated .h files
-# FIXME: Replace both with specific CFLAGS* statements in the makefiles
-__c_flags	= $(if $(obj),$(call addtree,-I$(src)) -I$(obj)) \
-		  $(call flags,_c_flags)
-__a_flags	= $(call flags,_a_flags)
-__cpp_flags     = $(call flags,_cpp_flags)
+_c_flags   += -I $(srctree)/$(src) -I $(objtree)/$(obj)
+_a_flags   += -I $(srctree)/$(src) -I $(objtree)/$(obj)
+_cpp_flags += -I $(srctree)/$(src) -I $(objtree)/$(obj)
 endif
 endif
 
 c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 -include $(srctree)/include/linux/compiler_types.h       \
-		 $(__c_flags) $(modkern_cflags)                           \
+		 $(_c_flags) $(modkern_cflags)                           \
 		 $(basename_flags) $(modname_flags)
 
 a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
-		 $(__a_flags) $(modkern_aflags)
+		 $(_a_flags) $(modkern_aflags)
 
 cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
-		 $(__cpp_flags)
+		 $(_cpp_flags)
 
 ld_flags       = $(KBUILD_LDFLAGS) $(ldflags-y) $(LDFLAGS_$(@F))
 
-- 
2.17.1

