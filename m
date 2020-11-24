Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EB32C2B3F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389729AbgKXP0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730900AbgKXP0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:26:52 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D57AC0613D6;
        Tue, 24 Nov 2020 07:26:51 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id s8so22683974wrw.10;
        Tue, 24 Nov 2020 07:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=k+Iagc0aS3/EnNIwiIo6ZqVN4M6qIqWHIstOKgb6RBM=;
        b=TGjvJ/O8mQ4BBtCTUOVEuvsV/ulyv9D3/nkqLq3r4zf6F7FGNZdEDkcWnlyy4a+l7U
         P043tqdh98oNoPbqC//vEqQcPSrD07vn+8jH3FwcRaW6FAVACV6ZPVWYs+UywSdYXPWm
         JD35x6fSFaLzfOKw/PiTl2n1NS9OVamy9frAiCvPPnkoxUNuaObcfq1XcPzxu2xVc4il
         BhoDo2nUI0+EEB1ECp/CaDUJS/LOXHGY5P2Tz94BbS7SbLoT/fGHNUDGgRd2JXRVcA8I
         FgmrO0BpEOffA/txtAGYaVFgaUCs6KQzQZ7oaQvrzP9Dnz9hTvLa30tTHcozdCFFmDf1
         8Hwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=k+Iagc0aS3/EnNIwiIo6ZqVN4M6qIqWHIstOKgb6RBM=;
        b=KLfU1VZsN3V8jLgqXkdvWg7AeKIOpce/U33NFMBOuYY82SpuqwScT6ZAeI8w30CEUk
         4vxWnb8NFHbkY+nHzRzd0Yzo/yZXRb9M6hm35vi2hKdzkQSXztvKIbSJoMF/SLIOfKJo
         5qdTcPoKFfttFSe0jc6aT424pP1CGUAKVhxCgZ4ciir2KQjHNmW3FFCFlxDa/tbDaOwx
         qn8m22qg96OGXHoqUV9AN8K5o4PCWl/BW52467lU77C7zHBVvEc1LuGQBlBXVOdAJsOR
         cH8pLRJZDXfN+ahc4LTVhfsGVxp0DDAR/y4Vb/nNDrGvWOr38zL43II8lVcY0TQqwp9E
         7mCQ==
X-Gm-Message-State: AOAM532rTuftOHE50cwEfjl+19mDWEPMMJJXNvjAfLmN74k775hvi3YC
        0GIMzRBl2G0Si3l4sw98Tuop6tVImoEynQ==
X-Google-Smtp-Source: ABdhPJzo+2coZTD3QonwH13kAa3QAamwILg9Hc5MxylE0mG7e5z8jQKj9Ha49b3oHAPAyOhQC2sNtg==
X-Received: by 2002:a5d:4004:: with SMTP id n4mr5768370wrp.230.1606231609659;
        Tue, 24 Nov 2020 07:26:49 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:4cf3:cdf5:5d2a:5c8c? (p200300ea8f2328004cf3cdf55d2a5c8c.dip0.t-ipconnect.de. [2003:ea:8f23:2800:4cf3:cdf5:5d2a:5c8c])
        by smtp.googlemail.com with ESMTPSA id g131sm6426505wma.35.2020.11.24.07.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 07:26:49 -0800 (PST)
Subject: Re: [PATCH] net: phy: fix auto-negotiation in case of 'down-shift'
To:     Antonio Borneo <antonio.borneo@st.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yonglong Liu <liuyonglong@huawei.com>, stable@vger.kernel.org,
        linuxarm@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
References: <20201124143848.874894-1-antonio.borneo@st.com>
 <20201124145647.GF1551@shell.armlinux.org.uk>
 <bd83b9c15f6cfed5df90da4f6b50d1a3f479b831.camel@st.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2dc7ad93-5719-dd8a-44a9-8667a22a3b19@gmail.com>
Date:   Tue, 24 Nov 2020 16:26:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <bd83b9c15f6cfed5df90da4f6b50d1a3f479b831.camel@st.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 24.11.2020 um 16:17 schrieb Antonio Borneo:
> On Tue, 2020-11-24 at 14:56 +0000, Russell King - ARM Linux admin wrote:
>> On Tue, Nov 24, 2020 at 03:38:48PM +0100, Antonio Borneo wrote:
>>> If the auto-negotiation fails to establish a gigabit link, the phy
>>> can try to 'down-shift': it resets the bits in MII_CTRL1000 to
>>> stop advertising 1Gbps and retries the negotiation at 100Mbps.
>>>
>>> From commit 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode
>>> in genphy_read_status") the content of MII_CTRL1000 is not checked
>>> anymore at the end of the negotiation, preventing the detection of
>>> phy 'down-shift'.
>>> In case of 'down-shift' phydev->advertising gets out-of-sync wrt
>>> MII_CTRL1000 and still includes modes that the phy have already
>>> dropped. The link partner could still advertise higher speeds,
>>> while the link is established at one of the common lower speeds.
>>> The logic 'and' in phy_resolve_aneg_linkmode() between
>>> phydev->advertising and phydev->lp_advertising will report an
>>> incorrect mode.
>>>
>>> Issue detected with a local phy rtl8211f connected with a gigabit
>>> capable router through a two-pairs network cable.
>>>
>>> After auto-negotiation, read back MII_CTRL1000 and mask-out from
>>> phydev->advertising the modes that have been eventually discarded
>>> due to the 'down-shift'.
>>
>> Sorry, but no. While your solution will appear to work, in
>> introduces unexpected changes to the user visible APIs.
>>
>>>  	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
>>> +		if (phydev->is_gigabit_capable) {
>>> +			adv = phy_read(phydev, MII_CTRL1000);
>>> +			if (adv < 0)
>>> +				return adv;
>>> +			/* update advertising in case of 'down-shift' */
>>> +			mii_ctrl1000_mod_linkmode_adv_t(phydev->advertising,
>>> +							adv);
>>
>> If a down-shift occurs, this will cause the configured advertising
>> mask to lose the 1G speed, which will be visible to userspace.
> 
> You are right, it gets propagated to user that 1Gbps is not advertised
> 
>> Userspace doesn't expect the advertising mask to change beneath it.
>> Since updates from userspace are done using a read-modify-write of
>> the ksettings, this can have the undesired effect of removing 1G
>> from the configured advertising mask.
>>
>> We've had other PHYs have this behaviour; the correct solution is for
>> the PHY driver to implement reading the resolution from the PHY rather
>> than relying on the generic implementation if it can down-shift
> 
> If it's already upstream, could you please point to one of the phy driver
> that already implements this properly?
> 

See e.g. aqr107_read_rate(), used by aqr107_read_status().

> Thanks
> Antonio
> 

