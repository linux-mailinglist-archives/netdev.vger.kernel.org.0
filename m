Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB93B55EE2A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbiF1TvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiF1Tut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:49 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8153A705;
        Tue, 28 Jun 2022 12:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445743; x=1687981743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RBYELKLN8xHT64H2SZNXxit0NQ+8Jyn2q2/+cMeDt7I=;
  b=VXcq7UrFmFJqokctgdYD+O6+Cdnd039GuBH04uahmZ4SoakQB13qmpaj
   vTv0//DPThpTsvHgU9lRZwtrGk1vwc2CItz7OEscQLUtZC3LuzTpiYcgW
   DdS3Ud+Zh0x1gMC7GvwTAx9IKlGfinlH4cHLm5n8OUucLgSA2vynhzcu5
   5cPoRvq8ZICe+UEK4OE9Qsu8Hyz1mNaLLbesRgT3OP8pwIRvUw2RXeVV5
   Bzs2FrFImWtLSQcXXN2wHH8DQjdT3fHq+Es1qX5Lp369WNBAFa6jQ5pzT
   P2ixYqgE/N/6FtXZADeEHds4CkaKBJr9OtokGZldUPfzyb+nsFouPK6//
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282568019"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282568019"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="565181145"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 28 Jun 2022 12:48:58 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr92022013;
        Tue, 28 Jun 2022 20:48:56 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 02/52] libbpf: try to load vmlinux BTF from the kernel first
Date:   Tue, 28 Jun 2022 21:47:22 +0200
Message-Id: <20220628194812.1453059-3-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Larysa Zaremba <larysa.zaremba@intel.com>

Try to acquire vmlinux BTF the same way it's being done for module
BTFs. Use btf_load_next_with_info() and resort to the filesystem
lookup only if it fails.
Also, adjust debug messages in btf__load_vmlinux_btf() to reflect
that it actually tries to load vmlinux BTF.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/btf.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7e4dbf71fd52..8ecd50923fab 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -4927,6 +4927,25 @@ struct btf *btf_load_next_with_info(__u32 start_id, struct bpf_btf_info *info,
 	}
 }
 
+static struct btf *btf_load_vmlinux_from_kernel(void)
+{
+	char name[BTF_NAME_BUF_LEN] = { };
+	struct bpf_btf_info info;
+	struct btf *btf;
+
+	memset(&info, 0, sizeof(info));
+	info.name = ptr_to_u64(name);
+	info.name_len = sizeof(name);
+
+	btf = btf_load_next_with_info(0, &info, NULL, true);
+	if (!libbpf_get_error(btf)) {
+		close(btf->fd);
+		btf__set_fd(btf, -1);
+	}
+
+	return btf;
+}
+
 /*
  * Probe few well-known locations for vmlinux kernel image and try to load BTF
  * data out of it to use for target BTF.
@@ -4953,6 +4972,15 @@ struct btf *btf__load_vmlinux_btf(void)
 	struct btf *btf;
 	int i, err;
 
+	btf = btf_load_vmlinux_from_kernel();
+	err = libbpf_get_error(btf);
+	pr_debug("loading vmlinux BTF from kernel: %d\n", err);
+	if (!err)
+		return btf;
+
+	pr_info("failed to load vmlinux BTF from kernel: %d, will look through filesystem\n",
+		err);
+
 	uname(&buf);
 
 	for (i = 0; i < ARRAY_SIZE(locations); i++) {
@@ -4966,14 +4994,14 @@ struct btf *btf__load_vmlinux_btf(void)
 		else
 			btf = btf__parse_elf(path, NULL);
 		err = libbpf_get_error(btf);
-		pr_debug("loading kernel BTF '%s': %d\n", path, err);
+		pr_debug("loading vmlinux BTF '%s': %d\n", path, err);
 		if (err)
 			continue;
 
 		return btf;
 	}
 
-	pr_warn("failed to find valid kernel BTF\n");
+	pr_warn("failed to find valid vmlinux BTF\n");
 	return libbpf_err_ptr(-ESRCH);
 }
 
-- 
2.36.1

