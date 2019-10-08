Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4764DD0045
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 20:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfJHR7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 13:59:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:54146 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbfJHR7t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 13:59:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 10:59:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,272,1566889200"; 
   d="scan'208";a="193446446"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga007.fm.intel.com with ESMTP; 08 Oct 2019 10:59:47 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [net] net: update net_dim documentation after rename
Date:   Tue,  8 Oct 2019 10:59:41 -0700
Message-Id: <20191008175941.12913-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.23.0.245.gf157bbb9169d
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8960b38932be ("linux/dim: Rename externally used net_dim
members") renamed the net_dim API, removing the "net_" prefix from the
structures and functions. The patch didn't update the net_dim.txt
documentation file.

Fix the documentation so that its examples match the current code.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/net_dim.txt | 32 ++++++++++++++--------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/net_dim.txt b/Documentation/networking/net_dim.txt
index 9cb31c5e2dcd..729d01c1619b 100644
--- a/Documentation/networking/net_dim.txt
+++ b/Documentation/networking/net_dim.txt
@@ -92,16 +92,16 @@ under some conditions.
 Part III: Registering a Network Device to DIM
 ==============================================
 
-Net DIM API exposes the main function net_dim(struct net_dim *dim,
-struct net_dim_sample end_sample). This function is the entry point to the Net
+Net DIM API exposes the main function net_dim(struct dim *dim,
+struct dim_sample end_sample). This function is the entry point to the Net
 DIM algorithm and has to be called every time the driver would like to check if
 it should change interrupt moderation parameters. The driver should provide two
-data structures: struct net_dim and struct net_dim_sample. Struct net_dim
+data structures: struct dim and struct dim_sample. Struct dim
 describes the state of DIM for a specific object (RX queue, TX queue,
 other queues, etc.). This includes the current selected profile, previous data
 samples, the callback function provided by the driver and more.
-Struct net_dim_sample describes a data sample, which will be compared to the
-data sample stored in struct net_dim in order to decide on the algorithm's next
+Struct dim_sample describes a data sample, which will be compared to the
+data sample stored in struct dim in order to decide on the algorithm's next
 step. The sample should include bytes, packets and interrupts, measured by
 the driver.
 
@@ -110,9 +110,9 @@ main net_dim() function. The recommended method is to call net_dim() on each
 interrupt. Since Net DIM has a built-in moderation and it might decide to skip
 iterations under certain conditions, there is no need to moderate the net_dim()
 calls as well. As mentioned above, the driver needs to provide an object of type
-struct net_dim to the net_dim() function call. It is advised for each entity
-using Net DIM to hold a struct net_dim as part of its data structure and use it
-as the main Net DIM API object. The struct net_dim_sample should hold the latest
+struct dim to the net_dim() function call. It is advised for each entity
+using Net DIM to hold a struct dim as part of its data structure and use it
+as the main Net DIM API object. The struct dim_sample should hold the latest
 bytes, packets and interrupts count. No need to perform any calculations, just
 include the raw data.
 
@@ -132,13 +132,13 @@ usage is not complete but it should make the outline of the usage clear.
 
 my_driver.c:
 
-#include <linux/net_dim.h>
+#include <linux/dim.h>
 
 /* Callback for net DIM to schedule on a decision to change moderation */
 void my_driver_do_dim_work(struct work_struct *work)
 {
-	/* Get struct net_dim from struct work_struct */
-	struct net_dim *dim = container_of(work, struct net_dim,
+	/* Get struct dim from struct work_struct */
+	struct dim *dim = container_of(work, struct dim,
 					   work);
 	/* Do interrupt moderation related stuff */
 	...
@@ -152,13 +152,13 @@ int my_driver_handle_interrupt(struct my_driver_entity *my_entity, ...)
 {
 	...
 	/* A struct to hold current measured data */
-	struct net_dim_sample dim_sample;
+	struct dim_sample dim_sample;
 	...
 	/* Initiate data sample struct with current data */
-	net_dim_sample(my_entity->events,
-		       my_entity->packets,
-		       my_entity->bytes,
-		       &dim_sample);
+	dim_update_sample(my_entity->events,
+		          my_entity->packets,
+		          my_entity->bytes,
+		          &dim_sample);
 	/* Call net DIM */
 	net_dim(&my_entity->dim, dim_sample);
 	...
-- 
2.23.0.245.gf157bbb9169d

