Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CF3496852
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 00:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiAUXw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 18:52:27 -0500
Received: from giacobini.uberspace.de ([185.26.156.129]:39048 "EHLO
        giacobini.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiAUXw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 18:52:26 -0500
Received: (qmail 2300 invoked by uid 990); 21 Jan 2022 23:52:24 -0000
Authentication-Results: giacobini.uberspace.de;
        auth=pass (plain)
Message-ID: <5d83dba0-2283-ef9d-e8f7-82e6628d4263@eknoes.de>
Date:   Sat, 22 Jan 2022 00:52:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20220121173622.192744-1-soenke.huster@eknoes.de>
 <4f3d6dcf-c142-9a99-df97-6190c8f2abc9@eknoes.de>
 <CABBYNZ+VQ3Gfw0n=PavFhnnOy2=+1OAeV5UT_S25Lz_4gWzWEQ@mail.gmail.com>
 <995e58bb-6dfb-b3db-c8a5-b9e30dbb104d@eknoes.de>
 <CABBYNZJx+UzHLRA8o=z-fkiHAmBJ6-WtY35eJtD6C6N6PhLbDQ@mail.gmail.com>
From:   =?UTF-8?Q?S=c3=b6nke_Huster?= <soenke.huster@eknoes.de>
Subject: Re: [RFC PATCH] Bluetooth: hci_event: Ignore multiple conn complete
 events
In-Reply-To: <CABBYNZJx+UzHLRA8o=z-fkiHAmBJ6-WtY35eJtD6C6N6PhLbDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -
X-Rspamd-Report: MIME_GOOD(-0.1) BAYES_HAM(-3) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -1.6
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Sat, 22 Jan 2022 00:52:24 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

On 22.01.22 00:32, Luiz Augusto von Dentz wrote:
> Hi Sönke,
> 
> On Fri, Jan 21, 2022 at 3:18 PM Sönke Huster <soenke.huster@eknoes.de> wrote:
>>
>> Hi Luiz,
>>
>> On 21.01.22 22:31, Luiz Augusto von Dentz wrote:
>>> Hi Sönke,
>>>
>>> On Fri, Jan 21, 2022 at 10:22 AM Sönke Huster <soenke.huster@eknoes.de> wrote:
>>>>
>>>> I just noticed that just checking for handle does not work, as obviously 0x0 could also be a handle value and therefore it can't be distinguished, whether it is not set yet or it is 0x0.
>>>
>>> Yep, we should probably check its state, check for state != BT_OPEN
>>> since that is what hci_conn_add initialize the state.
>>>
>>
>> I thought there are more valid connection states for the first HCI_CONNECTION_COMPLETE event, as it also occurs e.g. after an HCI_Create_Connection command, see Core 5.3 p.2170:
>>> This event also indicates to the Host which issued the HCI_Create_Connection, HCI_Accept_-
>>> Connection_Request, or HCI_Reject_Connection_Request command, and
>>> then received an HCI_Command_Status event, if the issued command failed or
>>> was successful.
>>
>> For example in hci_conn.c hci_acl_create_connection (which triggers a HCI_Create_Connection command as far as I understand), the state of the connection is changed to BT_CONNECT or BT_CONNECT2.
>> But as I am quite new in the (Linux) Bluetooth world, I might have a wrong understanding of that.
> 
> Yep, we would probably need a switch to capture which states are valid
> and which are not or we initialize the handle with something outside
> of the valid range of handles (0x0000 to 0x0EFF) so we can initialize
> it to e.g. 0xffff (using something like define HCI_CONN_HANDLE_UNSET)
> so we can really tell when it has been set or not.
> 

I think the state switch is just possible if there is no possibility
to change a connection state back into one of the accepted states.
Unless changing the state back into an accepted state includes a call
to "hci_conn_del_sysfs", as the real issue when getting a duplicate
HCI_Create_Connection event is that device_add in hci_conn_add_sysfs
is called twice for the same connection.

There might be other issues as well in processing a duplicate event,
but as far as I can see the bugs I trigger rely on multiple calls to
device_add which lead in the long run to multiple user-after frees
or null-pointer derefs. I tried to write that up in the bugzilla report
here: https://bugzilla.kernel.org/show_bug.cgi?id=215497


When using something like HCI_CONN_HANDLE_UNSET, we need to make sure
that everywhere where we receive a handle from an event and use it to
set conn->handle, it is a valid one. Otherwise a hacked / malicious
controller would just send multiple events for the invalid handle.

What solution do you prefer? If you don't mind I'd like to try to
create a patch.  

>>>> On 21.01.22 18:36, Soenke Huster wrote:
>>>>> When a HCI_CONNECTION_COMPLETE event is received multiple times
>>>>> for the same handle, the device is registered multiple times which leads
>>>>> to memory corruptions. Therefore, consequent events for a single
>>>>> connection are ignored.
>>>>>
>>>>> The conn->state can hold different values so conn->handle is
>>>>> checked to detect whether a connection is already set up.
>>>>>
>>>>> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=215497
>>>>> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
>>>>> ---
>>>>> This fixes the referenced bug and several use-after-free issues I discovered.
>>>>> I tagged it as RFC, as I am not 100% sure if checking the existence of the
>>>>> handle is the correct approach, but to the best of my knowledge it must be
>>>>> set for the first time in this function for valid connections of this event,
>>>>> therefore it should be fine.
>>>>>
>>>>> net/bluetooth/hci_event.c | 11 +++++++++++
>>>>>  1 file changed, 11 insertions(+)
>>>>>
>>>>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>>>>> index 681c623aa380..71ccb12c928d 100644
>>>>> --- a/net/bluetooth/hci_event.c
>>>>> +++ b/net/bluetooth/hci_event.c
>>>>> @@ -3106,6 +3106,17 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
>>>>>               }
>>>>>       }
>>>>>
>>>>> +     /* The HCI_Connection_Complete event is only sent once per connection.
>>>>> +      * Processing it more than once per connection can corrupt kernel memory.
>>>>> +      *
>>>>> +      * As the connection handle is set here for the first time, it indicates
>>>>> +      * whether the connection is already set up.
>>>>> +      */
>>>>> +     if (conn->handle) {
>>>>> +             bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for existing connection");
>>>>> +             goto unlock;
>>>>> +     }
>>>>> +
>>>>>       if (!ev->status) {
>>>>>               conn->handle = __le16_to_cpu(ev->handle);
>>>>>
>>>
>>>
>>>
>>
>> Best
>> Sönke
> 
> 
> 
