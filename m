Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D5D127790
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfLTIzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:55:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:34861 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbfLTIzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:55:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 00:55:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,335,1571727600"; 
   d="scan'208";a="218434377"
Received: from unknown (HELO localhost.localdomain) ([10.190.210.212])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2019 00:55:12 -0800
Received: from localhost.localdomain (localhost [127.0.0.1])
        by localhost.localdomain (8.15.2/8.15.2/Debian-10) with ESMTPS id xBK8tYjM005040
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 20 Dec 2019 14:25:34 +0530
Received: (from root@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id xBK8tYSG005039;
        Fri, 20 Dec 2019 14:25:34 +0530
From:   Jay Jayatheerthan <jay.jayatheerthan@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org,
        Jay Jayatheerthan <jay.jayatheerthan@intel.com>
Subject: [PATCH bpf-next 2/6] samples/bpf: xdpsock: Use common code to handle signal and main exit
Date:   Fri, 20 Dec 2019 14:25:26 +0530
Message-Id: <20191220085530.4980-3-jay.jayatheerthan@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
References: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to do cleanup for signals and application completion in a unified
fashion. The signal handler sets benckmark_done flag terminating the
threads. The cleanup is called before returning from main() function.

Signed-off-by: Jay Jayatheerthan <jay.jayatheerthan@intel.com>
---
 samples/bpf/xdpsock_user.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index e188a79a9c31..7febc3d519a1 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -209,6 +209,11 @@ static void remove_xdp_program(void)
 }
 
 static void int_exit(int sig)
+{
+	benchmark_done = true;
+}
+
+static void xdpsock_cleanup(void)
 {
 	struct xsk_umem *umem = xsks[0]->umem->umem;
 	int i;
@@ -218,8 +223,6 @@ static void int_exit(int sig)
 		xsk_socket__delete(xsks[i]->xsk);
 	(void)xsk_umem__delete(umem);
 	remove_xdp_program();
-
-	exit(EXIT_SUCCESS);
 }
 
 static void __exit_with_error(int error, const char *file, const char *func,
@@ -893,5 +896,7 @@ int main(int argc, char **argv)
 
 	pthread_join(pt, NULL);
 
+	xdpsock_cleanup();
+
 	return 0;
 }
-- 
2.17.1

