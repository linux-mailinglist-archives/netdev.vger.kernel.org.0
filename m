Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558CB217968
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgGGUaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbgGGUaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 16:30:17 -0400
Received: from embeddedor (unknown [200.39.26.250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2129206C3;
        Tue,  7 Jul 2020 20:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594153815;
        bh=ZBG73L/0WVqupbAF8AmWnDxYad91I+9I1o5IDmHitwY=;
        h=Date:From:To:Cc:Subject:From;
        b=NzUBMPH/ZaapJTJiyzPUPPW1foolDWpL0iqmVYiH4frWQyxIpGocwDiReTEJo31Ul
         CZ49UYizkrY++Si77EnlY3L448s4U3/xeNe97CUzBzFfJGmI+O2mlkcH0kGfjdQ6vN
         QjQzahhoQ5rWu9yUmfrrDJYEzaWyQe4UWFp3GpbU=
Date:   Tue, 7 Jul 2020 15:35:41 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] Bluetooth: Use fallthrough pseudo-keyword
Message-ID: <20200707203541.GA8972@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/bluetooth/bcm203x.c     |  2 +-
 drivers/bluetooth/bluecard_cs.c |  2 --
 drivers/bluetooth/hci_ll.c      |  2 +-
 drivers/bluetooth/hci_qca.c     |  8 +-------
 net/bluetooth/hci_event.c       |  4 ++--
 net/bluetooth/hci_sock.c        |  3 +--
 net/bluetooth/l2cap_core.c      | 19 +++++++++----------
 net/bluetooth/l2cap_sock.c      |  4 ++--
 net/bluetooth/mgmt.c            |  4 ++--
 net/bluetooth/rfcomm/core.c     |  2 +-
 net/bluetooth/rfcomm/sock.c     |  2 +-
 net/bluetooth/smp.c             |  2 +-
 12 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/bluetooth/bcm203x.c b/drivers/bluetooth/bcm203x.c
index 3b176257b993..e667933c3d70 100644
--- a/drivers/bluetooth/bcm203x.c
+++ b/drivers/bluetooth/bcm203x.c
@@ -106,7 +106,7 @@ static void bcm203x_complete(struct urb *urb)
 		}
 
 		data->state = BCM203X_LOAD_FIRMWARE;
