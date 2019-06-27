Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1912D5787F
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfF0AcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfF0AcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:15 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64111216E3;
        Thu, 27 Jun 2019 00:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595534;
        bh=wjEIhQKHUhQNrYqK3cZWtemh2Vz/gHxG6Psmdl6mB1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKxcJI3c3ZFwFX6Fm1GC88L2CKr8X+Q124E+stRHFgGsTal0ZUwBMu1yY4Rbxxfoh
         +RqHMmmtCZ4xglKju0gmSd87tifKTJEysBqnUfrzt2zY7sfs4vr2WzSSjNnmeZ02xd
         obIC5sqfgp+EzSSwdm9o/Xww1xSy0Wt+Ewj4yvx4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzesimir Nowak <krzesimir@kinvolk.io>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 33/95] tools: bpftool: Fix JSON output when lookup fails
Date:   Wed, 26 Jun 2019 20:29:18 -0400
Message-Id: <20190627003021.19867-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzesimir Nowak <krzesimir@kinvolk.io>

[ Upstream commit 1884c066579a7a274dd981a4d9639ca63db66a23 ]

In commit 9a5ab8bf1d6d ("tools: bpftool: turn err() and info() macros
into functions") one case of error reporting was special cased, so it
could report a lookup error for a specific key when dumping the map
element. What the code forgot to do is to wrap the key and value keys
into a JSON object, so an example output of pretty JSON dump of a
sockhash map (which does not support looking up its values) is:

[
    "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x00"
    ],
    "value": {
        "error": "Operation not supported"
    },
    "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x01"
    ],
    "value": {
        "error": "Operation not supported"
    }
]

Note the key-value pairs inside the toplevel array. They should be
wrapped inside a JSON object, otherwise it is an invalid JSON. This
commit fixes this, so the output now is:

[{
        "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x00"
        ],
        "value": {
            "error": "Operation not supported"
        }
    },{
        "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x01"
        ],
        "value": {
            "error": "Operation not supported"
        }
    }
]

Fixes: 9a5ab8bf1d6d ("tools: bpftool: turn err() and info() macros into functions")
Cc: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 994a7e0d16fb..14f581b562bd 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -713,12 +713,14 @@ static int dump_map_elem(int fd, void *key, void *value,
 		return 0;
 
 	if (json_output) {
+		jsonw_start_object(json_wtr);
 		jsonw_name(json_wtr, "key");
 		print_hex_data_json(key, map_info->key_size);
 		jsonw_name(json_wtr, "value");
 		jsonw_start_object(json_wtr);
 		jsonw_string_field(json_wtr, "error", strerror(lookup_errno));
 		jsonw_end_object(json_wtr);
+		jsonw_end_object(json_wtr);
 	} else {
 		if (errno == ENOENT)
 			print_entry_plain(map_info, key, NULL);
-- 
2.20.1

