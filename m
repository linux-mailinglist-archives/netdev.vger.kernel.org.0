Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19703271277
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 07:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgITFCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 01:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITFCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 01:02:02 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5933C061755;
        Sat, 19 Sep 2020 22:02:02 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q4so5443879pjh.5;
        Sat, 19 Sep 2020 22:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0E0b+X1jkrlTu6z8mSI8a6HrAt56K4WH6UtjHG85cYo=;
        b=fcqW9OSaVGejCbM4BwKgGBI6hnrFhTfw0oJtj/Fibd0cjyNYPeFLbu3PUU3C08UgW6
         igmQtLTejOw+tQkiI7yQzLx8ZqhXcmddLXi1O4FBZmUjKPWyE/bbHYLsP38W4o8k7waw
         nwajJGJ5PtUOYopz9XCvQIDUVaHRoGpkpsIHd7P3EtYnYhmWhHubTHslhhj5RLc5dv7l
         LZuYLoXcw2/Na2aTarnclHSCRF05eXSX6iaYdS3Lv68L3/k/3n4/sdtdMYW+1V0KsO3U
         G10gRDvleW0S7anBOLvBhItFXbkr0DamhKBIw2jAEjPR6pZrcRT1BCoYKnKMpBFEkcQd
         mqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0E0b+X1jkrlTu6z8mSI8a6HrAt56K4WH6UtjHG85cYo=;
        b=UOIPlIsdVpMQ/vm0PepHSC0araZQh2QtERCDkC+GXw5MiabdkDTh/ak4CfkMjP5oW3
         hI1qCJr0TYgnfnTqUqbSELKObBMA8ixDVK7gblgESkgg5emPCK7EX8jhppMTAc/2jJQ9
         FT90fw3uvJwdBrApMuet+2Pkv9kS8MDQPDXLxI0RcUfnRnr8aNrjZ7NPkSovSzl3EVHz
         ffcCZ2/33BSdvq5fODw6yzOwsmf9bIdWBXVPPtEwva3NwWHu3BlwieU2qN6DTeFm+3GT
         HkcvvGcejaNlgahY/KIJAWVDgnKbciqmkPJ/meXvFLVcohaXqf9KVz7au0NVgboVEtE+
         9IhA==
X-Gm-Message-State: AOAM533AoD6CP0hbtkFZdemHHKoyvHqdsrm5OBmyqrCQgksJxCHiY3UV
        fHKgjeD59nK8bjfiNpqosVDs1jMSODo6Ng38
X-Google-Smtp-Source: ABdhPJySyOgkQf0gYlRuUe5x87i7ZKU+PAmGWdVK0QLgKwbERmRE8AdcSPaYf3dNBQVV4nb1p/wS2A==
X-Received: by 2002:a17:90b:889:: with SMTP id bj9mr19264070pjb.73.1600578122382;
        Sat, 19 Sep 2020 22:02:02 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:d88d:3b4f:9cac:cf18])
        by smtp.gmail.com with ESMTPSA id w19sm8432556pfq.60.2020.09.19.22.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 22:02:01 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH bpf v1 1/3] bpf: fix sysfs export of empty BTF section
Date:   Sat, 19 Sep 2020 22:01:33 -0700
Message-Id: <b38db205a66238f70823039a8c531535864eaac5.1600417359.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1600417359.git.Tony.Ambardar@gmail.com>
References: <cover.1600417359.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If BTF data is missing or removed from the ELF section it is still exported
via sysfs as a zero-length file:

  root@OpenWrt:/# ls -l /sys/kernel/btf/vmlinux
  -r--r--r--    1 root    root    0 Jul 18 02:59 /sys/kernel/btf/vmlinux

Moreover, reads from this file succeed and leak kernel data:

  root@OpenWrt:/# hexdump -C /sys/kernel/btf/vmlinux|head -10
  000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
  *
  000cc0 00 00 00 00 00 00 00 00 00 00 00 00 80 83 b0 80 |................|
  000cd0 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
  000ce0 00 00 00 00 00 00 00 00 00 00 00 00 57 ac 6e 9d |............W.n.|
  000cf0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
  *
  002650 00 00 00 00 00 00 00 10 00 00 00 01 00 00 00 01 |................|
  002660 80 82 9a c4 80 85 97 80 81 a9 51 68 00 00 00 02 |..........Qh....|
  002670 80 25 44 dc 80 85 97 80 81 a9 50 24 81 ab c4 60 |.%D.......P$...`|

This situation was first observed with kernel 5.4.x, cross-compiled for a
MIPS target system. Fix by adding a sanity-check for export of zero-length
data sections.

Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 kernel/bpf/sysfs_btf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
index 3b495773de5a..11b3380887fa 100644
--- a/kernel/bpf/sysfs_btf.c
+++ b/kernel/bpf/sysfs_btf.c
@@ -30,15 +30,15 @@ static struct kobject *btf_kobj;
 
 static int __init btf_vmlinux_init(void)
 {
-	if (!__start_BTF)
+	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
+
+	if (!__start_BTF || bin_attr_btf_vmlinux.size == 0)
 		return 0;
 
 	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
 	if (!btf_kobj)
 		return -ENOMEM;
 
-	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
-
 	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
 }
 
-- 
2.25.1

