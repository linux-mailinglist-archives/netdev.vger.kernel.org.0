Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A9D461CEB
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350186AbhK2RqM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Nov 2021 12:46:12 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:53679 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234425AbhK2RoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 12:44:12 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id EF4A7CED2E;
        Mon, 29 Nov 2021 18:40:52 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v6 2/2] bluetooth: Add MGMT Adv Monitor Device Found/Lost
 events
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211121110853.v6.2.I9eda306e4c542010535dc49b5488946af592795e@changeid>
Date:   Mon, 29 Nov 2021 18:40:52 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7248C3A0-3237-43DD-B0B1-76354C0CA356@holtmann.org>
References: <20211121110853.v6.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
 <20211121110853.v6.2.I9eda306e4c542010535dc49b5488946af592795e@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> This patch introduces two new MGMT events for notifying the bluetoothd
> whenever the controller starts/stops monitoring a device.
> 
> Test performed:
> - Verified by logs that the MSFT Monitor Device is received from the
>  controller and the bluetoothd is notified whenever the controller
>  starts/stops monitoring a device.
> 
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Miao-chen Chou <mcchou@google.com>
> 
> ---
> 
> Changes in v6:
> - Fix compiler warning for mgmt_adv_monitor_device_found().
> 
> Changes in v5:
> - New patch in the series. Split previous patch into two.
> - Update the Device Found logic to send existing Device Found event or
>  Adv Monitor Device Found event depending on the active scanning state.
> 
> include/net/bluetooth/hci_core.h |   3 +
> include/net/bluetooth/mgmt.h     |  16 +++++
> net/bluetooth/mgmt.c             | 100 ++++++++++++++++++++++++++++++-
> net/bluetooth/msft.c             |  15 ++++-
> 4 files changed, 132 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 6734b394c6e7..2aabd6f62f51 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -598,6 +598,7 @@ struct hci_dev {
> 	struct delayed_work	interleave_scan;
> 
> 	struct list_head	monitored_devices;
> +	bool			advmon_pend_notify;
> 
> #if IS_ENABLED(CONFIG_BT_LEDS)
> 	struct led_trigger	*power_led;
> @@ -1844,6 +1845,8 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
> int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
> int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
> int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
> +void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
> +				  bdaddr_t *bdaddr, u8 addr_type);
> 
> u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
> 		      u16 to_multiplier);
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index 23a0524061b7..4b85f93b8a77 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -1103,3 +1103,19 @@ struct mgmt_ev_controller_resume {
> #define MGMT_WAKE_REASON_NON_BT_WAKE		0x0
> #define MGMT_WAKE_REASON_UNEXPECTED		0x1
> #define MGMT_WAKE_REASON_REMOTE_WAKE		0x2
> +
> +#define MGMT_EV_ADV_MONITOR_DEVICE_FOUND	0x002f
> +struct mgmt_ev_adv_monitor_device_found {
> +	__le16 monitor_handle;
> +	struct mgmt_addr_info addr;
> +	__s8   rssi;
> +	__le32 flags;
> +	__le16 eir_len;
> +	__u8   eir[0];
> +} __packed;
> +
> +#define MGMT_EV_ADV_MONITOR_DEVICE_LOST		0x0030
> +struct mgmt_ev_adv_monitor_device_lost {
> +	__le16 monitor_handle;
> +	struct mgmt_addr_info addr;
> +} __packed;
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index f8f74d344297..01f74e4feb97 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -174,6 +174,8 @@ static const u16 mgmt_events[] = {
> 	MGMT_EV_ADV_MONITOR_REMOVED,
> 	MGMT_EV_CONTROLLER_SUSPEND,
> 	MGMT_EV_CONTROLLER_RESUME,
> +	MGMT_EV_ADV_MONITOR_DEVICE_FOUND,
> +	MGMT_EV_ADV_MONITOR_DEVICE_LOST,
> };
> 
> static const u16 mgmt_untrusted_commands[] = {
> @@ -9524,6 +9526,78 @@ static bool is_filter_match(struct hci_dev *hdev, s8 rssi, u8 *eir,
> 	return true;
> }
> 
> +void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
> +				  bdaddr_t *bdaddr, u8 addr_type)
> +{
> +	struct mgmt_ev_adv_monitor_device_lost ev;
> +
> +	ev.monitor_handle = cpu_to_le16(handle);
> +	bacpy(&ev.addr.bdaddr, bdaddr);
> +	ev.addr.type = addr_type;
> +
> +	mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_LOST, hdev, &ev, sizeof(ev),
> +		   NULL);
> +}
> +
> +static void mgmt_adv_monitor_device_found(struct hci_dev *hdev,
> +					  struct mgmt_ev_device_found *ev,
> +					  size_t ev_size, bool discovering)
> +{
> +	char buf[518];
> +	struct mgmt_ev_adv_monitor_device_found *advmon_ev = (void *)buf;
> +	size_t advmon_ev_size;
> +	struct monitored_device *dev, *tmp;
> +	bool matched = false;
> +	bool notified = false;
> +
> +	/* Make sure that the buffer is big enough */
> +	advmon_ev_size = ev_size + (sizeof(*advmon_ev) - sizeof(*ev));
> +	if (advmon_ev_size > sizeof(buf))
> +		return;
> +
> +	/* ADV_MONITOR_DEVICE_FOUND is similar to DEVICE_FOUND event except
> +	 * that it also has 'monitor_handle'. Make a copy of DEVICE_FOUND and
> +	 * store monitor_handle of the matched monitor.
> +	 */
> +	memcpy(&advmon_ev->addr, ev, ev_size);
> +
> +	hdev->advmon_pend_notify = false;
> +
> +	list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices, list) {
> +		if (!bacmp(&dev->bdaddr, &advmon_ev->addr.bdaddr)) {
> +			matched = true;
> +
> +			if (!dev->notified) {
> +				advmon_ev->monitor_handle =
> +						cpu_to_le16(dev->handle);
> +
> +				mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_FOUND,
> +					   hdev, advmon_ev, advmon_ev_size,
> +					   NULL);
> +
> +				notified = true;
> +				dev->notified = true;
> +			}
> +		}
> +
> +		if (!dev->notified)
> +			hdev->advmon_pend_notify = true;
> +	}
> +
> +	if (!discovering &&
> +	    ((matched && !notified) || !msft_monitor_supported(hdev))) {
> +		/* Handle 0 indicates that we are not active scanning and this
> +		 * is a subsequent advertisement report for an already matched
> +		 * Advertisement Monitor or the controller offloading support
> +		 * is not available.
> +		 */
> +		advmon_ev->monitor_handle = 0;
> +
> +		mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_FOUND, hdev, advmon_ev,
> +			   advmon_ev_size, NULL);
> +	}
> +}
> +
> void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
> 		       u8 addr_type, u8 *dev_class, s8 rssi, u32 flags,
> 		       u8 *eir, u16 eir_len, u8 *scan_rsp, u8 scan_rsp_len)
> @@ -9606,7 +9680,31 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
> 	ev->eir_len = cpu_to_le16(eir_len + scan_rsp_len);
> 	ev_size = sizeof(*ev) + eir_len + scan_rsp_len;
> 
> -	mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, ev_size, NULL);
> +	/* We have received the Advertisement Report because:
> +	 * 1. the kernel has initiated active discovery
> +	 * 2. if not, we have pend_le_reports > 0 in which case we are doing
> +	 *    passive scanning
> +	 * 3. if none of the above is true, we have one or more active
> +	 *    Advertisement Monitor
> +	 *
> +	 * For case 1 and 2, report all advertisements via MGMT_EV_DEVICE_FOUND
> +	 * and report ONLY one advertisement per device for the matched Monitor
> +	 * via MGMT_EV_ADV_MONITOR_DEVICE_FOUND event.
> +	 *
> +	 * For case 3, since we are not active scanning and all advertisements
> +	 * received are due to a matched Advertisement Monitor, report all
> +	 * advertisements ONLY via MGMT_EV_ADV_MONITOR_DEVICE_FOUND event.
> +	 */
> +
> +	if (hci_discovery_active(hdev) ||
> +	    (link_type == LE_LINK && !list_empty(&hdev->pend_le_reports))) {
> +		mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, ev_size, NULL);
> +
> +		if (hdev->advmon_pend_notify)
> +			mgmt_adv_monitor_device_found(hdev, ev, ev_size, true);
> +	} else {
> +		mgmt_adv_monitor_device_found(hdev, ev, ev_size, false);
> +	}
> }

so you are breaking the stack-frame-size now. You might need to re-design the general device found event handling to fit into a 1k stack frame size.

Regards

Marcel

