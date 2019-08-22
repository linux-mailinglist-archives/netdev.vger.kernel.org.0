Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E2E9903D
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732805AbfHVKAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:00:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:1799 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732735AbfHVKAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:00:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 03:00:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,416,1559545200"; 
   d="scan'208";a="180336863"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by fmsmga007.fm.intel.com with ESMTP; 22 Aug 2019 03:00:43 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v5 08/11] samples/bpf: add unaligned chunks mode support to xdpsock
Date:   Thu, 22 Aug 2019 01:44:24 +0000
Message-Id: <20190822014427.49800-9-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190822014427.49800-1-kevin.laatz@intel.com>
References: <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190822014427.49800-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the unaligned chunks mode. The addition of the
unaligned chunks option will allow users to run the application with more
relaxed chunk placement in the XDP umem.

Unaligned chunks mode can be used with the '-u' or '--unaligned' command
line options.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>

---
v4:
  - updated help text for -f
  - use new chunk flag define
---
 samples/bpf/xdpsock_user.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index da84c760c094..7312eab4d201 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -68,6 +68,9 @@ static int opt_queue;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
+static u32 opt_umem_flags;
+static int opt_unaligned_chunks;
+static u32 opt_xdp_bind_flags;
 static int opt_xsk_frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 static int opt_timeout = 1000;
 static bool opt_need_wakeup = true;
@@ -284,7 +287,9 @@ static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
 		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
 		.frame_size = opt_xsk_frame_size,
 		.frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM,
+		.flags = opt_umem_flags
 	};
+
 	int ret;
 
 	umem = calloc(1, sizeof(*umem));
@@ -293,6 +298,7 @@ static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
 
 	ret = xsk_umem__create(&umem->umem, buffer, size, &umem->fq, &umem->cq,
 			       &cfg);
+
 	if (ret)
 		exit_with_error(-ret);
 
@@ -355,6 +361,7 @@ static struct option long_options[] = {
 	{"copy", no_argument, 0, 'c'},
 	{"frame-size", required_argument, 0, 'f'},
 	{"no-need-wakeup", no_argument, 0, 'm'},
+	{"unaligned", no_argument, 0, 'u'},
 	{0, 0, 0, 0}
 };
 
@@ -376,6 +383,8 @@ static void usage(const char *prog)
 		"  -c, --copy           Force copy mode.\n"
 		"  -f, --frame-size=n   Set the frame size (must be a power of two, default is %d).\n"
 		"  -m, --no-need-wakeup Turn off use of driver need wakeup flag.\n"
+		"  -f, --frame-size=n   Set the frame size (must be a power of two in aligned mode, default is %d).\n"
+		"  -u, --unaligned	Enable unaligned chunk placement\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE);
 	exit(EXIT_FAILURE);
@@ -388,8 +397,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-
-		c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:m",
+		c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:mu",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -429,6 +437,10 @@ static void parse_command_line(int argc, char **argv)
 		case 'c':
 			opt_xdp_bind_flags |= XDP_COPY;
 			break;
+		case 'u':
+			opt_umem_flags |= XDP_UMEM_UNALIGNED_CHUNK_FLAG;
+			opt_unaligned_chunks = 1;
+			break;
 		case 'F':
 			opt_xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
@@ -438,6 +450,7 @@ static void parse_command_line(int argc, char **argv)
 			opt_need_wakeup = false;
 			opt_xdp_bind_flags &= ~XDP_USE_NEED_WAKEUP;
 			break;
+
 		default:
 			usage(basename(argv[0]));
 		}
@@ -450,7 +463,8 @@ static void parse_command_line(int argc, char **argv)
 		usage(basename(argv[0]));
 	}
 
-	if (opt_xsk_frame_size & (opt_xsk_frame_size - 1)) {
+	if ((opt_xsk_frame_size & (opt_xsk_frame_size - 1)) &&
+	    !opt_unaligned_chunks) {
 		fprintf(stderr, "--frame-size=%d is not a power of two\n",
 			opt_xsk_frame_size);
 		usage(basename(argv[0]));
-- 
2.17.1

