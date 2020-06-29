Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8060820DD7B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbgF2S5n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jun 2020 14:57:43 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:39176 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729915AbgF2S5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:57:41 -0400
Received: from marcel-macpro.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 6F94DCECCC;
        Mon, 29 Jun 2020 08:59:12 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [RFC PATCH v1 2/2] Bluetooth: queue L2CAP conn req if encryption
 is needed
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200627185320.RFC.v1.2.I7363a6e528433d88c5240b67cbda5a88a107f56c@changeid>
Date:   Mon, 29 Jun 2020 08:49:17 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9117B008-7B6C-48E1-B6B6-087531652C70@holtmann.org>
References: <20200627105437.453053-1-apusaka@google.com>
 <20200627185320.RFC.v1.2.I7363a6e528433d88c5240b67cbda5a88a107f56c@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> It is possible to receive an L2CAP conn req for an encrypted
> connection, before actually receiving the HCI change encryption
> event. If this happened, the received L2CAP packet will be ignored.
> 
> This patch queues the L2CAP packet and process them after the
> expected HCI event is received. If after 2 seconds we still don't
> receive it, then we assume something bad happened and discard the
> queued packets.

as with the other patch, this should be behind the same quirk and experimental setting for exactly the same reasons.

> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> ---
> 
> include/net/bluetooth/bluetooth.h |  6 +++
> include/net/bluetooth/l2cap.h     |  6 +++
> net/bluetooth/hci_event.c         |  3 ++
> net/bluetooth/l2cap_core.c        | 87 +++++++++++++++++++++++++++----
> 4 files changed, 91 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
> index 7ee8041af803..e64278401084 100644
> --- a/include/net/bluetooth/bluetooth.h
> +++ b/include/net/bluetooth/bluetooth.h
> @@ -335,7 +335,11 @@ struct l2cap_ctrl {
> 	u16	reqseq;
> 	u16	txseq;
> 	u8	retries;
> +	u8	rsp_code;
> +	u8	amp_id;
> +	__u8	ident;
> 	__le16  psm;
> +	__le16	scid;
> 	bdaddr_t bdaddr;
> 	struct l2cap_chan *chan;
> };

I would not bother trying to make this work with CREATE_CHAN_REQ. That is if you want to setup a L2CAP channel that can be moved between BR/EDR and AMP controllers and in that case you have to read the L2CAP information and features first. Meaning there will have been unencrypted ACL packets. This problem only exists if the remote side doesn’t request any version information first.

