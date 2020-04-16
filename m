Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C11ACFC3
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 20:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgDPSh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 14:37:28 -0400
Received: from mta-out1.inet.fi ([62.71.2.202]:39580 "EHLO johanna4.inet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbgDPSh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 14:37:26 -0400
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrudeliedgleefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuuffpveftnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgsehtkeertddtfeejnecuhfhrohhmpefnrghurhhiucflrghkkhhuuceolhgruhhrihdrjhgrkhhkuhesphhprdhinhgvthdrfhhiqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgrdhinhenucfkphepkeegrddvgeekrdeftddrudelheenucfrrghrrghmpehhvghloheplgduledvrdduieekrddurddufeehngdpihhnvghtpeekgedrvdegkedrfedtrdduleehpdhmrghilhhfrhhomhepoehlrghujhgrkhdqfeesmhgsohigrdhinhgvthdrfhhiqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeohhhkrghllhifvghithdusehgmhgrihhlrdgtohhmqedprhgtphhtthhopeeolhgvohhnsehkvghrnhgvlhdrohhrgheqpdhrtghpthhtohepoehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgheqpdhrtghpthhtohepoehnihgtpghsfihsugesrhgvrghlthgvkhdrtghomheqnecuvehluhhsthgvrhfuihiivgeptd
Received: from [192.168.1.135] (84.248.30.195) by johanna4.inet.fi (9.0.019.26-1) (authenticated as laujak-3)
        id 5E1C3A4349F7E77B; Thu, 16 Apr 2020 21:37:14 +0300
Subject: Re: NET: r8168/r8169 identifying fix
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
 <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
 <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
 <4860e57e-93e4-24f5-6103-fa80acbdfa0d@pp.inet.fi>
 <70cfcfb3-ce2a-9d47-b034-b94682e46e35@gmail.com>
From:   Lauri Jakku <lauri.jakku@pp.inet.fi>
Message-ID: <d4e622f1-7bd1-d884-20b2-c16e60b42bf2@pp.inet.fi>
Date:   Thu, 16 Apr 2020 21:37:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <70cfcfb3-ce2a-9d47-b034-b94682e46e35@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 16.4.2020 21.26, Heiner Kallweit wrote:
> On 16.04.2020 13:30, Lauri Jakku wrote:
>> Hi,
>>
>>
>> 5.6.3-2-MANJARO: stock manjaro kernel, without modifications --> network does not work
>>
>> 5.6.3-2-MANJARO-lja: No attach check, modified kernel (r8169 mods only) --> network does not work
>>
>> 5.6.3-2-MANJARO-with-the-r8169-patch: phy patched + r8169 mods -> devices show up ok, network works
>>
>> All different initcpio's have realtek.ko in them.
>>
> Thanks for the logs. Based on the logs you're presumable affected by a known BIOS bug.
> Check bug tickets 202275 and 207203 at bugzilla.kernel.org.
> In the first referenced tickets it's about the same mainboard (with earlier BIOS version).
> BIOS on this mainboard seems to not initialize the network chip / PHY correctly, it reports
> a random number as PHY ID, resulting in no PHY driver being found.
> Enable "Onboard LAN Boot ROM" in the BIOS, and your problem should be gone.
>
OK, I try that, thank you :)

>> The problem with old method seems to be, that device does not have had time to attach before the
>> PHY driver check.
>>
>> The patch:
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index bf5bf05970a2..acd122a88d4a 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -5172,11 +5172,11 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>          if (!tp->phydev) {
>>                  mdiobus_unregister(new_bus);
>>                  return -ENODEV;
>> -       } else if (!tp->phydev->drv) {
>> +       } else if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>                  /* Most chip versions fail with the genphy driver.
>>                   * Therefore ensure that the dedicated PHY driver is loaded.
>>                   */
>> -               dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>> +               dev_err(&pdev->dev, "Not known MAC version.\n");
>>                  mdiobus_unregister(new_bus);
>>                  return -EUNATCH;
>>          }
>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>> index 66b8c61ca74c..aba2b304b821 100644
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -704,6 +704,10 @@ EXPORT_SYMBOL_GPL(phy_modify_mmd);
>>   
>>   static int __phy_read_page(struct phy_device *phydev)
>>   {
>> +       /* If not attached, do nothing (no warning) */
>> +       if (!phydev->attached_dev)
>> +               return -EOPNOTSUPP;
>> +
>>          if (WARN_ONCE(!phydev->drv->read_page, "read_page callback not available, PHY driver not loaded?\n"))
>>                  return -EOPNOTSUPP;
>>   
>> @@ -712,12 +716,17 @@ static int __phy_read_page(struct phy_device *phydev)
>>   
>>   static int __phy_write_page(struct phy_device *phydev, int page)
>>   {
>> +       /* If not attached, do nothing (no warning) */
>> +       if (!phydev->attached_dev)
>> +               return -EOPNOTSUPP;
>> +
>>          if (WARN_ONCE(!phydev->drv->write_page, "write_page callback not available, PHY driver not loaded?\n"))
>>                  return -EOPNOTSUPP;
>>   
>>          return phydev->drv->write_page(phydev, page);
>>   }
>>   
>> +
>>   /**
>>    * phy_save_page() - take the bus lock and save the current page
>>    * @phydev: a pointer to a &struct phy_device
>>
>>
>>
>> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
>>
>>      On 15.04.2020 16:39, Lauri Jakku wrote:
>>
>>          Hi, There seems to he Something odd problem, maybe timing related. Stripped version not workingas expected. I get back to you, when  i have it working.
>>
>>
>>      There's no point in working on your patch. W/o proper justification it
>>      isn't acceptable anyway. And so far we still don't know which problem
>>      you actually have.
>>      FIRST please provide the requested logs and explain the actual problem
>>      (incl. the commit that caused the regression).
>>
>>
>>
>>
>>          13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote:
>>
>>          On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi, Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020 13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix The driver installation determination made properly by checking PHY vs DRIVER id's. --- drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2 files changed, 72 insertions(+), 9 deletions(-) I would say that most of the code is debug prints. I tought that they are helpful to keep, they are using the debug calls, so they are not visible if user does not like those. You are missing the point of who are your users. Users want to have working device and the code. They don't need or like to debug their kernel. Thanks
>>
>>
