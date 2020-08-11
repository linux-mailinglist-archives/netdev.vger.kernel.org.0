Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B40E241404
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 02:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgHKADD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 20:03:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:22100 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbgHKADD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 20:03:03 -0400
IronPort-SDR: 9RZNHRGXO1ycF7wxPHXYrhoMomwbQ3zoKqEvxp6xQqCpwzN9VEO7E9h9h3c3m9GqJB4UM9YtEL
 VYOfR8BjjaGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="141498658"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="141498658"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 17:03:02 -0700
IronPort-SDR: xoPjqZyc1+7oOVqcu8XRvlVY+BTfSmmneyOXGUhmXC7ZHQbK6nLF7NqOv690CosdLHBAu8hsmz
 UEfs3ix+nwqw==
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="469231771"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 17:03:02 -0700
From:   ira.weiny@intel.com
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Ilya Lesokhin <ilyal@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/tls: Fix kmap usage
Date:   Mon, 10 Aug 2020 17:02:58 -0700
Message-Id: <20200811000258.2797151-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

When MSG_OOB is specified to tls_device_sendpage() the mapped page is
never unmapped.

Hold off mapping the page until after the flags are checked and the page
is actually needed.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 net/tls/tls_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 0e55f8365ce2..0cbad566f281 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -561,7 +561,7 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct iov_iter	msg_iter;
-	char *kaddr = kmap(page);
+	char *kaddr;
 	struct kvec iov;
 	int rc;
 
@@ -576,6 +576,7 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 		goto out;
 	}
 
+	kaddr = kmap(page);
 	iov.iov_base = kaddr + offset;
 	iov.iov_len = size;
 	iov_iter_kvec(&msg_iter, WRITE, &iov, 1, size);
-- 
2.28.0.rc0.12.gb6a658bd00c9

