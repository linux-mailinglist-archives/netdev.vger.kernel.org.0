Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505602DFA5A
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 10:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgLUJo3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 04:44:29 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:34674 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgLUJnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 04:43:55 -0500
Received: from marcel-macbook.holtmann.net (p4ff9fab6.dip0.t-ipconnect.de [79.249.250.182])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8C067CED02;
        Mon, 21 Dec 2020 10:12:31 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH v3 1/5] Bluetooth: advmon offload MSFT add rssi support
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201216123317.v3.1.I92d2e2a87419730d60136680cbe27636baf94b15@changeid>
Date:   Mon, 21 Dec 2020 10:05:13 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B793BC08-C614-4118-BDD1-05160BCF8809@holtmann.org>
References: <20201216043335.2185278-1-apusaka@google.com>
 <20201216123317.v3.1.I92d2e2a87419730d60136680cbe27636baf94b15@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> MSFT needs rssi parameter for monitoring advertisement packet,
> therefore we should supply them from mgmt. This adds a new opcode
> to add advertisement monitor with rssi parameters.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Yun-Hao Chung <howardchung@google.com>
> 
> ---
> 
> Changes in v3:
> * Flips the order of rssi and pattern_count on mgmt struct
> 
> Changes in v2:
> * Add a new opcode instead of modifying an existing one
> 
> include/net/bluetooth/hci_core.h |  9 +++
> include/net/bluetooth/mgmt.h     | 16 ++++++
> net/bluetooth/mgmt.c             | 99 ++++++++++++++++++++++++--------
> 3 files changed, 101 insertions(+), 23 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 677a8c50b2ad..8b7cf3620938 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -250,8 +250,17 @@ struct adv_pattern {
> 	__u8 value[HCI_MAX_AD_LENGTH];
> };
> 
> +struct adv_rssi_thresholds {
> +	__s8 low_threshold;
> +	__s8 high_threshold;
> +	__u16 low_threshold_timeout;
> +	__u16 high_threshold_timeout;
> +	__u8 sampling_period;
> +};
> +
> struct adv_monitor {
> 	struct list_head patterns;
> +	struct adv_rssi_thresholds rssi;
> 	bool		active;
> 	__u16		handle;
> };
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index f9a6638e20b3..9917b911a4fb 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -821,6 +821,22 @@ struct mgmt_rp_add_ext_adv_data {
> 	__u8	instance;
> } __packed;
> 
> +struct mgmt_adv_rssi_thresholds {
> +	__s8 high_threshold;
> +	__le16 high_threshold_timeout;
> +	__s8 low_threshold;
> +	__le16 low_threshold_timeout;
> +	__u8 sampling_period;
> +} __packed;
> +

please indent this in a away that it stays readable.

	__s8   a
	__le16 b
	..

