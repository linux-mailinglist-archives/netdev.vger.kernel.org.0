Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60274256C3
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242343AbhJGPlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:41:02 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:50794
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241276AbhJGPk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:40:58 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 33A633FFE5;
        Thu,  7 Oct 2021 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633621141;
        bh=XjqgtqwqDFgS7tw+AK2jjUrsaYkkIjhm3C/y4nw1Jn4=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=DhMgNsh15/n7ow3GLR/XDpppd3e2zVZ+rnKR+I/4T58OQt8qKtuihFAKB+RWj4DwZ
         7msVplHtUf9Kp0hEgiEeJ1IgGe6hurnQNZJWSLmsQX7/zm+0KMnc3IptRy6HShGjZd
         hMh7BBhZcJvm09KSCM+ILiHAlh0EItSIk839rNWfR3qbT8c8RClr5s2kuMWh670Zdu
         +uYuQzyRKz9RYtLQkoAJJo80dBLxL3pXvikZle1ke0neGTOMAslKF+jhp6KVHec8RS
         2DCztjnCkoV8dQ2R+PX0DDAfqzDsldB9NBoVHYfwopc8v0c5TTIIhuHmR7hk1jg4Wx
         A/+MNapE2LEpw==
Message-ID: <51ce4458-cf8c-6219-e945-3333226dbdcc@canonical.com>
Date:   Thu, 7 Oct 2021 16:39:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH][next] Bluetooth: use bitmap_empty to check if a bitmap
 has any bits set
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20211007111713.12207-1-colin.king@canonical.com>
 <CABBYNZKzVtyZ_qO8pvenSLFRdm9aumxD_-Src4VG3UHQa8y+1w@mail.gmail.com>
From:   Colin Ian King <colin.king@canonical.com>
In-Reply-To: <CABBYNZKzVtyZ_qO8pvenSLFRdm9aumxD_-Src4VG3UHQa8y+1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2021 16:34, Luiz Augusto von Dentz wrote:
> Hi Colin,
> 
> On Thu, Oct 7, 2021 at 4:17 AM Colin King <colin.king@canonical.com> wrote:
>>
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The check to see if any tasks are left checks if bitmap array is zero
>> rather than using the appropriate bitmap helper functions to check the
>> bits in the array. Fix this by using bitmap_empty on the bitmap.
>>
>> Addresses-Coverity: (" Array compared against 0")
>> Fixes: 912730b52552 ("Bluetooth: Fix wake up suspend_wait_q prematurely")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>   net/bluetooth/hci_request.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
>> index 209f4fe17237..bad3b9c895ba 100644
>> --- a/net/bluetooth/hci_request.c
>> +++ b/net/bluetooth/hci_request.c
>> @@ -1108,7 +1108,7 @@ static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
>>          clear_bit(SUSPEND_SET_ADV_FILTER, hdev->suspend_tasks);
>>
>>          /* Wake up only if there are no tasks left */
>> -       if (!hdev->suspend_tasks)
>> +       if (!bitmap_empty(hdev->suspend_tasks, __SUSPEND_NUM_TASKS))
>>                  wake_up(&hdev->suspend_wait_q);
>>   }
>>
>> --
>> 2.32.0
> 
> I was going to revert this change since it appears wake_up does
> actually check the wake condition there is no premature wake up after
> all.
> 
OK, makes sense.

Colin
