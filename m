Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AE735A0CF
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 16:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhDIOO1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Apr 2021 10:14:27 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45734 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhDIOO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 10:14:26 -0400
Received: from marcel-macbook.holtmann.net (p5b3d235a.dip0.t-ipconnect.de [91.61.35.90])
        by mail.holtmann.org (Postfix) with ESMTPSA id 316B2CECC3;
        Fri,  9 Apr 2021 16:21:53 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v1] Bluetooth: Return whether a connection is outbound
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210402105437.v1.1.Id5ee0a2edda8f0902498aaeb1b6c78d062579b75@changeid>
Date:   Fri, 9 Apr 2021 16:14:09 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4E147FE8-F1B6-4EE9-9D7F-FE5656EAB2BE@holtmann.org>
References: <20210402105437.v1.1.Id5ee0a2edda8f0902498aaeb1b6c78d062579b75@changeid>
To:     Yu Liu <yudiliu@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yu,

> When an MGMT_EV_DEVICE_CONNECTED event is reported back to the user
> space we will set the flags to tell if the established connection is
> outbound or not. This is useful for the user space to log better metrics
> and error messages.
> 
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Signed-off-by: Yu Liu <yudiliu@google.com>
> ---
> 
> Changes in v1:
> - Initial change
> 
> include/net/bluetooth/mgmt.h | 2 ++
> net/bluetooth/mgmt.c         | 5 +++++
> 2 files changed, 7 insertions(+)
> 
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index a7cffb069565..7cc724386b00 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -885,6 +885,8 @@ struct mgmt_ev_new_long_term_key {
> 	struct mgmt_ltk_info key;
> } __packed;
> 
> +#define MGMT_DEV_CONN_INITIATED_CONNECTION 0x08
> +

I would just add this to MGMT_DEV_FOUND_INITIATED_CONN 0x08. And yes, I realize that this is a bit weird, but then all values are in one place.

> #define MGMT_EV_DEVICE_CONNECTED	0x000B
> struct mgmt_ev_device_connected {
> 	struct mgmt_addr_info addr;
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 09e099c419f2..77213e67e8e4 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -8774,6 +8774,11 @@ void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
> 	bacpy(&ev->addr.bdaddr, &conn->dst);
> 	ev->addr.type = link_to_bdaddr(conn->type, conn->dst_type);

So the prototype of mgmt_device_connected needs to be changed to remove the flags parameter. It is not used at all.

> 
> +	if (conn->out)
> +		flags |= MGMT_DEV_CONN_INITIATED_CONNECTION;
> +	else
> +		flags &= ~MGMT_DEV_CONN_INITIATED_CONNECTION;
> +

And then this should be just this:

	if (conn->out)
		flags |= MGMT_DEV_CONN_INITIATED_CONNECTION;

> 	ev->flags = __cpu_to_le32(flags);
> 
> 	/* We must ensure that the EIR Data fields are ordered and

Regards

Marcel

