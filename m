Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838512288A7
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 20:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgGUS40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 14:56:26 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:44372 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgGUS4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 14:56:25 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 9268F21BD66F
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH RFC] bluetooth: add support for some old headsets
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     Marcel Holtmann <marcel@holtmann.org>
CC:     Johan Hedberg <johan.hedberg@gmail.com>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Ildar Kamaletdinov" <i.kamaletdinov@omprussia.ru>
References: <6f461412-a6c0-aa53-5e74-394e278ee9b1@omprussia.ru>
 <1834765D-52E6-45B8-9923-778C9182CFA9@holtmann.org>
 <e9f32310-2728-60a2-adc7-3a7418ce54e3@omprussia.ru>
 <848144D3-85F9-47F8-8CDA-02457FA7530F@holtmann.org>
 <0c2a8da1-6071-6597-d0d1-32ce1490aba7@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <6f271bf7-04ee-c971-9c69-de3f696769ed@omprussia.ru>
Date:   Tue, 21 Jul 2020 21:56:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0c2a8da1-6071-6597-d0d1-32ce1490aba7@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.87.161.224]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/17/20 10:12 PM, Sergey Shtylyov wrote:

>>>>> The MediaTek Bluetooth platform (MT6630 etc.) has a peculiar implementation
>>>>> for the eSCO/SCO connection via BT/EDR: the host controller returns error
>>>>> code 0x20 (LMP feature not supported) for HCI_Setup_Synchronous_Connection
>>>>> (0x0028) command without actually trying to setup connection with a remote
>>>>> device in case such device (like Digma BT-14 headset) didn't advertise its
>>>>> supported features.  Even though this doesn't break compatibility with the
>>>>> Bluetooth standard it breaks the compatibility with the Hands-Free Profile
>>>>> (HFP).
>>>>>
>>>>> This patch returns the compatibility with the HFP profile and actually
>>>>> tries to check all available connection parameters despite of the specific
>>>>> MediaTek implementation. Without it one was unable to establish eSCO/SCO
>>>>> connection with some headsets.
[...]
>>>>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>>>>>
>>>>> ---
>>>>> This patch is against the 'bluetooth-next.git' repo.
>>>>>
>>>>> net/bluetooth/hci_event.c |    8 ++++++++
>>>>> 1 file changed, 8 insertions(+)
>>>>>
>>>>> Index: bluetooth-next/net/bluetooth/hci_event.c
>>>>> ===================================================================
>>>>> --- bluetooth-next.orig/net/bluetooth/hci_event.c
>>>>> +++ bluetooth-next/net/bluetooth/hci_event.c
>>>>> @@ -2187,6 +2187,13 @@ static void hci_cs_setup_sync_conn(struc
>>>>> 	if (acl) {
>>>>> 		sco = acl->link;
>>>>> 		if (sco) {
>>>>> +			if (status == 0x20 && /* Unsupported LMP Parameter value */
>>>>> +			    sco->out) {
> 
>     Actually, I was expecting that you'd tell me to create a HCI quirk for this situation.
> I have a patch doing that but I haven't been able to locate the driver in which to set this
> quirk flag...

   And that's no wonder! The BT driver that needs this patch is out-of-tree (and not even open
source, it seems) as we have finally ascertained with Ildar... Is there any interest in the
"preparatory" patch that lowers the indentation levels in hci_cs_setup_sync_conn()?

[...]

MBR, Sergei
