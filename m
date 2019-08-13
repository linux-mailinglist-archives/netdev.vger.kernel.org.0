Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6436F8B994
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfHMNJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:09:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56275 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbfHMNJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 09:09:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id f72so1453854wmf.5
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 06:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jwSUSEZgz5QveQuauT2jx1+QbRo0U2C9co9dcGbvAiA=;
        b=eicD9E5jysBbCK9zfKC3ab5eWoNN/w4uDiEs4Xntnv5Pi8S3uFoq8JxCWX/PbHn11x
         SQVSaO8KFwWb8JoojYneeFmALd5rOozBIlnf5OX9paDnL3Ua9Qa/B5vdPEvsnbrmMoSu
         lQuB0hDLQjjpROtG+BC0vswWYzfJHW4P9xtRd93x5a2Pef2/qWzNxuTlvr47D6aBesjQ
         IbBz7xDQ4Q0N0XP+Kpm6PsIfE0LmJVL0Zt9i3AJRwJqNjT1O1WrCL0uSkgZ5AC/fMLnf
         NwSb13k+WRHxcWUWwi5CJQbmWiqlaCnH1OKqPqfvCFdciUG5fBEl5C8GkIu0J4dUK69o
         Ab8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jwSUSEZgz5QveQuauT2jx1+QbRo0U2C9co9dcGbvAiA=;
        b=Q6Ntx7Xafs7ZWceVzWDF52q7CYtoE64IQ3uWLOKIJ5+QZjeVhSRNmq+NT7nhR/jVcr
         URjruGDRWdB0/SZEqvkf7ktg3crWnGClwMnOhBi+S5Eio4HLub7o7+7tUN/7NI/BiBme
         kUJHuUIKjKTE0Mcypv19tf6RY7YCpj9okj78HlfMNuGZ1L9vN1I63QBLEqHnCht65iye
         iRE5VQ4OB0J8l6DYsASz4Zr5UgoOKmjlJ3woKDhzTENyHM0CMAWPY1gJ1Wh5Oofq1N/V
         FN1DVmsWg2vUdJltqAemWDyGB+wnkIzaBO2Xq4Mu4G8wBVLS4x7XSIc6btyAAuVbeO2Y
         gAgA==
X-Gm-Message-State: APjAAAVBbnDuH2m3Wzz5CXj9JLIuLK7xsgMq7Iy76tIWEIm69k7XrKUr
        Nh32qSQCpkP1r+n/kaae7o5+gQ==
X-Google-Smtp-Source: APXvYqzQDPXOOf07TR4BQXYp3MxwPCeDBruQaLzxBoGWRWeHQqs/G821Aiuw12ZZ6Esz2SNPaix6ZQ==
X-Received: by 2002:a1c:27c1:: with SMTP id n184mr2842664wmn.61.1565701777656;
        Tue, 13 Aug 2019 06:09:37 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id e3sm130534191wrs.37.2019.08.13.06.09.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:09:36 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [RFC bpf-next 1/3] tools: bpftool: clean up dump_map_elem() return value
Date:   Tue, 13 Aug 2019 14:09:19 +0100
Message-Id: <20190813130921.10704-2-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813130921.10704-1-quentin.monnet@netronome.com>
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code for dumping a map entry (as part of a full map dump) was moved
to a specific function dump_map_elem() in commit 18a781daa93e
("tools/bpf: bpftool, split the function do_dump()"). The "num_elems"
variable was moved in that function, incremented on success, and
returned to be immediately added to the counter in do_dump().

Returning the count of elements dumped, which is either 0 or 1, is not
really consistent with the rest of the function, especially because
"dump_map_elem()" name is not explicit about returning a counter.
Furthermore, the counter is not incremented when the entry is dumped in
JSON. This has no visible effect, because the number of elements
successfully dumped is not printed for JSON output.

Still, let's remove "num_elems" from the function and make it return 0
or -1 in case of success or failure, respectively. This is more correct,
and more consistent with the rest of the code.

It is unclear if an error value should indeed be returned for maps of
maps or maps of progs, but this has no effect on the output either, so
we just leave the current behaviour unchanged.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/map.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index bfbbc6b4cb83..206ee46189d9 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -686,7 +686,6 @@ static int dump_map_elem(int fd, void *key, void *value,
 			 struct bpf_map_info *map_info, struct btf *btf,
 			 json_writer_t *btf_wtr)
 {
-	int num_elems = 0;
 	int lookup_errno;
 
 	if (!bpf_map_lookup_elem(fd, key, value)) {
@@ -704,9 +703,8 @@ static int dump_map_elem(int fd, void *key, void *value,
 			} else {
 				print_entry_plain(map_info, key, value);
 			}
-			num_elems++;
 		}
-		return num_elems;
+		return 0;
 	}
 
 	/* lookup error handling */
@@ -714,7 +712,7 @@ static int dump_map_elem(int fd, void *key, void *value,
 
 	if (map_is_map_of_maps(map_info->type) ||
 	    map_is_map_of_progs(map_info->type))
-		return 0;
+		return -1;
 
 	if (json_output) {
 		jsonw_start_object(json_wtr);
@@ -738,7 +736,7 @@ static int dump_map_elem(int fd, void *key, void *value,
 				  msg ? : strerror(lookup_errno));
 	}
 
-	return 0;
+	return -1;
 }
 
 static int do_dump(int argc, char **argv)
@@ -800,7 +798,8 @@ static int do_dump(int argc, char **argv)
 				err = 0;
 			break;
 		}
-		num_elems += dump_map_elem(fd, key, value, &info, btf, btf_wtr);
+		if (!dump_map_elem(fd, key, value, &info, btf, btf_wtr))
+			num_elems++;
 		prev_key = key;
 	}
 
-- 
2.17.1

