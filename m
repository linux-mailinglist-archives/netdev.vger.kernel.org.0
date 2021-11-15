Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDDF450BF7
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhKORcm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Nov 2021 12:32:42 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:47475 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbhKORab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:30:31 -0500
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id D2B04CED38;
        Mon, 15 Nov 2021 18:27:33 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] bluetooth: fix uninitialized variables notify_evt
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211115085613.1924762-1-liu.yun@linux.dev>
Date:   Mon, 15 Nov 2021 18:27:33 +0100
Cc:     "Tumkur Narayan, Chethan" <chethan.tumkur.narayan@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <73AF4476-F5B2-4E83-9F43-72D98B4615FF@holtmann.org>
References: <20211115085613.1924762-1-liu.yun@linux.dev>
To:     Jackie Liu <liu.yun@linux.dev>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jackie,

> Coverity Scan report:
> 
> [...]
> *** CID 1493985:  Uninitialized variables  (UNINIT)
> /net/bluetooth/hci_event.c: 4535 in hci_sync_conn_complete_evt()
> 4529
> 4530     	/* Notify only in case of SCO over HCI transport data path which
> 4531     	 * is zero and non-zero value shall be non-HCI transport data path
> 4532     	 */
> 4533     	if (conn->codec.data_path == 0) {
> 4534     		if (hdev->notify)
>>>>    CID 1493985:  Uninitialized variables  (UNINIT)
>>>>    Using uninitialized value "notify_evt" when calling "*hdev->notify".
> 4535     			hdev->notify(hdev, notify_evt);
> 4536     	}
> 4537
> 4538     	hci_connect_cfm(conn, ev->status);
> 4539     	if (ev->status)
> 4540     		hci_conn_del(conn);
> [...]
> 
> Although only btusb uses air_mode, and he only handles HCI_NOTIFY_ENABLE_SCO_CVSD
> and HCI_NOTIFY_ENABLE_SCO_TRANSP, there is still a very small chance that
> ev->air_mode is not equal to 0x2 and 0x3, but notify_evt is initialized to
> HCI_NOTIFY_ENABLE_SCO_CVSD or HCI_NOTIFY_ENABLE_SCO_TRANSP. the context is
> maybe not correct.
> 
> In order to ensure 100% correctness, we directly give him a default value 0.
> 
> Addresses-Coverity: ("Uninitialized variables")
> Fixes: f4f9fa0c07bb ("Bluetooth: Allow usb to auto-suspend when SCO use	non-HCI transport")
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> ---
> net/bluetooth/hci_event.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 7d0db1ca1248..f898fa42a183 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4445,7 +4445,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
> {
> 	struct hci_ev_sync_conn_complete *ev = (void *) skb->data;
> 	struct hci_conn *conn;
> -	unsigned int notify_evt;
> +	unsigned int notify_evt = 0;
> 
> 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);

lets modify the switch statement and add a default case. And then lets add a check to notify_evt != 0.

With that in mind, I wonder if this is not better

        /* Notify only in case of SCO over HCI transport data path which
         * is zero and non-zero value shall be non-HCI transport data path
         */ 
	if (conn->codec.data_path == 0 && hdev->notify) {
		switch (ev->air_mode) {
		case 0x02:
			hdev->notify(hdev, HCI_NOTIFY_ENABLE_SCO_CVSD);
			break;
		case 0x03:
			hdev->notify(hdev, HCI_NOTIFY_ENABLE_SCO_TRANSP);
			break;
		}
	}

Regards

Marcel

