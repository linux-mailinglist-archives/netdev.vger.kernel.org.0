Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5516B1A2F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 04:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCIDxt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Mar 2023 22:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCIDxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 22:53:46 -0500
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FABD23BF;
        Wed,  8 Mar 2023 19:53:45 -0800 (PST)
Received: from smtpclient.apple ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=PLAIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 3293r5s4017429-3293r5s5017429
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 9 Mar 2023 11:53:05 +0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.2\))
Subject: Re: [PATCH v2] wifi: rtw88: fix memory leak in rtw_usb_probe()
From:   Dongliang Mu <dzm91@hust.edu.cn>
In-Reply-To: <792ecb45f7e540b1abdb30bf965c5072@realtek.com>
Date:   Thu, 9 Mar 2023 11:53:05 +0800
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <9186AD8D-EB50-4302-B1CD-5010E27F53E8@hust.edu.cn>
References: <20230309021636.528601-1-dzm91@hust.edu.cn>
 <792ecb45f7e540b1abdb30bf965c5072@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
X-Mailer: Apple Mail (2.3696.120.41.1.2)
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 9, 2023, at 11:47, Ping-Ke Shih <pkshih@realtek.com> wrote:
> 
> 
> 
>> -----Original Message-----
>> From: Dongliang Mu <dzm91@hust.edu.cn>
>> Sent: Thursday, March 9, 2023 10:17 AM
>> To: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller
>> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
>> <pabeni@redhat.com>
>> Cc: Dongliang Mu <dzm91@hust.edu.cn>; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Subject: [PATCH v2] wifi: rtw88: fix memory leak in rtw_usb_probe()
>> 
>> drivers/net/wireless/realtek/rtw88/usb.c:876 rtw_usb_probe()
>> warn: 'hw' from ieee80211_alloc_hw() not released on lines: 811
> 
> Can I know which tool can detect this? It would be good to mention the tool
> in commit message.
> 

Oh, Smatch, I forget to mention it.

>> 
>> Fix this by modifying return to a goto statement.
>> 
>> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
>> ---
>> v1->v2: modify the commit title
>> drivers/net/wireless/realtek/rtw88/usb.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
>> index 2a8336b1847a..68e1b782d199 100644
>> --- a/drivers/net/wireless/realtek/rtw88/usb.c
>> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
>> @@ -808,7 +808,7 @@ int rtw_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
>> 
>>        ret = rtw_usb_alloc_rx_bufs(rtwusb);
>>        if (ret)
>> -               return ret;
>> +               goto err_release_hw;
>> 
>>        ret = rtw_core_init(rtwdev);
>>        if (ret)
>> --
>> 2.39.2

