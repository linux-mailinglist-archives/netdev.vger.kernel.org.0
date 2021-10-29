Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E09243F8F8
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 10:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhJ2Ift convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Oct 2021 04:35:49 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:53737 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhJ2Ift (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 04:35:49 -0400
Received: from smtpclient.apple (p4ff9fd51.dip0.t-ipconnect.de [79.249.253.81])
        by mail.holtmann.org (Postfix) with ESMTPSA id E64A9CED10;
        Fri, 29 Oct 2021 10:33:19 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] Bluetooth: Fix removing adv when processing cmd complete
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABBYNZKyJ7wJC5HcYy24LayrysywqjcRpAkMtHmm7=UrfucV4Q@mail.gmail.com>
Date:   Fri, 29 Oct 2021 10:33:19 +0200
Cc:     Archie Pusaka <apusaka@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <AD0DFB4A-3191-4C30-9BCD-8F0C829CE661@holtmann.org>
References: <20211028191723.1.I94a358fc5abdb596412a2e22dd2b73b71f56fa82@changeid>
 <CABBYNZKyJ7wJC5HcYy24LayrysywqjcRpAkMtHmm7=UrfucV4Q@mail.gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

>> If we remove one instance of adv using Set Extended Adv Enable, there
>> is a possibility of issue occurs when processing the Command Complete
>> event. Especially, the adv_info might not be found since we already
>> remove it in hci_req_clear_adv_instance() -> hci_remove_adv_instance().
>> If that's the case, we will mistakenly proceed to remove all adv
>> instances instead of just one single instance.
>> 
>> This patch fixes the issue by checking the content of the HCI command
>> instead of checking whether the adv_info is found.
>> 
>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
>> Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
>> 
>> ---
>> 
>> net/bluetooth/hci_event.c | 6 ++++--
>> 1 file changed, 4 insertions(+), 2 deletions(-)
>> 
>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>> index 3cba2bbefcd6..894670419a27 100644
>> --- a/net/bluetooth/hci_event.c
>> +++ b/net/bluetooth/hci_event.c
>> @@ -1326,8 +1326,10 @@ static void hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev,
>>                                           &conn->le_conn_timeout,
>>                                           conn->conn_timeout);
>>        } else {
>> -               if (adv) {
>> -                       adv->enabled = false;
>> +               if (cp->num_of_sets) {
>> +                       if (adv)
>> +                               adv->enabled = false;
>> +
>>                        /* If just one instance was disabled check if there are
>>                         * any other instance enabled before clearing HCI_LE_ADV
>>                         */

I haven’t applied this yet since I wanted to make sure it doesn’t interfere with our set of 23 patches. Do you need to rebase?

Regards

Marcel

