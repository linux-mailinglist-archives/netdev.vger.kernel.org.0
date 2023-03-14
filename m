Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAB86B972F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCNOFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjCNOFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:05:03 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DAC170C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 07:05:00 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 38EB61260;
        Tue, 14 Mar 2023 15:04:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678802698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9qA7yZ868e7qShVp3vUoLT4lGEjMMrw6CmAzhtuvh4=;
        b=EICtFi5FM8uQcXwR44nGAhE3NFvTOmhH2m51jk9Pcfub7eyQq7twVBpyXYahNjFs57VCmm
        U/rCs2Fbf11MWqhztdrOyYr7SjJ24N7S9Ph4ijBHtHV3AIUInP8Ub+ZPpjbrOtrSxb5tYZ
        ghwfunEvBYh5kFlV+1qmBG3mPMPh6ha9Z2poaYvVqFoYBIDFqFx8/uzhzCXaFvgIBEVrJo
        yjdMbU+V7rftMyiUI6sQd3NIf7Oi3pvahNtoJGiQrrrmHO4qOefVhSXEemq37YCMsz1kcK
        DdW5oUioDR+nKXs4M9owIwY4yBnc05gQajjIM0rND0BORN4oCp4M3W0EA6DGlA==
MIME-Version: 1.0
Date:   Tue, 14 Mar 2023 15:04:58 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Xu Liang <lxu@maxlinear.com>, hkallweit1@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, rtanwar@maxlinear.com,
        mohammad.athari.ismail@intel.com, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v4] net: phy: mxl-gpy: enhance delay time
 required by loopback disable function
In-Reply-To: <67a3a8f3-5bee-4379-890a-6c8e8be391a8@lunn.ch>
References: <20230314093648.44510-1-lxu@maxlinear.com>
 <67a3a8f3-5bee-4379-890a-6c8e8be391a8@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1e78d2e117fbb8e409f54a00694dc324@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-03-14 14:50, schrieb Andrew Lunn:
>> +	/* It takes 3 seconds to fully switch out of loopback mode before
>> +	 * it can safely re-enter loopback mode. Record the time when
>> +	 * loopback is disabled. Check and wait if necessary before loopback
>> +	 * is enabled.
>> +	 */
> 
> Is there are restriction about entering loopback mode within the first
> 3 seconds after power on?
> 
>> +	bool lb_dis_chk;
>> +	u64 lb_dis_to;
>>  };
>> 
>>  static const struct {
>> @@ -769,18 +777,34 @@ static void gpy_get_wol(struct phy_device 
>> *phydev,
>> 
>>  static int gpy_loopback(struct phy_device *phydev, bool enable)
>>  {
>> +	struct gpy_priv *priv = phydev->priv;
>> +	u16 set = 0;
>>  	int ret;
>> 
>> -	ret = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
>> -			 enable ? BMCR_LOOPBACK : 0);
>> -	if (!ret) {
>> -		/* It takes some time for PHY device to switch
>> -		 * into/out-of loopback mode.
>> +	if (enable) {
>> +		/* wait until 3 seconds from last disable */
>> +		if (priv->lb_dis_chk && time_is_after_jiffies64(priv->lb_dis_to))
>> +			msleep(jiffies64_to_msecs(priv->lb_dis_to - get_jiffies_64()));
>> +
>> +		priv->lb_dis_chk = false;
>> +		set = BMCR_LOOPBACK;
> 
> Maybe this can be simplified by setting priv->lb_dis_to =
> get_jiffies_64() + HZ * 3 in _probe(). Then you don't need
> priv->lb_dis_chk.

First, I wonder if this is worth the effort and code complications.
phy_loopback() seem to be used very seldom. Anyway.

Can't we just save the jiffies on last enable as kind of a timestamp.
If it's 0 you know it wasn't called yet and if it's set, you have to at
least wait for until it is after "jiffies + HZ*3".

Also isn't that racy right now? "priv->lb_dis_to - get_jiffies_64())" 
can
get negative, no?

-michael
