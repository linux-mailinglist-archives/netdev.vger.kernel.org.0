Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C6243E245
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhJ1NdQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 Oct 2021 09:33:16 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:55361 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhJ1NdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:33:14 -0400
Received: from smtpclient.apple (p4ff9fd51.dip0.t-ipconnect.de [79.249.253.81])
        by mail.holtmann.org (Postfix) with ESMTPSA id 49BF2CED00;
        Thu, 28 Oct 2021 15:30:45 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] Bluetooth: Limit duration of Remote Name Resolve
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211028191805.1.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
Date:   Thu, 28 Oct 2021 15:30:44 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <180B4F43-B60A-4326-A463-327645BA8F1B@holtmann.org>
References: <20211028191805.1.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
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
> name request. The limit is increased for every iteration where we fail
> to complete the RNR in order to eventually solve all names.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> 
> ---
> Hi maintainers, we found one instance where a test device spends ~90
> seconds to do Remote Name Resolving, hence this patch.
> I think it's better if we reset the time limit to the default value
> at some point, but I don't have a good proposal where to do that, so
> in the end I didn't.

do you have a btmon trace for this as well?

The HCI Remote Name Request is essentially a paging procedure and then a few LMP messages. It is fundamentally a connection request inside BR/EDR and if you have a remote device that has page scan disabled, but inquiry scan enabled, then you get into this funky situation. Sadly, the BR/EDR parts don’t give you any hint on this weird combination. You can't configure BlueZ that way since it is really stupid setup and I remember that GAP doesn’t have this case either, but it can happen. So we might want to check if that is what happens. And of course it needs to be a Bluetooth 2.0 device or a device that doesn’t support Secure Simple Pairing. There is a chance of really bad radio interference, but that is then just bad luck and is only going to happen every once in a blue moon.

That said, you should receive a Page Timeout in the Remote Name Request Complete event for what you describe. Or you just use HCI Remote Name Request Cancel to abort the paging. If I remember correctly then the setting for Page Timeout is also applied to Remote Name resolving procedure. So we could tweak that value. Actually once we get the “sync” work merged, we could configure different Page Timeout for connection requests and name resolving if that would help. Not sure if this is worth it, since we could as simple just cancel the request.

> include/net/bluetooth/hci_core.h |  5 +++++
> net/bluetooth/hci_event.c        | 12 ++++++++++++
> 2 files changed, 17 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index dd8840e70e25..df9ffedf1d29 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -87,6 +87,8 @@ struct discovery_state {
> 	u8			(*uuids)[16];
> 	unsigned long		scan_start;
> 	unsigned long		scan_duration;
> +	unsigned long		name_resolve_timeout;
> +	unsigned long		name_resolve_duration;
> };
> 
> #define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
> @@ -805,6 +807,8 @@ static inline void sco_recv_scodata(struct hci_conn *hcon, struct sk_buff *skb)
> #define INQUIRY_CACHE_AGE_MAX   (HZ*30)   /* 30 seconds */
> #define INQUIRY_ENTRY_AGE_MAX   (HZ*60)   /* 60 seconds */
> 
> +#define NAME_RESOLVE_INIT_DURATION	5120	/* msec */
> +
> static inline void discovery_init(struct hci_dev *hdev)
> {
> 	hdev->discovery.state = DISCOVERY_STOPPED;
> @@ -813,6 +817,7 @@ static inline void discovery_init(struct hci_dev *hdev)
> 	INIT_LIST_HEAD(&hdev->discovery.resolve);
> 	hdev->discovery.report_invalid_rssi = true;
> 	hdev->discovery.rssi = HCI_RSSI_INVALID;
> +	hdev->discovery.name_resolve_duration = NAME_RESOLVE_INIT_DURATION;
> }
> 
> static inline void hci_discovery_filter_clear(struct hci_dev *hdev)
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 3cba2bbefcd6..104a1308f454 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -2086,6 +2086,15 @@ static bool hci_resolve_next_name(struct hci_dev *hdev)
> 	if (list_empty(&discov->resolve))
> 		return false;
> 
> +	/* We should stop if we already spent too much time resolving names.
> +	 * However, double the name resolve duration for the next iterations.
> +	 */
> +	if (time_after(jiffies, discov->name_resolve_timeout)) {
> +		bt_dev_dbg(hdev, "Name resolve takes too long, stopping.");
> +		discov->name_resolve_duration *= 2;
> +		return false;
> +	}
> +
> 	e = hci_inquiry_cache_lookup_resolve(hdev, BDADDR_ANY, NAME_NEEDED);
> 	if (!e)
> 		return false;
> @@ -2634,6 +2643,9 @@ static void hci_inquiry_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
> 	if (e && hci_resolve_name(hdev, e) == 0) {
> 		e->name_state = NAME_PENDING;
> 		hci_discovery_set_state(hdev, DISCOVERY_RESOLVING);
> +
> +		discov->name_resolve_timeout = jiffies +
> +				msecs_to_jiffies(discov->name_resolve_duration);

So if this is really caused by a device with page scan disabled and inquiry scan enabled, then this fix is just a paper over hole approach. If you have more devices requiring name resolving, you end up penalizing them and make the discovery procedure worse up to the extend that no names are resolved. So I wouldn’t be in favor of this.

What LE scan window/interval is actually working against what configured BR/EDR page timeout here? The discovery procedure is something that a user triggers so we always had that one take higher priority since the user is expecting results. This means any tweaking needs to be considered carefully since it is an immediate user impact if the name is missing.

Is this a LE background scan you are worried about or an LE active scan that runs in parallel during discovery?

Regards

Marcel

