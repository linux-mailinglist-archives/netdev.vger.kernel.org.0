Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D699127797
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfLTIzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:55:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:34862 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbfLTIzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:55:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 00:55:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,335,1571727600"; 
   d="scan'208";a="218434383"
Received: from unknown (HELO localhost.localdomain) ([10.190.210.212])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2019 00:55:13 -0800
Received: from localhost.localdomain (localhost [127.0.0.1])
        by localhost.localdomain (8.15.2/8.15.2/Debian-10) with ESMTPS id xBK8tZRH005056
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 20 Dec 2019 14:25:35 +0530
Received: (from root@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id xBK8tZGF005055;
        Fri, 20 Dec 2019 14:25:35 +0530
From:   Jay Jayatheerthan <jay.jayatheerthan@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org,
        Jay Jayatheerthan <jay.jayatheerthan@intel.com>
Subject: [PATCH bpf-next 6/6] samples/bpf: xdpsock: Add option to specify transmit fill pattern
Date:   Fri, 20 Dec 2019 14:25:30 +0530
Message-Id: <20191220085530.4980-7-jay.jayatheerthan@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
References: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The UDP payload fill pattern can be specified using '-P' or '--tx-pkt-pattern'
option. It is an unsigned 32 bit field and defaulted to 0x12345678.

The IP and UDP checksum is calculated by the code as per the content of
the packet before transmission.

Signed-off-by: Jay Jayatheerthan <jay.jayatheerthan@intel.com>
---
 samples/bpf/xdpsock_user.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 2297158a32bd..d74c4c83fc93 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -76,7 +76,7 @@ static bool benchmark_done;
 static u32 opt_batch_size = 64;
 static int opt_pkt_count;
 static u16 opt_pkt_size = MIN_PKT_SIZE;
-static u32 pkt_fill_pattern = 0x12345678;
+static u32 opt_pkt_fill_pattern = 0x12345678;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
@@ -517,7 +517,7 @@ static void gen_eth_hdr_data(void)
 	udp_hdr->len = htons(UDP_PKT_SIZE);
 
 	/* UDP data */
-	memset32_htonl(pkt_data + PKT_HDR_SIZE, pkt_fill_pattern,
+	memset32_htonl(pkt_data + PKT_HDR_SIZE, opt_pkt_fill_pattern,
 		       UDP_PKT_DATA_SIZE);
 
 	/* UDP header checksum */
@@ -630,6 +630,7 @@ static struct option long_options[] = {
 	{"batch-size", required_argument, 0, 'b'},
 	{"tx-pkt-count", required_argument, 0, 'C'},
 	{"tx-pkt-size", required_argument, 0, 's'},
+	{"tx-pkt-pattern", required_argument, 0, 'P'},
 	{0, 0, 0, 0}
 };
 
@@ -663,10 +664,11 @@ static void usage(const char *prog)
 		"  -s, --tx-pkt-size=n	Transmit packet size.\n"
 		"			(Default: %d bytes)\n"
 		"			Min size: %d, Max size %d.\n"
+		"  -P, --tx-pkt-pattern=nPacket fill pattern. Default: 0x%x\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
-		XSK_UMEM__DEFAULT_FRAME_SIZE);
+		XSK_UMEM__DEFAULT_FRAME_SIZE, opt_pkt_fill_pattern);
 
 	exit(EXIT_FAILURE);
 }
@@ -678,7 +680,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -756,6 +758,9 @@ static void parse_command_line(int argc, char **argv)
 				usage(basename(argv[0]));
 			}
 			break;
+		case 'P':
+			opt_pkt_fill_pattern = strtol(optarg, NULL, 16);
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
-- 
2.17.1

