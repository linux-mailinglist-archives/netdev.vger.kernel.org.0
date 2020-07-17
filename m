Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7E4223509
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgGQG7r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jul 2020 02:59:47 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45345 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgGQG7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:59:46 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 81F2ECED0F;
        Fri, 17 Jul 2020 09:09:43 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH RFC] bluetooth: add support for some old headsets
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <e9f32310-2728-60a2-adc7-3a7418ce54e3@omprussia.ru>
Date:   Fri, 17 Jul 2020 08:59:44 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <848144D3-85F9-47F8-8CDA-02457FA7530F@holtmann.org>
References: <6f461412-a6c0-aa53-5e74-394e278ee9b1@omprussia.ru>
 <1834765D-52E6-45B8-9923-778C9182CFA9@holtmann.org>
 <e9f32310-2728-60a2-adc7-3a7418ce54e3@omprussia.ru>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

>>> The MediaTek Bluetooth platform (MT6630 etc.) has a peculiar implementation
>>> for the eSCO/SCO connection via BT/EDR: the host controller returns error
>>> code 0x20 (LMP feature not supported) for HCI_Setup_Synchronous_Connection
>>> (0x0028) command without actually trying to setup connection with a remote
>>> device in case such device (like Digma BT-14 headset) didn't advertise its
>>> supported features.  Even though this doesn't break compatibility with the
>>> Bluetooth standard it breaks the compatibility with the Hands-Free Profile
>>> (HFP).
>>> 
>>> This patch returns the compatibility with the HFP profile and actually
>>> tries to check all available connection parameters despite of the specific
>>> MediaTek implementation. Without it one was unable to establish eSCO/SCO
>>> connection with some headsets.
>> 
>> please include the parts of btmon output that show this issue.
> 
>   Funny, I had removed that part from the original patch. Here's that log:
> 
> < HCI Command: Setup Synchronous Connection (0x01|0x0028) plen 17                                  #1 [hci0] 6.705320
>        Handle: 50
>        Transmit bandwidth: 8000
>        Receive bandwidth: 8000
>        Max latency: 10
>        Setting: 0x0060
>          Input Coding: Linear
>          Input Data Format: 2's complement
>          Input Sample Size: 16-bit
>            of bits padding at MSB: 0
>          Air Coding Format: CVSD
>        Retransmission effort: Optimize for power consumption (0x01)
>        Packet type: 0x0380
>          3-EV3 may not be used
>          2-EV5 may not be used
>          3-EV5 may not be used
>> HCI Event: Command Status (0x0f) plen 4                                                          #2 [hci0] 6.719598
>      Setup Synchronous Connection (0x01|0x0028) ncmd 1
>        Status: Unsupported LMP Parameter Value / Unsupported LL Parameter Value (0x20)

I double check with the specification and it is not precise that errors should be reported via sync conn complete events. My assumption would be that your headset only supports SCO and thus the controller realizes that eSCO request can not be completed anyway. So the controller opts for quickest path to get out of this.

> 
>>> Based on the patch by Ildar Kamaletdinov <i.kamaletdinov@omprussia.ru>.
>>> 
>>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>>> 
>>> ---
>>> This patch is against the 'bluetooth-next.git' repo.
>>> 
>>> net/bluetooth/hci_event.c |    8 ++++++++
>>> 1 file changed, 8 insertions(+)
>>> 
>>> Index: bluetooth-next/net/bluetooth/hci_event.c
>>> ===================================================================
>>> --- bluetooth-next.orig/net/bluetooth/hci_event.c
>>> +++ bluetooth-next/net/bluetooth/hci_event.c
>>> @@ -2187,6 +2187,13 @@ static void hci_cs_setup_sync_conn(struc
>>> 	if (acl) {
>>> 		sco = acl->link;
>>> 		if (sco) {
>>> +			if (status == 0x20 && /* Unsupported LMP Parameter value */
>>> +			    sco->out) {
>>> +				sco->pkt_type = (hdev->esco_type & SCO_ESCO_MASK) |
>>> +						(hdev->esco_type & EDR_ESCO_MASK);
>>> +				if (hci_setup_sync(sco, sco->link->handle))
>>> +					goto unlock;
>>> +			}
>>> 			sco->state = BT_CLOSED;
>> 
>> since this is the command status event, I doubt that sco->out check is needed.
> 
>   Can't comment oin this, my BT fu is too weak... 

It is the case. Command status is only local to command we issued and thus in this case it is the connection creation attempt from our side. Meaning it is always outgoing.

Regards

Marcel

