Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CAB347206
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 08:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbhCXHGn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Mar 2021 03:06:43 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:37100 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhCXHGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 03:06:38 -0400
Received: from mac-pro.holtmann.net (p4fefce19.dip0.t-ipconnect.de [79.239.206.25])
        by mail.holtmann.org (Postfix) with ESMTPSA id 4D665CECD2;
        Wed, 24 Mar 2021 08:14:11 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] Bluetooth: Always call advertising disable before setting
 params
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210323141653.1.I53e6be1f7df0be198b7e55ae9fc45c7f5760132d@changeid>
Date:   Wed, 24 Mar 2021 08:06:32 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8E70C497-BDCE-471F-9ECD-790E2FE3B024@holtmann.org>
References: <20210323141653.1.I53e6be1f7df0be198b7e55ae9fc45c7f5760132d@changeid>
To:     Daniel Winkler <danielwinkler@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

> In __hci_req_enable_advertising, the HCI_LE_ADV hdev flag is temporarily
> cleared to allow the random address to be set, which exposes a race
> condition when an advertisement is configured immediately (<10ms) after
> software rotation starts to refresh an advertisement.
> 
> In normal operation, the HCI_LE_ADV flag is updated as follows:
> 
> 1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
>   __hci_req_enable_advertising, but hci_req configures an enable
>   request
> 2. hci_req is run, enable callback re-sets HCI_LE_ADV flag
> 
> However, in this race condition, the following occurs:
> 
> 1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
>   __hci_req_enable_advertising, but hci_req configures an enable
>   request
> 2. add_advertising is called, which also calls
>   __hci_req_enable_advertising. Because HCI_LE_ADV was cleared in Step
>   1, no "disable" command is queued.
> 3. hci_req for adv_timeout_expire is run, which enables advertising and
>   re-sets HCI_LE_ADV
> 4. hci_req for add_advertising is run, but because no "disable" command
>   was queued, we try to set advertising parameters while advertising is
>   active, causing a Command Disallowed error, failing the registration.
> 
> To resolve the issue, this patch removes the check for the HCI_LE_ADV
> flag, and always queues the "disable" request, since HCI_LE_ADV could be
> very temporarily out-of-sync. According to the spec, there is no harm in
> calling "disable" when advertising is not active.
> 
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Daniel Winkler <danielwinkler@google.com>
> ---
> 
> net/bluetooth/hci_request.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 8ace5d34b01efe..2b4b99f4cedf21 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -1547,8 +1547,10 @@ void __hci_req_enable_advertising(struct hci_request *req)
> 	if (!is_advertising_allowed(hdev, connectable))
> 		return;
> 
> -	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
> -		__hci_req_disable_advertising(req);
> +	/* Request that the controller stop advertising. This can be called
> +	 * whether or not there is an active advertisement.
> +	 */
> +	__hci_req_disable_advertising(req);

can you include a btmon trace that shows that we don’t get a HCI error. Since if we get one, then the complete request will fail. And that has further side effects.

Regards

Marcel

