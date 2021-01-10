Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C2F2F048A
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbhAJAUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbhAJAUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:20:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17A3F239FE;
        Sun, 10 Jan 2021 00:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610237940;
        bh=/NvBgDzx8WHlWosIN9pwAzVOPkazw1g9HPyMgmfBRjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llJcn09e+B8+x5FccUZjIB5SlH9C2XRFPayOLkGZyjUp2z2nBfTH66GseAJ5+4dZ5
         coV5BJ9zJtNC3hOBm4aJ/+UElTGvKwS72uuCFSzuOCHyU+6dNztCJlxyI4I+Ju8+g2
         o8oDKPqumC8NDx1bjOfhwUdleuPMPhz+6qNxy2C/pfpZtGmw7wpLaEFysgfmguk43+
         InAJF0eEt7v/HKcnuQbUyw4KJ4pGgjhasgqH9TMVMoOhv2BiGAfuCfqva7GXTAJSqH
         sFbQCV1T01koFtm3g+I/5BazyKXsOjy1GCVgIpCcOCWUkS2yEgJLQ+NqjSQt+kBE10
         HyrYEVIm0S+Yw==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v2 08/11] selftests: Make address validation apply only to client mode
Date:   Sat,  9 Jan 2021 17:18:49 -0700
Message-Id: <20210110001852.35653-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210110001852.35653-1-dsahern@kernel.org>
References: <20210110001852.35653-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

When a single instance of nettest is used for client and server
make sure address validation is only done for client mode.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 159430a0fc9b..828dc7e879f2 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1718,6 +1718,12 @@ static int ipc_child(int fd, struct sock_args *args)
 
 	server_mode = 1; /* to tell log_msg in case we are in both_mode */
 
+	/* when running in both mode, address validation applies
+	 * solely to client side
+	 */
+	args->has_expected_laddr = 0;
+	args->has_expected_raddr = 0;
+
 	rc = do_server(args, fd);
 
 	free(outbuf);
-- 
2.24.3 (Apple Git-128)

