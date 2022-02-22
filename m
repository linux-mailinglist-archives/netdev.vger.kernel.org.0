Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E534F4C035B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 21:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiBVUvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 15:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiBVUvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 15:51:46 -0500
X-Greylist: delayed 512 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Feb 2022 12:51:16 PST
Received: from mail.tintel.eu (mail.tintel.eu [51.83.127.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48E2A9A5D;
        Tue, 22 Feb 2022 12:51:16 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 1E8714474A4B;
        Tue, 22 Feb 2022 21:42:38 +0100 (CET)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id BM6b5kB9oOfL; Tue, 22 Feb 2022 21:42:37 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 8DBF242A43DF;
        Tue, 22 Feb 2022 21:42:37 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu 8DBF242A43DF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1645562557;
        bh=pYviirxjEDGerTDDcjS7GbGKZkzZlGlIYio/BGWknF4=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=frvh2zYWczA9n39TRhcHcFP9YQnZG56XYXkJnz/d06YV+sTTTmuyGxxycfTe8qzeW
         0HSVMSz9RZh7kFkCfsOKupV97fDuvSNwRatmbkCBJHj4e6USTL0EQupP5vZJ617E8W
         x378qFJLE14BkAYuY3pgoYaH9DuZ4706lWWVuSzA=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id AcB_YAI3-8Gp; Tue, 22 Feb 2022 21:42:37 +0100 (CET)
Received: from taz.sof.bg.adlevio.net (unknown [IPv6:2001:67c:21bc:20::10])
        by mail.tintel.eu (Postfix) with ESMTPS id 3B38A4474A4B;
        Tue, 22 Feb 2022 21:42:37 +0100 (CET)
From:   Stijn Tintel <stijn@linux-ipv6.be>
To:     toke@redhat.com, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        kpsingh@kernel.org, john.fastabend@gmail.com, yhs@fb.com,
        songliubraving@fb.com, kafai@fb.com, andrii@kernel.org,
        daniel@iogearbox.net, ast@kernel.org
Subject: [PATCH] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
Date:   Tue, 22 Feb 2022 22:42:36 +0200
Message-Id: <20220222204236.2192513-1-stijn@linux-ipv6.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: IP_WHITELIST
X-Rspamd-Queue-Id: 3B38A4474A4B
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: IP_WHITELIST
X-Spamd-Result: default: False [0.00 / 15.00];
        TAGGED_RCPT(0.00)[];
        ASN(0.00)[asn:200533, ipnet:2001:67c:21bc::/48, country:BG];
        IP_WHITELIST(0.00)[2001:67c:21bc:20::10]
X-Rspamd-Server: skulls
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
max_entries parameter set, this parameter will be set to the number of
possible CPUs. Due to this, the map_is_reuse_compat function will return
false, causing the following error when trying to reuse the map:

libbpf: couldn't reuse pinned map at '/sys/fs/bpf/m_logging': parameter m=
ismatch

Fix this by checking against the number of possible CPUs if the
max_entries parameter is not set in the map definition.

Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF o=
bjects")
Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
---
 tools/lib/bpf/libbpf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7f10dd501a52..b076ab728f0e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4750,7 +4750,7 @@ static bool map_is_reuse_compat(const struct bpf_ma=
p *map, int map_fd)
 	struct bpf_map_info map_info =3D {};
 	char msg[STRERR_BUFSIZE];
 	__u32 map_info_len;
-	int err;
+	int def_max_entries, err;
=20
 	map_info_len =3D sizeof(map_info);
=20
@@ -4763,10 +4763,15 @@ static bool map_is_reuse_compat(const struct bpf_=
map *map, int map_fd)
 		return false;
 	}
=20
+	if (map->def.type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY && !map->def.max=
_entries)
+		def_max_entries =3D libbpf_num_possible_cpus();
+	else
+		def_max_entries =3D map->def.max_entries;
+
 	return (map_info.type =3D=3D map->def.type &&
 		map_info.key_size =3D=3D map->def.key_size &&
 		map_info.value_size =3D=3D map->def.value_size &&
-		map_info.max_entries =3D=3D map->def.max_entries &&
+		map_info.max_entries =3D=3D def_max_entries &&
 		map_info.map_flags =3D=3D map->def.map_flags &&
 		map_info.map_extra =3D=3D map->map_extra);
 }
--=20
2.34.1

