Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B459277D0A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgIYAkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgIYAk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:40:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83CFC0613D4
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:40:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 139so1033778ybe.15
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=fYl5lM0Fn6DS4iK0oFZUAw+DA01KyIzNf6yDjoDQYi4=;
        b=usIZdSAsc/LONzBr7dmNq1nDo2wHoIGz0+EsgrpeOlG7GaOd5fjzVhGKyn8xTOGCoA
         qUVM0nYWsFDwpDikhFFchIT37tOt0E/CSxkCRePi/9eXsOFpjSBJRnOQpwEihOLsuyrn
         w/JNDU9svxW7A+JGXa9mjZUVC3XdRVoTRz01ah2UEupqU14ixemAoQ2vmWOYRZTNBbsd
         GeDxldFCHF9bvaOBdaC+rtL1wrTKnlNiyQ/6mGU5wYVyIcB7XWIL+kqA2pFAsXaac8U5
         TihDEkqxK3MT/4kQ53wRcjwWZfgP8zpO7yM9D4U1rw7WFxiE2WW1yI3cD5BIREl6sW6v
         YZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fYl5lM0Fn6DS4iK0oFZUAw+DA01KyIzNf6yDjoDQYi4=;
        b=sThkiLANLyrq+tVHJHZEd5TEgwqbFeGIr4hdWI10P6NHdSBeR5Vo7e5/g7HaIlgC/9
         EjVieIf7U+5pUTnHoyv7xQIBHeF3hyKxsGIQgeQAXFpCeMGm09ILDyNPZGd6HRjiD7E1
         DdSWLpjB77yyVUeSZov5PhE9ZNJv2akbIlqmWpBvzpsMTwVcZer8/rmODfln11tK3bas
         EJvF/ZV2bXjw5iW5g8oc2Tn6pfBUngR/FI9vjC3CGLbnoGxP4XF8M9BudzKULN+hIzVs
         wtefGEvYrTuSN3LQrByBHlkdlEa07heq012cx96Od6SZcEq5CveX3kQcLNCEVX55lwuu
         zwDA==
X-Gm-Message-State: AOAM5331cYLVtJGobePpDKi9BHKfMDFF8gWLEuNHC+Y8PEy1EtIW5zQj
        lEPUnwfrotTc/qEGgncqGaGycWxQMTbbo3FYVyto
X-Google-Smtp-Source: ABdhPJx1GMLRW4TL0sTFCj5xA6AShOE5omxytNHdYjpCv9qugy/sA8zZyu6IHAc9YbBCDleNlL3nOWr1POlmyXa34trX
Sender: "danielwinkler via sendgmr" 
        <danielwinkler@danielwinkler-linux.mtv.corp.google.com>
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a25:e0d2:: with SMTP id
 x201mr2071788ybg.180.1600994425045; Thu, 24 Sep 2020 17:40:25 -0700 (PDT)
Date:   Thu, 24 Sep 2020 17:40:04 -0700
In-Reply-To: <20200925004007.2378410-1-danielwinkler@google.com>
Message-Id: <20200924173752.v3.2.Id8bee28ed00d158d0894b32c0cd94baa5a012605@changeid>
Mime-Version: 1.0
References: <20200925004007.2378410-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v3 2/5] Bluetooth: Break add adv into two mgmt commands
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Daniel Winkler <danielwinkler@google.com>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the new advertising add interface, with the
first command setting advertising parameters and the second to set
advertising data. The set parameters command allows the caller to leave
some fields "unset", with a params bitfield defining which params were
purposefully set. Unset parameters will be given defaults when calling
hci_add_adv_instance. The data passed to the param mgmt command is
allowed to be flexible, so in the future if bluetoothd passes a larger
structure with new params, the mgmt command will ignore the unknown
members at the end.

This change has been validated on both hatch (extended advertising) and
kukui (no extended advertising) chromebooks running bluetoothd that
support this new interface. I ran the following manual tests:
- Set several (3) advertisements using modified test_advertisement.py
- For each, validate correct data and parameters in btmon trace
- Verified both for software rotation and extended adv

Automatic test suite also run, testing many (25) scenarios of single and
multi-advertising for data/parameter correctness.

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

Changes in v3:
- Adding selected tx power to adv params mgmt response, removing event

