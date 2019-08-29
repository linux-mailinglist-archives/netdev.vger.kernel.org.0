Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37049A172B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 12:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfH2Kur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 06:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbfH2Kuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A927623405;
        Thu, 29 Aug 2019 10:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075845;
        bh=ONx14oMxgGVjejwC1H+cAhSrLULeYa5AfyZ3w2hjqZA=;
        h=From:To:Cc:Subject:Date:From;
        b=WyGH4v+mf7QdMMIM046pQ2TH5Ybho6KjBiDkCfBlN7IfP/2+L81/zLQV3fv6jmg72
         4bg9GcF8wXcnojAH2yd/SckHzXMJkVcNb73fD8BbjV+5bgBTKEqFCVxLGJPAkmrE5S
         nI1HbyiWNHayBEEgFDDB1FfQzCdb0Xdq14wXgjpY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 4.14 01/14] hv_sock: Fix hang when a connection is closed
Date:   Thu, 29 Aug 2019 06:50:30 -0400
Message-Id: <20190829105043.2508-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 685703b497bacea8765bb409d6b73455b73c540e ]

There is a race condition for an established connection that is being closed
by the guest: the refcnt is 4 at the end of hvs_release() (Note: here the
'remove_sock' is false):

1 for the initial value;
1 for the sk being in the bound list;
1 for the sk being in the connected list;
1 for the delayed close_work.

After hvs_release() finishes, __vsock_release() -> sock_put(sk) *may*
decrease the refcnt to 3.

Concurrently, hvs_close_connection() runs in another thread:
  calls vsock_remove_sock() to decrease the refcnt by 2;
  call sock_put() to decrease the refcnt to 0, and free the sk;
  next, the "release_sock(sk)" may hang due to use-after-free.

In the above, after hvs_release() finishes, if hvs_close_connection() runs
faster than "__vsock_release() -> sock_put(sk)", then there is not any issue,
because at the beginning of hvs_close_connection(), the refcnt is still 4.

The issue can be resolved if an extra reference is taken when the
connection is established.

Fixes: a9eeb998c28d ("hv_sock: Add support for delayed close")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/hyperv_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 52ac3e49c7efd..ec72a5edaa1b8 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -320,6 +320,11 @@ static void hvs_close_connection(struct vmbus_channel *chan)
 	lock_sock(sk);
 	hvs_do_close_lock_held(vsock_sk(sk), true);
 	release_sock(sk);
+
+	/* Release the refcnt for the channel that's opened in
+	 * hvs_open_connection().
+	 */
+	sock_put(sk);
 }
 
 static void hvs_open_connection(struct vmbus_channel *chan)
@@ -389,6 +394,9 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 	}
 
 	set_per_channel_state(chan, conn_from_host ? new : sk);
+
+	/* This reference will be dropped by hvs_close_connection(). */
+	sock_hold(conn_from_host ? new : sk);
 	vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
 
 	/* Set the pending send size to max packet size to always get
-- 
2.20.1

