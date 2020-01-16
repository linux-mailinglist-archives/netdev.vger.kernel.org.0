Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4217913E569
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391045AbgAPROh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:14:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391036AbgAPROh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:14:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 588912469D;
        Thu, 16 Jan 2020 17:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194876;
        bh=TbGXhwCyiiSgzBOyD8VskMJHmRt2e+werhnVDQj3bmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLR3WgDlUvBp8AxdEfOT9XiKpcDyUVbdqDK3h6YMYOrH26Ngka2R/o52dWuI/wh35
         HjxGCe9eLSWqu3d1NN8CcR/H+feSWIDc8BmeAtEQ/pwcHjt5xjOg2ZzBO8MI4QfPP8
         oqdEr450/zlvBP9ZjC2FW1CmX/Pj3qUGKIqRaA7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 666/671] samples/bpf: Fix broken xdp_rxq_info due to map order assumptions
Date:   Thu, 16 Jan 2020 12:05:04 -0500
Message-Id: <20200116170509.12787-403-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit edbca120a8cdfa5a5793707e33497aa5185875ca ]

In the days of using bpf_load.c the order in which the 'maps' sections
were defines in BPF side (*_kern.c) file, were used by userspace side
to identify the map via using the map order as an index. In effect the
order-index is created based on the order the maps sections are stored
in the ELF-object file, by the LLVM compiler.

This have also carried over in libbpf via API bpf_map__next(NULL, obj)
to extract maps in the order libbpf parsed the ELF-object file.

When BTF based maps were introduced a new section type ".maps" were
created. I found that the LLVM compiler doesn't create the ".maps"
sections in the order they are defined in the C-file. The order in the
ELF file is based on the order the map pointer is referenced in the code.

This combination of changes lead to xdp_rxq_info mixing up the map
file-descriptors in userspace, resulting in very broken behaviour, but
without warning the user.

This patch fix issue by instead using bpf_object__find_map_by_name()
to find maps via their names. (Note, this is the ELF name, which can
be longer than the name the kernel retains).

Fixes: be5bca44aa6b ("samples: bpf: convert some XDP samples from bpf_load to libbpf")
Fixes: 451d1dc886b5 ("samples: bpf: update map definition to new syntax BTF-defined map")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/157529025128.29832.5953245340679936909.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_rxq_info_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index ef26f882f92f..a55c81301c1a 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -472,9 +472,9 @@ int main(int argc, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return EXIT_FAIL;
 
-	map = bpf_map__next(NULL, obj);
-	stats_global_map = bpf_map__next(map, obj);
-	rx_queue_index_map = bpf_map__next(stats_global_map, obj);
+	map =  bpf_object__find_map_by_name(obj, "config_map");
+	stats_global_map = bpf_object__find_map_by_name(obj, "stats_global_map");
+	rx_queue_index_map = bpf_object__find_map_by_name(obj, "rx_queue_index_map");
 	if (!map || !stats_global_map || !rx_queue_index_map) {
 		printf("finding a map in obj file failed\n");
 		return EXIT_FAIL;
-- 
2.20.1

