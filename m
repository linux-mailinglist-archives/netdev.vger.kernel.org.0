Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935A2309F1
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfEaIPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:64476 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbfEaIPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:12 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/13] iavf: rename i40e_device to iavf_device
Date:   Fri, 31 May 2019 01:15:17 -0700
Message-Id: <20190531081518.16430-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Renaming remaining defines from i40e to iavf

Signed-off-by: Alice Michael <alice.michael@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  4 ++--
 drivers/net/ethernet/intel/iavf/iavf_client.c | 20 +++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 5a537d57a531..657019418693 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -109,7 +109,7 @@ struct iavf_q_vector {
 
 /* Helper macros to switch between ints/sec and what the register uses.
  * And yes, it's the same math going both ways.  The lowest value
- * supported by all of the i40e hardware is 8.
+ * supported by all of the iavf hardware is 8.
  */
 #define EITR_INTS_PER_SEC_TO_REG(_eitr) \
 	((_eitr) ? (1000000000 / ((_eitr) * 256)) : 8)
@@ -351,7 +351,7 @@ struct iavf_adapter {
 /* Ethtool Private Flags */
 
 /* lan device, used by client interface */
-struct i40e_device {
+struct iavf_device {
 	struct list_head list;
 	struct iavf_adapter *vf;
 };
diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.c b/drivers/net/ethernet/intel/iavf/iavf_client.c
index 83d7dd267aa8..f7414769fda5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_client.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_client.c
@@ -11,7 +11,7 @@
 static
 const char iavf_client_interface_version_str[] = IAVF_CLIENT_VERSION_STR;
 static struct iavf_client *vf_registered_client;
-static LIST_HEAD(i40e_devices);
+static LIST_HEAD(iavf_devices);
 static DEFINE_MUTEX(iavf_device_mutex);
 
 static u32 iavf_client_virtchnl_send(struct iavf_info *ldev,
@@ -291,11 +291,11 @@ void iavf_client_subtask(struct iavf_adapter *adapter)
  **/
 int iavf_lan_add_device(struct iavf_adapter *adapter)
 {
-	struct i40e_device *ldev;
+	struct iavf_device *ldev;
 	int ret = 0;
 
 	mutex_lock(&iavf_device_mutex);
-	list_for_each_entry(ldev, &i40e_devices, list) {
+	list_for_each_entry(ldev, &iavf_devices, list) {
 		if (ldev->vf == adapter) {
 			ret = -EEXIST;
 			goto out;
@@ -308,7 +308,7 @@ int iavf_lan_add_device(struct iavf_adapter *adapter)
 	}
 	ldev->vf = adapter;
 	INIT_LIST_HEAD(&ldev->list);
-	list_add(&ldev->list, &i40e_devices);
+	list_add(&ldev->list, &iavf_devices);
 	dev_info(&adapter->pdev->dev, "Added LAN device bus=0x%02x dev=0x%02x func=0x%02x\n",
 		 adapter->hw.bus.bus_id, adapter->hw.bus.device,
 		 adapter->hw.bus.func);
@@ -331,11 +331,11 @@ int iavf_lan_add_device(struct iavf_adapter *adapter)
  **/
 int iavf_lan_del_device(struct iavf_adapter *adapter)
 {
-	struct i40e_device *ldev, *tmp;
+	struct iavf_device *ldev, *tmp;
 	int ret = -ENODEV;
 
 	mutex_lock(&iavf_device_mutex);
-	list_for_each_entry_safe(ldev, tmp, &i40e_devices, list) {
+	list_for_each_entry_safe(ldev, tmp, &iavf_devices, list) {
 		if (ldev->vf == adapter) {
 			dev_info(&adapter->pdev->dev,
 				 "Deleted LAN device bus=0x%02x dev=0x%02x func=0x%02x\n",
@@ -360,11 +360,11 @@ int iavf_lan_del_device(struct iavf_adapter *adapter)
 static void iavf_client_release(struct iavf_client *client)
 {
 	struct iavf_client_instance *cinst;
-	struct i40e_device *ldev;
+	struct iavf_device *ldev;
 	struct iavf_adapter *adapter;
 
 	mutex_lock(&iavf_device_mutex);
-	list_for_each_entry(ldev, &i40e_devices, list) {
+	list_for_each_entry(ldev, &iavf_devices, list) {
 		adapter = ldev->vf;
 		cinst = adapter->cinst;
 		if (!cinst)
@@ -394,11 +394,11 @@ static void iavf_client_release(struct iavf_client *client)
  **/
 static void iavf_client_prepare(struct iavf_client *client)
 {
-	struct i40e_device *ldev;
+	struct iavf_device *ldev;
 	struct iavf_adapter *adapter;
 
 	mutex_lock(&iavf_device_mutex);
-	list_for_each_entry(ldev, &i40e_devices, list) {
+	list_for_each_entry(ldev, &iavf_devices, list) {
 		adapter = ldev->vf;
 		/* Signal the watchdog to service the client */
 		adapter->flags |= IAVF_FLAG_SERVICE_CLIENT_REQUESTED;
-- 
2.21.0

