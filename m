Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F766EFA5
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 16:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfGTOW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 10:22:57 -0400
Received: from er-systems.de ([148.251.68.21]:41552 "EHLO er-systems.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbfGTOW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jul 2019 10:22:56 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
        by er-systems.de (Postfix) with ESMTP id C0FD8D6005E;
        Sat, 20 Jul 2019 16:22:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on er-systems.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.1
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by er-systems.de (Postfix) with ESMTPS id 927D6D6005A;
        Sat, 20 Jul 2019 16:22:51 +0200 (CEST)
Date:   Sat, 20 Jul 2019 16:22:50 +0200 (CEST)
From:   Thomas Voegtle <tv@lio96.de>
X-X-Sender: thomas@er-systems.de
To:     Heiner Kallweit <hkallweit1@gmail.com>
cc:     linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: network problems with r8169
In-Reply-To: <9cab7996-d801-0ae5-9e82-6d24eeb8d7c7@gmail.com>
Message-ID: <alpine.LSU.2.21.1907201620070.2099@er-systems.de>
References: <alpine.LSU.2.21.1907182032370.7080@er-systems.de> <2eeedff5-4911-db6e-6bfd-99b591daa7ef@gmail.com> <alpine.LSU.2.21.1907192310140.11569@er-systems.de> <9cab7996-d801-0ae5-9e82-6d24eeb8d7c7@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-74181308-858477326-1563632571=:2099"
X-Virus-Status: No
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.100.3/25516/Sat Jul 20 10:15:21 2019 signatures 58.
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---74181308-858477326-1563632571=:2099
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 20 Jul 2019, Heiner Kallweit wrote:

> On 19.07.2019 23:12, Thomas Voegtle wrote:
>> On Fri, 19 Jul 2019, Heiner Kallweit wrote:
>>
>>> On 18.07.2019 20:50, Thomas Voegtle wrote:
>>>>
>>>> Hello,
>>>>
>>>> I'm having network problems with the commits on r8169 since v5.2. There are ping packet loss, sometimes 100%, sometimes 50%. In the end network is unusable.
>>>>
>>>> v5.2 is fine, I bisected it down to:
>>>>
>>>> a2928d28643e3c064ff41397281d20c445525032 is the first bad commit
>>>> commit a2928d28643e3c064ff41397281d20c445525032
>>>> Author: Heiner Kallweit <hkallweit1@gmail.com>
>>>> Date:   Sun Jun 2 10:53:49 2019 +0200
>>>>
>>>>     r8169: use paged versions of phylib MDIO access functions
>>>>
>>>>     Use paged versions of phylib MDIO access functions to simplify
>>>>     the code.
>>>>
>>>>     Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>>>
>>>>
>>>> Reverting that commit on top of v5.2-11564-g22051d9c4a57 fixes the problem
>>>> for me (had to adjust the renaming to r8169_main.c).
>>>>
>>>> I have a:
>>>> 04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
>>>> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev
>>>> 0c)
>>>>         Subsystem: Biostar Microtech Int'l Corp Device [1565:2400]
>>>>         Kernel driver in use: r8169
>>>>
>>>> on a BIOSTAR H81MG motherboard.
>>>>
>>> Interesting. I have the same chip version (RTL8168g) and can't reproduce
>>> the issue. Can you provide a full dmesg output and test the patch below
>>> on top of linux-next? I'd be interested in the WARN_ON stack traces
>>> (if any) and would like to know whether the experimental change to
>>> __phy_modify_changed helps.
>>>
>>>>
>>>> greetings,
>>>>
>>>>   Thomas
>>>>
>>>>
>>> Heiner
>>>
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index 8d7dd4c5f..26be73000 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -1934,6 +1934,8 @@ static int rtl_get_eee_supp(struct rtl8169_private *tp)
>>>     struct phy_device *phydev = tp->phydev;
>>>     int ret;
>>>
>>> +    WARN_ON(phy_read(phydev, 0x1f));
>>> +
>>>     switch (tp->mac_version) {
>>>     case RTL_GIGA_MAC_VER_34:
>>>     case RTL_GIGA_MAC_VER_35:
>>> @@ -1957,6 +1959,8 @@ static int rtl_get_eee_lpadv(struct rtl8169_private *tp)
>>>     struct phy_device *phydev = tp->phydev;
>>>     int ret;
>>>
>>> +    WARN_ON(phy_read(phydev, 0x1f));
>>> +
>>>     switch (tp->mac_version) {
>>>     case RTL_GIGA_MAC_VER_34:
>>>     case RTL_GIGA_MAC_VER_35:
>>> @@ -1980,6 +1984,8 @@ static int rtl_get_eee_adv(struct rtl8169_private *tp)
>>>     struct phy_device *phydev = tp->phydev;
>>>     int ret;
>>>
>>> +    WARN_ON(phy_read(phydev, 0x1f));
>>> +
>>>     switch (tp->mac_version) {
>>>     case RTL_GIGA_MAC_VER_34:
>>>     case RTL_GIGA_MAC_VER_35:
>>> @@ -2003,6 +2009,8 @@ static int rtl_set_eee_adv(struct rtl8169_private *tp, int val)
>>>     struct phy_device *phydev = tp->phydev;
>>>     int ret = 0;
>>>
>>> +    WARN_ON(phy_read(phydev, 0x1f));
>>> +
>>>     switch (tp->mac_version) {
>>>     case RTL_GIGA_MAC_VER_34:
>>>     case RTL_GIGA_MAC_VER_35:
>>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>>> index 16667fbac..1aa1142b8 100644
>>> --- a/drivers/net/phy/phy-core.c
>>> +++ b/drivers/net/phy/phy-core.c
>>> @@ -463,12 +463,10 @@ int __phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
>>>         return ret;
>>>
>>>     new = (ret & ~mask) | set;
>>> -    if (new == ret)
>>> -        return 0;
>>>
>>> -    ret = __phy_write(phydev, regnum, new);
>>> +    __phy_write(phydev, regnum, new);
>>>
>>> -    return ret < 0 ? ret : 1;
>>> +    return new != ret;
>>> }
>>> EXPORT_SYMBOL_GPL(__phy_modify_changed);
>>>
>>>
>>
>> Took your patch on top of next-20190719.
>> See attached dmesg.
>> It didn't work. Same thing, lots of ping drops, no usable network.
>>
>> like that:
>> 44 packets transmitted, 2 received, 95% packet loss, time 44005ms
>>
>>
>> Maybe important:
>> I build a kernel with no modules.
>>
>> I have to power off when I booted a kernel which doesn't work, a (soft) reboot into a older kernel (e.g. 4.9.y)  doesn't
>> fix the problem. Powering off and on does.
>>
>
> Then, what you could do is reversing the hunks of the patch step by step.
> Or make them separate patches and bisect.
> Relevant are the hunks from point 1 and 2.
>
> 1. first 5 hunks (I don't think you have to reverse them individually)
>   EEE-related
>
> 2. rtl8168g_disable_aldps, rtl8168g_phy_adjust_10m_aldps, rtl8168g_1_hw_phy_config
>   all of these hunks are in the path for RTL8168g
>
> 3. rtl8168h_1_hw_phy_config, rtl8168h_2_hw_phy_config, rtl8168ep_1_hw_phy_config,
>   rtl8168ep_2_hw_phy_config
>   not in the path for RTL8168g
>

this is the minimal revert:

diff --git a/drivers/net/ethernet/realtek/r8169_main.c 
b/drivers/net/ethernet/realtek/r8169_main.c
index efef5453b94f..267995a614b5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3249,12 +3249,14 @@ static void rtl8168g_1_hw_phy_config(struct 
rtl8169_private *tp)
         else
                 phy_modify_paged(tp->phydev, 0x0bcc, 0x12, 0, BIT(15));

-       ret = phy_read_paged(tp->phydev, 0x0a46, 0x13);
-       if (ret & BIT(8))
-               phy_modify_paged(tp->phydev, 0x0c41, 0x12, 0, BIT(1));
-       else
-               phy_modify_paged(tp->phydev, 0x0c41, 0x12, BIT(1), 0);
-
+       rtl_writephy(tp, 0x1f, 0x0a46);
+       if (rtl_readphy(tp, 0x13) & 0x0100) {
+               rtl_writephy(tp, 0x1f, 0x0c41);
+               rtl_w0w1_phy(tp, 0x15, 0x0002, 0x0000);
+       } else {
+               rtl_writephy(tp, 0x1f, 0x0c41);
+               rtl_w0w1_phy(tp, 0x15, 0x0000, 0x0002);
+       }
         /* Enable PHY auto speed down */
         phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));



Could it be, that there is just a typo?

         if (ret & BIT(8))
-               phy_modify_paged(tp->phydev, 0x0c41, 0x12, 0, BIT(1));
+               phy_modify_paged(tp->phydev, 0x0c41, 0x15, 0, BIT(1));
         else
-               phy_modify_paged(tp->phydev, 0x0c41, 0x12, BIT(1), 0);
+               phy_modify_paged(tp->phydev, 0x0c41, 0x15, BIT(1), 0);




greetings,

       Thomas

---74181308-858477326-1563632571=:2099--

