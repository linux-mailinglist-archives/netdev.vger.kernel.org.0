Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFBB4F71D8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 04:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiDGCJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 22:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiDGCJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 22:09:21 -0400
X-Greylist: delayed 26205 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Apr 2022 19:07:22 PDT
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80B292D25
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 19:07:22 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id F203583E20;
        Thu,  7 Apr 2022 04:07:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1649297239;
        bh=qE8u9cNExmhekgm4UHY2JGvUfyLFl+GCud2tEbmgHWk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mpMxUvJJv4ZggSRY5IbD5XMsgOusCIe+Mn2RycPlzXP5bM5UzPUZ7RZX9lzQ2ZIV+
         Ww/HP8l396qkASnxu+yDwXmQrhx3Kc476oRvEqlV05AVaJBukU1znbEh+X/CTgdxpW
         mDRSIEIxdCklaKcXreWYJuPaG7dhX+Lvi0XGyoGmdgMa78YMJTQft4nnknMD+fd/UI
         D2Via7FV0DSjEM01CeFytFZztJcipjiNnG1/cKXYlsf+vz7JyVsINmU26qeLu/PidJ
         rLdRFVJgKZgP0TEOlrKBlvZNj0VcmC+lhujHhXwgtnkoK/jGaKTBaTtHUizVtV2lHQ
         TqWajT4aB6ApA==
Message-ID: <f2078d1d-071c-f261-c4e9-007915831933@denx.de>
Date:   Thu, 7 Apr 2022 04:07:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: phy: micrel: ksz9031/ksz9131: add cabletest support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220406185020.301197-1-marex@denx.de> <Yk4/Cm3uuBF7vplL@lunn.ch>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <Yk4/Cm3uuBF7vplL@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 03:31, Andrew Lunn wrote:
>> +static int ksz9x31_cable_test_start(struct phy_device *phydev)
>> +{
>> +	int ret;
>> +
>> +	/* KSZ9131RNX, DS00002841B-page 38, 4.14 LinkMD (R) Cable Diagnostic
>> +	 * Prior to running the cable diagnostics, Auto-negotiation should
>> +	 * be disabled, full duplex set and the link speed set to 1000Mbps
>> +	 * via the Basic Control Register.
>> +	 */
>> +	ret = phy_modify(phydev, MII_BMCR,
>> +			 BMCR_SPEED1000 | BMCR_FULLDPLX |
>> +			 BMCR_ANENABLE | BMCR_SPEED100,
>> +			 BMCR_SPEED1000 | BMCR_FULLDPLX);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* KSZ9131RNX, DS00002841B-page 38, 4.14 LinkMD (R) Cable Diagnostic
>> +	 * The Master-Slave configuration should be set to Slave by writing
>> +	 * a value of 0x1000 to the Auto-Negotiation Master Slave Control
>> +	 * Register.
>> +	 */
>> +	return phy_modify(phydev, MII_CTRL1000,
>> +			  CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER,
>> +			  CTL1000_ENABLE_MASTER);
> 
> Did you check if this gets undone when the cable test is
> completed? The phy state machine will call phy_init_hw(), but i've no
> idea if that is sufficient to reset the master selection.

Ha, I did not, V2 is coming with this fixed.

[...]
