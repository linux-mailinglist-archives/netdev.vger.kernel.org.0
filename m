Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC5D60C8B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 22:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfGEUoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 16:44:23 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37514 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEUoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 16:44:22 -0400
Received: by mail-ot1-f66.google.com with SMTP id s20so10246936otp.4;
        Fri, 05 Jul 2019 13:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mg6V3accc4yquag3sS74Nfk02reE/ilWyY4j7TW7Qg0=;
        b=hL5BRmpxXNftHaGBvTpkpAGtBH18XqM1xzZ2WpB6C8+JvqyesuqKQ/WePGG5BazPeA
         P42W2fJNi13hAgyLs4FVLojkNWwZrALMSx34FfoQ6zXTi05LTxhqOT+trfYktphsSv3Y
         5EG2mApbDbOjdjOHJPZQik3v03YH0Zvkfl7S6rgQZAeoF25xcpVu8MNXwhpWNcpyls1Z
         fERpDUqdN8TxoHZdl1WJ4Rd0OxGBOE5uIM1LXf/PV93gqz0L5X4td5rN2fdNc1yaQuiU
         IBTlOEQCKaIoxeoyHjSQ2Yd4YwwixNzcSGWsIz4gXhT/l60SR/OEnkjudtWE38lS+iav
         uiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mg6V3accc4yquag3sS74Nfk02reE/ilWyY4j7TW7Qg0=;
        b=PgQQTFjCZ5/tuCQvH6IP61e/fhSFtQ6KIFIpLt1ScqjDyI2oA3ENmBxT4axnTzkpH7
         jrzTjjCog67XrK3fODuns9DiMYxWv9bj3/wlded5+CXEzeiZve8Hi724oI5x0ETFv0wN
         GI4RlLMTQ3GUUGJQNHy7OezhgBIkOw09QTF77tNxnnItw9bycpfF7lJIJYv5QC19il66
         GX+HoVrad/hd27Dibld7M0/wljG6PuyA4YeLGN2FyEV1+tEqSUmwraVV2SEmGAkeRfG9
         9tgv3KCsTnbAkj2oOHdt7koXBzh2RW44WQ1H/G42Z/grqRIBIafyKANDjJujB4JkyaTW
         H6Jg==
X-Gm-Message-State: APjAAAXtrq6fD1eTXuLoXFNHLDSQHi3W0EapPzIt1b2fVZAvD0Ae6T0M
        OgRjJkYS7EvIpVvWmU8xEzD+cs65Jv0=
X-Google-Smtp-Source: APXvYqx9mC50KZGqtnF574/1R1gf0ySU++scklDK1T04BhxhN3Q9Og6dm7EdUuSZNt+ulKNucoCf8g==
X-Received: by 2002:a9d:1712:: with SMTP id i18mr4290112ota.60.1562359461751;
        Fri, 05 Jul 2019 13:44:21 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:91ff:fe99:7fe5])
        by smtp.gmail.com with ESMTPSA id l5sm3397529otf.53.2019.07.05.13.44.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 13:44:21 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>
Subject: [PATCH bpf-next 2/2] bpf, libbpf: add an option to reuse existing maps in bpf_prog_load_xattr
Date:   Fri,  5 Jul 2019 20:44:13 +0000
Message-Id: <b21b243d9525c36fcd629f6856c6eb474c8a7183.1562359091.git.a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1562359091.git.a.s.protopopov@gmail.com>
References: <cover.1562359091.git.a.s.protopopov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new pinned_maps_path member to the bpf_prog_load_attr structure and
extend the bpf_prog_load_xattr() function to pass this pointer to the new
bpf_object__reuse_maps() helper. This change provides users with a simple
way to use existing pinned maps when (re)loading BPF programs.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 tools/lib/bpf/libbpf.c | 8 ++++++++
 tools/lib/bpf/libbpf.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 84c9e8f7bfd3..9daa09c9fe1a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3953,6 +3953,14 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 			first_prog = prog;
 	}
 
+	if (attr->pinned_maps_path) {
+		err = bpf_object__reuse_maps(obj, attr->pinned_maps_path);
+		if (err < 0) {
+			bpf_object__close(obj);
+			return err;
+		}
+	}
+
 	bpf_object__for_each_map(map, obj) {
 		if (!bpf_map__is_offload_neutral(map))
 			map->map_ifindex = attr->ifindex;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 7fe465a1be76..6bf405bb9c1f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -329,6 +329,7 @@ struct bpf_prog_load_attr {
 	int ifindex;
 	int log_level;
 	int prog_flags;
+	const char *pinned_maps_path;
 };
 
 LIBBPF_API int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
-- 
2.19.1

