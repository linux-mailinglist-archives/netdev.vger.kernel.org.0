Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF9E430364
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 17:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhJPPfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 11:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238772AbhJPPfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 11:35:33 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B86EC06176E;
        Sat, 16 Oct 2021 08:33:24 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4HWnGV5JhCzQkB3;
        Sat, 16 Oct 2021 17:33:22 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <33b1bd25-7ed7-4a45-8b18-9454f848b325@v0yd.nl>
Date:   Sat, 16 Oct 2021 17:33:17 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/5] mwifiex: Send DELBA requests according to spec
Content-Language: en-US
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20211016103656.16791-1-verdre@v0yd.nl>
 <20211016103656.16791-5-verdre@v0yd.nl>
 <20211016142809.tjezv4dpxrlmdp6v@pali>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <20211016142809.tjezv4dpxrlmdp6v@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CD5AC188C
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/21 16:28, Pali Rohár wrote:
> On Saturday 16 October 2021 12:36:55 Jonas Dreßler wrote:
>> While looking at on-air packets using Wireshark, I noticed we're never
>> setting the initiator bit when sending DELBA requests to the AP: While
>> we set the bit on our del_ba_param_set bitmask, we forget to actually
>> copy that bitmask over to the command struct, which means we never
>> actually set the initiator bit.
>>
>> Fix that and copy the bitmask over to the host_cmd_ds_11n_delba command
>> struct.
>>
>> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
> 
> Hello! This looks like is fixing mwifiex_send_delba() function which was
> added in initial mwifiex commit. So probably it should have following
> tag:
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> 

Hi Pali,

thanks a lot for the quick review, I just addressed this in v3!

>> ---
>>   drivers/net/wireless/marvell/mwifiex/11n.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
>> index b0695432b26a..9ff2058bcd7e 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/11n.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/11n.c
>> @@ -657,14 +657,15 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
>>   	uint16_t del_ba_param_set;
>>   
>>   	memset(&delba, 0, sizeof(delba));
>> -	delba.del_ba_param_set = cpu_to_le16(tid << DELBA_TID_POS);
>>   
>> -	del_ba_param_set = le16_to_cpu(delba.del_ba_param_set);
>> +	del_ba_param_set = tid << DELBA_TID_POS;
>> +
>>   	if (initiator)
>>   		del_ba_param_set |= IEEE80211_DELBA_PARAM_INITIATOR_MASK;
>>   	else
>>   		del_ba_param_set &= ~IEEE80211_DELBA_PARAM_INITIATOR_MASK;
>>   
>> +	delba.del_ba_param_set = cpu_to_le16(del_ba_param_set);
>>   	memcpy(&delba.peer_mac_addr, peer_mac, ETH_ALEN);
>>   
>>   	/* We don't wait for the response of this command */
>> -- 
>> 2.31.1
>>