Changes in v2: None

 include/net/bluetooth/hci_core.h |   2 +
 include/net/bluetooth/mgmt.h     |  34 +++
 net/bluetooth/hci_event.c        |   1 +
 net/bluetooth/mgmt.c             | 368 ++++++++++++++++++++++++++++++-
 4 files changed, 394 insertions(+), 11 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 300b3572d479e1..48d144ae8b57d6 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -238,6 +238,8 @@ struct adv_info {
 #define HCI_MAX_ADV_INSTANCES		5
 #define HCI_DEFAULT_ADV_DURATION	2
 
+#define HCI_ADV_TX_POWER_NO_PREFERENCE 0x7F
+
 struct adv_pattern {
 	struct list_head list;
 	__u8 ad_type;
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 6b55155e05e977..83f684af3ae843 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -782,6 +782,40 @@ struct mgmt_rp_remove_adv_monitor {
 	__le16 monitor_handle;
 } __packed;
 
+#define MGMT_ADV_PARAM_DURATION		BIT(0)
+#define MGMT_ADV_PARAM_TIMEOUT		BIT(1)
+#define MGMT_ADV_PARAM_INTERVALS	BIT(2)
+#define MGMT_ADV_PARAM_TX_POWER		BIT(3)
+
+#define MGMT_OP_ADD_EXT_ADV_PARAMS		0x0054
+struct mgmt_cp_add_ext_adv_params {
+	__u8	instance;
+	__le32	flags;
+	__le16	params;
+	__le16	duration;
+	__le16	timeout;
+	__le32	min_interval;
+	__le32	max_interval;
+	__s8	tx_power;
+} __packed;
+#define MGMT_ADD_EXT_ADV_PARAMS_MIN_SIZE	20
+struct mgmt_rp_add_ext_adv_params {
+	__u8	instance;
+	__s8	tx_power;
+} __packed;
+
+#define MGMT_OP_ADD_EXT_ADV_DATA		0x0055
+struct mgmt_cp_add_ext_adv_data {
+	__u8	instance;
+	__u8	adv_data_len;
+	__u8	scan_rsp_len;
+	__u8	data[];
+} __packed;
+#define MGMT_ADD_EXT_ADV_DATA_SIZE	3
+struct mgmt_rp_add_ext_adv_data {
+	__u8	instance;
+} __packed;
+
 #define MGMT_EV_CMD_COMPLETE		0x0001
 struct mgmt_ev_cmd_complete {
 	__le16	opcode;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index bd306ba3ade545..4281f4ac6700d4 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1749,6 +1749,7 @@ static void hci_cc_set_ext_adv_param(struct hci_dev *hdev, struct sk_buff *skb)
 	}
 	/* Update adv data as tx power is known now */
 	hci_req_update_adv_data(hdev, hdev->cur_adv_instance);
+
 	hci_dev_unlock(hdev);
 }
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 0b711ad80f6bd1..ee425fec43bf1b 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -122,6 +122,8 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_READ_ADV_MONITOR_FEATURES,
 	MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
 	MGMT_OP_REMOVE_ADV_MONITOR,
+	MGMT_OP_ADD_EXT_ADV_PARAMS,
+	MGMT_OP_ADD_EXT_ADV_DATA,
 };
 
 static const u16 mgmt_events[] = {
@@ -7372,6 +7374,31 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
 	return true;
 }
 
