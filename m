Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5B727BCFE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgI2GVL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Sep 2020 02:21:11 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59938 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI2GVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:21:11 -0400
Received: from [172.20.10.2] (x59cc8957.dyn.telefonica.de [89.204.137.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id A2581CED1B;
        Tue, 29 Sep 2020 08:28:06 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v3] Bluetooth: Check for encryption key size on connect
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAJQfnxE2R0ouT+c_Z0TyU-xV=tFCbqBA=n8trwFmZuT=Bp+VDg@mail.gmail.com>
Date:   Tue, 29 Sep 2020 08:21:05 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DE574843-49B0-4DF6-95F4-23F507424695@holtmann.org>
References: <20200922155548.v3.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
 <BC59363A-B32A-4DAA-BAF5-F7FBA01752E6@holtmann.org>
 <CAJQfnxHPDktGp=MQJzY57qmMTO7TPfNZvLHLm7DAyZ-4qM-DnQ@mail.gmail.com>
 <6FDED095-BAE4-437D-9A25-37245B8454B1@holtmann.org>
 <CAJQfnxFbBRfiDF2xmzzPZ7N3qr41ubH29Fa0FDg9+jh-4OQxhg@mail.gmail.com>
 <E61715A9-7B65-4EB4-8CED-AADE46FF72A1@holtmann.org>
 <CAJQfnxE2R0ouT+c_Z0TyU-xV=tFCbqBA=n8trwFmZuT=Bp+VDg@mail.gmail.com>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

>>>>>>> When receiving connection, we only check whether the link has been
>>>>>>> encrypted, but not the encryption key size of the link.
>>>>>>> 
>>>>>>> This patch adds check for encryption key size, and reject L2CAP
>>>>>>> connection which size is below the specified threshold (default 7)
>>>>>>> with security block.
>>>>>>> 
>>>>>>> Here is some btmon trace.
>>>>>>> @ MGMT Event: New Link Key (0x0009) plen 26    {0x0001} [hci0] 5.847722
>>>>>>>     Store hint: No (0x00)
>>>>>>>     BR/EDR Address: 38:00:25:F7:F1:B0 (OUI 38-00-25)
>>>>>>>     Key type: Unauthenticated Combination key from P-192 (0x04)
>>>>>>>     Link key: 7bf2f68c81305d63a6b0ee2c5a7a34bc
>>>>>>>     PIN length: 0
>>>>>>>> HCI Event: Encryption Change (0x08) plen 4        #29 [hci0] 5.871537
>>>>>>>     Status: Success (0x00)
>>>>>>>     Handle: 256
>>>>>>>     Encryption: Enabled with E0 (0x01)
>>>>>>> < HCI Command: Read Encryp... (0x05|0x0008) plen 2  #30 [hci0] 5.871609
>>>>>>>     Handle: 256
>>>>>>>> HCI Event: Command Complete (0x0e) plen 7         #31 [hci0] 5.872524
>>>>>>>   Read Encryption Key Size (0x05|0x0008) ncmd 1
>>>>>>>     Status: Success (0x00)
>>>>>>>     Handle: 256
>>>>>>>     Key size: 3
>>>>>>> 
>>>>>>> ////// WITHOUT PATCH //////
>>>>>>>> ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 5.895023
>>>>>>>   L2CAP: Connection Request (0x02) ident 3 len 4
>>>>>>>     PSM: 4097 (0x1001)
>>>>>>>     Source CID: 64
>>>>>>> < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 5.895213
>>>>>>>   L2CAP: Connection Response (0x03) ident 3 len 8
>>>>>>>     Destination CID: 64
>>>>>>>     Source CID: 64
>>>>>>>     Result: Connection successful (0x0000)
>>>>>>>     Status: No further information available (0x0000)
>>>>>>> 
>>>>>>> ////// WITH PATCH //////
>>>>>>>> ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 4.887024
>>>>>>>   L2CAP: Connection Request (0x02) ident 3 len 4
>>>>>>>     PSM: 4097 (0x1001)
>>>>>>>     Source CID: 64
>>>>>>> < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 4.887127
>>>>>>>   L2CAP: Connection Response (0x03) ident 3 len 8
>>>>>>>     Destination CID: 0
>>>>>>>     Source CID: 64
>>>>>>>     Result: Connection refused - security block (0x0003)
>>>>>>>     Status: No further information available (0x0000)
>>>>>>> 
>>>>>>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
>>>>>>> 
>>>>>>> ---
>>>>>>> 
>>>>>>> Changes in v3:
>>>>>>> * Move the check to hci_conn_check_link_mode()
>>>>>>> 
>>>>>>> Changes in v2:
>>>>>>> * Add btmon trace to the commit message
>>>>>>> 
>>>>>>> net/bluetooth/hci_conn.c | 4 ++++
>>>>>>> 1 file changed, 4 insertions(+)
>>>>>>> 
>>>>>>> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
>>>>>>> index 9832f8445d43..89085fac797c 100644
>>>>>>> --- a/net/bluetooth/hci_conn.c
>>>>>>> +++ b/net/bluetooth/hci_conn.c
>>>>>>> @@ -1348,6 +1348,10 @@ int hci_conn_check_link_mode(struct hci_conn *conn)
>>>>>>>        !test_bit(HCI_CONN_ENCRYPT, &conn->flags))
>>>>>>>            return 0;
>>>>>>> 
>>>>>>> +     if (test_bit(HCI_CONN_ENCRYPT, &conn->flags) &&
>>>>>>> +         conn->enc_key_size < conn->hdev->min_enc_key_size)
>>>>>>> +             return 0;
>>>>>>> +
>>>>>>>    return 1;
>>>>>>> }
>>>>>> 
>>>>>> I am a bit concerned since we had that check and I on purpose moved it. See commit 693cd8ce3f88 for the change where I removed and commit d5bb334a8e17 where I initially added it.
>>>>>> 
>>>>>> Naively adding the check in that location caused a major regression with Bluetooth 2.0 devices. This makes me a bit reluctant to re-add it here since I restructured the whole change to check the key size a different location.
>>>>> 
>>>>> I have tried this patch (both v2 and v3) to connect with a Bluetooth
>>>>> 2.0 device, it doesn't have any connection problem.
>>>>> I suppose because in the original patch (d5bb334a8e17), there is no
>>>>> check for the HCI_CONN_ENCRYPT flag.
>>>> 
>>>> while that might be the case, I am still super careful. Especially also in conjunction with the email / patch from Alex trying to add just another encryption key size check. If we really need them or even both, we have to audit the whole code since I must have clearly missed something when adding the KNOB fix.
>>>> 
>>>>>> Now I have to ask, are you running an upstream kernel with both commits above that address KNOB vulnerability?
>>>>> 
>>>>> Actually no, I haven't heard of KNOB vulnerability before.
>>>>> This patch is written for qualification purposes, specifically to pass
>>>>> GAP/SEC/SEM/BI-05-C to BI-08-C.
>>>>> However, it sounds like it could also prevent some KNOB vulnerability
>>>>> as a bonus.
>>>> 
>>>> That part worries me since there should be no gaps that allows an encryption key size downgrade if our side supports Read Encryption Key Size.
>>>> 
>>>> We really have to ensure that any L2CAP communication is stalled until we have all information from HCI connection setup that we need. So maybe the change Alex did would work as well, or as I mentioned put any L2CAP connection request as pending so that the validation happens in one place.
>>> 
>>> I think Alex and I are solving the same problem, either one of the
>>> patches should be enough.
>>> 
>>> Here is my test method using BlueZ as both the IUT and the lower test.
>>> (1) Copy the bluez/test/test-profile python script to IUT and lower test.
>>> (2) Assign a fake service server to IUT
>>> python test-profile -u 00001fff-0000-1000-2000-123456789abc -s -P 4097
>>> (3) Assign a fake service client to lower test
>>> python test-profile -u 00001fff-0000-1000-2000-123456789abc -c
>>> (4) Make the lower test accept weak encryption key
>>> echo 1 > /sys/kernel/debug/bluetooth/hci0/min_encrypt_key_size
>>> (5) Enable ssp and disable sc on lower test
>>> btmgmt ssp on
>>> btmgmt sc off
>>> (6) Set lower test encryption key size to 1
>>> (7) initiate connection from lower test
>>> dbus-send --system --print-reply --dest=org.bluez
>>> /org/bluez/hci0/dev_<IUT> org.bluez.Device1.ConnectProfile
>>> string:00001fff-0000-1000-2000-123456789abc
>>> 
>>> After MITM authentication, IUT will incorrectly accept the connection,
>>> even though the encryption key used is less than the one specified in
>>> IUT's min_encrypt_key_size.
>> 
>> I almost assumed that you two are chasing the same issue here. Problem is I really don’t yet know where to correctly put that encryption key size check.
>> 
>> There is one case in l2cap_connect() that will not respond with L2CAP_CR_PEND.
>> 
>>                                /* Force pending result for AMP controllers.
>>                                 * The connection will succeed after the
>>                                 * physical link is up.
>>                                 */
>>                                if (amp_id == AMP_ID_BREDR) {
>>                                        l2cap_state_change(chan, BT_CONFIG);
>>                                        result = L2CAP_CR_SUCCESS;
>>                                } else {
>>                                        l2cap_state_change(chan, BT_CONNECT2);
>>                                        result = L2CAP_CR_PEND;
>>                                }
>>                                status = L2CAP_CS_NO_INFO;
>> 
>> Most services will actually use FLAG_DEFER_SETUP and then you also don’t run into this issue since at this stage the response is L2CAP_CR_PEND as well.
>> 
>> One question we should answer is if we just always return L2CAP_CR_PEND or if we actually add the check for the encryption key size here as well. This has always been a shortcut to avoid an unneeded round-trip if all information are present. Question really is if all information are present or if this is just pure luck. I don’t see a guarantee that the encryption key size has been read in any of your patches.
>> 
>> Everywhere else in the code we have this sequence of checks:
>> 
>>        l2cap_chan_check_security()
>> 
>>        l2cap_check_enc_key_size()
>> 
>> This is generally how l2cap_do_start() or l2cap_conn_start() do their job. So we might have to restructure l2cap_connect() a little bit for following the same principle.
>> 
>> Anyhow, before do this, can we try if this patch fixes this as well and check the btmon trace for it:
>> 
>> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
>> index 1ab27b90ddcb..88e4c1292b98 100644
>> --- a/net/bluetooth/l2cap_core.c
>> +++ b/net/bluetooth/l2cap_core.c
>> @@ -4156,17 +4156,8 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
>>                                status = L2CAP_CS_AUTHOR_PEND;
>>                                chan->ops->defer(chan);
>>                        } else {
>> -                               /* Force pending result for AMP controllers.
>> -                                * The connection will succeed after the
>> -                                * physical link is up.
>> -                                */
>> -                               if (amp_id == AMP_ID_BREDR) {
>> -                                       l2cap_state_change(chan, BT_CONFIG);
>> -                                       result = L2CAP_CR_SUCCESS;
>> -                               } else {
>> -                                       l2cap_state_change(chan, BT_CONNECT2);
>> -                                       result = L2CAP_CR_PEND;
>> -                               }
>> +                               l2cap_state_change(chan, BT_CONNECT2);
>> +                               result = L2CAP_CR_PEND;
>>                                status = L2CAP_CS_NO_INFO;
>>                        }
>>                } else {
>> 
>> If this fixes your issue and puts the encryption key size check back in play, then I just have to think about on how to fix this.
> 
> That patch alone doesn't fix the issue I have. By applying it, the
> only difference I am aware of is we would first reply "connection
> pending" to the initial SDP request of the peripheral, instead of just
> "connection successful". Subsequent L2CAP connections go to the
> FLAG_DEFER_SETUP branch just a tad above the change in the patch, so
> they are not affected at all.

but SDP is especially allowed to be unencrypted. In conclusion that also means that a negotiated key size of 1 would be acceptable. It is for everything except PSM 1 where we have to ensure that it is a) encrypted and b) has a minimum key size.

Regards

Marcel