-		/* fall through */
+		fallthrough;
 	case BCM203X_LOAD_FIRMWARE:
 		if (data->fw_sent == data->fw_size) {
 			usb_fill_int_urb(urb, udev, usb_rcvintpipe(udev, BCM203X_IN_EP),
diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index cc6e56223656..36eabf61717f 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -295,7 +295,6 @@ static void bluecard_write_wakeup(struct bluecard_info *info)
 				baud_reg = REG_CONTROL_BAUD_RATE_115200;
 				break;
 			case PKT_BAUD_RATE_57600:
-				/* Fall through... */
 			default:
 				baud_reg = REG_CONTROL_BAUD_RATE_57600;
 				break;
@@ -585,7 +584,6 @@ static int bluecard_hci_set_baud_rate(struct hci_dev *hdev, int baud)
 		hci_skb_pkt_type(skb) = PKT_BAUD_RATE_115200;
 		break;
 	case 57600:
-		/* Fall through... */
 	default:
 		cmd[4] = 0x03;
 		hci_skb_pkt_type(skb) = PKT_BAUD_RATE_57600;
diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index d9a4c6c691e0..8bfe024d1fcd 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -219,7 +219,7 @@ static void ll_device_want_to_wakeup(struct hci_uart *hu)
 		 * perfectly safe to always send one.
 		 */
 		BT_DBG("dual wake-up-indication");
-		/* fall through */
+		fallthrough;
 	case HCILL_ASLEEP:
 		/* acknowledge device wake up */
 		if (send_hcill_cmd(HCILL_WAKE_UP_ACK, hu) < 0) {
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 99d14c777105..7e395469ca4f 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -472,8 +472,6 @@ static void hci_ibs_tx_idle_timeout(struct timer_list *t)
 
 	case HCI_IBS_TX_ASLEEP:
 	case HCI_IBS_TX_WAKING:
-		/* Fall through */
-
 	default:
 		BT_ERR("Spurious timeout tx state %d", qca->tx_ibs_state);
 		break;
@@ -516,8 +514,6 @@ static void hci_ibs_wake_retrans_timeout(struct timer_list *t)
 
 	case HCI_IBS_TX_ASLEEP:
 	case HCI_IBS_TX_AWAKE:
-		/* Fall through */
-
 	default:
 		BT_ERR("Spurious timeout tx state %d", qca->tx_ibs_state);
 		break;
@@ -835,8 +831,6 @@ static void device_woke_up(struct hci_uart *hu)
 		break;
 
 	case HCI_IBS_TX_ASLEEP:
-		/* Fall through */
-
 	default:
 		BT_ERR("Received HCI_IBS_WAKE_ACK in tx state %d",
 		       qca->tx_ibs_state);
@@ -2072,7 +2066,7 @@ static int __maybe_unused qca_suspend(struct device *dev)
 	switch (qca->tx_ibs_state) {
 	case HCI_IBS_TX_WAKING:
 		del_timer(&qca->wake_retrans_timer);
-		/* Fall through */
+		fallthrough;
 	case HCI_IBS_TX_AWAKE:
 		del_timer(&qca->tx_idle_timer);
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 03a0759f2fc2..94f046f08301 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2825,7 +2825,7 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		case HCI_AUTO_CONN_LINK_LOSS:
 			if (ev->reason != HCI_ERROR_CONNECTION_TIMEOUT)
 				break;
-			/* Fall through */
+			fallthrough;
 
 		case HCI_AUTO_CONN_DIRECT:
 		case HCI_AUTO_CONN_ALWAYS:
@@ -4320,7 +4320,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 			if (hci_setup_sync(conn, conn->link->handle))
 				goto unlock;
 		}
-		/* fall through */
+		fallthrough;
 
 	default:
 		conn->state = BT_CLOSED;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d5627967fc25..fad842750442 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -443,8 +443,7 @@ static struct sk_buff *create_monitor_event(struct hci_dev *hdev, int event)
 	case HCI_DEV_SETUP:
 		if (hdev->manufacturer == 0xffff)
 			return NULL;
-
-		/* fall through */
+		fallthrough;
 
 	case HCI_DEV_UP:
 		skb = bt_skb_alloc(HCI_MON_INDEX_INFO_SIZE, GFP_ATOMIC);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 35d2bc569a2d..ade83e224567 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -666,8 +666,7 @@ void l2cap_chan_del(struct l2cap_chan *chan, int err)
 
 		l2cap_seq_list_free(&chan->srej_list);
 		l2cap_seq_list_free(&chan->retrans_list);
-
-		/* fall through */
+		fallthrough;
 
 	case L2CAP_MODE_STREAMING:
 		skb_queue_purge(&chan->tx_q);
@@ -872,7 +871,8 @@ static inline u8 l2cap_get_auth_type(struct l2cap_chan *chan)
 			else
 				return HCI_AT_NO_BONDING;
 		}
-		/* fall through */
+		fallthrough;
+
 	default:
 		switch (chan->sec_level) {
 		case BT_SECURITY_HIGH:
@@ -2983,8 +2983,7 @@ static void l2cap_tx_state_wait_f(struct l2cap_chan *chan,
 		break;
 	case L2CAP_EV_RECV_REQSEQ_AND_FBIT:
 		l2cap_process_reqseq(chan, control->reqseq);
-
-		/* Fall through */
+		fallthrough;
 
 	case L2CAP_EV_RECV_FBIT:
 		if (control && control->final) {
@@ -3311,7 +3310,7 @@ static inline __u8 l2cap_select_mode(__u8 mode, __u16 remote_feat_mask)
 	case L2CAP_MODE_ERTM:
 		if (l2cap_mode_supported(mode, remote_feat_mask))
 			return mode;
-		/* fall through */
+		fallthrough;
 	default:
 		return L2CAP_MODE_BASIC;
 	}
@@ -3447,7 +3446,7 @@ static int l2cap_build_conf_req(struct l2cap_chan *chan, void *data, size_t data
 		if (__l2cap_efs_supported(chan->conn))
 			set_bit(FLAG_EFS_ENABLE, &chan->flags);
 
-		/* fall through */
+		fallthrough;
 	default:
 		chan->mode = l2cap_select_mode(rfc.mode, chan->conn->feat_mask);
 		break;
@@ -4539,7 +4538,7 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
 				goto done;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 
 	default:
 		l2cap_chan_set_err(chan, ECONNRESET);
@@ -7719,7 +7718,7 @@ static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
 			conn->mtu = hcon->hdev->le_mtu;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		conn->mtu = hcon->hdev->acl_mtu;
 		break;
@@ -7841,7 +7840,7 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 	case L2CAP_MODE_STREAMING:
 		if (!disable_ertm)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		err = -EOPNOTSUPP;
 		goto done;
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index a995d2c51fa7..738a5345fa21 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -284,7 +284,7 @@ static int l2cap_sock_listen(struct socket *sock, int backlog)
 	case L2CAP_MODE_STREAMING:
 		if (!disable_ertm)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		err = -EOPNOTSUPP;
 		goto done;
@@ -760,7 +760,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 		case L2CAP_MODE_STREAMING:
 			if (!disable_ertm)
 				break;
-			/* fall through */
+			fallthrough;
 		default:
 			err = -EINVAL;
 			break;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5e9b9728eeac..2e6b4312f5fe 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4504,7 +4504,7 @@ static bool discovery_type_is_valid(struct hci_dev *hdev, uint8_t type,
 		*mgmt_status = mgmt_le_support(hdev);
 		if (*mgmt_status)
 			return false;
-		/* Intentional fall-through */
+		fallthrough;
 	case DISCOV_TYPE_BREDR:
 		*mgmt_status = mgmt_bredr_support(hdev);
 		if (*mgmt_status)
@@ -5880,7 +5880,7 @@ static int load_long_term_keys(struct sock *sk, struct hci_dev *hdev,
 		case MGMT_LTK_P256_DEBUG:
 			authenticated = 0x00;
 			type = SMP_LTK_P256_DEBUG;
-			/* fall through */
+			fallthrough;
 		default:
 			continue;
 		}
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 2e20af317cea..f2bacb464ccf 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -479,7 +479,7 @@ static int __rfcomm_dlc_close(struct rfcomm_dlc *d, int err)
 		/* if closing a dlc in a session that hasn't been started,
 		 * just close and unlink the dlc
 		 */
-		/* fall through */
+		fallthrough;
 
 	default:
 		rfcomm_dlc_clear_timer(d);
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index df14eebe80da..0afc4bc5ab41 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -218,7 +218,7 @@ static void __rfcomm_sock_close(struct sock *sk)
 	case BT_CONFIG:
 	case BT_CONNECTED:
 		rfcomm_dlc_close(d, 0);
-		/* fall through */
+		fallthrough;
 
 	default:
 		sock_set_flag(sk, SOCK_ZAPPED);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 684e60e1915c..21f5e6d9ea95 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1654,7 +1654,7 @@ int smp_user_confirm_reply(struct hci_conn *hcon, u16 mgmt_op, __le32 passkey)
 		memset(smp->tk, 0, sizeof(smp->tk));
 		BT_DBG("PassKey: %d", value);
 		put_unaligned_le32(value, smp->tk);
-		/* Fall Through */
+		fallthrough;
 	case MGMT_OP_USER_CONFIRM_REPLY:
 		set_bit(SMP_FLAG_TK_VALID, &smp->flags);
 		break;
-- 
2.27.0

