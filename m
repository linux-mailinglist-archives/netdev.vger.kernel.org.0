Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCFC44D8D2
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhKKPFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:05:21 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:55686 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbhKKPFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:05:20 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CECF01FD40;
        Thu, 11 Nov 2021 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636642950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I0IS9eHAFjRbFhRVgmy1zwTE8qh3rhYd1ikPaMLm9/o=;
        b=0XK4wzAIhjQJeIlvW/qyZnVjyx6c/uosaQxI8SBFgQ8Q/3nVa4h6aMxzcKLcueX78zaPkZ
        sgP81p+Wnq8DTHFYZgHcCl9BIGrm4li+YZcv6F7VVlThQTh2psuxauB6TfO1KjrJxlZd19
        7156aXVpu8M6PJgKvb4yVt5nPhCsR2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636642950;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I0IS9eHAFjRbFhRVgmy1zwTE8qh3rhYd1ikPaMLm9/o=;
        b=I8toBzgm8ND8LYB2vlNRMR2O4Cm/YcjT+o/J0JJrsHgo6KPToMffKVmcICAebMatOSyw1T
        JaFa+9lR9XC/wmCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0505213DBC;
        Thu, 11 Nov 2021 15:02:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wXJ2OYUwjWHhcQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Thu, 11 Nov 2021 15:02:29 +0000
Subject: Re: [PATCH] net: stmmac: socfpga: add runtime suspend/resume callback
 for stratix10 platform
To:     "Li, Meng" <Meng.Li@windriver.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20211111135630.24996-1-Meng.Li@windriver.com>
 <499952a2-c919-109d-4f0a-fb4db4ead604@suse.de>
 <PH0PR11MB5191582745F77F7D876001ECF1949@PH0PR11MB5191.namprd11.prod.outlook.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <788fa547-49c9-458b-8427-afddcee412a6@suse.de>
Date:   Thu, 11 Nov 2021 18:02:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <PH0PR11MB5191582745F77F7D876001ECF1949@PH0PR11MB5191.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/11/21 5:16 PM, Li, Meng пишет:
> 
> 
>> -----Original Message-----
>> From: Denis Kirjanov <dkirjanov@suse.de>
>> Sent: Thursday, November 11, 2021 10:02 PM
>> To: Li, Meng <Meng.Li@windriver.com>; peppe.cavallaro@st.com;
>> alexandre.torgue@foss.st.com; joabreu@synopsys.com;
>> davem@davemloft.net; kuba@kernel.org; mcoquelin.stm32@gmail.com
>> Cc: netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com;
>> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] net: stmmac: socfpga: add runtime suspend/resume
>> callback for stratix10 platform
>>
>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>
>> 11/11/21 4:56 PM, Meng Li пишет:
>>> From: Meng Li <meng.li@windriver.com>
>>>
>>> According to upstream commit 5ec55823438e("net: stmmac:
>>> add clocks management for gmac driver "), it improve clocks management
>>> for stmmac driver. So, it is necessary to implement the runtime
>>> callback in dwmac-socfpga driver because it doesn’t use the common
>>> stmmac_pltfr_pm_ops instance. Otherwise, clocks are not disabled when
>>> system enters suspend status.
>>
>> Please add Fixes tag
> 
> Thanks for suggest.
> Yes! this patch is used to fix an clock operation issue in dwmac-socfpga driver,
> But I am not sure which Fixing commit ID I should use.
> Because 5ec55823438e breaks the original clock operation of dwmac-socfpga driver, but this commit 5ec55823438e is not a bug.
> Moreover, if without 5ec55823438e dwmac-socfpga driver also works fine.
Yes I see. I also checked the commit 5ec55823438e and it logically 
relates to your change
> 
> How about your suggest?
> 
> Thanks,
> Limeng
> 
>>>
>>> Signed-off-by: Meng Li <Meng.Li@windriver.com>
>>> ---
>>>    .../ethernet/stmicro/stmmac/dwmac-socfpga.c   | 24
>> +++++++++++++++++--
>>>    1 file changed, 22 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
>>> b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
>>> index 85208128f135..93abde467de4 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
>>> @@ -485,8 +485,28 @@ static int socfpga_dwmac_resume(struct device
>> *dev)
>>>    }
>>>    #endif /* CONFIG_PM_SLEEP */
>>>
>>> -static SIMPLE_DEV_PM_OPS(socfpga_dwmac_pm_ops, stmmac_suspend,
>>> -                                            socfpga_dwmac_resume);
>>> +static int __maybe_unused socfpga_dwmac_runtime_suspend(struct
>> device
>>> +*dev) {
>>> +     struct net_device *ndev = dev_get_drvdata(dev);
>>> +     struct stmmac_priv *priv = netdev_priv(ndev);
>>> +
>>> +     stmmac_bus_clks_config(priv, false);
>> check the return value?
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int __maybe_unused socfpga_dwmac_runtime_resume(struct
>> device
>>> +*dev) {
>>> +     struct net_device *ndev = dev_get_drvdata(dev);
>>> +     struct stmmac_priv *priv = netdev_priv(ndev);
>>> +
>>> +     return stmmac_bus_clks_config(priv, true); }
>>> +
>>> +const struct dev_pm_ops socfpga_dwmac_pm_ops = {
>>> +     SET_SYSTEM_SLEEP_PM_OPS(stmmac_suspend,
>> socfpga_dwmac_resume)
>>> +     SET_RUNTIME_PM_OPS(socfpga_dwmac_runtime_suspend,
>>> +socfpga_dwmac_runtime_resume, NULL) };
>>>
>>>    static const struct socfpga_dwmac_ops socfpga_gen5_ops = {
>>>        .set_phy_mode = socfpga_gen5_set_phy_mode,
>>>
