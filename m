Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700306B0263
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjCHJHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCHJGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:06:55 -0500
X-Greylist: delayed 926 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Mar 2023 01:06:27 PST
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CBBB6D3F
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 01:06:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678265417; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=nzA2/7aGm9uqLYDPWojlBg5rCiXMU7vgMolusMiB66EVidBr8ubCd8eBZMTIbRAcLFfqBt/lLJUoXtoH9eztT6MlCKXcZeZ+voDoOxceTLLfXcqQQcZtEMWKFOGUVy+xAPlG7NtlyAOe9sngBTqYNwqlGOGdd8Rnq/I9LFtuHkY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678265417; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=RegfERULej+941mOyU4tNlczm+KFqme2Zd1D/0dQ1IU=; 
        b=kMaQa6pEwulqF0zPTD39nfyi2qxQ2XC2U7GK9liKteKIPwfw0tgQ1g5/vz+StBwNNW6Pwe7eHdKVv2OZLnS9X0Zz+OtK9pH/sw3jjpiboZTzxrbq6jqEti1Y0KjBNyInpiJySh9DWZlF75q/UTpRJBr9274Zjrw0aUuybqrCDDI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678265417;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=RegfERULej+941mOyU4tNlczm+KFqme2Zd1D/0dQ1IU=;
        b=HlkNjF9v5Zf6d1Mx44X+xqW4F86Z9W/hMSv5ZqtpsEt6kER3e03w+6cQ3o9BdYud
        Ps+OCu/I1OkytJX4hmR8X7O/IcysoaWcm4EO1vuUJ7/uuQbJd3NLYQMV6o48DGRskuc
        Q0Garo2rY7BHFToHb1Gcs5uibkXem2ZFWQeMN/tg=
Received: from [10.10.10.3] (212.68.60.226 [212.68.60.226]) by mx.zohomail.com
        with SMTPS id 1678265416245518.3169018503368; Wed, 8 Mar 2023 00:50:16 -0800 (PST)
Message-ID: <c46f5be8-2d64-65dc-33c1-a71b3d5cc70c@arinc9.com>
Date:   Wed, 8 Mar 2023 11:50:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net 2/2] net: dsa: mt7530: set PLL frequency only when
 trgmii is used
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230307220328.11186-1-arinc.unal@arinc9.com>
 <20230307220328.11186-2-arinc.unal@arinc9.com>
 <20230307233354.y3srdoggy2yzugnq@skbuf>
Content-Language: en-US
In-Reply-To: <20230307233354.y3srdoggy2yzugnq@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8.03.2023 02:33, Vladimir Oltean wrote:
> On Wed, Mar 08, 2023 at 01:03:28AM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> As my testing on the MCM MT7530 switch on MT7621 SoC shows, setting the PLL
>> frequency does not affect MII modes other than trgmii on port 5 and port 6.
>> So the assumption is that the operation here called "setting the PLL
>> frequency" actually sets the frequency of the TRGMII TX clock.
>>
>> Make it so that it is set only when the trgmii mode is used.
>>
>> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   drivers/net/dsa/mt7530.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index b1a79460df0e..961306c1ac14 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -430,8 +430,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>>   	switch (interface) {
>>   	case PHY_INTERFACE_MODE_RGMII:
>>   		trgint = 0;
>> -		/* PLL frequency: 125MHz */
>> -		ncpo1 = 0x0c80;
>>   		break;
>>   	case PHY_INTERFACE_MODE_TRGMII:
>>   		trgint = 1;
>> -- 
>> 2.37.2
>>
> 
> NACK.
> 
> By deleting the assignment to the ncpo1 variable, it becomes
> uninitialized when port 6's interface mode is PHY_INTERFACE_MODE_RGMII.
> In the C language, uninitialized variables take the value of whatever
> memory happens to be on the stack at the address they are placed,
> interpreted as an appropriate data type for that variable - here u32.
> 
> Writing the value to CORE_PLL_GROUP5 happens when the function below is
> called, not when the "ncpo1" variable is assigned.
> 
> 	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
> 
> It is not a good idea to write uninitialized kernel stack memory to
> hardware registers, unless perhaps you want to use it as some sort of
> poor quality entropy source for a random number generator...

Thanks a lot for this. Now that you moved setting the core clock to
somewhere else, I think we can run the TRGMII setup only when trgmii
mode is used, exactly what I already explained on the patch log, with
the diff below. This should make it so that writing the value to
CORE_PLL_GROUP5 happens in the case where ncpo1 is always set.

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b1a79460df0e..c2d81b7a429d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -430,8 +430,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
  	switch (interface) {
  	case PHY_INTERFACE_MODE_RGMII:
  		trgint = 0;
-		/* PLL frequency: 125MHz */
-		ncpo1 = 0x0c80;
  		break;
  	case PHY_INTERFACE_MODE_TRGMII:
  		trgint = 1;
@@ -462,38 +460,40 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
  	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
  		   P6_INTF_MODE(trgint));
  
-	/* Lower Tx Driving for TRGMII path */
-	for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
-		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
-
-	/* Disable MT7530 core and TRGMII Tx clocks */
-	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
-		   REG_GSWCK_EN | REG_TRGMIICK_EN);
-
-	/* Setup the MT7530 TRGMII Tx Clock */
-	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
-	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
-	core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
-	core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
-	core_write(priv, CORE_PLL_GROUP4,
-		   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
-		   RG_SYSPLL_BIAS_LPF_EN);
-	core_write(priv, CORE_PLL_GROUP2,
-		   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
-		   RG_SYSPLL_POSDIV(1));
-	core_write(priv, CORE_PLL_GROUP7,
-		   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
-		   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
-
-	/* Enable MT7530 core and TRGMII Tx clocks */
-	core_set(priv, CORE_TRGMII_GSW_CLK_CG,
-		 REG_GSWCK_EN | REG_TRGMIICK_EN);
-
-	if (!trgint)
+	if (trgint) {
+		/* Lower Tx Driving for TRGMII path */
+		for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
+			mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
+				     TD_DM_DRVP(8) | TD_DM_DRVN(8));
+
+		/* Disable MT7530 core and TRGMII Tx clocks */
+		core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
+			   REG_GSWCK_EN | REG_TRGMIICK_EN);
+
+		/* Setup the MT7530 TRGMII Tx Clock */
+		core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
+		core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
+		core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
+		core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
+		core_write(priv, CORE_PLL_GROUP4,
+			   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
+			   RG_SYSPLL_BIAS_LPF_EN);
+		core_write(priv, CORE_PLL_GROUP2,
+			   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
+			   RG_SYSPLL_POSDIV(1));
+		core_write(priv, CORE_PLL_GROUP7,
+			   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
+			   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
+
+		/* Enable MT7530 core and TRGMII Tx clocks */
+		core_set(priv, CORE_TRGMII_GSW_CLK_CG,
+			 REG_GSWCK_EN | REG_TRGMIICK_EN);
+	} else {
  		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
  			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
  				   RD_TAP_MASK, RD_TAP(16));
+	}
+
  	return 0;
  }
  

I'll do some tests to make sure everything works fine.

Arınç
