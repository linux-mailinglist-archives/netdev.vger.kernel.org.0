Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0C92D65B2
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 19:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393198AbgLJS5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 13:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbgLJS5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 13:57:05 -0500
From:   Mark Brown <broonie@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Daniel Diaz <daniel.diaz@linaro.org>,
        Veronika Kabatova <vkabatov@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] selftests: Skip BPF seftests by default
Date:   Thu, 10 Dec 2020 18:52:33 +0000
Message-Id: <20201210185233.28091-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; i=7Xhvzkgs2X5AXYEHO8N7h/4qCSh88rSZtK7RUR5uyKc=; m=NLFbCJ5BO0tEebe5aDGXW+BpeGH7KelNPszypI0wiNo=; p=NP0IeQiNob21poKCDV2rFRlDlnvPgTk/qWODOlZgNeE=; g=10657ae2c8ea502e09f342527ca847c8098f2fb4
X-Patch-Sig: m=pgp; i=broonie@kernel.org; s=0xC3F436CA30F5D8EB; b=iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/SbQkACgkQJNaLcl1Uh9BTVwf8DRx FtItjWz319skvRSHPOX/iQq3C99DcGdMRQ9v+/pyEhQrdHEBp0g2WohTe/2u//PIZHTQbgtRMSU+N bsNOU0/dDxZzbk+sHVdeIawELWDoE/7pWZTHxCP2RwcSjxP7z+Kj95t5LfejBZFcUBEgmwAdWqCw3 HN5nzxYQdc466bbM5NLjevK8v7ySdo1AkGwvVKsopkn8H6E07xmPbqwWTOeA2xfnaIa7VUbmYuLas SJaTVHW+GygbiEcHSgvMYlq/5PhKxwPJCSy1r4ChUvhvMkdy1NSbC/V5Qfxf+s02o65usz6NkxF7y gvh2eWVMT03qv54xEJjxjlXy1j6xQzg==
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF selftests have build time dependencies on cutting edge versions
of tools in the BPF ecosystem including LLVM which are more involved
to satisfy than more typical requirements like installing a package from
your distribution.  This causes issues for users looking at kselftest in
as a whole who find that a default build of kselftest fails and that
resolving this is time consuming and adds administrative overhead.  The
fast pace of BPF development and the need for a full BPF stack to do
substantial development or validation work on the code mean that people
working directly on it don't see a reasonable way to keep supporting
older environments without causing problems with the usability of the
BPF tests in BPF development so these requirements are unlikely to be
relaxed in the immediate future.

There is already support for skipping targets so in order to reduce the
barrier to entry for people interested in kselftest as a whole let's use
that to skip the BPF tests by default when people work with the top
level kselftest build system.  Users can still build the BPF selftests
as part of the wider kselftest build by specifying SKIP_TARGETS,
including setting an empty SKIP_TARGETS to build everything.  They can
also continue to build the BPF selftests individually in cases where
they are specifically focused on BPF.

This isn't ideal since it means people will need to take special steps
to build the BPF tests but the dependencies mean that realistically this
is already the case to some extent and it makes it easier for people to
pick up and work with the other selftests which is hopefully a net win.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index afbab4aeef3c..8a917cb4426a 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -77,8 +77,10 @@ TARGETS += zram
 TARGETS_HOTPLUG = cpu-hotplug
 TARGETS_HOTPLUG += memory-hotplug
 
-# User can optionally provide a TARGETS skiplist.
-SKIP_TARGETS ?=
+# User can optionally provide a TARGETS skiplist.  By default we skip
+# BPF since it has cutting edge build time dependencies which require
+# more effort to install.
+SKIP_TARGETS ?= bpf
 ifneq ($(SKIP_TARGETS),)
 	TMP := $(filter-out $(SKIP_TARGETS), $(TARGETS))
 	override TARGETS := $(TMP)
-- 
2.20.1

