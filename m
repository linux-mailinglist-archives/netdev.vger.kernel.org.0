Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C901D3BBCF9
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 14:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhGEMqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 08:46:01 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49515 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230247AbhGEMqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 08:46:00 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F9A25C00F9;
        Mon,  5 Jul 2021 08:43:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 05 Jul 2021 08:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AlpY3EVeFaaGGaHMg
        uyLzl1R1b77+miegqGsG3nafAs=; b=Qm18D2fSvVp9kFpRGwlIB+8JAgBxzKa24
        WJMbjdllsTwpkfyZb2KZgUHbZOasDNHdQh32vDpoGlYrMftApe+hBviWpv1CcNRM
        zr7J+8qkS9XqV94FUwWylGX5/ct9JG/JokPzEhyXCJTtMkCbrSCjfUyPNlmh/97l
        2UMgY1BVFSKRomf6RJmYUC8r9pyWtvYvl3Ntsy+HmOAqJsHNH3s2GNElr0MZZynK
        EjOMTvB4kkIAxzc7k18z0b4CbOvrunVM5DLryyXX1k6i3xS9GVyGaBVNAtmD0N7l
        htaR2d5ejNKB2W6kRa7ThWvhAKGdTh897hp67P4+fip+GsJ5ms+IA==
X-ME-Sender: <xms:av7iYMB62o2hPqcqzfhLd4CIG1wmMJwNKnUQVPueEOK_6CnJXGYBZg>
    <xme:av7iYOjfRKGh1hAK7wR6c9mSz72PctbpcQdbV-mJygpCgM1wanq5e-hIxBLxTqgZ3
    RtVV6zhnL9VD7MEqMM>
X-ME-Received: <xmr:av7iYPkdvhyeMwVoY4GoJaiVQi__DLTiI_2g14VgZ6r83YA59sUi_nFw9rvV-1e4fYFnJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejgedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepofgrrhhthihnrghsucfruhhmphhuthhishcuoehmsehlrghmsggu
    rgdrlhhtqeenucggtffrrghtthgvrhhnpeeuhfefvdehleeiudehvdeviefftdelheeiud
    euheejjedtkeduvddtffehueeljeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehmsehlrghmsggurgdrlhht
X-ME-Proxy: <xmx:av7iYCzlT-Cll3lZRZsFpB3r7gFEYzVlpEJX0tUVoTj9hzY7QnjQzQ>
    <xmx:av7iYBTgvfJV8a7aG03ir8mU2v5sWNy-ATfXHGqFxGJe2JS_fTpq2g>
    <xmx:av7iYNb8gF0k6xdHiw-IBVAmfyQJbwb3Pv51QaeT39_2V5iCDrAxew>
    <xmx:a_7iYMdbVcSR0wwuDg82WvTn4Tgy0NqepuKr01DZJXIYmlfzcklDPw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jul 2021 08:43:21 -0400 (EDT)
From:   Martynas Pumputis <m@lambda.lt>
To:     netdev@vger.kernel.org
Cc:     haliu@redhat.com, stephen@networkplumber.org, dsahern@gmail.com,
        m@lambda.lt
Subject: [PATCH iproute2] libbpf: fix attach of prog with multiple sections
Date:   Mon,  5 Jul 2021 14:43:07 +0200
Message-Id: <20210705124307.201303-1-m@lambda.lt>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When BPF programs which consists of multiple executable sections via
iproute2+libbpf (configured with LIBBPF_FORCE=on), we noticed that a
wrong section can be attached to a device. E.g.:

    # tc qdisc replace dev lxc_health clsact
    # tc filter replace dev lxc_health ingress prio 1 \
        handle 1 bpf da obj bpf_lxc.o sec from-container
    # tc filter show dev lxc_health ingress filter protocol all
        pref 1 bpf chain 0 filter protocol all pref 1 bpf chain 0
        handle 0x1 bpf_lxc.o:[__send_drop_notify] <-- WRONG SECTION
        direct-action not_in_hw id 38 tag 7d891814eda6809e jited

After taking a closer look into load_bpf_object() in lib/bpf_libbpf.c,
we noticed that the filter used in the program iterator does not check
whether a program section name matches a requested section name
(cfg->section). This can lead to a wrong prog FD being used to attach
the program.

Fixes: 6d61a2b55799 ("lib: add libbpf support")
Signed-off-by: Martynas Pumputis <m@lambda.lt>
---
 lib/bpf_libbpf.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index d05737a4..f76b90d2 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 	}
 
 	bpf_object__for_each_program(p, obj) {
+		bool prog_to_attach = !prog && cfg->section &&
+			!strcmp(get_bpf_program__section_name(p), cfg->section);
+
 		/* Only load the programs that will either be subsequently
 		 * attached or inserted into a tail call map */
-		if (find_legacy_tail_calls(p, obj) < 0 && cfg->section &&
-		    strcmp(get_bpf_program__section_name(p), cfg->section)) {
+		if (find_legacy_tail_calls(p, obj) < 0 && !prog_to_attach) {
 			ret = bpf_program__set_autoload(p, false);
 			if (ret)
 				return -EINVAL;
@@ -279,7 +281,8 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 
 		bpf_program__set_type(p, cfg->type);
 		bpf_program__set_ifindex(p, cfg->ifindex);
-		if (!prog)
+
+		if (prog_to_attach)
 			prog = p;
 	}
 
-- 
2.32.0

