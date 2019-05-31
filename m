Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB0A309F3
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfEaIP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:64473 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726945AbfEaIPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:11 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sergey Nemov <sergey.nemov@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/13] iavf: change iavf_status_code to iavf_status
Date:   Fri, 31 May 2019 01:15:11 -0700
Message-Id: <20190531081518.16430-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Nemov <sergey.nemov@intel.com>

Instead of typedefing the enum iavf_status_code with iavf_status,
just shorten the enum itself and get rid of typedef.

Signed-off-by: Sergey Nemov <sergey.nemov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_adminq.c | 67 ++++++++++---------
 drivers/net/ethernet/intel/iavf/iavf_alloc.h  | 17 +++--
 drivers/net/ethernet/intel/iavf/iavf_client.c |  6 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c | 53 ++++++++-------
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 20 +++---
 drivers/net/ethernet/intel/iavf/iavf_osdep.h  |  1 -
 .../net/ethernet/intel/iavf/iavf_prototype.h  | 52 +++++++-------
 drivers/net/ethernet/intel/iavf/iavf_status.h |  2 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 14 ++--
 10 files changed, 121 insertions(+), 113 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 272d76b733aa..42118f63f4f0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -402,7 +402,7 @@ void iavf_enable_vlan_stripping(struct iavf_adapter *adapter);
 void iavf_disable_vlan_stripping(struct iavf_adapter *adapter);
 void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			      enum virtchnl_ops v_opcode,
