Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801684533B3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbhKPOKw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Nov 2021 09:10:52 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:59986 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237032AbhKPOKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:10:50 -0500
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id 65929CECD7;
        Tue, 16 Nov 2021 15:07:52 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v2 1/2] Bluetooth: Send device found event on name resolve
 failure
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211115171726.v2.1.Id7366eb14b6f48173fcbf17846ace59479179c7c@changeid>
Date:   Tue, 16 Nov 2021 15:07:51 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <44A01538-D569-464C-B716-24DC00D92907@holtmann.org>
References: <20211115171726.v2.1.Id7366eb14b6f48173fcbf17846ace59479179c7c@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> Introducing CONFIRM_NAME_FAILED flag that will be sent together with
> device found event on name resolve failure. This will provide the
> userspace with an information so it can decide not to resolve the
> name for these devices in the future.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> 
> ---
> Hi maintainers,
> 
> This is the patch series for remote name request as was discussed here.
> https://patchwork.kernel.org/project/bluetooth/patch/20211028191805.1.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid/
> Please also review the corresponding userspace change.
> 
> Thanks,
> Archie
> 
> Changes in v2:
> * Remove the part which accepts DONT_CARE flag in MGMT_OP_CONFIRM_NAME
> * Rename MGMT constant to conform with the docs
> 
> include/net/bluetooth/mgmt.h |  1 +
> net/bluetooth/hci_event.c    | 11 ++++-------
> net/bluetooth/mgmt.c         | 11 ++++++++---
> 3 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index 23a0524061b7..3cda081ed6d0 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -940,6 +940,7 @@ struct mgmt_ev_auth_failed {
> #define MGMT_DEV_FOUND_LEGACY_PAIRING  0x02
> #define MGMT_DEV_FOUND_NOT_CONNECTABLE 0x04
> #define MGMT_DEV_FOUND_INITIATED_CONN  0x08
> +#define MGMT_DEV_FOUND_NAME_REQUEST_FAILED 0x10

please indent the other defines to match this one.

> 
> #define MGMT_EV_DEVICE_FOUND		0x0012
> struct mgmt_ev_device_found {
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index d4b75a6cfeee..2de3080659f9 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -2175,13 +2175,10 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
> 		return;
> 
> 	list_del(&e->list);
> -	if (name) {
> -		e->name_state = NAME_KNOWN;
> -		mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00,
> -				 e->data.rssi, name, name_len);
> -	} else {
> -		e->name_state = NAME_NOT_KNOWN;
> -	}
> +
> +	e->name_state = name ? NAME_KNOWN : NAME_NOT_KNOWN;
> +	mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00, e->data.rssi,
> +			 name, name_len);
> 
> 	if (hci_resolve_next_name(hdev))
> 		return;
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 06384d761928..0d77c010b391 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -9615,7 +9615,8 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
> {
> 	struct mgmt_ev_device_found *ev;
> 	char buf[sizeof(*ev) + HCI_MAX_NAME_LENGTH + 2];
> -	u16 eir_len;
> +	u16 eir_len = 0;
> +	u32 flags = 0;
> 
> 	ev = (struct mgmt_ev_device_found *) buf;
> 
> @@ -9625,10 +9626,14 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
> 	ev->addr.type = link_to_bdaddr(link_type, addr_type);
> 	ev->rssi = rssi;
> 
> -	eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
> -				  name_len);
> +	if (name)
> +		eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
> +					  name_len);
> +	else
> +		flags |= MGMT_DEV_FOUND_NAME_REQUEST_FAILED;

So instead of initializing a variable, I prefer to set them where they are used.

	if (name) {
		eir_len = eir_..
		flags = 0;
	} else {
		eir_len = 0;
		flags = MGMT_DEV_FOUND_NAME_REQUEST_FAILED;
	}

This way, the compiler will complain loudly if we change things and forget to set any of these two variables.

> 
> 	ev->eir_len = cpu_to_le16(eir_len);
> +	ev->flags = cpu_to_le32(flags);
> 
> 	mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, sizeof(*ev) + eir_len, NULL);
> }
> -- 

Regards

Marcel

