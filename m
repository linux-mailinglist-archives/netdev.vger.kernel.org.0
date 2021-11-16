Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7F24533D0
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbhKPOOn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Nov 2021 09:14:43 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:46169 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237247AbhKPOOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:14:41 -0500
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id 54CB7CECD7;
        Tue, 16 Nov 2021 15:11:43 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v2 2/2] Bluetooth: Limit duration of Remote Name Resolve
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211115171726.v2.2.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
Date:   Tue, 16 Nov 2021 15:11:42 +0100
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
Message-Id: <19C4C970-8259-46EF-B56C-15658F58EABC@holtmann.org>
References: <20211115171726.v2.1.Id7366eb14b6f48173fcbf17846ace59479179c7c@changeid>
 <20211115171726.v2.2.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> When doing remote name request, we cannot scan. In the normal case it's
> OK since we can expect it to finish within a short amount of time.
> However, there is a possibility to scan lots of devices that
> (1) requires Remote Name Resolve
> (2) is unresponsive to Remote Name Resolve
> When this happens, we are stuck to do Remote Name Resolve until all is
> done before continue scanning.
> 
> This patch adds a time limit to stop us spending too long on remote
> name request.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> (no changes since v1)
> 
> include/net/bluetooth/hci_core.h | 3 +++
> net/bluetooth/hci_event.c        | 7 +++++++
> 2 files changed, 10 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index b5f061882c10..4112907bb49d 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -88,6 +88,7 @@ struct discovery_state {
> 	u8			(*uuids)[16];
> 	unsigned long		scan_start;
> 	unsigned long		scan_duration;
> +	unsigned long		name_resolve_timeout;
> };
> 
> #define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
> @@ -1762,6 +1763,8 @@ void hci_mgmt_chan_unregister(struct hci_mgmt_chan *c);
> #define DISCOV_LE_FAST_ADV_INT_MIN	0x00A0	/* 100 msec */
> #define DISCOV_LE_FAST_ADV_INT_MAX	0x00F0	/* 150 msec */
> 
> +#define NAME_RESOLVE_DURATION		msecs_to_jiffies(10240)	/* msec */
> +

It is nice that you define the unit here, but we also want the amount. So 10.24 seconds.

> void mgmt_fill_version_info(void *ver);
> int mgmt_new_settings(struct hci_dev *hdev);
> void mgmt_index_added(struct hci_dev *hdev);
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 2de3080659f9..6180ab0e8b8d 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -2129,6 +2129,12 @@ static bool hci_resolve_next_name(struct hci_dev *hdev)
> 	if (list_empty(&discov->resolve))
> 		return false;
> 
> +	/* We should stop if we already spent too much time resolving names. */
> +	if (time_after(jiffies, discov->name_resolve_timeout)) {
> +		bt_dev_dbg(hdev, "Name resolve takes too long, stopping.");

I might be better to have bt_dev_warn_ratelimited here. I mean if this happens, you want to have something actionable in your logs. Or if you don’t care, then also scrap the message and include more details in the comments that you just abort since it is taking too long.

> +		return false;
> +	}
> +
> 	e = hci_inquiry_cache_lookup_resolve(hdev, BDADDR_ANY, NAME_NEEDED);
> 	if (!e)
> 		return false;
> @@ -2716,6 +2722,7 @@ static void hci_inquiry_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
> 	if (e && hci_resolve_name(hdev, e) == 0) {
> 		e->name_state = NAME_PENDING;
> 		hci_discovery_set_state(hdev, DISCOVERY_RESOLVING);
> +		discov->name_resolve_timeout = jiffies + NAME_RESOLVE_DURATION;
> 	} else {
> 		/* When BR/EDR inquiry is active and no LE scanning is in
> 		 * progress, then change discovery state to indicate completion.

Regards

Marcel

