Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A60D68E1D0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 21:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjBGUZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 15:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBGUZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 15:25:00 -0500
Received: from sender4-op-o16.zoho.com (sender4-op-o16.zoho.com [136.143.188.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C932410277;
        Tue,  7 Feb 2023 12:24:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675801463; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Hl/XRgWpiWibiDat/L1KwETvSOMPWaJDiVyhogHfIz9QJI8rU1Pj5fT3hl5Btp+CgMhY/jkc8KETV1U1AKGp9I0BMs2bynL+ITP2PAv76upgv83uLerBGJTIAadRs9LR+8qxEYUw0jZ/tXBxcOXWcTWk4P+InRvNzio7V/aiFgM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1675801463; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ciZyfUunIdJXVokdar4vWZKf/PpE7JeGcTYMOT/PkXI=; 
        b=KPYFxIpeEkMYeSWqREQOfUBLr4/fUyBDbPladT0ilSiTdqjemQNrAPgihA8uMGyzTpQIAlp/lFmCLi1GoGkjtlp9ZIvNzxOf00fqy1jGgtb+ImF4OdHHCjW+V1WYjJgn0c+aZYFGJQ91I1lOEgCSl9o2XBYk6ULoYpHYYEiIASE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1675801463;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=ciZyfUunIdJXVokdar4vWZKf/PpE7JeGcTYMOT/PkXI=;
        b=itaIk8cEmENhemuWlmkCwgbz67Q9DZ17uzWs01/iZySRjIFrHqHvyBmr+GSkmVli
        8W5Z3WKla6e+dqO0k3Vi3y34711RmqRBTTPLP9ReYsv9DTkd17CAtBh9x9YL8H/Fjd8
        HYdfAT+tnaNurhl+Pbi9ZZ6dgjpIilB8FHaauZS8=
Received: from [10.10.10.3] (31.223.26.239 [31.223.26.239]) by mx.zohomail.com
        with SMTPS id 1675801462229826.7971689472303; Tue, 7 Feb 2023 12:24:22 -0800 (PST)
Message-ID: <5d025125-77e4-cbfb-8caa-b71dd4adfc40@arinc9.com>
Date:   Tue, 7 Feb 2023 23:24:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: enable special tag when
 any MAC uses DSA
To:     Jakub Kicinski <kuba@kernel.org>, arinc9.unal@gmail.com
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Richard van Schagen <richard@routerhints.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
References: <20230205175331.511332-1-arinc.unal@arinc9.com>
 <20230207105613.4f56b445@kernel.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230207105613.4f56b445@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7.02.2023 21:56, Jakub Kicinski wrote:
> On Sun,  5 Feb 2023 20:53:31 +0300 arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The special tag is only enabled when the first MAC uses DSA. However, it
>> must be enabled when any MAC uses DSA. Change the check accordingly.
>>
>> This fixes hardware DSA untagging not working on the second MAC of the
>> MT7621 and MT7623 SoCs, and likely other SoCs too. Therefore, remove the
>> check that disables hardware DSA untagging for the second MAC of the MT7621
>> and MT7623 SoCs.
>>
>> Fixes: a1f47752fd62 ("net: ethernet: mtk_eth_soc: disable hardware DSA untagging for second MAC")
> 
> As Paolo pointed out to me off-list this is pretty much a revert of
> commit under Fixes. Is this an actual regression fix, or second MAC
> as DSA port never worked but now you found a way to make it work?

Second MAC as DSA master after hardware DSA untagging was enabled never 
worked. I first disabled it to make the communication work again, then, 
with this patch, I found a way to make it work which is what should've 
been done with the commit for adding hardware DSA untagging support.

Arınç
