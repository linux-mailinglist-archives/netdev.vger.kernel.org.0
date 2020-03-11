Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7661181B3D
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgCKOba convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Mar 2020 10:31:30 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:53401 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbgCKOb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:31:29 -0400
Received: from [172.20.10.2] (x59cc8a78.dyn.telefonica.de [89.204.138.120])
        by mail.holtmann.org (Postfix) with ESMTPSA id D1D5CCECDF;
        Wed, 11 Mar 2020 15:40:55 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] Bluetooth: clean up connection in hci_cs_disconnect
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200310113816.1.I12c0712e93f74506385b67c6df287658c8fdad04@changeid>
Date:   Wed, 11 Mar 2020 15:31:26 +0100
Cc:     Alain Michaud <alainm@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Joseph Hwang <josephsih@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C60D1463-5B04-4C25-B4A2-0A9DD25A67B9@holtmann.org>
References: <20200310113816.1.I12c0712e93f74506385b67c6df287658c8fdad04@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> In bluetooth core specification 4.2,
> Vol 2, Part E, 7.8.9 LE Set Advertise Enable Command, it says
> 
>    The Controller shall continue advertising until ...
>    or until a connection is created or ...
>    In these cases, advertising is then disabled.
> 
> Hence, advertising would be disabled before a connection is
> established. In current kernel implementation, advertising would
> be re-enabled when all connections are terminated.
> 
> The correct disconnection flow looks like
> 
>  < HCI Command: Disconnect
> 
>> HCI Event: Command Status
>      Status: Success
> 
>> HCI Event: Disconnect Complete
>      Status: Success
> 
> Specifically, the last Disconnect Complete Event would trigger a
> callback function hci_event.c:hci_disconn_complete_evt() to
> cleanup the connection and re-enable advertising when proper.
> 
> However, sometimes, there might occur an exception in the controller
> when disconnection is being executed. The disconnection flow might
> then look like
> 
>  < HCI Command: Disconnect
> 
>> HCI Event: Command Status
>      Status: Unknown Connection Identifier
> 
>  Note that "> HCI Event: Disconnect Complete" is missing when such an
> exception occurs. This would result in advertising staying disabled
> forever since the connection in question is not cleaned up correctly.
> 
> To fix the controller exception issue, we need to do some connection
> cleanup when the disconnect command status indicates an error.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> 
> net/bluetooth/hci_event.c | 14 +++++++++++++-
> 1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index a40ed31f6eb8f..7f7e5ba3974a8 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -2191,6 +2191,7 @@ static void hci_cs_disconnect(struct hci_dev *hdev, u8 status)
> {
> 	struct hci_cp_disconnect *cp;
> 	struct hci_conn *conn;
> +	u8 type;

remove this please.

> 
> 	if (!status)
> 		return;
> @@ -2202,10 +2203,21 @@ static void hci_cs_disconnect(struct hci_dev *hdev, u8 status)
> 	hci_dev_lock(hdev);
> 
> 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
> -	if (conn)
> +	if (conn) {

And add this.

		u8 type = conn->type;

> 		mgmt_disconnect_failed(hdev, &conn->dst, conn->type,
> 				       conn->dst_type, status);
> 
> +		/* If the disconnection failed for any reason, the upper layer
> +		 * does not retry to disconnect in current implementation.
> +		 * Hence, we need to do some basic cleanup here and re-enable
> +		 * advertising if necessary.
> +		 */
> +		type = conn->type;

And then remove this.

> +		hci_conn_del(conn);
> +		if (type == LE_LINK)
> +			hci_req_reenable_advertising(hdev);
> +	}
> +
> 	hci_dev_unlock(hdev);
> }

Otherwise this looks good.

Regards

Marcel

