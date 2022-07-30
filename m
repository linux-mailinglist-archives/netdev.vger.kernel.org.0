Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCFD585C17
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 22:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbiG3Uax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 16:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235737AbiG3Uaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 16:30:52 -0400
Received: from smtp.smtpout.orange.fr (smtp04.smtpout.orange.fr [80.12.242.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC0D11C0F
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 13:30:50 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id Ht6bo0sxd5V1hHt6bojkgf; Sat, 30 Jul 2022 22:30:49 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 30 Jul 2022 22:30:49 +0200
X-ME-IP: 90.11.190.129
Message-ID: <e5cbad07-f930-8a66-2579-42f993ca566a@wanadoo.fr>
Date:   Sat, 30 Jul 2022 22:30:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] stmmac: intel: Add a missing clk_disable_unprepare()
 call in intel_eth_pci_remove()
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     vee.khee.wong@intel.com, weifeng.voon@intel.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Newsgroups: gmane.linux.kernel.janitors,gmane.linux.kernel,gmane.linux.network,gmane.linux.ports.arm.kernel
References: <b5b44a0c025d0fdddd9b9d23153261363089a06a.1659204745.git.christophe.jaillet@wanadoo.fr>
 <YuWR9I8y9cWlLG3O@smile.fi.intel.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YuWR9I8y9cWlLG3O@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 30/07/2022 à 22:17, Andy Shevchenko a écrit :
> On Sat, Jul 30, 2022 at 08:19:47PM +0200, Christophe JAILLET wrote:
>> Commit 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove
>> paths") removed this clk_disable_unprepare()
>>
>> This was partly revert by commit ac322f86b56c ("net: stmmac: Fix clock
>> handling on remove path") which removed this clk_disable_unprepare()
>> because:
>> "
>>     While unloading the dwmac-intel driver, clk_disable_unprepare() is
>>     being called twice in stmmac_dvr_remove() and
>>     intel_eth_pci_remove(). This causes kernel panic on the second call.
>> "
>>
>> However later on, commit 5ec55823438e8 ("net: stmmac: add clocks management
>> for gmac driver") has updated stmmac_dvr_remove() which do not call
>> clk_disable_unprepare() anymore.
>>
>> So this call should now be called from intel_eth_pci_remove().
> 
> The correct way of fixing it (which might be very well end up functionally
> the same as this patch), is to introduce ->quit() in struct stmmac_pci_info
> and assign it correctly, because not all platforms enable clocks.

I won't be able to propose anything like that.

By the way, in the first sentence of my log, s/removed/added/.
(I hope that it can be fixed when/if the patch is applied)


Thanks for the review.

CJ

> 
> Perhaps, we may leave this patch as is (for the sake of easy backporting) and
> apply another one as I explained above to avoid similar mistakes in the future.
> 
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
>> Fixes: 5ec55823438e8 ("net: stmmac: add clocks management for gmac driver")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> /!\     This patch is HIGHLY speculative.     /!\
>>
>> The corresponding clk_disable_unprepare() is still called within the pm
>> related stmmac_bus_clks_config() function.
>>
>> However, with my limited understanding of the pm API, I think it that the
>> patch is valid.
>> (in other word, does the pm_runtime_put() and/or pm_runtime_disable()
>> and/or stmmac_dvr_remove() can end up calling .runtime_suspend())
>>
>> So please review with care, as I'm not able to test the change by myself.
>>
>>
>> If I'm wrong, maybe a comment explaining why it is safe to have this
>> call in the error handling path of the probe and not in the remove function
>> would avoid erroneous patches generated from static code analyzer to be
>> sent.
>> ---
>>   drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
>> index 52f9ed8db9c9..9f38642f86ce 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
>> @@ -1134,6 +1134,7 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
>>   
>>   	stmmac_dvr_remove(&pdev->dev);
>>   
>> +	clk_disable_unprepare(plat->stmmac_clk);
>>   	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
>>   
>>   	pcim_iounmap_regions(pdev, BIT(0));
>> -- 
>> 2.34.1
>>
> 