+static bool requested_adv_flags_are_valid(struct hci_dev *hdev, u32 adv_flags)
+{
+	u32 supported_flags, phy_flags;
+
+	/* The current implementation only supports a subset of the specified
+	 * flags. Also need to check mutual exclusiveness of sec flags.
+	 */
+	supported_flags = get_supported_adv_flags(hdev);
+	phy_flags = adv_flags & MGMT_ADV_FLAG_SEC_MASK;
+	if (adv_flags & ~supported_flags ||
+	    ((phy_flags && (phy_flags ^ (phy_flags & -phy_flags)))))
+		return false;
+
+	return true;
+}
+
+static bool adv_busy(struct hci_dev *hdev)
+{
+	return (pending_find(MGMT_OP_ADD_ADVERTISING, hdev) ||
+		pending_find(MGMT_OP_REMOVE_ADVERTISING, hdev) ||
+		pending_find(MGMT_OP_SET_LE, hdev) ||
+		pending_find(MGMT_OP_ADD_EXT_ADV_PARAMS, hdev) ||
+		pending_find(MGMT_OP_ADD_EXT_ADV_DATA, hdev));
+}
+
 static void add_advertising_complete(struct hci_dev *hdev, u8 status,
 				     u16 opcode)
 {
@@ -7386,6 +7413,8 @@ static void add_advertising_complete(struct hci_dev *hdev, u8 status,
 	hci_dev_lock(hdev);
 
 	cmd = pending_find(MGMT_OP_ADD_ADVERTISING, hdev);
+	if (!cmd)
+		cmd = pending_find(MGMT_OP_ADD_EXT_ADV_DATA, hdev);
 
 	list_for_each_entry_safe(adv_instance, n, &hdev->adv_instances, list) {
 		if (!adv_instance->pending)
@@ -7430,7 +7459,6 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	struct mgmt_cp_add_advertising *cp = data;
 	struct mgmt_rp_add_advertising rp;
 	u32 flags;
-	u32 supported_flags, phy_flags;
 	u8 status;
 	u16 timeout, duration;
 	unsigned int prev_instance_cnt = hdev->adv_instance_cnt;
@@ -7466,13 +7494,7 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	timeout = __le16_to_cpu(cp->timeout);
 	duration = __le16_to_cpu(cp->duration);
 
-	/* The current implementation only supports a subset of the specified
-	 * flags. Also need to check mutual exclusiveness of sec flags.
-	 */
-	supported_flags = get_supported_adv_flags(hdev);
-	phy_flags = flags & MGMT_ADV_FLAG_SEC_MASK;
-	if (flags & ~supported_flags ||
-	    ((phy_flags && (phy_flags ^ (phy_flags & -phy_flags)))))
+	if (!requested_adv_flags_are_valid(hdev, flags))
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 				       MGMT_STATUS_INVALID_PARAMS);
 
@@ -7484,9 +7506,7 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	if (pending_find(MGMT_OP_ADD_ADVERTISING, hdev) ||
-	    pending_find(MGMT_OP_REMOVE_ADVERTISING, hdev) ||
-	    pending_find(MGMT_OP_SET_LE, hdev)) {
+	if (adv_busy(hdev)) {
 		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 				      MGMT_STATUS_BUSY);
 		goto unlock;
@@ -7577,6 +7597,328 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
+static void add_ext_adv_params_complete(struct hci_dev *hdev, u8 status,
+					u16 opcode)
+{
+	struct mgmt_pending_cmd *cmd;
+	struct mgmt_cp_add_ext_adv_params *cp;
+	struct mgmt_rp_add_ext_adv_params rp;
+	struct adv_info *adv_instance;
+
+	BT_DBG("%s", hdev->name);
+
+	hci_dev_lock(hdev);
+
+	cmd = pending_find(MGMT_OP_ADD_EXT_ADV_PARAMS, hdev);
+	if (!cmd)
+		goto unlock;
+
+	cp = cmd->param;
+	adv_instance = hci_find_adv_instance(hdev, cp->instance);
+	if (!adv_instance)
+		goto unlock;
+
+	rp.instance = cp->instance;
+	rp.tx_power = adv_instance->tx_power;
+
+	if (status) {
+		/* If this advertisement was previously advertising and we
+		 * failed to update it, we signal that it has been removed and
+		 * delete its structure
+		 */
+		if (!adv_instance->pending)
+			mgmt_advertising_removed(cmd->sk, hdev, cp->instance);
+
+		hci_remove_adv_instance(hdev, cp->instance);
+
+		mgmt_cmd_status(cmd->sk, cmd->index, cmd->opcode,
+				mgmt_status(status));
+
+	} else {
+		mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
+				  mgmt_status(status), &rp, sizeof(rp));
+	}
+
+unlock:
+	if (cmd)
+		mgmt_pending_remove(cmd);
+
+	hci_dev_unlock(hdev);
+}
+
+static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
+			      void *data, u16 data_len)
+{
+	struct mgmt_cp_add_ext_adv_params *cp = data;
+	struct mgmt_rp_add_ext_adv_params rp;
+	struct mgmt_pending_cmd *cmd = NULL;
+	struct adv_info *adv_instance;
+	struct hci_request req;
+	u32 flags, min_interval, max_interval;
+	u16 params, timeout, duration;
+	u8 status;
+	s8 tx_power;
+	int err;
+
+	BT_DBG("%s", hdev->name);
+
+	status = mgmt_le_support(hdev);
+	if (status)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_PARAMS,
+				       status);
+
+	if (cp->instance < 1 || cp->instance > hdev->le_num_of_adv_sets)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_PARAMS,
+				       MGMT_STATUS_INVALID_PARAMS);
+
+	/* The purpose of breaking add_advertising into two separate MGMT calls
+	 * for params and data is to allow more parameters to be added to this
+	 * structure in the future. For this reason, we verify that we have the
+	 * bare minimum structure we know of when the interface was defined. Any
+	 * extra parameters we don't know about will be ignored in this request.
+	 */
+	if (data_len < MGMT_ADD_EXT_ADV_PARAMS_MIN_SIZE)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
+				       MGMT_STATUS_INVALID_PARAMS);
+
+	flags = __le32_to_cpu(cp->flags);
+	params = __le16_to_cpu(cp->params);
+
+	if (!requested_adv_flags_are_valid(hdev, flags))
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_PARAMS,
+				       MGMT_STATUS_INVALID_PARAMS);
+
+	hci_dev_lock(hdev);
+
+	/* In new interface, we require that we are powered to register */
+	if (!hdev_is_powered(hdev)) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_PARAMS,
+				      MGMT_STATUS_REJECTED);
+		goto unlock;
+	}
+
+	if (adv_busy(hdev)) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_PARAMS,
+				      MGMT_STATUS_BUSY);
+		goto unlock;
+	}
+
+	/* Parse defined parameters from request, use defaults otherwise */
+	timeout = (params & MGMT_ADV_PARAM_TIMEOUT) ?
+		  __le16_to_cpu(cp->timeout) : 0;
+
+	duration = (params & MGMT_ADV_PARAM_DURATION) ?
+		   __le16_to_cpu(cp->duration) :
+		   hdev->def_multi_adv_rotation_duration;
+
+	min_interval = (params & MGMT_ADV_PARAM_INTERVALS) ?
+		       __le32_to_cpu(cp->min_interval) :
+		       hdev->le_adv_min_interval;
+
+	max_interval = (params & MGMT_ADV_PARAM_INTERVALS) ?
+		       __le32_to_cpu(cp->max_interval) :
+		       hdev->le_adv_max_interval;
+
+	tx_power = (params & MGMT_ADV_PARAM_TX_POWER) ?
+		   cp->tx_power :
+		   HCI_ADV_TX_POWER_NO_PREFERENCE;
+
+	/* Create advertising instance with no advertising or response data */
+	err = hci_add_adv_instance(hdev, cp->instance, flags,
+				   0, NULL, 0, NULL, timeout, duration);
+
+	if (err < 0) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_PARAMS,
+				      MGMT_STATUS_FAILED);
+		goto unlock;
+	}
+
+	hdev->cur_adv_instance = cp->instance;
+	/* Submit request for advertising params if ext adv available */
+	if (ext_adv_capable(hdev)) {
+		hci_req_init(&req, hdev);
+		adv_instance = hci_find_adv_instance(hdev, cp->instance);
+
+		/* Updating parameters of an active instance will return a
+		 * Command Disallowed error, so we must first disable the
+		 * instance if it is active.
+		 */
+		if (!adv_instance->pending)
+			__hci_req_disable_ext_adv_instance(&req, cp->instance);
+
+		__hci_req_setup_ext_adv_instance(&req, cp->instance);
+
+		err = hci_req_run(&req, add_ext_adv_params_complete);
+
+		if (!err)
+			cmd = mgmt_pending_add(sk, MGMT_OP_ADD_EXT_ADV_PARAMS,
+					       hdev, data, data_len);
+		if (!cmd) {
+			err = -ENOMEM;
+			hci_remove_adv_instance(hdev, cp->instance);
+			goto unlock;
+		}
+
+	} else {
+		rp.instance = cp->instance;
+		rp.tx_power = HCI_ADV_TX_POWER_NO_PREFERENCE;
+		err = mgmt_cmd_complete(sk, hdev->id,
+					MGMT_OP_ADD_EXT_ADV_PARAMS,
+					MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
+	}
+
+unlock:
+	hci_dev_unlock(hdev);
+
+	return err;
+}
+
+static int add_ext_adv_data(struct sock *sk, struct hci_dev *hdev, void *data,
+			    u16 data_len)
+{
+	struct mgmt_cp_add_ext_adv_data *cp = data;
+	struct mgmt_rp_add_ext_adv_data rp;
+	u8 schedule_instance = 0;
+	struct adv_info *next_instance;
+	struct adv_info *adv_instance;
+	int err = 0;
+	struct mgmt_pending_cmd *cmd;
+	struct hci_request req;
+
+	BT_DBG("%s", hdev->name);
+
+	hci_dev_lock(hdev);
+
+	adv_instance = hci_find_adv_instance(hdev, cp->instance);
+
+	if (!adv_instance) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_DATA,
+				      MGMT_STATUS_INVALID_PARAMS);
+		goto unlock;
+	}
+
+	/* In new interface, we require that we are powered to register */
+	if (!hdev_is_powered(hdev)) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_DATA,
+				      MGMT_STATUS_REJECTED);
+		goto clear_new_instance;
+	}
+
+	if (adv_busy(hdev)) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_DATA,
+				      MGMT_STATUS_BUSY);
+		goto clear_new_instance;
+	}
+
+	/* Validate new data */
+	if (!tlv_data_is_valid(hdev, adv_instance->flags, cp->data,
+			       cp->adv_data_len, true) ||
+	    !tlv_data_is_valid(hdev, adv_instance->flags, cp->data +
+			       cp->adv_data_len, cp->scan_rsp_len, false)) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_DATA,
+				      MGMT_STATUS_INVALID_PARAMS);
+		goto clear_new_instance;
+	}
+
+	/* Set the data in the advertising instance */
+	hci_set_adv_instance_data(hdev, cp->instance, cp->adv_data_len,
+				  cp->data, cp->scan_rsp_len,
+				  cp->data + cp->adv_data_len);
+
+	/* We're good to go, update advertising data, parameters, and start
+	 * advertising.
+	 */
+
+	hci_req_init(&req, hdev);
+
+	hci_req_add(&req, HCI_OP_READ_LOCAL_NAME, 0, NULL);
+
+	if (ext_adv_capable(hdev)) {
+		__hci_req_update_adv_data(&req, cp->instance);
+		__hci_req_update_scan_rsp_data(&req, cp->instance);
+		__hci_req_enable_ext_advertising(&req, cp->instance);
+
+	} else {
+		/* If using software rotation, determine next instance to use */
+
+		if (hdev->cur_adv_instance == cp->instance) {
+			/* If the currently advertised instance is being changed
+			 * then cancel the current advertising and schedule the
+			 * next instance. If there is only one instance then the
+			 * overridden advertising data will be visible right
+			 * away
+			 */
+			cancel_adv_timeout(hdev);
+
+			next_instance = hci_get_next_instance(hdev,
+							      cp->instance);
+			if (next_instance)
+				schedule_instance = next_instance->instance;
+		} else if (!hdev->adv_instance_timeout) {
+			/* Immediately advertise the new instance if no other
+			 * instance is currently being advertised.
+			 */
+			schedule_instance = cp->instance;
+		}
+
+		/* If the HCI_ADVERTISING flag is set or there is no instance to
+		 * be advertised then we have no HCI communication to make.
+		 * Simply return.
+		 */
+		if (hci_dev_test_flag(hdev, HCI_ADVERTISING) ||
+		    !schedule_instance) {
+			if (adv_instance->pending) {
+				mgmt_advertising_added(sk, hdev, cp->instance);
+				adv_instance->pending = false;
+			}
+			rp.instance = cp->instance;
+			err = mgmt_cmd_complete(sk, hdev->id,
+						MGMT_OP_ADD_EXT_ADV_DATA,
+						MGMT_STATUS_SUCCESS, &rp,
+						sizeof(rp));
+			goto unlock;
+		}
+
+		err = __hci_req_schedule_adv_instance(&req, schedule_instance,
+						      true);
+	}
+
+	cmd = mgmt_pending_add(sk, MGMT_OP_ADD_EXT_ADV_DATA, hdev, data,
+			       data_len);
+	if (!cmd) {
+		err = -ENOMEM;
+		goto clear_new_instance;
+	}
+
+	if (!err)
+		err = hci_req_run(&req, add_advertising_complete);
+
+	if (err < 0) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_DATA,
+				      MGMT_STATUS_FAILED);
+		mgmt_pending_remove(cmd);
+		goto clear_new_instance;
+	}
+
+	/* We were successful in updating data, so trigger advertising_added
+	 * event if this is an instance that wasn't previously advertising. If
+	 * a failure occurs in the requests we initiated, we will remove the
+	 * instance again in add_advertising_complete
+	 */
+	if (adv_instance->pending)
+		mgmt_advertising_added(sk, hdev, cp->instance);
+
+	goto unlock;
+
+clear_new_instance:
+	hci_remove_adv_instance(hdev, cp->instance);
+
+unlock:
+	hci_dev_unlock(hdev);
+
+	return err;
+}
+
 static void remove_advertising_complete(struct hci_dev *hdev, u8 status,
 					u16 opcode)
 {
@@ -7851,6 +8193,10 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ add_adv_patterns_monitor,MGMT_ADD_ADV_PATTERNS_MONITOR_SIZE,
 						HCI_MGMT_VAR_LEN },
 	{ remove_adv_monitor,      MGMT_REMOVE_ADV_MONITOR_SIZE },
+	{ add_ext_adv_params,      MGMT_ADD_EXT_ADV_PARAMS_MIN_SIZE,
+						HCI_MGMT_VAR_LEN },
+	{ add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
+						HCI_MGMT_VAR_LEN },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.28.0.709.gb0816b6eb0-goog

