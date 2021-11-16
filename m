Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE4345205C
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbhKPAwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:52:35 -0500
Received: from out2.migadu.com ([188.165.223.204]:48528 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350501AbhKPAuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:50:02 -0500
Subject: Re: [PATCH] bluetooth: fix uninitialized variables notify_evt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1637023624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SCice28xuZZAc41fE60nr3s0IgXGGl/rTAATNISezms=;
        b=DIIVhgdFFfEYFNLUC+GikeCQY2YRK8ieNu0bzrwwwFHhvsvpseaXmKcDdgMKIJn9JBAjRr
        sM8GvXwF1KxYzoxJUnbiVsRVDHyA5hCy7BfkMCD9fR69M3Nc4/XhM7uMlDTXXA8q4/+e0g
        9fVcXxophtkH+U9duWzTbqhgxlv9Hoc=
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     "Tumkur Narayan, Chethan" <chethan.tumkur.narayan@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20211115085613.1924762-1-liu.yun@linux.dev>
 <73AF4476-F5B2-4E83-9F43-72D98B4615FF@holtmann.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jackie Liu <liu.yun@linux.dev>
Message-ID: <e2d72c6c-3bf0-0d88-8033-af885259223c@linux.dev>
Date:   Tue, 16 Nov 2021 08:46:55 +0800
MIME-Version: 1.0
In-Reply-To: <73AF4476-F5B2-4E83-9F43-72D98B4615FF@holtmann.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: liu.yun@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Marcel.

ÔÚ 2021/11/16 ÉÏÎç1:27, Marcel Holtmann Ð´µÀ:
> Hi Jackie,
> 
>> Coverity Scan report:
>>
>> [...]
>> *** CID 1493985:  Uninitialized variables  (UNINIT)
>> /net/bluetooth/hci_event.c: 4535 in hci_sync_conn_complete_evt()
>> 4529
>> 4530     	/* Notify only in case of SCO over HCI transport data path which
>> 4531     	 * is zero and non-zero value shall be non-HCI transport data path
>> 4532     	 */
>> 4533     	if (conn->codec.data_path == 0) {
>> 4534     		if (hdev->notify)
>>>>>     CID 1493985:  Uninitialized variables  (UNINIT)
>>>>>     Using uninitialized value "notify_evt" when calling "*hdev->notify".
>> 4535     			hdev->notify(hdev, notify_evt);
>> 4536     	}
>> 4537
>> 4538     	hci_connect_cfm(conn, ev->status);
>> 4539     	if (ev->status)
>> 4540     		hci_conn_del(conn);
>> [...]
>>
>> Although only btusb uses air_mode, and he only handles HCI_NOTIFY_ENABLE_SCO_CVSD
>> and HCI_NOTIFY_ENABLE_SCO_TRANSP, there is still a very small chance that
>> ev->air_mode is not equal to 0x2 and 0x3, but notify_evt is initialized to
>> HCI_NOTIFY_ENABLE_SCO_CVSD or HCI_NOTIFY_ENABLE_SCO_TRANSP. the context is
>> maybe not correct.
>>
>> In order to ensure 100% correctness, we directly give him a default value 0.
>>
>> Addresses-Coverity: ("Uninitialized variables")
>> Fixes: f4f9fa0c07bb ("Bluetooth: Allow usb to auto-suspend when SCO use	non-HCI transport")
>> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
>> ---
>> net/bluetooth/hci_event.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>> index 7d0db1ca1248..f898fa42a183 100644
>> --- a/net/bluetooth/hci_event.c
>> +++ b/net/bluetooth/hci_event.c
>> @@ -4445,7 +4445,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
>> {
>> 	struct hci_ev_sync_conn_complete *ev = (void *) skb->data;
>> 	struct hci_conn *conn;
>> -	unsigned int notify_evt;
>> +	unsigned int notify_evt = 0;
>>
>> 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
> 
> lets modify the switch statement and add a default case. And then lets add a check to notify_evt != 0.
> 
> With that in mind, I wonder if this is not better
> 
>          /* Notify only in case of SCO over HCI transport data path which
>           * is zero and non-zero value shall be non-HCI transport data path
>           */
> 	if (conn->codec.data_path == 0 && hdev->notify) {
> 		switch (ev->air_mode) {
> 		case 0x02:
> 			hdev->notify(hdev, HCI_NOTIFY_ENABLE_SCO_CVSD);
> 			break;
> 		case 0x03:
> 			hdev->notify(hdev, HCI_NOTIFY_ENABLE_SCO_TRANSP);
> 			break;
> 		}
> 	}

I prefer this, because it is a restoration of earlier logic, rather than
changing his logic. I will resend a patch, thank you.

--
Jackie Liu

> 
> Regards
> 
> Marcel
> 
