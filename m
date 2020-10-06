Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B712843FC
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 04:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgJFCPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 22:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgJFCPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 22:15:14 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680C5C0613CE;
        Mon,  5 Oct 2020 19:15:14 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id j33so411852pgj.5;
        Mon, 05 Oct 2020 19:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F6uCDwHT15MZwocQuEWQL17rLGGSpUMgqsQxnevkueU=;
        b=FHD1cRk8WIrgJ7kDJOju7ENsyyax/WM/f6YFP2Dlo/5F/B+p8Nz6n8jifETv2Ar6AU
         gupBn1DxQDgIapkXq05fdGYrwTS8lyNcL7iRlPVU4HqjW4xUNx1cNtuLUs6jmZ737uI2
         Jr31Np+zRq9In1VZsXKP1Lx1KzAAhZnCaNmXGxQmKsO53mBZCHhQjKkVVP9tP8c8g+5P
         zsRoWMP+prKGfyXW76V0YN72RWwj63HLDyrm6s16X60yyR7sTdrE/aGOmQulKJrvfWag
         7IoqvW8aOL5Wl65wtVPYj3i38l+SuP5DoEkf/i75Isjio2w0m3pQDNZSM5yYifh6WfHJ
         dMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F6uCDwHT15MZwocQuEWQL17rLGGSpUMgqsQxnevkueU=;
        b=E6PV+8akRY5gJh2I/5vgNpdZIkQXAwlV2OjEiFlv+3jY1Dr79TQXaieQOhSY8RWiOy
         cKudQ7U+fsU89j7IRmEipjMcROEp/wPlTCWNujq/GG3ZfkF9dN/prhUDxh+Cu5+1sg5/
         UcUTUjDgW0cvisJD2pxhb3yHWnAALWxZaT3z0yyDZ0SGVkIyTt10Gef2VzR5VEZrilKO
         82BaHhWrEtB25G+qSCIPPiurqY7mo02z7RZYKS1ACUhXoOVWAt/ww40ghr0l2lV6Dwoa
         FDlPkWBsF4TelB+PcGmiYpbl+g9o6zBtQQuQyNu9iaS978W1ZtalJJaSBhLa6aETN5ms
         iJ9w==
X-Gm-Message-State: AOAM533LVYUKRKs/0frztuNbP1pTYalyhgDxcBW9TpDqv6kcg5aiCEYX
        NvT/P5v7p9TUFIgGxTQFPNAs5qw8tZpX2Q==
X-Google-Smtp-Source: ABdhPJxDmuKQEZqYhtFjfk3d2M0UhP6vvLOmUAkGI3imSZPfP5ASqahm+5nPrWRsjcjYEFf3qGx8bA==
X-Received: by 2002:a63:4c1d:: with SMTP id z29mr2112670pga.203.1601950513759;
        Mon, 05 Oct 2020 19:15:13 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1301594pfc.96.2020.10.05.19.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 19:15:13 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCHv3 bpf 2/3] libbpf: check if pin_path was set even map fd exist
Date:   Tue,  6 Oct 2020 10:13:44 +0800
Message-Id: <20201006021345.3817033-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201006021345.3817033-1-liuhangbin@gmail.com>
References: <20201003085505.3388332-1-liuhangbin@gmail.com>
 <20201006021345.3817033-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Say a user reuse map fd after creating a map manually and set the
pin_path, then load the object via libbpf.

In libbpf bpf_object__create_maps(), bpf_object__reuse_map() will
return 0 if there is no pinned map in map->pin_path. Then after
checking if map fd exist, we should also check if pin_path was set
and do bpf_map__pin() instead of continue the loop.

Fix it by creating map if fd not exist and continue checking pin_path
after that.

Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: no update
v2: keep if condition with existing order
---
 tools/lib/bpf/libbpf.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c8b5fe45682d..1fb3fd733b23 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4245,29 +4245,28 @@ bpf_object__create_maps(struct bpf_object *obj)
 		if (map->fd >= 0) {
 			pr_debug("map '%s': skipping creation (preset fd=%d)\n",
 				 map->name, map->fd);
-			continue;
-		}
-
-		err = bpf_object__create_map(obj, map);
-		if (err)
-			goto err_out;
+		} else {
+			err = bpf_object__create_map(obj, map);
+			if (err)
+				goto err_out;
 
-		pr_debug("map '%s': created successfully, fd=%d\n", map->name,
-			 map->fd);
+			pr_debug("map '%s': created successfully, fd=%d\n",
+				 map->name, map->fd);
 
-		if (bpf_map__is_internal(map)) {
-			err = bpf_object__populate_internal_map(obj, map);
-			if (err < 0) {
-				zclose(map->fd);
-				goto err_out;
+			if (bpf_map__is_internal(map)) {
+				err = bpf_object__populate_internal_map(obj, map);
+				if (err < 0) {
+					zclose(map->fd);
+					goto err_out;
+				}
 			}
-		}
 
-		if (map->init_slots_sz) {
-			err = init_map_slots(map);
-			if (err < 0) {
-				zclose(map->fd);
-				goto err_out;
+			if (map->init_slots_sz) {
+				err = init_map_slots(map);
+				if (err < 0) {
+					zclose(map->fd);
+					goto err_out;
+				}
 			}
 		}
 
-- 
2.25.4

