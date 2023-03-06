Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566806AC0A5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjCFNUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjCFNTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:19:55 -0500
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D2C298DB;
        Mon,  6 Mar 2023 05:19:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678108740; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Usc3U+m036F/GJenU64yhcHJ8sB418nOyXsbOtEEUn8L3x9A+iWdTgdif8J72KUw1wKBVSaTD6A8GZuS5VUcz+EZz2an05h9z3xQQ2+G88/AJHv1zGLE3wyF7GsOMTmJECeHZJEsGyQu4DEdt4u1ETKA2iiAxAjGSTVqZ8B2TTE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678108740; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Nkz3gGspeeY9dH/8hh4d0Lg8dzAyUxZH+rMD5cbi76Q=; 
        b=eKKf8WJHxq5qUXctP7ya8cfq+YKfhDkxWk6r9ixeXhfE6asJMNPJeWRm16Q4MGuj8/NS7f3yls8UqQSV4CxMtGs0znXDeDdwjhfR6KTwCxIt7j5LVQwedVlSvsdpS4mhpqO9JvWddjboZ1yP2g/gpTnmaKKOUj1BXO7Gn6ovosY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678108740;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Nkz3gGspeeY9dH/8hh4d0Lg8dzAyUxZH+rMD5cbi76Q=;
        b=TQvFjc3Av3UVZaweaDW46VwAtfsWwzSysGoaqXS3z7xc8PFhOP9zaQ/qgb9SBGad
        3VIrQrkSsViV7yUUhAVhMxeZO8CfiHONB4D74GXLnxLxMiw0XyZfItszzBz7jX/+N/U
        3NnEv6ze6nbxOoE7LC+cdirgYtt0NnERRleCJxOY=
Received: from [10.10.10.3] (212.68.60.226 [212.68.60.226]) by mx.zohomail.com
        with SMTPS id 1678108738745306.70357433678555; Mon, 6 Mar 2023 05:18:58 -0800 (PST)
Message-ID: <bdb31e6c-bb47-b637-cfbe-fc1e987d07bd@arinc9.com>
Date:   Mon, 6 Mar 2023 16:18:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH net] net: dsa: mt7530: move PLL setup out of port 6
 pad configuration
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Alexander Couzens <lynxis@fe80.eu>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230304125453.53476-1-arinc.unal@arinc9.com>
 <ZANBwZryFXDEVEtG@shell.armlinux.org.uk>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZANBwZryFXDEVEtG@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4.03.2023 16:04, Russell King (Oracle) wrote:
> On Sat, Mar 04, 2023 at 03:54:54PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Move the PLL setup of the MT7530 switch out of the pad configuration of
>> port 6 to mt7530_setup, after reset.
>>
>> This fixes the improper initialisation of the switch when only port 5 is
>> used as a CPU port.
>>
>> Add supported phy modes of port 5 on the PLL setup.
>>
>> Remove now incorrect comment regarding P5 as GMAC5.
> 
> If this is what is necessary, you're taking some of the configuration
> out of phylink's control, effectively making port 6 a fixed-interface
> mode port. In that case, there should only ever be one interface
> mode set in port 6's supported_interface mask, so that phylink knows
> that no other interface modes can be selected for that port.

Thanks for the heads up Russell.

Arınç
