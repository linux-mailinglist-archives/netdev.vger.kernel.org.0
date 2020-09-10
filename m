Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD48264405
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgIJK1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730989AbgIJK1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 06:27:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9297AC061786
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 03:27:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so6110868wrt.3
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 03:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qCkbdaUxcOLV6qU6kxWcLZk/XxFKvurYHi1esL6nT4Q=;
        b=X8439DK5LD0Um4SHGnfZ9NrT6nkk5Qo65cMJes1Zcouo8W6mXfM/Ct5nKnxRB3xdtl
         NGMQcFybJwlQYduWlGhU4RxtTWUBtrTfNf8d//dxBc8HyaE/2R52QXwxHabbKs+fxmyK
         EAQyTnpPGC2UpXRaXciqbmVdtC0WQ62PYSFz9XxClCJsFzAwa8E1rUf+PENtDeUCie45
         FwLQlzYvTULrMAxbP4f3tCbK9YZDMXEJsy/dDdzTxCTuWP8O+z2YfiHdNhkLWNrLhyz3
         3di6HhpmKjozMu/DfSRZOJoL+z37H9U5GtITeLtmekFbRGH7U8PtA67NiYexQycWx8sl
         lWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qCkbdaUxcOLV6qU6kxWcLZk/XxFKvurYHi1esL6nT4Q=;
        b=iVKesNOJWmXNkOOUL6iFKf5RGxsDP8zQhXophmcQ9nAUnuxM8zGm32m+Osf6R61eXm
         vVze3JXMkfL/VsbHSeO4YiwlawiHtJcgk4VNfMeeI2swSDc0emNBhbtScP9zRJxHvJMZ
         BALu8vvThFW4mpMfsjCgAwBr9NdHaL8m2pq8h3m81qSa4FXkO8BGuI1aqwRsOEbg+VNV
         TO9hJYF5WEGsB06r5lri9kLLH/bI5UogDwqDxR/cBLCKLj7aJdGuRvG3g0uerKj2bV7b
         MSyyuh7v/0BFY9nGWrrd3ulghKHzmSqoCAQ6pPyEWPavM0XG2+Bkii9IaG8J6J8ycoyq
         2dhg==
X-Gm-Message-State: AOAM531TPKaHABhAg22FzLNatWLLR3R/BwoWgzvkl+QynBMY1zhXBgrX
        XYPrOPogcLw+cWfHRKGNDVU5ww==
X-Google-Smtp-Source: ABdhPJz4o34D4wwA7tquDWANd0D5MgxjXdf4OwgfcgkNG+xvHrjOF1WEDaWMzvrW8AP53Tu1Zoup7Q==
X-Received: by 2002:adf:f3c4:: with SMTP id g4mr8468020wrp.168.1599733624322;
        Thu, 10 Sep 2020 03:27:04 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.178])
        by smtp.gmail.com with ESMTPSA id h186sm3039494wmf.24.2020.09.10.03.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 03:27:03 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 2/3] tools: bpftool: keep errors for map-of-map dumps if distinct from ENOENT
Date:   Thu, 10 Sep 2020 11:26:51 +0100
Message-Id: <20200910102652.10509-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200910102652.10509-1-quentin@isovalent.com>
References: <20200910102652.10509-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dumping outer maps or prog_array maps, and on lookup failure,
bpftool simply skips the entry with no error message. This is because
the kernel returns non-zero when no value is found for the provided key,
which frequently happen for those maps if they have not been filled.

When such a case occurs, errno is set to ENOENT. It seems unlikely we
could receive other error codes at this stage (we successfully retrieved
map info just before), but to be on the safe side, let's skip the entry
only if errno was ENOENT, and not for the other errors.

v3: New patch

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c8159cb4fb1e..d8581d5e98a1 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -240,8 +240,8 @@ print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
 	 * means there is no entry for that key. Do not print an error message
 	 * in that case.
 	 */
-	if (map_is_map_of_maps(map_info->type) ||
-	    map_is_map_of_progs(map_info->type))
+	if ((map_is_map_of_maps(map_info->type) ||
+	     map_is_map_of_progs(map_info->type)) && lookup_errno == ENOENT)
 		return;
 
 	if (json_output) {
-- 
2.25.1

