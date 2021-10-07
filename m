Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C400425704
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbhJGPth convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Oct 2021 11:49:37 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:39927 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhJGPth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:49:37 -0400
Received: from smtpclient.apple (p5b3d2185.dip0.t-ipconnect.de [91.61.33.133])
        by mail.holtmann.org (Postfix) with ESMTPSA id A8422CECE5;
        Thu,  7 Oct 2021 17:47:41 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH][next] Bluetooth: use bitmap_empty to check if a bitmap
 has any bits set
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABBYNZKzVtyZ_qO8pvenSLFRdm9aumxD_-Src4VG3UHQa8y+1w@mail.gmail.com>
Date:   Thu, 7 Oct 2021 17:47:41 +0200
Cc:     Colin King <colin.king@canonical.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <888C3A95-5410-4B53-8805-4BAE9A9E6010@holtmann.org>
References: <20211007111713.12207-1-colin.king@canonical.com>
 <CABBYNZKzVtyZ_qO8pvenSLFRdm9aumxD_-Src4VG3UHQa8y+1w@mail.gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

>> The check to see if any tasks are left checks if bitmap array is zero
>> rather than using the appropriate bitmap helper functions to check the
>> bits in the array. Fix this by using bitmap_empty on the bitmap.
>> 
>> Addresses-Coverity: (" Array compared against 0")
>> Fixes: 912730b52552 ("Bluetooth: Fix wake up suspend_wait_q prematurely")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>> net/bluetooth/hci_request.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
>> index 209f4fe17237..bad3b9c895ba 100644
>> --- a/net/bluetooth/hci_request.c
>> +++ b/net/bluetooth/hci_request.c
>> @@ -1108,7 +1108,7 @@ static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
>>        clear_bit(SUSPEND_SET_ADV_FILTER, hdev->suspend_tasks);
>> 
>>        /* Wake up only if there are no tasks left */
>> -       if (!hdev->suspend_tasks)
>> +       if (!bitmap_empty(hdev->suspend_tasks, __SUSPEND_NUM_TASKS))
>>                wake_up(&hdev->suspend_wait_q);
>> }
>> 
>> --
>> 2.32.0
> 
> I was going to revert this change since it appears wake_up does
> actually check the wake condition there is no premature wake up after
> all.

so should I take the patch "Fix wake up suspend_wait_q prematurely” completely out?

Regards

Marcel

