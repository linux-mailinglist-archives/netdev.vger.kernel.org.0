Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433596DEBCF
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjDLGby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjDLGbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:31:53 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376DA4C24;
        Tue, 11 Apr 2023 23:31:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681281038; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=My2rJCFnTpnH+GL2v3ym4Pph4sOl8sHD+zJObog45cYOdAxD5Sau/XzTzcrpabz6dQtUIharubH4HHZ2Atptzkv2/cdV4aSNHQjNDznON6oz8X7ems+BcT07CCqbLgvn71/oqqpxIclfQ6iNffA2c10DRXx0MFagSfdue0Swyfc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681281038; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=o2miyoGfbCcRLimBj3L70ONV9oorgx56a71K9dJ05CE=; 
        b=KITY1A4RVRs0t0PEQZD0UQWplgGdZPwsssWdrAnvK6b+miJYKiAph5ie0giCCpX5H4/JdeTCnZt24mVlVLhW/8kKHJDkPsg19lN5NuJLXTPVh0eY42ZbkSftqYVKaiRdGrSPrB9BUV/BidZGTJIO+7NB8fpIi9Xi1mBZm5Z9vvI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681281038;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=o2miyoGfbCcRLimBj3L70ONV9oorgx56a71K9dJ05CE=;
        b=EdPisSJMMOUIbAUtQCFrnkidicWtGQqL8APAdPZQ5y2iEfkSSi6cyjdggiNjBI2E
        LoL6qwYcMfqP5rP99X00KQ0e5M6wyL+XhaB5MVWJxIiJc2KfFHNCsiQQrApLVYyKBrN
        OrIjXPWOlgcU/TiiGqFXwMhGT+AWr1TFaggrmL3Q=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681281035406493.8289945315429; Tue, 11 Apr 2023 23:30:35 -0700 (PDT)
Message-ID: <8cdf8c13-0c6a-9e9a-871a-cb738a181b3f@arinc9.com>
Date:   Wed, 12 Apr 2023 09:30:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v2 net-next 02/14] net: dsa: mt7530: fix phylink for
 port 5 and fix port 5 modes
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
 <20230407134626.47928-3-arinc.unal@arinc9.com>
 <20230411150056.2uhtoy6iqnt2qopr@skbuf>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230411150056.2uhtoy6iqnt2qopr@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.04.2023 18:00, Vladimir Oltean wrote:
> On Fri, Apr 07, 2023 at 04:46:14PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> There're two code paths for setting up port 5:
>>
>> mt7530_setup()
>> -> mt7530_setup_port5()
>>
>> mt753x_phylink_mac_config()
>> -> mt753x_mac_config()
>>     -> mt7530_mac_config()
>>        -> mt7530_setup_port5()
>>
>> The first code path is supposed to run when PHY muxing is being used. In
>> this case, port 5 is somewhat of a hidden port. It won't be defined on the
>> devicetree so phylink can't be used to manage the port.
>>
>> The second code path used to call mt7530_setup_port5() directly under case
>> 5 on mt7530_phylink_mac_config() before it was moved to mt7530_mac_config()
>> with 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a
>> new hardware"). mt7530_setup_port5() will never run through this code path
>> because the current code on mt7530_setup() bypasses phylink for all cases
>> of port 5.
>>
>> Fix this by leaving it to phylink if port 5 is used as a CPU, DSA, or user
>> port. For the cases of PHY muxing or the port being disabled, call
>> mt7530_setup_port5() directly from mt7530_setup() without involving
>> phylink.
>>
>> Move setting the interface and P5_DISABLED mode to a more specific
>> location. They're supposed to be overwritten if PHY muxing is detected.
>>
>> Add comments which explain the process.
>>
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> We have a natural language processing engine (AUTOSEL) which
> automatically picks up as candidates for "stable" those patches which
> weren't explicitly submitted through the proper process for that (and
> they contain words like "fix", "bug", "crash", "leak" etc).
> 
> Your chosen wording, both in the commit title and message, would most
> likely trigger that bot, and then you'd have to explain why you chose
> this language and not something else more descriptive of your change.
> It would be nice if you could rewrite the commit messages for your
> entire series to be a bit more succint as to what is the purpose of the
> change you are making, and don't use the word "fix" when there is no
> problem to be observed.

Will do, thanks.

Arınç
