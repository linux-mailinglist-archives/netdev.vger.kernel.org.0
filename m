Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5191B2223A5
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgGPNOe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jul 2020 09:14:34 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:39948 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbgGPNOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 09:14:33 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7A4F8CED01;
        Thu, 16 Jul 2020 15:24:30 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH RFC] bluetooth: add support for some old headsets
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <6f461412-a6c0-aa53-5e74-394e278ee9b1@omprussia.ru>
Date:   Thu, 16 Jul 2020 15:14:31 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1834765D-52E6-45B8-9923-778C9182CFA9@holtmann.org>
References: <6f461412-a6c0-aa53-5e74-394e278ee9b1@omprussia.ru>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

> The MediaTek Bluetooth platform (MT6630 etc.) has a peculiar implementation
> for the eSCO/SCO connection via BT/EDR: the host controller returns error
> code 0x20 (LMP feature not supported) for HCI_Setup_Synchronous_Connection
> (0x0028) command without actually trying to setup connection with a remote
> device in case such device (like Digma BT-14 headset) didn't advertise its
> supported features.  Even though this doesn't break compatibility with the
> Bluetooth standard it breaks the compatibility with the Hands-Free Profile
> (HFP).
> 
> This patch returns the compatibility with the HFP profile and actually
> tries to check all available connection parameters despite of the specific
> MediaTek implementation. Without it one was unable to establish eSCO/SCO
> connection with some headsets.

please include the parts of btmon output that show this issue.

> Based on the patch by Ildar Kamaletdinov <i.kamaletdinov@omprussia.ru>.
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> 
> ---
> This patch is against the 'bluetooth-next.git' repo.
> 
> net/bluetooth/hci_event.c |    8 ++++++++
> 1 file changed, 8 insertions(+)
> 
> Index: bluetooth-next/net/bluetooth/hci_event.c
> ===================================================================
> --- bluetooth-next.orig/net/bluetooth/hci_event.c
> +++ bluetooth-next/net/bluetooth/hci_event.c
> @@ -2187,6 +2187,13 @@ static void hci_cs_setup_sync_conn(struc
> 	if (acl) {
> 		sco = acl->link;
> 		if (sco) {
> +			if (status == 0x20 && /* Unsupported LMP Parameter value */
> +			    sco->out) {
> +				sco->pkt_type = (hdev->esco_type & SCO_ESCO_MASK) |
> +						(hdev->esco_type & EDR_ESCO_MASK);
> +				if (hci_setup_sync(sco, sco->link->handle))
> +					goto unlock;
> +			}
> 			sco->state = BT_CLOSED;

since this is the command status event, I doubt that sco->out check is needed. And I would start with a switch statement right away.

I also think that we need to re-structure this hci_cs_setup_sync_conn function a little to avoid the deep indentation. Make it look more like hci_sync_conn_complete_evt also use a switch statement even if right now we only have one entry.

Regards

Marcel

