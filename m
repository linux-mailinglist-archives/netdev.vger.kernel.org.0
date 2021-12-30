Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD42481926
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbhL3D6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:58:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:3816 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235614AbhL3D6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 22:58:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640836728; x=1672372728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=izOcQEI75S9RXJnvu6Dy9r/kjnTJGhtidSucruZ+rTI=;
  b=j+NvKCsk0J/R7eZn4BM/HFjwFTg60pi6MWZq+FrLpsu4gSp4nnryixOL
   7meg/4SsJJj7tHZdlPxSIqT8Xc+jmpDTzcb+cLeN/fSuxyG8OxeLi7bPl
   IqOSvIAT+YZ5c9x3R5+Z2LDeXo0hKQbMTv4kekXErRME5r75HrtpJEZZY
   f6rIOve0lvPA7TY+5je9m12l312wR3pyM+Eu1wuLOe/5Gjrb5tygfoTms
   Qv8gl4ezmvd8gRdgVNVLkBL0Fa8aiOBRXO1ha6q8Bq2Re63x2euniQYRw
   kthEv2FDl+0Mr1FCIgMhixwgjJS4HjaNqVAGkVtSI9YTGcDVfb0TgvNL8
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="239154646"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="239154646"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 19:58:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="609801553"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Dec 2021 19:58:44 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH bpf-next v2 6/7] samples/bpf: xdpsock: add time-out for cleaning Tx
Date:   Thu, 30 Dec 2021 11:54:46 +0800
Message-Id: <20211230035447.523177-7-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211230035447.523177-1-boon.leong.ong@intel.com>
References: <20211230035447.523177-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user sets tx-pkt-count and in case where there are invalid Tx frame,
the complete_tx_only_all() process polls indefinitely. So, this patch
adds a time-out mechanism into the process so that the application
can terminate automatically after it retries 3*polling interval duration.

v1->v2:
 Thanks to Jesper's and Song Liu's suggestion.
 - clean-up git message to remove polling log
 - make the Tx time-out retries configurable with 1s granularity

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index b7d0f536f97..319cb3cdb22 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -113,6 +113,7 @@ static u32 irq_no;
 static int irqs_at_init = -1;
 static int opt_poll;
 static int opt_interval = 1;
+static int opt_retries = 3;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static u32 opt_umem_flags;
 static int opt_unaligned_chunks;
@@ -1028,6 +1029,7 @@ static struct option long_options[] = {
 	{"xdp-skb", no_argument, 0, 'S'},
 	{"xdp-native", no_argument, 0, 'N'},
 	{"interval", required_argument, 0, 'n'},
+	{"retries", required_argument, 0, 'O'},
 	{"zero-copy", no_argument, 0, 'z'},
 	{"copy", no_argument, 0, 'c'},
 	{"frame-size", required_argument, 0, 'f'},
@@ -1072,6 +1074,7 @@ static void usage(const char *prog)
 		"  -S, --xdp-skb=n	Use XDP skb-mod\n"
 		"  -N, --xdp-native=n	Enforce XDP native mode\n"
 		"  -n, --interval=n	Specify statistics update interval (default 1 sec).\n"
+		"  -O, --retries=n	Specify time-out retries (1s interval) attempt (default 3).\n"
 		"  -z, --zero-copy      Force zero-copy mode.\n"
 		"  -c, --copy           Force copy mode.\n"
 		"  -m, --no-need-wakeup Turn off use of driver need wakeup flag.\n"
@@ -1122,7 +1125,7 @@ static void parse_command_line(int argc, char **argv)
 
 	for (;;) {
 		c = getopt_long(argc, argv,
-				"Frtli:q:pSNn:w:czf:muMd:b:C:s:P:VJ:K:G:H:T:W:U:xQaI:BR",
+				"Frtli:q:pSNn:w:O:czf:muMd:b:C:s:P:VJ:K:G:H:T:W:U:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1164,6 +1167,9 @@ static void parse_command_line(int argc, char **argv)
 				opt_clock = CLOCK_MONOTONIC;
 			}
 			break;
+		case 'O':
+			opt_retries = atoi(optarg);
+			break;
 		case 'z':
 			opt_xdp_bind_flags |= XDP_ZEROCOPY;
 			break;
@@ -1509,7 +1515,8 @@ static void complete_tx_only_all(void)
 				pending = !!xsks[i]->outstanding_tx;
 			}
 		}
-	} while (pending);
+		sleep(1);
+	} while (pending && opt_retries-- > 0);
 }
 
 static void tx_only_all(void)
-- 
2.25.1