-			      iavf_status v_retval, u8 *msg, u16 msglen);
+			      enum iavf_status v_retval, u8 *msg, u16 msglen);
 int iavf_config_rss(struct iavf_adapter *adapter);
 int iavf_lan_add_device(struct iavf_adapter *adapter);
 int iavf_lan_del_device(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
index 04b44614ec38..22d3b79a6049 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -32,9 +32,9 @@ static void i40e_adminq_init_regs(struct iavf_hw *hw)
  *  i40e_alloc_adminq_asq_ring - Allocate Admin Queue send rings
  *  @hw: pointer to the hardware structure
  **/
-static iavf_status i40e_alloc_adminq_asq_ring(struct iavf_hw *hw)
+static enum iavf_status i40e_alloc_adminq_asq_ring(struct iavf_hw *hw)
 {
-	iavf_status ret_code;
+	enum iavf_status ret_code;
 
 	ret_code = iavf_allocate_dma_mem(hw, &hw->aq.asq.desc_buf,
 					 i40e_mem_atq_ring,
@@ -59,9 +59,9 @@ static iavf_status i40e_alloc_adminq_asq_ring(struct iavf_hw *hw)
  *  i40e_alloc_adminq_arq_ring - Allocate Admin Queue receive rings
  *  @hw: pointer to the hardware structure
  **/
-static iavf_status i40e_alloc_adminq_arq_ring(struct iavf_hw *hw)
+static enum iavf_status i40e_alloc_adminq_arq_ring(struct iavf_hw *hw)
 {
-	iavf_status ret_code;
+	enum iavf_status ret_code;
 
 	ret_code = iavf_allocate_dma_mem(hw, &hw->aq.arq.desc_buf,
 					 i40e_mem_arq_ring,
@@ -100,11 +100,11 @@ static void i40e_free_adminq_arq(struct iavf_hw *hw)
  *  i40e_alloc_arq_bufs - Allocate pre-posted buffers for the receive queue
  *  @hw: pointer to the hardware structure
  **/
-static iavf_status i40e_alloc_arq_bufs(struct iavf_hw *hw)
+static enum iavf_status i40e_alloc_arq_bufs(struct iavf_hw *hw)
 {
 	struct i40e_aq_desc *desc;
 	struct iavf_dma_mem *bi;
-	iavf_status ret_code;
+	enum iavf_status ret_code;
 	int i;
 
 	/* We'll be allocating the buffer info memory first, then we can
@@ -168,10 +168,10 @@ static iavf_status i40e_alloc_arq_bufs(struct iavf_hw *hw)
  *  i40e_alloc_asq_bufs - Allocate empty buffer structs for the send queue
  *  @hw: pointer to the hardware structure
  **/
-static iavf_status i40e_alloc_asq_bufs(struct iavf_hw *hw)
+static enum iavf_status i40e_alloc_asq_bufs(struct iavf_hw *hw)
 {
 	struct iavf_dma_mem *bi;
-	iavf_status ret_code;
+	enum iavf_status ret_code;
 	int i;
 
 	/* No mapped memory needed yet, just the buffer info structures */
@@ -253,9 +253,9 @@ static void i40e_free_asq_bufs(struct iavf_hw *hw)
  *
  *  Configure base address and length registers for the transmit queue
  **/
-static iavf_status i40e_config_asq_regs(struct iavf_hw *hw)
+static enum iavf_status i40e_config_asq_regs(struct iavf_hw *hw)
 {
-	iavf_status ret_code = 0;
+	enum iavf_status ret_code = 0;
 	u32 reg = 0;
 
 	/* Clear Head and Tail */
@@ -282,9 +282,9 @@ static iavf_status i40e_config_asq_regs(struct iavf_hw *hw)
  *
  * Configure base address and length registers for the receive (event queue)
  **/
-static iavf_status i40e_config_arq_regs(struct iavf_hw *hw)
+static enum iavf_status i40e_config_arq_regs(struct iavf_hw *hw)
 {
-	iavf_status ret_code = 0;
+	enum iavf_status ret_code = 0;
 	u32 reg = 0;
 
 	/* Clear Head and Tail */
@@ -321,9 +321,9 @@ static iavf_status i40e_config_arq_regs(struct iavf_hw *hw)
  *  Do *NOT* hold the lock when calling this as the memory allocation routines
  *  called are not going to be atomic context safe
  **/
-static iavf_status i40e_init_asq(struct iavf_hw *hw)
+static enum iavf_status i40e_init_asq(struct iavf_hw *hw)
 {
-	iavf_status ret_code = 0;
+	enum iavf_status ret_code = 0;
 
 	if (hw->aq.asq.count > 0) {
 		/* queue already initialized */
@@ -380,9 +380,9 @@ static iavf_status i40e_init_asq(struct iavf_hw *hw)
  *  Do *NOT* hold the lock when calling this as the memory allocation routines
  *  called are not going to be atomic context safe
  **/
-static iavf_status i40e_init_arq(struct iavf_hw *hw)
+static enum iavf_status i40e_init_arq(struct iavf_hw *hw)
 {
-	iavf_status ret_code = 0;
+	enum iavf_status ret_code = 0;
 
 	if (hw->aq.arq.count > 0) {
 		/* queue already initialized */
@@ -432,9 +432,9 @@ static iavf_status i40e_init_arq(struct iavf_hw *hw)
  *
  *  The main shutdown routine for the Admin Send Queue
  **/
-static iavf_status i40e_shutdown_asq(struct iavf_hw *hw)
+static enum iavf_status i40e_shutdown_asq(struct iavf_hw *hw)
 {
-	iavf_status ret_code = 0;
+	enum iavf_status ret_code = 0;
 
 	mutex_lock(&hw->aq.asq_mutex);
 
@@ -466,9 +466,9 @@ static iavf_status i40e_shutdown_asq(struct iavf_hw *hw)
  *
  *  The main shutdown routine for the Admin Receive Queue
  **/
-static iavf_status i40e_shutdown_arq(struct iavf_hw *hw)
+static enum iavf_status i40e_shutdown_arq(struct iavf_hw *hw)
 {
-	iavf_status ret_code = 0;
+	enum iavf_status ret_code = 0;
 
 	mutex_lock(&hw->aq.arq_mutex);
 
@@ -505,9 +505,9 @@ static iavf_status i40e_shutdown_arq(struct iavf_hw *hw)
  *     - hw->aq.arq_buf_size
  *     - hw->aq.asq_buf_size
  **/
-iavf_status iavf_init_adminq(struct iavf_hw *hw)
+enum iavf_status iavf_init_adminq(struct iavf_hw *hw)
 {
-	iavf_status ret_code;
+	enum iavf_status ret_code;
 
 	/* verify input for valid configuration */
 	if ((hw->aq.num_arq_entries == 0) ||
@@ -549,9 +549,9 @@ iavf_status iavf_init_adminq(struct iavf_hw *hw)
  *  iavf_shutdown_adminq - shutdown routine for the Admin Queue
  *  @hw: pointer to the hardware structure
  **/
-iavf_status iavf_shutdown_adminq(struct iavf_hw *hw)
+enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw)
 {
-	iavf_status ret_code = 0;
+	enum iavf_status ret_code = 0;
 
 	if (iavf_check_asq_alive(hw))
 		iavf_aq_queue_shutdown(hw, true);
@@ -629,16 +629,17 @@ bool iavf_asq_done(struct iavf_hw *hw)
  *  This is the main send command driver routine for the Admin Queue send
  *  queue.  It runs the queue, cleans the queue, etc
  **/
-iavf_status iavf_asq_send_command(struct iavf_hw *hw, struct i40e_aq_desc *desc,
-				  void *buff, /* can be NULL */
-				  u16  buff_size,
-				  struct i40e_asq_cmd_details *cmd_details)
+enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
+				       struct i40e_aq_desc *desc,
+				       void *buff, /* can be NULL */
+				       u16  buff_size,
+				       struct i40e_asq_cmd_details *cmd_details)
 {
 	struct iavf_dma_mem *dma_buff = NULL;
 	struct i40e_asq_cmd_details *details;
 	struct i40e_aq_desc *desc_on_ring;
 	bool cmd_completed = false;
-	iavf_status status = 0;
+	enum iavf_status status = 0;
 	u16  retval = 0;
 	u32  val = 0;
 
@@ -841,13 +842,13 @@ void iavf_fill_default_direct_cmd_desc(struct i40e_aq_desc *desc, u16 opcode)
  *  the contents through e.  It can also return how many events are
  *  left to process through 'pending'
  **/
-iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
-				   struct i40e_arq_event_info *e,
-				   u16 *pending)
+enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
+					struct i40e_arq_event_info *e,
+					u16 *pending)
 {
 	u16 ntc = hw->aq.arq.next_to_clean;
 	struct i40e_aq_desc *desc;
-	iavf_status ret_code = 0;
+	enum iavf_status ret_code = 0;
 	struct iavf_dma_mem *bi;
 	u16 desc_idx;
 	u16 datalen;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_alloc.h b/drivers/net/ethernet/intel/iavf/iavf_alloc.h
index bf2753146f30..2711573c14ec 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_alloc.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_alloc.h
@@ -20,12 +20,15 @@ enum iavf_memory_type {
 };
 
 /* prototype for functions used for dynamic memory allocation */
-iavf_status iavf_allocate_dma_mem(struct iavf_hw *hw, struct iavf_dma_mem *mem,
-				  enum iavf_memory_type type,
-				  u64 size, u32 alignment);
-iavf_status iavf_free_dma_mem(struct iavf_hw *hw, struct iavf_dma_mem *mem);
-iavf_status iavf_allocate_virt_mem(struct iavf_hw *hw,
-				   struct iavf_virt_mem *mem, u32 size);
-iavf_status iavf_free_virt_mem(struct iavf_hw *hw, struct iavf_virt_mem *mem);
+enum iavf_status iavf_allocate_dma_mem(struct iavf_hw *hw,
+				       struct iavf_dma_mem *mem,
+				       enum iavf_memory_type type,
+				       u64 size, u32 alignment);
+enum iavf_status iavf_free_dma_mem(struct iavf_hw *hw,
+				   struct iavf_dma_mem *mem);
+enum iavf_status iavf_allocate_virt_mem(struct iavf_hw *hw,
+					struct iavf_virt_mem *mem, u32 size);
+enum iavf_status iavf_free_virt_mem(struct iavf_hw *hw,
+				    struct iavf_virt_mem *mem);
 
 #endif /* _IAVF_ALLOC_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.c b/drivers/net/ethernet/intel/iavf/iavf_client.c
index ab9db7e9f09d..3cdcaac75b70 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_client.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_client.c
@@ -135,7 +135,7 @@ void iavf_notify_client_open(struct iavf_vsi *vsi)
 static int iavf_client_release_qvlist(struct i40e_info *ldev)
 {
 	struct iavf_adapter *adapter = ldev->vf;
-	iavf_status err;
+	enum iavf_status err;
 
 	if (adapter->aq_required)
 		return -EAGAIN;
@@ -420,7 +420,7 @@ static u32 iavf_client_virtchnl_send(struct i40e_info *ldev,
 				     u8 *msg, u16 len)
 {
 	struct iavf_adapter *adapter = ldev->vf;
-	iavf_status err;
+	enum iavf_status err;
 
 	if (adapter->aq_required)
 		return -EAGAIN;
@@ -449,7 +449,7 @@ static int iavf_client_setup_qvlist(struct i40e_info *ldev,
 	struct virtchnl_iwarp_qvlist_info *v_qvlist_info;
 	struct iavf_adapter *adapter = ldev->vf;
 	struct i40e_qv_info *qv_info;
-	iavf_status err;
+	enum iavf_status err;
 	u32 v_idx, i;
 	size_t msg_size;
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index d9d9f6060353..44cd15793bb5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -13,9 +13,9 @@
  * This function sets the mac type of the adapter based on the
  * vendor ID and device ID stored in the hw structure.
  **/
-iavf_status iavf_set_mac_type(struct iavf_hw *hw)
+enum iavf_status iavf_set_mac_type(struct iavf_hw *hw)
 {
-	iavf_status status = 0;
+	enum iavf_status status = 0;
 
 	if (hw->vendor_id == PCI_VENDOR_ID_INTEL) {
 		switch (hw->device_id) {
@@ -104,7 +104,7 @@ const char *iavf_aq_str(struct iavf_hw *hw, enum i40e_admin_queue_err aq_err)
  * @hw: pointer to the HW structure
  * @stat_err: the status error code to convert
  **/
-const char *iavf_stat_str(struct iavf_hw *hw, iavf_status stat_err)
+const char *iavf_stat_str(struct iavf_hw *hw, enum iavf_status stat_err)
 {
 	switch (stat_err) {
 	case 0:
@@ -327,12 +327,12 @@ bool iavf_check_asq_alive(struct iavf_hw *hw)
  * Tell the Firmware that we're shutting down the AdminQ and whether
  * or not the driver is unloading as well.
  **/
-iavf_status iavf_aq_queue_shutdown(struct iavf_hw *hw, bool unloading)
+enum iavf_status iavf_aq_queue_shutdown(struct iavf_hw *hw, bool unloading)
 {
 	struct i40e_aq_desc desc;
 	struct i40e_aqc_queue_shutdown *cmd =
 		(struct i40e_aqc_queue_shutdown *)&desc.params.raw;
-	iavf_status status;
+	enum iavf_status status;
 
 	iavf_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_queue_shutdown);
 
@@ -354,12 +354,12 @@ iavf_status iavf_aq_queue_shutdown(struct iavf_hw *hw, bool unloading)
  *
  * Internal function to get or set RSS look up table
  **/
-static iavf_status iavf_aq_get_set_rss_lut(struct iavf_hw *hw,
-					   u16 vsi_id, bool pf_lut,
-					   u8 *lut, u16 lut_size,
-					   bool set)
+static enum iavf_status iavf_aq_get_set_rss_lut(struct iavf_hw *hw,
+						u16 vsi_id, bool pf_lut,
+						u8 *lut, u16 lut_size,
+						bool set)
 {
-	iavf_status status;
+	enum iavf_status status;
 	struct i40e_aq_desc desc;
 	struct i40e_aqc_get_set_rss_lut *cmd_resp =
 		   (struct i40e_aqc_get_set_rss_lut *)&desc.params.raw;
@@ -407,8 +407,8 @@ static iavf_status iavf_aq_get_set_rss_lut(struct iavf_hw *hw,
  *
  * get the RSS lookup table, PF or VSI type
  **/
-iavf_status iavf_aq_get_rss_lut(struct iavf_hw *hw, u16 vsi_id,
-				bool pf_lut, u8 *lut, u16 lut_size)
+enum iavf_status iavf_aq_get_rss_lut(struct iavf_hw *hw, u16 vsi_id,
+				     bool pf_lut, u8 *lut, u16 lut_size)
 {
 	return iavf_aq_get_set_rss_lut(hw, vsi_id, pf_lut, lut, lut_size,
 				       false);
@@ -424,8 +424,8 @@ iavf_status iavf_aq_get_rss_lut(struct iavf_hw *hw, u16 vsi_id,
  *
  * set the RSS lookup table, PF or VSI type
  **/
-iavf_status iavf_aq_set_rss_lut(struct iavf_hw *hw, u16 vsi_id,
-				bool pf_lut, u8 *lut, u16 lut_size)
+enum iavf_status iavf_aq_set_rss_lut(struct iavf_hw *hw, u16 vsi_id,
+				     bool pf_lut, u8 *lut, u16 lut_size)
 {
 	return iavf_aq_get_set_rss_lut(hw, vsi_id, pf_lut, lut, lut_size, true);
 }
@@ -439,12 +439,12 @@ iavf_status iavf_aq_set_rss_lut(struct iavf_hw *hw, u16 vsi_id,
  *
  * get the RSS key per VSI
  **/
-static
+static enum
 iavf_status iavf_aq_get_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
 				    struct i40e_aqc_get_set_rss_key_data *key,
 				    bool set)
 {
-	iavf_status status;
+	enum iavf_status status;
 	struct i40e_aq_desc desc;
 	struct i40e_aqc_get_set_rss_key *cmd_resp =
 			(struct i40e_aqc_get_set_rss_key *)&desc.params.raw;
@@ -479,8 +479,8 @@ iavf_status iavf_aq_get_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
  * @key: pointer to key info struct
  *
  **/
-iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 vsi_id,
-				struct i40e_aqc_get_set_rss_key_data *key)
+enum iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 vsi_id,
+				     struct i40e_aqc_get_set_rss_key_data *key)
 {
 	return iavf_aq_get_set_rss_key(hw, vsi_id, key, false);
 }
@@ -493,8 +493,8 @@ iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 vsi_id,
  *
  * set the RSS key per VSI
  **/
-iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
-				struct i40e_aqc_get_set_rss_key_data *key)
+enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
+				     struct i40e_aqc_get_set_rss_key_data *key)
 {
 	return iavf_aq_get_set_rss_key(hw, vsi_id, key, true);
 }
@@ -877,14 +877,15 @@ struct iavf_rx_ptype_decoded iavf_ptype_lookup[] = {
  * is sent asynchronously, i.e. iavf_asq_send_command() does not wait for
  * completion before returning.
  **/
-iavf_status iavf_aq_send_msg_to_pf(struct iavf_hw *hw,
-				   enum virtchnl_ops v_opcode,
-				   iavf_status v_retval, u8 *msg, u16 msglen,
-				   struct i40e_asq_cmd_details *cmd_details)
+enum iavf_status iavf_aq_send_msg_to_pf(struct iavf_hw *hw,
+					enum virtchnl_ops v_opcode,
+					enum iavf_status v_retval,
+					u8 *msg, u16 msglen,
+					struct i40e_asq_cmd_details *cmd_details)
 {
 	struct i40e_asq_cmd_details details;
 	struct i40e_aq_desc desc;
-	iavf_status status;
+	enum iavf_status status;
 
 	iavf_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_send_msg_to_pf);
 	desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_SI);
@@ -948,7 +949,7 @@ void iavf_vf_parse_hw_config(struct iavf_hw *hw,
  * as none will be forthcoming. Immediately after calling this function,
  * the admin queue should be shut down and (optionally) reinitialized.
  **/
-iavf_status iavf_vf_reset(struct iavf_hw *hw)
+enum iavf_status iavf_vf_reset(struct iavf_hw *hw)
 {
 	return iavf_aq_send_msg_to_pf(hw, VIRTCHNL_OP_RESET_VF,
 				      0, NULL, 0, NULL);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 78340b297dab..ab4e3573f9db 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -66,9 +66,9 @@ static struct workqueue_struct *iavf_wq;
  * @size: size of memory requested
  * @alignment: what to align the allocation to
  **/
-iavf_status iavf_allocate_dma_mem_d(struct iavf_hw *hw,
-				    struct iavf_dma_mem *mem,
-				    u64 size, u32 alignment)
+enum iavf_status iavf_allocate_dma_mem_d(struct iavf_hw *hw,
+					 struct iavf_dma_mem *mem,
+					 u64 size, u32 alignment)
 {
 	struct iavf_adapter *adapter = (struct iavf_adapter *)hw->back;
 
@@ -89,7 +89,8 @@ iavf_status iavf_allocate_dma_mem_d(struct iavf_hw *hw,
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to free
  **/
-iavf_status iavf_free_dma_mem_d(struct iavf_hw *hw, struct iavf_dma_mem *mem)
+enum iavf_status iavf_free_dma_mem_d(struct iavf_hw *hw,
+				     struct iavf_dma_mem *mem)
 {
 	struct iavf_adapter *adapter = (struct iavf_adapter *)hw->back;
 
@@ -106,8 +107,8 @@ iavf_status iavf_free_dma_mem_d(struct iavf_hw *hw, struct iavf_dma_mem *mem)
  * @mem:  ptr to mem struct to fill out
  * @size: size of memory requested
  **/
-iavf_status iavf_allocate_virt_mem_d(struct iavf_hw *hw,
-				     struct iavf_virt_mem *mem, u32 size)
+enum iavf_status iavf_allocate_virt_mem_d(struct iavf_hw *hw,
+					  struct iavf_virt_mem *mem, u32 size)
 {
 	if (!mem)
 		return I40E_ERR_PARAM;
@@ -126,7 +127,8 @@ iavf_status iavf_allocate_virt_mem_d(struct iavf_hw *hw,
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to free
  **/
-iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw, struct iavf_virt_mem *mem)
+enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
+				      struct iavf_virt_mem *mem)
 {
 	if (!mem)
 		return I40E_ERR_PARAM;
@@ -2022,7 +2024,7 @@ static void iavf_adminq_task(struct work_struct *work)
 	struct iavf_hw *hw = &adapter->hw;
 	struct i40e_arq_event_info event;
 	enum virtchnl_ops v_op;
-	iavf_status ret, v_ret;
+	enum iavf_status ret, v_ret;
 	u32 val, oldval;
 	u16 pending;
 
@@ -2037,7 +2039,7 @@ static void iavf_adminq_task(struct work_struct *work)
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
 		v_op = (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
-		v_ret = (iavf_status)le32_to_cpu(event.desc.cookie_low);
+		v_ret = (enum iavf_status)le32_to_cpu(event.desc.cookie_low);
 
 		if (ret || !v_op)
 			break; /* No event to process or error cleaning ARQ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_osdep.h b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
index c90cafb526d0..d39684558597 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
@@ -48,5 +48,4 @@ struct iavf_virt_mem {
 extern void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
 	__printf(3, 4);
 
-typedef enum iavf_status_code iavf_status;
 #endif /* _IAVF_OSDEP_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_prototype.h b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
index d6685103af39..2ff49dc75e31 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_prototype.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
@@ -16,16 +16,17 @@
  */
 
 /* adminq functions */
-iavf_status iavf_init_adminq(struct iavf_hw *hw);
-iavf_status iavf_shutdown_adminq(struct iavf_hw *hw);
+enum iavf_status iavf_init_adminq(struct iavf_hw *hw);
+enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw);
 void i40e_adminq_init_ring_data(struct iavf_hw *hw);
-iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
-				   struct i40e_arq_event_info *e,
-				   u16 *events_pending);
-iavf_status iavf_asq_send_command(struct iavf_hw *hw, struct i40e_aq_desc *desc,
-				  void *buff, /* can be NULL */
-				  u16 buff_size,
-				  struct i40e_asq_cmd_details *cmd_details);
+enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
+					struct i40e_arq_event_info *e,
+					u16 *events_pending);
+enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
+				       struct i40e_aq_desc *desc,
+				       void *buff, /* can be NULL */
+				       u16 buff_size,
+				       struct i40e_asq_cmd_details *cmd_details);
 bool iavf_asq_done(struct iavf_hw *hw);
 
 /* debug function for adminq */
@@ -35,20 +36,20 @@ void iavf_debug_aq(struct iavf_hw *hw, enum iavf_debug_mask mask,
 void i40e_idle_aq(struct iavf_hw *hw);
 void iavf_resume_aq(struct iavf_hw *hw);
 bool iavf_check_asq_alive(struct iavf_hw *hw);
-iavf_status iavf_aq_queue_shutdown(struct iavf_hw *hw, bool unloading);
+enum iavf_status iavf_aq_queue_shutdown(struct iavf_hw *hw, bool unloading);
 const char *iavf_aq_str(struct iavf_hw *hw, enum i40e_admin_queue_err aq_err);
-const char *iavf_stat_str(struct iavf_hw *hw, iavf_status stat_err);
+const char *iavf_stat_str(struct iavf_hw *hw, enum iavf_status stat_err);
 
-iavf_status iavf_aq_get_rss_lut(struct iavf_hw *hw, u16 seid,
-				bool pf_lut, u8 *lut, u16 lut_size);
-iavf_status iavf_aq_set_rss_lut(struct iavf_hw *hw, u16 seid,
-				bool pf_lut, u8 *lut, u16 lut_size);
-iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 seid,
-				struct i40e_aqc_get_set_rss_key_data *key);
-iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 seid,
-				struct i40e_aqc_get_set_rss_key_data *key);
+enum iavf_status iavf_aq_get_rss_lut(struct iavf_hw *hw, u16 seid,
+				     bool pf_lut, u8 *lut, u16 lut_size);
+enum iavf_status iavf_aq_set_rss_lut(struct iavf_hw *hw, u16 seid,
+				     bool pf_lut, u8 *lut, u16 lut_size);
+enum iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 seid,
+				     struct i40e_aqc_get_set_rss_key_data *key);
+enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 seid,
+				     struct i40e_aqc_get_set_rss_key_data *key);
 
-iavf_status iavf_set_mac_type(struct iavf_hw *hw);
+enum iavf_status iavf_set_mac_type(struct iavf_hw *hw);
 
 extern struct iavf_rx_ptype_decoded iavf_ptype_lookup[];
 
@@ -59,9 +60,10 @@ static inline struct iavf_rx_ptype_decoded decode_rx_desc_ptype(u8 ptype)
 
 void iavf_vf_parse_hw_config(struct iavf_hw *hw,
 			     struct virtchnl_vf_resource *msg);
-iavf_status iavf_vf_reset(struct iavf_hw *hw);
-iavf_status iavf_aq_send_msg_to_pf(struct iavf_hw *hw,
-				   enum virtchnl_ops v_opcode,
-				   iavf_status v_retval, u8 *msg, u16 msglen,
-				   struct i40e_asq_cmd_details *cmd_details);
+enum iavf_status iavf_vf_reset(struct iavf_hw *hw);
+enum iavf_status iavf_aq_send_msg_to_pf(struct iavf_hw *hw,
+					enum virtchnl_ops v_opcode,
+					enum iavf_status v_retval,
+					u8 *msg, u16 msglen,
+					struct i40e_asq_cmd_details *cmd_details);
 #endif /* _IAVF_PROTOTYPE_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_status.h b/drivers/net/ethernet/intel/iavf/iavf_status.h
index 46742fab7b8c..95026298685d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_status.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_status.h
@@ -5,7 +5,7 @@
 #define _IAVF_STATUS_H_
 
 /* Error Codes */
-enum iavf_status_code {
+enum iavf_status {
 	I40E_SUCCESS				= 0,
 	I40E_ERR_NVM				= -1,
 	I40E_ERR_NVM_CHECKSUM			= -2,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 357c74bc3265..95457869f249 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -22,7 +22,7 @@ static int iavf_send_pf_msg(struct iavf_adapter *adapter,
 			    enum virtchnl_ops op, u8 *msg, u16 len)
 {
 	struct iavf_hw *hw = &adapter->hw;
-	iavf_status err;
+	enum iavf_status err;
 
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		return 0; /* nothing to see here, move along */
@@ -69,7 +69,7 @@ int iavf_verify_api_ver(struct iavf_adapter *adapter)
 	struct iavf_hw *hw = &adapter->hw;
 	struct i40e_arq_event_info event;
 	enum virtchnl_ops op;
-	iavf_status err;
+	enum iavf_status err;
 
 	event.buf_len = IAVF_MAX_AQ_BUF_SIZE;
 	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
@@ -92,7 +92,7 @@ int iavf_verify_api_ver(struct iavf_adapter *adapter)
 	}
 
 
-	err = (iavf_status)le32_to_cpu(event.desc.cookie_low);
+	err = (enum iavf_status)le32_to_cpu(event.desc.cookie_low);
 	if (err)
 		goto out_alloc;
 
@@ -191,7 +191,7 @@ int iavf_get_vf_config(struct iavf_adapter *adapter)
 	struct iavf_hw *hw = &adapter->hw;
 	struct i40e_arq_event_info event;
 	enum virtchnl_ops op;
-	iavf_status err;
+	enum iavf_status err;
 	u16 len;
 
 	len =  sizeof(struct virtchnl_vf_resource) +
@@ -216,7 +216,7 @@ int iavf_get_vf_config(struct iavf_adapter *adapter)
 			break;
 	}
 
-	err = (iavf_status)le32_to_cpu(event.desc.cookie_low);
+	err = (enum iavf_status)le32_to_cpu(event.desc.cookie_low);
 	memcpy(adapter->vf_res, event.msg_buf, min(event.msg_len, len));
 
 	/* some PFs send more queues than we should have so validate that
@@ -1184,8 +1184,8 @@ void iavf_request_reset(struct iavf_adapter *adapter)
  * This function handles the reply messages.
  **/
 void iavf_virtchnl_completion(struct iavf_adapter *adapter,
-			      enum virtchnl_ops v_opcode, iavf_status v_retval,
-			      u8 *msg, u16 msglen)
+			      enum virtchnl_ops v_opcode,
+			      enum iavf_status v_retval, u8 *msg, u16 msglen)
 {
 	struct net_device *netdev = adapter->netdev;
 
-- 
2.21.0