> +#define MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI	0x0056
> +struct mgmt_cp_add_adv_patterns_monitor_rssi {
> +	struct mgmt_adv_rssi_thresholds rssi;
> +	__u8 pattern_count;
> +	struct mgmt_adv_pattern patterns[];
> +} __packed;
> +#define MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE	8
> +
> #define MGMT_EV_CMD_COMPLETE		0x0001
> struct mgmt_ev_cmd_complete {
> 	__le16	opcode;
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index fa0f7a4a1d2f..cd574054aa39 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -124,6 +124,7 @@ static const u16 mgmt_commands[] = {
> 	MGMT_OP_REMOVE_ADV_MONITOR,
> 	MGMT_OP_ADD_EXT_ADV_PARAMS,
> 	MGMT_OP_ADD_EXT_ADV_DATA,
> +	MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI,
> };
> 
> static const u16 mgmt_events[] = {
> @@ -4225,22 +4226,40 @@ static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
> 	return err;
> }
> 
> -static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> -				    void *data, u16 len)
> +static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> +				      void *data, u16 len, u16 op)
> {
> -	struct mgmt_cp_add_adv_patterns_monitor *cp = data;
> +	struct mgmt_cp_add_adv_patterns_monitor *cp = NULL;
> +	struct mgmt_cp_add_adv_patterns_monitor_rssi *cp_rssi = NULL;
> 	struct mgmt_rp_add_adv_patterns_monitor rp;
> +	struct mgmt_adv_rssi_thresholds *rssi = NULL;
> +	struct mgmt_adv_pattern *patterns = NULL;
> 	struct adv_monitor *m = NULL;
> 	struct adv_pattern *p = NULL;
> 	unsigned int mp_cnt = 0, prev_adv_monitors_cnt;
> 	__u8 cp_ofst = 0, cp_len = 0;
> 	int err, i;
> +	u8 pattern_count;
> +	u16 expected_len;
> 
> 	BT_DBG("request for %s", hdev->name);
> 
> -	if (len <= sizeof(*cp) || cp->pattern_count == 0) {
> -		err = mgmt_cmd_status(sk, hdev->id,
> -				      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
> +	if (op == MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI) {
> +		cp_rssi = data;
> +		pattern_count = cp_rssi->pattern_count;
> +		rssi = &cp_rssi->rssi;
> +		patterns = cp_rssi->patterns;
> +		expected_len = sizeof(*cp_rssi) +
> +			       pattern_count * sizeof(*patterns);
> +	} else {
> +		cp = data;
> +		pattern_count = cp->pattern_count;
> +		patterns = cp->patterns;
> +		expected_len = sizeof(*cp) + pattern_count * sizeof(*patterns);
> +	}
> +
> +	if (len != expected_len || pattern_count == 0) {
> +		err = mgmt_cmd_status(sk, hdev->id, op,
> 				      MGMT_STATUS_INVALID_PARAMS);
> 		goto failed;
> 	}
> @@ -4254,21 +4273,40 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 	INIT_LIST_HEAD(&m->patterns);
> 	m->active = false;
> 
> -	for (i = 0; i < cp->pattern_count; i++) {
> +	if (rssi) {
> +		m->rssi.low_threshold = rssi->low_threshold;
> +		m->rssi.low_threshold_timeout =
> +		    __le16_to_cpu(rssi->low_threshold_timeout);
> +		m->rssi.high_threshold = rssi->high_threshold;
> +		m->rssi.high_threshold_timeout =
> +		    __le16_to_cpu(rssi->high_threshold_timeout);
> +		m->rssi.sampling_period = rssi->sampling_period;
> +	} else {
> +		/* Default values. These numbers are the least constricting
> +		 * parameters for MSFT API to work, so it behaves as if there
> +		 * are no rssi parameter to consider. May need to be changed
> +		 * if other API are to be supported.
> +		 */
> +		m->rssi.low_threshold = -127;
> +		m->rssi.low_threshold_timeout = 60;
> +		m->rssi.high_threshold = -127;
> +		m->rssi.high_threshold_timeout = 0;
> +		m->rssi.sampling_period = 0;
> +	}
> +
> +	for (i = 0; i < pattern_count; i++) {
> 		if (++mp_cnt > HCI_MAX_ADV_MONITOR_NUM_PATTERNS) {
> -			err = mgmt_cmd_status(sk, hdev->id,
> -					      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
> +			err = mgmt_cmd_status(sk, hdev->id, op,
> 					      MGMT_STATUS_INVALID_PARAMS);
> 			goto failed;
> 		}
> 
> -		cp_ofst = cp->patterns[i].offset;
> -		cp_len = cp->patterns[i].length;
> +		cp_ofst = patterns[i].offset;
> +		cp_len = patterns[i].length;
> 		if (cp_ofst >= HCI_MAX_AD_LENGTH ||
> 		    cp_len > HCI_MAX_AD_LENGTH ||
> 		    (cp_ofst + cp_len) > HCI_MAX_AD_LENGTH) {
> -			err = mgmt_cmd_status(sk, hdev->id,
> -					      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
> +			err = mgmt_cmd_status(sk, hdev->id, op,
> 					      MGMT_STATUS_INVALID_PARAMS);
> 			goto failed;
> 		}
> @@ -4279,18 +4317,17 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 			goto failed;
> 		}
> 
> -		p->ad_type = cp->patterns[i].ad_type;
> -		p->offset = cp->patterns[i].offset;
> -		p->length = cp->patterns[i].length;
> -		memcpy(p->value, cp->patterns[i].value, p->length);
> +		p->ad_type = patterns[i].ad_type;
> +		p->offset = patterns[i].offset;
> +		p->length = patterns[i].length;
> +		memcpy(p->value, patterns[i].value, p->length);
> 
> 		INIT_LIST_HEAD(&p->list);
> 		list_add(&p->list, &m->patterns);
> 	}
> 
> -	if (mp_cnt != cp->pattern_count) {
> -		err = mgmt_cmd_status(sk, hdev->id,
> -				      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
> +	if (mp_cnt != pattern_count) {
> +		err = mgmt_cmd_status(sk, hdev->id, op,
> 				      MGMT_STATUS_INVALID_PARAMS);
> 		goto failed;
> 	}
> @@ -4302,8 +4339,7 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 	err = hci_add_adv_monitor(hdev, m);
> 	if (err) {
> 		if (err == -ENOSPC) {
> -			mgmt_cmd_status(sk, hdev->id,
> -					MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
> +			mgmt_cmd_status(sk, hdev->id, op,
> 					MGMT_STATUS_NO_RESOURCES);
> 		}
> 		goto unlock;
> @@ -4316,7 +4352,7 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 
> 	rp.monitor_handle = cpu_to_le16(m->handle);
> 
> -	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
> +	return mgmt_cmd_complete(sk, hdev->id, op,
> 				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
> 
> unlock:
> @@ -4327,6 +4363,20 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 	return err;
> }
> 
> +static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> +				    void *data, u16 len)
> +{
> +	return __add_adv_patterns_monitor(sk, hdev, data, len,
> +					  MGMT_OP_ADD_ADV_PATTERNS_MONITOR);
> +}
> +
> +static int add_adv_patterns_monitor_rssi(struct sock *sk, struct hci_dev *hdev,
> +					 void *data, u16 len)
> +{
> +	return __add_adv_patterns_monitor(sk, hdev, data, len,
> +					 MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI);
> +}
> +

Is this really the best way to handle this. I would put the parameter parsing into these functions and then call the common function.

> static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
> 			      void *data, u16 len)
> {
> @@ -8234,6 +8284,9 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
> 						HCI_MGMT_VAR_LEN },
> 	{ add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
> 						HCI_MGMT_VAR_LEN },
> +	{ add_adv_patterns_monitor_rssi,
> +				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE,
> +						HCI_MGMT_VAR_LEN },
> };

Regards

Marcel