> @@ -374,6 +378,8 @@ struct bt_skb_cb {
> 		struct hci_ctrl hci;
> 	};
> };
> +static_assert(sizeof(struct bt_skb_cb) <= sizeof(((struct sk_buff *)0)->cb));
> +
> #define bt_cb(skb) ((struct bt_skb_cb *)((skb)->cb))
> 
> #define hci_skb_pkt_type(skb) bt_cb((skb))->pkt_type
> diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
> index 8f1e6a7a2df8..f8f6dec96f12 100644
> --- a/include/net/bluetooth/l2cap.h
> +++ b/include/net/bluetooth/l2cap.h
> @@ -58,6 +58,7 @@
> #define L2CAP_MOVE_ERTX_TIMEOUT		msecs_to_jiffies(60000)
> #define L2CAP_WAIT_ACK_POLL_PERIOD	msecs_to_jiffies(200)
> #define L2CAP_WAIT_ACK_TIMEOUT		msecs_to_jiffies(10000)
> +#define L2CAP_PEND_ENC_CONN_TIMEOUT	msecs_to_jiffies(2000)
> 
> #define L2CAP_A2MP_DEFAULT_MTU		670
> 
> @@ -700,6 +701,9 @@ struct l2cap_conn {
> 	struct mutex		chan_lock;
> 	struct kref		ref;
> 	struct list_head	users;
> +
> +	struct delayed_work	remove_pending_encrypt_conn;
> +	struct sk_buff_head	pending_conn_q;
> };
> 
> struct l2cap_user {
> @@ -1001,4 +1005,6 @@ void l2cap_conn_put(struct l2cap_conn *conn);
> int l2cap_register_user(struct l2cap_conn *conn, struct l2cap_user *user);
> void l2cap_unregister_user(struct l2cap_conn *conn, struct l2cap_user *user);
> 
> +void l2cap_process_pending_encrypt_conn(struct hci_conn *hcon);
> +
> #endif /* __L2CAP_H */
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 108c6c102a6a..8cefc51a5ca4 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -3136,6 +3136,9 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
> 
> unlock:
> 	hci_dev_unlock(hdev);
> +
> +	if (conn && !ev->status && ev->encrypt)
> +		l2cap_process_pending_encrypt_conn(conn);
> }
> 
> static void hci_change_link_key_complete_evt(struct hci_dev *hdev,
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 35d2bc569a2d..fc6fe2c80c46 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -62,6 +62,10 @@ static void l2cap_send_disconn_req(struct l2cap_chan *chan, int err);
> static void l2cap_tx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
> 		     struct sk_buff_head *skbs, u8 event);
> 
> +static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
> +					u8 ident, u8 *data, u8 rsp_code,
> +					u8 amp_id, bool queue_if_fail);
> +
> static inline u8 bdaddr_type(u8 link_type, u8 bdaddr_type)
> {
> 	if (link_type == LE_LINK) {
> @@ -1902,6 +1906,8 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
> 	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
> 		cancel_delayed_work_sync(&conn->info_timer);
> 
> +	cancel_delayed_work_sync(&conn->remove_pending_encrypt_conn);
> +
> 	hcon->l2cap_data = NULL;
> 	conn->hchan = NULL;
> 	l2cap_conn_put(conn);
> @@ -2023,6 +2029,55 @@ static void l2cap_retrans_timeout(struct work_struct *work)
> 	l2cap_chan_put(chan);
> }
> 
> +static void l2cap_add_pending_encrypt_conn(struct l2cap_conn *conn,
> +					   struct l2cap_conn_req *req,
> +					   u8 ident, u8 rsp_code, u8 amp_id)
> +{
> +	struct sk_buff *skb = bt_skb_alloc(0, GFP_KERNEL);
> +
> +	bt_cb(skb)->l2cap.psm = req->psm;
> +	bt_cb(skb)->l2cap.scid = req->scid;
> +	bt_cb(skb)->l2cap.ident = ident;
> +	bt_cb(skb)->l2cap.rsp_code = rsp_code;
> +	bt_cb(skb)->l2cap.amp_id = amp_id;
> +
> +	skb_queue_tail(&conn->pending_conn_q, skb);
> +	queue_delayed_work(conn->hcon->hdev->workqueue,
> +			   &conn->remove_pending_encrypt_conn,
> +			   L2CAP_PEND_ENC_CONN_TIMEOUT);
> +}
> +
> +void l2cap_process_pending_encrypt_conn(struct hci_conn *hcon)
> +{
> +	struct sk_buff *skb;
> +	struct l2cap_conn *conn = hcon->l2cap_data;
> +
> +	if (!conn)
> +		return;
> +
> +	while ((skb = skb_dequeue(&conn->pending_conn_q))) {
> +		struct l2cap_conn_req req;
> +		u8 ident, rsp_code, amp_id;
> +
> +		req.psm = bt_cb(skb)->l2cap.psm;
> +		req.scid = bt_cb(skb)->l2cap.scid;
> +		ident = bt_cb(skb)->l2cap.ident;
> +		rsp_code = bt_cb(skb)->l2cap.rsp_code;
> +		amp_id = bt_cb(skb)->l2cap.amp_id;
> +
> +		l2cap_connect(conn, ident, (u8 *)&req, rsp_code, amp_id, false);
> +		kfree_skb(skb);
> +	}
> +}
> +
> +static void l2cap_remove_pending_encrypt_conn(struct work_struct *work)
> +{
> +	struct l2cap_conn *conn = container_of(work, struct l2cap_conn,
> +					    remove_pending_encrypt_conn.work);
> +
> +	l2cap_process_pending_encrypt_conn(conn->hcon);
> +}
> +
> static void l2cap_streaming_send(struct l2cap_chan *chan,
> 				 struct sk_buff_head *skbs)
> {
> @@ -4076,8 +4131,8 @@ static inline int l2cap_command_rej(struct l2cap_conn *conn,
> }
> 
> static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
> -					struct l2cap_cmd_hdr *cmd,
> -					u8 *data, u8 rsp_code, u8 amp_id)
> +					u8 ident, u8 *data, u8 rsp_code,
> +					u8 amp_id, bool queue_if_fail)
> {
> 	struct l2cap_conn_req *req = (struct l2cap_conn_req *) data;
> 	struct l2cap_conn_rsp rsp;
> @@ -4103,8 +4158,15 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
> 	/* Check if the ACL is secure enough (if not SDP) */
> 	if (psm != cpu_to_le16(L2CAP_PSM_SDP) &&
> 	    !hci_conn_check_link_mode(conn->hcon)) {
> -		conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
> -		result = L2CAP_CR_SEC_BLOCK;
> +		if (!queue_if_fail) {
> +			conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
> +			result = L2CAP_CR_SEC_BLOCK;
> +			goto response;
> +		}
> +
> +		l2cap_add_pending_encrypt_conn(conn, req, ident, rsp_code,
> +					       amp_id);
> +		result = L2CAP_CR_PEND;
> 		goto response;
> 	}

So I am actually wondering if the approach is not better to send back a pending to the connect request like we do for everything else. And then proceed with getting our remote L2CAP information. If these come back in encrypted, then we can assume that we actually had encryption enabled and proceed with a L2CAP connect response saying that all is fine.

That also means no queuing of packets is required.

Regards

Marcel

