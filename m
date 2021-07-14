Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D03C85E1
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239487AbhGNOSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 10:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239449AbhGNOSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 10:18:44 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEAEC061762
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 07:15:52 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id y21-20020a7bc1950000b02902161fccabf1so4020876wmi.2
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 07:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mUCBpk5CyiIy6Bvb2NbvqDJflK7m0z2f3UFX/XqbowU=;
        b=RAYn8/FyE0vDqn1+um4/dz8OvsCxr3xK8V0y/cH7AFK8aH+gE18yp3X0EcDEfpSPoc
         KTky/k9y28lPJmzcxhzKgAi8aJUsdbOLvGAVl6MnEMEB1Btovt0aGlKZYMQBXsQHVG2g
         Q/zTCmD1iytWlKFNoCsm0zOzBxqDLR88Z0uZJmWdxCMK+DujzcTCA566SpjqTBHxUqsI
         cKHXwn97FRXHi7+T4zBYII3biel0jV0TizP04thyvHsHeGWuctfdMr5pCJOdWamJgwn1
         wntfJYFam8/DLeKRtRtpk94h3nbCDC9ehAQvzAB3RctJBt/znjQPu3nKlErKEi7mvDq7
         4cFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mUCBpk5CyiIy6Bvb2NbvqDJflK7m0z2f3UFX/XqbowU=;
        b=F0dKDRUHyp01cGjVz3sVq+MTn1ZTzVahG4DhyDUG5U3a/ktW/KOCo72Ksl22HQpyBB
         GaCtHkmhdBOzZbAfZwuXLpGWWM3WqfGexjIV0n6JGVuCq7+4YnnmS/xW1H1DvjhE5oLS
         RR2DGQAYpVwAo39Nn9S+fsjvGTNwukunIgUYWgsdjp2jPHjp6XQlPWN0F8QMrjSfzmZN
         1CiU6ETjspd6eLYy5cL70y+OlUuIxiJdJu4e/yrA1etEWggcBVwY7K9PMjEsnrhol2P3
         4Lc+rZToVOpIsqinWgyLaf2X53bKBD/oaMv1NhQlZ+sl7eSOTj4/lD2Tt+rm2hj2w3A4
         Jm3Q==
X-Gm-Message-State: AOAM531kMPcxhGzvBCcgJMPRPvD0FHl4/wB7EulwdifNaTwwsvTqj4aS
        A0b8O7RkOiEEw4FpPsYskpruCqoJNMisEA==
X-Google-Smtp-Source: ABdhPJyj3j4nBjWxbdPwSLusLHVQgftz8JotKj/8bOPJqJh0mVBKnenv5b0+bmlA5F65Nne5T1f5vA==
X-Received: by 2002:a7b:c147:: with SMTP id z7mr2175067wmi.110.1626272151231;
        Wed, 14 Jul 2021 07:15:51 -0700 (PDT)
Received: from localhost.localdomain ([149.86.90.174])
        by smtp.gmail.com with ESMTPSA id a207sm6380037wme.27.2021.07.14.07.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 07:15:50 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 6/6] tools: bpftool: support dumping split BTF by id
Date:   Wed, 14 Jul 2021 15:15:32 +0100
Message-Id: <20210714141532.28526-7-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210714141532.28526-1-quentin@isovalent.com>
References: <20210714141532.28526-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split BTF objects are typically BTF objects for kernel modules, which
are incrementally built on top of kernel BTF instead of redefining all
kernel symbols they need. We can use bpftool with its -B command-line
option to dump split BTF objects. It works well when the handle provided
for the BTF object to dump is a "path" to the BTF object, typically
under /sys/kernel/btf, because bpftool internally calls
btf__parse_split() which can take a "base_btf" pointer and resolve the
BTF reconstruction (although in that case, the "-B" option is
unnecessary because bpftool performs autodetection).

However, it did not work so far when passing the BTF object through its
id, because bpftool would call btf__get_from_id() which did not provide
a way to pass a "base_btf" pointer.

In other words, the following works:

    # bpftool btf dump file /sys/kernel/btf/i2c_smbus -B /sys/kernel/btf/vmlinux

But this was not possible:

    # bpftool btf dump id 6 -B /sys/kernel/btf/vmlinux

The libbpf API has recently changed, and btf__get_from_id() has been
deprecated in favour of btf__load_from_kernel_by_id() and its version
with support for split BTF, btf__load_from_kernel_by_id_split(). Let's
update bpftool to make it able to dump the BTF object in the second case
as well.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 2296e8eba0ff..b77a59225f5b 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -580,7 +580,7 @@ static int do_dump(int argc, char **argv)
 	}
 
 	if (!btf) {
-		err = btf__load_from_kernel_by_id(btf_id, &btf);
+		err = btf__load_from_kernel_by_id_split(btf_id, &btf, base_btf);
 		if (err) {
 			p_err("get btf by id (%u): %s", btf_id, strerror(err));
 			goto done;
-- 
2.30.2

