Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8336E3794
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 12:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjDPK4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 06:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjDPK4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 06:56:17 -0400
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D0826A4;
        Sun, 16 Apr 2023 03:56:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681642533; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=UqMHckyXcIFHfoaEyjSWBgSItMRDJGCT/lSiPfTTztXU+esoRDFCPNG5VHTVWdI5yeXwkF+ThMd5wZeHhf+vFczNpbnVNQ8qi9dLDfbbxOP2HQm0elNaagkpvf2jtfGGp5By6juMKOEWrB3wb4oK7M4pVwEUvS9dR0BPsxw2+B4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681642533; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=V97CTbRRx60wlBMlbpYx7Tf+OkDSsIy8nufSdDeF6Cw=; 
        b=UttCBE28loNQMpNq3POemwT5lMIKSTAntgb+F25KGLPAqug6yp9AvaPpVD0Ite22J0zgDWSb9l+mr+ZITCCGZbpOEJSkWmPW2Lrw7ld3hKVPQZK6nak9T/rX1HKPeM7BoofWv/XFabQmD2mPOyGVT9edtR6t6uVpdlCPag1Y4RM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681642533;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=V97CTbRRx60wlBMlbpYx7Tf+OkDSsIy8nufSdDeF6Cw=;
        b=W5VPss4P6cukgI3IUb1vyNbj3IP6miJhzJFQ2Taq9S6XOCsbGKaCIukbHiRz4rcy
        eRaECDM3thiWG0oFsGwgQwQknnI12pTaZyf1hI/mMWOJazcYvkD6o7FXZXgN1kknWvb
        PlfRqSvpDyOfIASd160zpIsT6COPO918w3NgkKlo=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681642532775839.6157058403239; Sun, 16 Apr 2023 03:55:32 -0700 (PDT)
Message-ID: <2ad08330-59a0-d3b2-214e-13d93dbe35a1@arinc9.com>
Date:   Sun, 16 Apr 2023 13:55:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC/RFT v1] net: ethernet: mtk_eth_soc: drop generic vlan rx
 offload, only use DSA untagging
Content-Language: en-US
To:     frank-w@public-files.de, Frank Wunderlich <linux@fw-web.de>,
        Felix Fietkau <nbd@nbd.name>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Daniel Golle <daniel@makrotopia.org>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230416091038.54479-1-linux@fw-web.de>
 <c657f6a2-74fa-2cc1-92cf-18f25464b1e1@arinc9.com>
 <161044DF-0663-42D4-94B8-03741C91B1A4@public-files.de>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <161044DF-0663-42D4-94B8-03741C91B1A4@public-files.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.04.2023 13:15, Frank Wunderlich wrote:
> Am 16. April 2023 11:52:31 MESZ schrieb "Arınç ÜNAL" <arinc.unal@arinc9.com>:
>> On 16.04.2023 12:10, Frank Wunderlich wrote:
>>> From: Felix Fietkau <nbd@nbd.name>
>>>
>>> Through testing I found out that hardware vlan rx offload support seems to
>>> have some hardware issues. At least when using multiple MACs and when receiving
>>> tagged packets on the secondary MAC, the hardware can sometimes start to emit
>>> wrong tags on the first MAC as well.
>>>
>>> In order to avoid such issues, drop the feature configuration and use the
>>> offload feature only for DSA hardware untagging on MT7621/MT7622 devices which
>>> only use one MAC.
>>
>> MT7621 devices most certainly use both MACs.
>>
>>>
>>> Tested-by: Frank Wunderlich <frank-w@public-files.de>
>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
>>> ---
>>> used felix Patch as base and ported up to 6.3-rc6 which seems to get lost
>>> and the original bug is not handled again.
>>>
>>> it reverts changes from vladimirs patch
>>>
>>> 1a3245fe0cf8 net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port 0
>>
>> Do I understand correctly that this is considered being reverted because the feature it fixes is being removed?
> 
> As far as i understood, vladimirs patch fixes one
> cornercase of hw rx offload where felix original
> patch was fixing more..sent it as rft to you to test
> if your bug (which vladimir fixed) is not coming in
> again. If it does we can try to merge both
> attempts. But current state has broken vlan on
> bpi-r3 non-dsa gmac1 (sfp-wan).

I tested this patch on MT7621AT and MT7623NI SoCs on the current 
linux-next. Port 0 keeps working fine.

So when you use VLANs on non-DSA gmac1, network connectivity is broken?

I've got an MT7621AT device which gmac1 is connected to an external phy 
(sfp-wan, the same case as yours). I'll test VLANs there. See if MT7621 
is affected by this as well since the patch log here states this feature 
is kept enabled for MT7621 because only gmac0 is used which is false.

Arınç
