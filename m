Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4602346535B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 17:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244011AbhLAQxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 11:53:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:26944 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242868AbhLAQxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 11:53:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="216513901"
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="216513901"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 08:50:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="677324335"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 01 Dec 2021 08:49:55 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B1GnsGV021198;
        Wed, 1 Dec 2021 16:49:54 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] samples: bpf: fix conflicting types in fds_example
Date:   Wed,  1 Dec 2021 17:49:31 +0100
Message-Id: <20211201164931.47357-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following samples/bpf build error appeared after the
introduction of bpf_map_create() in libbpf:

  CC  samples/bpf/fds_example.o
samples/bpf/fds_example.c:49:12: error: static declaration of 'bpf_map_create' follows non-static declaration
static int bpf_map_create(void)
           ^
samples/bpf/libbpf/include/bpf/bpf.h:55:16: note: previous declaration is here
LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
               ^
samples/bpf/fds_example.c:82:23: error: too few arguments to function call, expected 6, have 0
                fd = bpf_map_create();
                     ~~~~~~~~~~~~~~ ^
samples/bpf/libbpf/include/bpf/bpf.h:55:16: note: 'bpf_map_create' declared here
LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
               ^
2 errors generated.

fds_example by accident has a static function with the same name.
It's not worth it to separate a single call into its own function,
so just embed it.

Fixes: 992c4225419a ("libbpf: Unify low-level map creation APIs w/ new bpf_map_create()")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 samples/bpf/fds_example.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/samples/bpf/fds_example.c b/samples/bpf/fds_example.c
index 59f45fef5110..9a7c1fd7a4a8 100644
--- a/samples/bpf/fds_example.c
+++ b/samples/bpf/fds_example.c
@@ -46,12 +46,6 @@ static void usage(void)
 	printf("       -h          Display this help.\n");
 }
 
-static int bpf_map_create(void)
-{
-	return bpf_create_map(BPF_MAP_TYPE_ARRAY, sizeof(uint32_t),
-			      sizeof(uint32_t), 1024, 0);
-}
-
 static int bpf_prog_create(const char *object)
 {
 	static struct bpf_insn insns[] = {
@@ -79,7 +73,8 @@ static int bpf_do_map(const char *file, uint32_t flags, uint32_t key,
 	int fd, ret;
 
 	if (flags & BPF_F_PIN) {
-		fd = bpf_map_create();
+		fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, sizeof(uint32_t),
+				    sizeof(uint32_t), 1024, 0);
 		printf("bpf: map fd:%d (%s)\n", fd, strerror(errno));
 		assert(fd > 0);
 
-- 
2.33.1

