Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B9B2303AF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgG1HRB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jul 2020 03:17:01 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41332 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgG1HRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 03:17:00 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id B94B2CECCD;
        Tue, 28 Jul 2020 09:27:00 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH RFC] bluetooth: add support for some old headsets
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <6f271bf7-04ee-c971-9c69-de3f696769ed@omprussia.ru>
Date:   Tue, 28 Jul 2020 09:16:59 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ildar Kamaletdinov <i.kamaletdinov@omprussia.ru>
Content-Transfer-Encoding: 8BIT
Message-Id: <97E2381A-219D-46AF-962F-CBCD63B911AD@holtmann.org>
References: <6f461412-a6c0-aa53-5e74-394e278ee9b1@omprussia.ru>
 <1834765D-52E6-45B8-9923-778C9182CFA9@holtmann.org>
 <e9f32310-2728-60a2-adc7-3a7418ce54e3@omprussia.ru>
 <848144D3-85F9-47F8-8CDA-02457FA7530F@holtmann.org>
 <0c2a8da1-6071-6597-d0d1-32ce1490aba7@omprussia.ru>
 <6f271bf7-04ee-c971-9c69-de3f696769ed@omprussia.ru>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

>>>>>> The MediaTek Bluetooth platform (MT6630 etc.) has a peculiar implementation
>>>>>> for the eSCO/SCO connection via BT/EDR: the host controller returns error
>>>>>> code 0x20 (LMP feature not supported) for HCI_Setup_Synchronous_Connection
>>>>>> (0x0028) command without actually trying to setup connection with a remote
>>>>>> device in case such device (like Digma BT-14 headset) didn't advertise its
>>>>>> supported features.  Even though this doesn't break compatibility with the
>>>>>> Bluetooth standard it breaks the compatibility with the Hands-Free Profile
>>>>>> (HFP).
>>>>>> 
>>>>>> This patch returns the compatibility with the HFP profile and actually
>>>>>> tries to check all available connection parameters despite of the specific
>>>>>> MediaTek implementation. Without it one was unable to establish eSCO/SCO
>>>>>> connection with some headsets.
> [...]
>>>>>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>>>>>> 
>>>>>> ---
>>>>>> This patch is against the 'bluetooth-next.git' repo.
>>>>>> 
>>>>>> net/bluetooth/hci_event.c |    8 ++++++++
>>>>>> 1 file changed, 8 insertions(+)
>>>>>> 
>>>>>> Index: bluetooth-next/net/bluetooth/hci_event.c
>>>>>> ===================================================================
>>>>>> --- bluetooth-next.orig/net/bluetooth/hci_event.c
>>>>>> +++ bluetooth-next/net/bluetooth/hci_event.c
>>>>>> @@ -2187,6 +2187,13 @@ static void hci_cs_setup_sync_conn(struc
>>>>>> 	if (acl) {
>>>>>> 		sco = acl->link;
>>>>>> 		if (sco) {
>>>>>> +			if (status == 0x20 && /* Unsupported LMP Parameter value */
>>>>>> +			    sco->out) {
>> 
>>    Actually, I was expecting that you'd tell me to create a HCI quirk for this situation.
>> I have a patch doing that but I haven't been able to locate the driver in which to set this
>> quirk flag...
> 
>   And that's no wonder! The BT driver that needs this patch is out-of-tree (and not even open
> source, it seems) as we have finally ascertained with Ildar... Is there any interest in the
> "preparatory" patch that lowers the indentation levels in hci_cs_setup_sync_conn()?

how is it possible that there is an out-of-tree Bluetooth driver. Seems odd. Maybe want to submit that upstream first.

Regards

Marcel

