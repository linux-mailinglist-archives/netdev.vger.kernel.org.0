Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3DE68AB6F
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjBDRFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDRFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:05:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E03113E1;
        Sat,  4 Feb 2023 09:05:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D58E7B80AB0;
        Sat,  4 Feb 2023 17:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2683CC433D2;
        Sat,  4 Feb 2023 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675530304;
        bh=43GndDihT5L1+wA5X85xw22Vc8Kl4Ss63nT+xWN4MFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bcc9VQt3m6gs+g4pyFNwgV93gGfoQ+Wtb6aYCcVxmb/Bm+7hxRUyWpzTcJhTftYme
         uU4TyobjIjES2y07AHgL8RQqZU8sickXnH6vXV8r+Dgl74VbmD3sarTeeEnwc8XlKZ
         ghGmU2Oh3MYFD2G/Zz83ZESWdqeqhsf+OTKvMJ7BcphI6LJnHMOeZiLWdazZ8RnROH
         ickZQXGUqJUWC/o3P3r/RyIgMuEYkA+HSTPOAXo8Mph6QkuN58nZ3uPommhN6fElhu
         bVpsmYyeShQKhMxziTBJuEmudOvB8EdIHeRviaSTF8LBaV5zQWNpgrN1qKLosT4efq
         WAiZF7U63McFg==
Date:   Sat, 4 Feb 2023 09:05:02 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org, Ian Rogers <irogers@google.com>,
        x86@kernel.org, netdev@vger.kernel.org
Subject: Re: [tip: objtool/core] objtool: Fix HOSTCC flag usage
Message-ID: <20230204170502.qjc3dpmf2owa3w7v@treble>
References: <20230126190606.40739-4-irogers@google.com>
 <167526879495.4906.2898311831401901292.tip-bot2@tip-bot2>
 <Y9qbGHDBFtGoqnKK@FVFF77S0Q05N>
 <20230201173637.cyu6yzudwsuzl2vj@treble>
 <20230203182540.7linqqtr3tlrbfe7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230203182540.7linqqtr3tlrbfe7@skbuf>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 08:25:40PM +0200, Vladimir Oltean wrote:
> On Wed, Feb 01, 2023 at 09:36:37AM -0800, Josh Poimboeuf wrote:
> > On Wed, Feb 01, 2023 at 05:02:16PM +0000, Mark Rutland wrote:
> > > Hi,
> > > 
> > > I just spotted this breaks cross-compiling; details below.
> > 
> > Thanks, we'll fix it up with
> > 
> > diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
> > index 29a8cd7449bf..83b100c1e7f6 100644
> > --- a/tools/objtool/Makefile
> > +++ b/tools/objtool/Makefile
> > @@ -36,7 +36,7 @@ OBJTOOL_CFLAGS := -Werror $(WARNINGS) $(KBUILD_HOSTCFLAGS) -g $(INCLUDES) $(LIBE
> >  OBJTOOL_LDFLAGS := $(LIBELF_LIBS) $(LIBSUBCMD) $(KBUILD_HOSTLDFLAGS)
> >  
> >  # Allow old libelf to be used:
> > -elfshdr := $(shell echo '$(pound)include <libelf.h>' | $(CC) $(CFLAGS) -x c -E - | grep elf_getshdr)
> > +elfshdr := $(shell echo '$(pound)include <libelf.h>' | $(HOSTCC) $(OBJTOOL_CFLAGS) -x c -E - | grep elf_getshdr)
> >  OBJTOOL_CFLAGS += $(if $(elfshdr),,-DLIBELF_USE_DEPRECATED)
> >  
> >  # Always want host compilation.
> 
> Profiting off of the occasion to point out that cross-compiling with
> CONFIG_DEBUG_INFO_BTF=y is also broken (it builds the resolve_btfids
> tool):

The above patch was for objtool, though I'm guessing you were bitten by
a similar patch for bpf:

  13e07691a16f ("tools/resolve_btfids: Alter how HOSTCC is forced")

It looks like it might have a similar problem we had for objtool.  Does
this fix it?

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index daed388aa5d7..fff84cd914cd 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -18,8 +18,8 @@ else
 endif
 
 # always use the host compiler
-HOST_OVERRIDES := AR="$(HOSTAR)" CC="$(HOSTCC)" LD="$(HOSTLD)" ARCH="$(HOSTARCH)" \
-		  EXTRA_CFLAGS="$(HOSTCFLAGS) $(KBUILD_HOSTCFLAGS)"
+HOST_OVERRIDES := AR="$(HOSTAR)" CC="$(HOSTCC)" LD="$(HOSTLD)" ARCH="$(HOSTARCH)"
+BTF_CFLAGS     := $(HOSTCFLAGS) $(KBUILD_HOSTCFLAGS)
 
 RM      ?= rm
 CROSS_COMPILE =
@@ -53,23 +53,25 @@ $(OUTPUT) $(OUTPUT)/libsubcmd $(LIBBPF_OUT):
 
 $(SUBCMDOBJ): fixdep FORCE | $(OUTPUT)/libsubcmd
 	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(SUBCMD_OUT) \
-		    DESTDIR=$(SUBCMD_DESTDIR) $(HOST_OVERRIDES) prefix= subdir= \
+		    $(HOST_OVERRIDES) EXTRA_CFLAGS="$(BTF_CFLAGS)" \
+		    DESTDIR=$(LIBBPF_DESTDIR) prefix= subdir= \
 		    $(abspath $@) install_headers
 
 $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OUT)
 	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(LIBBPF_OUT)    \
-		    DESTDIR=$(LIBBPF_DESTDIR) $(HOST_OVERRIDES) prefix= subdir= \
+		    $(HOST_OVERRIDES) EXTRA_CFLAGS="$(BTF_CFLAGS)" \
+		    DESTDIR=$(LIBBPF_DESTDIR) prefix= subdir= \
 		    $(abspath $@) install_headers
 
 LIBELF_FLAGS := $(shell $(HOSTPKG_CONFIG) libelf --cflags 2>/dev/null)
 LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lelf)
 
-CFLAGS += -g \
-          -I$(srctree)/tools/include \
-          -I$(srctree)/tools/include/uapi \
-          -I$(LIBBPF_INCLUDE) \
-          -I$(SUBCMD_INCLUDE) \
-          $(LIBELF_FLAGS)
+BTF_CFLAGS += -g \
+              -I$(srctree)/tools/include \
+              -I$(srctree)/tools/include/uapi \
+              -I$(LIBBPF_INCLUDE) \
+              -I$(SUBCMD_INCLUDE) \
+              $(LIBELF_FLAGS)
 
 LIBS = $(LIBELF_LIBS) -lz
 
@@ -77,7 +79,7 @@ export srctree OUTPUT CFLAGS Q
 include $(srctree)/tools/build/Makefile.include
 
 $(BINARY_IN): fixdep FORCE prepare | $(OUTPUT)
-	$(Q)$(MAKE) $(build)=resolve_btfids $(HOST_OVERRIDES)
+	$(Q)$(MAKE) $(build)=resolve_btfids $(HOST_OVERRIDES) CFLAGS="$(BTF_CFLAGS)"
 
 $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
 	$(call msg,LINK,$@)
