Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E618222D23
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgGPUlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:41:49 -0400
Received: from mxout04.lancloud.ru ([89.108.124.63]:49028 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgGPUls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:41:48 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jul 2020 16:41:47 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru A7CC920F54B3
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH RFC] bluetooth: add support for some old headsets
To:     Marcel Holtmann <marcel@holtmann.org>
CC:     Johan Hedberg <johan.hedberg@gmail.com>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <6f461412-a6c0-aa53-5e74-394e278ee9b1@omprussia.ru>
 <1834765D-52E6-45B8-9923-778C9182CFA9@holtmann.org>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <e9f32310-2728-60a2-adc7-3a7418ce54e3@omprussia.ru>
Date:   Thu, 16 Jul 2020 23:33:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1834765D-52E6-45B8-9923-778C9182CFA9@holtmann.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.87.162.122]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/16/20 4:14 PM, Marcel Holtmann wrote:

>> The MediaTek Bluetooth platform (MT6630 etc.) has a peculiar implementation
>> for the eSCO/SCO connection via BT/EDR: the host controller returns error
>> code 0x20 (LMP feature not supported) for HCI_Setup_Synchronous_Connection
>> (0x0028) command without actually trying to setup connection with a remote
>> device in case such device (like Digma BT-14 headset) didn't advertise its
>> supported features.  Even though this doesn't break compatibility with the
>> Bluetooth standard it breaks the compatibility with the Hands-Free Profile
>> (HFP).
>>
>> This patch returns the compatibility with the HFP profile and actually
>> tries to check all available connection parameters despite of the specific
>> MediaTek implementation. Without it one was unable to establish eSCO/SCO
>> connection with some headsets.
> 
> please include the parts of btmon output that show this issue.

   Funny, I had removed that part from the original patch. Here's that log:

< HCI Command: Setup Synchronous Connection (0x01|0x0028) plen 17                                  #1 [hci0] 6.705320
        Handle: 50
        Transmit bandwidth: 8000
        Receive bandwidth: 8000
        Max latency: 10
        Setting: 0x0060
          Input Coding: Linear
          Input Data Format: 2's complement
          Input Sample Size: 16-bit
            of bits padding at MSB: 0
          Air Coding Format: CVSD
        Retransmission effort: Optimize for power consumption (0x01)
        Packet type: 0x0380
          3-EV3 may not be used
          2-EV5 may not be used
          3-EV5 may not be used
> HCI Event: Command Status (0x0f) plen 4                                                          #2 [hci0] 6.719598
      Setup Synchronous Connection (0x01|0x0028) ncmd 1
        Status: Unsupported LMP Parameter Value / Unsupported LL Parameter Value (0x20)

>> Based on the patch by Ildar Kamaletdinov <i.kamaletdinov@omprussia.ru>.
>>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>>
>> ---
>> This patch is against the 'bluetooth-next.git' repo.
>>
>> net/bluetooth/hci_event.c |    8 ++++++++
>> 1 file changed, 8 insertions(+)
>>
>> Index: bluetooth-next/net/bluetooth/hci_event.c
>> ===================================================================
>> --- bluetooth-next.orig/net/bluetooth/hci_event.c
>> +++ bluetooth-next/net/bluetooth/hci_event.c
>> @@ -2187,6 +2187,13 @@ static void hci_cs_setup_sync_conn(struc
>> 	if (acl) {
>> 		sco = acl->link;
>> 		if (sco) {
>> +			if (status == 0x20 && /* Unsupported LMP Parameter value */
>> +			    sco->out) {
>> +				sco->pkt_type = (hdev->esco_type & SCO_ESCO_MASK) |
>> +						(hdev->esco_type & EDR_ESCO_MASK);
>> +				if (hci_setup_sync(sco, sco->link->handle))
>> +					goto unlock;
>> +			}
>> 			sco->state = BT_CLOSED;
> 
> since this is the command status event, I doubt that sco->out check is needed.

   Can't comment oin this, my BT fu is too weak... 

> And I would start with a switch statement right away.

   Funny, I had removed the *switch* statement from the original patch... :-)

> I also think that we need to re-structure this hci_cs_setup_sync_conn function a little to avoid the deep indentation.
> Make it look more like hci_sync_conn_complete_evt also use a switch statement even if right now we only have one 
> entry.

    Indeed, done now. :-)
 
> Regards
> 
> Marcel

MBR, Sergey
