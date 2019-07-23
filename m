Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCD671D06
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 18:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388324AbfGWQjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 12:39:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:28574 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbfGWQjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 12:39:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 09:39:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,299,1559545200"; 
   d="scan'208";a="180790441"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 23 Jul 2019 09:39:45 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 5DE8681; Tue, 23 Jul 2019 19:39:44 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] hv_sock: Use consistent types for UUIDs
Date:   Tue, 23 Jul 2019 19:39:43 +0300
Message-Id: <20190723163943.65991-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rest of Hyper-V code is using new types for UUID handling.
Convert hv_sock as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/vmw_vsock/hyperv_transport.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index f2084e3f7aa4..2a1719c0f8d2 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -77,11 +77,11 @@ struct hvs_send_buf {
 					 VMBUS_PKT_TRAILER_SIZE)
 
 union hvs_service_id {
-	uuid_le	srv_id;
+	guid_t	srv_id;
 
 	struct {
 		unsigned int svm_port;
-		unsigned char b[sizeof(uuid_le) - sizeof(unsigned int)];
+		unsigned char b[sizeof(guid_t) - sizeof(unsigned int)];
 	};
 };
 
@@ -89,8 +89,8 @@ union hvs_service_id {
 struct hvsock {
 	struct vsock_sock *vsk;
 
-	uuid_le vm_srv_id;
-	uuid_le host_srv_id;
+	guid_t vm_srv_id;
+	guid_t host_srv_id;
 
 	struct vmbus_channel *chan;
 	struct vmpacket_descriptor *recv_desc;
@@ -159,21 +159,21 @@ struct hvsock {
 #define MIN_HOST_EPHEMERAL_PORT		(MAX_HOST_LISTEN_PORT + 1)
 
 /* 00000000-facb-11e6-bd58-64006a7986d3 */
-static const uuid_le srv_id_template =
-	UUID_LE(0x00000000, 0xfacb, 0x11e6, 0xbd, 0x58,
-		0x64, 0x00, 0x6a, 0x79, 0x86, 0xd3);
+static const guid_t srv_id_template =
+	GUID_INIT(0x00000000, 0xfacb, 0x11e6, 0xbd, 0x58,
+		  0x64, 0x00, 0x6a, 0x79, 0x86, 0xd3);
 
-static bool is_valid_srv_id(const uuid_le *id)
+static bool is_valid_srv_id(const guid_t *id)
 {
-	return !memcmp(&id->b[4], &srv_id_template.b[4], sizeof(uuid_le) - 4);
+	return !memcmp(&id->b[4], &srv_id_template.b[4], sizeof(guid_t) - 4);
 }
 
-static unsigned int get_port_by_srv_id(const uuid_le *svr_id)
+static unsigned int get_port_by_srv_id(const guid_t *svr_id)
 {
 	return *((unsigned int *)svr_id);
 }
 
-static void hvs_addr_init(struct sockaddr_vm *addr, const uuid_le *svr_id)
+static void hvs_addr_init(struct sockaddr_vm *addr, const guid_t *svr_id)
 {
 	unsigned int port = get_port_by_srv_id(svr_id);
 
@@ -316,7 +316,7 @@ static void hvs_close_connection(struct vmbus_channel *chan)
 
 static void hvs_open_connection(struct vmbus_channel *chan)
 {
-	uuid_le *if_instance, *if_type;
+	guid_t *if_instance, *if_type;
 	unsigned char conn_from_host;
 
 	struct sockaddr_vm addr;
-- 
2.20.1

