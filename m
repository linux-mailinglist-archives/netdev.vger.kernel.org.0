Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8119D3D25ED
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhGVN6k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Jul 2021 09:58:40 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47706 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhGVN6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:58:39 -0400
Received: from smtpclient.apple (p5b3d2eb8.dip0.t-ipconnect.de [91.61.46.184])
        by mail.holtmann.org (Postfix) with ESMTPSA id E3DF1CECDF;
        Thu, 22 Jul 2021 16:39:12 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] Bluetooth: skip invalid hci_sync_conn_complete_evt
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210721101710.82974-1-desmondcheongzx@gmail.com>
Date:   Thu, 22 Jul 2021 16:39:12 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <A47B24AE-C807-4ADA-B0F7-8283ACC83BF7@holtmann.org>
References: <20210721101710.82974-1-desmondcheongzx@gmail.com>
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Desmond,

> Syzbot reported a corrupted list in kobject_add_internal [1]. This
> happens when multiple HCI_EV_SYNC_CONN_COMPLETE event packets with
> status 0 are sent for the same HCI connection. This causes us to
> register the device more than once which corrupts the kset list.

and that is actually forbidden by the spec. So we need to complain loudly that such a device is misbehaving.

> To fix this, in hci_sync_conn_complete_evt, we check whether we're
> trying to process the same HCI_EV_SYNC_CONN_COMPLETE event multiple
> times for one connection. If that's the case, the event is invalid, so
> we skip further processing and exit.
> 
> Link: https://syzkaller.appspot.com/bug?extid=66264bf2fd0476be7e6c [1]
> Reported-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
> Tested-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> ---
> net/bluetooth/hci_event.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 016b2999f219..091a92338492 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4373,6 +4373,8 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
> 
> 	switch (ev->status) {
> 	case 0x00:
> +		if (conn->state == BT_CONNECTED)
> +			goto unlock;  /* Already connected, event not valid */

The comment has go above and be a lot more details since this is not expected behavior from valid hardware and we should add a bt_dev_err as well.

> 		conn->handle = __le16_to_cpu(ev->handle);
> 		conn->state  = BT_CONNECTED;
> 		conn->type   = ev->link_type;

Regards

Marcel

