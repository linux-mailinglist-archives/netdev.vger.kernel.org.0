Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C763F55EE4A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiF1Tx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiF1Tuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:55 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFA119C;
        Tue, 28 Jun 2022 12:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445785; x=1687981785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dB3Xt0F7hnoEevA2MD5Np5ujq3lddankoDvz3+hjrx0=;
  b=iSn6uvFR89n1JgcBC1hseJZ329DuFvQWAUot+VznP3YmfTR1PkfHk61P
   P4UwYgnoBR8ePymGE+SD8g7XSq5W1binORdIpY/D4G2F4xMWoNFq+Rbiu
   mdP3XZS6ylQn/yiFNmazGONhia/ggq2RGCrXe8U78DsccnipcODICni3Y
   XRr88Ird77AQfPBi8hEcAZdDoIut/Afz+DrRB4z6636xJacfCvE2XMI1b
   SW3V3z8dzFt+LvtunfRzLpMBX3HoMm1nuX61Ia6rQCkvH+dVW4mtuFUZ+
   HHVGBud5Q3cmexnmPgaWNH/B1dSp000BR9JGb4mIYSymqGCeNEdqGOLbB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343523322"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="343523322"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="717555210"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 28 Jun 2022 12:49:41 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9Y022013;
        Tue, 28 Jun 2022 20:49:39 +0100
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
Subject: [PATCH RFC bpf-next 34/52] samples/bpf: add 'timeout' option to xdp_redirect_cpu
Date:   Tue, 28 Jun 2022 21:47:54 +0200
Message-Id: <20220628194812.1453059-35-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to specify a deferred flush timeout (in usec, not nsec!)
when setting up a cpumap in xdp_redirect_cpu sample.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 samples/bpf/xdp_redirect_cpu_user.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index ca457c34eb0f..d184c3fcab53 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -34,6 +34,8 @@ static const char *__doc__ =
 #include "xdp_sample_user.h"
 #include "xdp_redirect_cpu.skel.h"
 
+#define NSEC_PER_USEC		1000UL
+
 static int map_fd;
 static int avail_fd;
 static int count_fd;
@@ -61,6 +63,7 @@ static const struct option long_options[] = {
 	{ "redirect-device", required_argument, NULL, 'r' },
 	{ "redirect-map", required_argument, NULL, 'm' },
 	{ "meta-thresh", optional_argument, NULL, 'M' },
+	{ "timeout", required_argument, NULL, 't'},
 	{}
 };
 
@@ -128,9 +131,10 @@ static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 		}
 	}
 
-	printf("%s CPU: %u as idx: %u qsize: %d cpumap_prog_fd: %d (cpus_count: %u)\n",
+	printf("%s CPU: %u as idx: %u qsize: %d timeout: %llu cpumap_prog_fd: %d (cpus_count: %u)\n",
 	       new ? "Add new" : "Replace", cpu, avail_idx,
-	       value->qsize, value->bpf_prog.fd, curr_cpus_count);
+	       value->qsize, value->timeout, value->bpf_prog.fd,
+	       curr_cpus_count);
 
 	return 0;
 }
@@ -346,6 +350,7 @@ int main(int argc, char **argv)
 	 *   tuned-adm profile network-latency
 	 */
 	qsize = 2048;
+	value.timeout = 0; /* Defaults to 0 to mimic the previous behaviour. */
 
 	skel = xdp_redirect_cpu__open();
 	if (!skel) {
@@ -383,7 +388,7 @@ int main(int argc, char **argv)
 	}
 
 	prog = skel->progs.xdp_prognum5_lb_hash_ip_pairs;
-	while ((opt = getopt_long(argc, argv, "d:si:Sxp:f:e:r:m:c:q:FMvh",
+	while ((opt = getopt_long(argc, argv, "d:si:Sxp:f:e:r:m:c:q:FMt:vh",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
@@ -466,6 +471,10 @@ int main(int argc, char **argv)
 			opts.meta_thresh = optarg ? strtoul(optarg, NULL, 0) :
 					   1;
 			break;
+		case 't':
+			value.timeout = strtoull(optarg, NULL, 0) *
+					NSEC_PER_USEC;
+			break;
 		case 'h':
 			error = false;
 		default:
-- 
2.36.1

