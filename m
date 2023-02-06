Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E56968C5FC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBFSl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBFSlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:41:55 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334D173F;
        Mon,  6 Feb 2023 10:41:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675708875; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=HvPZoRoztiFry6G8NNQ7DEovbjbJGM+glsPpptqwdg8j3l4zKnBZ9U0N4eGESqM9j2b5b0EToaQxa9LpkXSoIU5MvSjml2YLjChipQNex262mKxCKuZAjLa13p6T/ttnb/p0/fmzkErpMmPh2WaqFGCIurcpwt/Lg1+9wXlSA18=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1675708875; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=arkdi84OlgD/8JIjBhprSNAS0S9dnuy2bKkOoDUEn7w=; 
        b=NumanfTudQLojOt9+t7fsi/8aciPlaLjk6QePC4LAhEPgIt6+RTiyjPAEsdL0OXAThjrr3kEX0Vc+muQNnOFvnZSS3yOEYkgrw58GlORscRuJLxtkBppYOWqLY5nUayJP3vEJH5esYZb+axN65ZPtm4eCIRPaO6I0YCr2z5ewWU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1675708875;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=arkdi84OlgD/8JIjBhprSNAS0S9dnuy2bKkOoDUEn7w=;
        b=X6EWEHD41ZVIzuEsFLMgPG2WhnuB8iZY+XiFkS1SWsBTVtEJayB85MdhuHxD63iH
        pRlt9CYWe6sBFGJ+jKQjt8nya/1Ap+WvwBrGxDVMk7/fk73Uwt+SF8xUPzgrjJZBR+h
        Td6WXz+SrpXh9QNU7jShbpcQAhEiXr7/8h+80YrQ=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1675708872711675.352353078918; Mon, 6 Feb 2023 10:41:12 -0800 (PST)
Message-ID: <5e474cb7-446c-d44a-47f6-f679ae121335@arinc9.com>
Date:   Mon, 6 Feb 2023 21:41:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, richard@routerhints.com
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
 <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
 <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
 <20230205235053.g5cttegcdsvh7uk3@skbuf>
 <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
 <20230206174627.mv4ljr4gtkpr7w55@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230206174627.mv4ljr4gtkpr7w55@skbuf>
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

On 6.02.2023 20:46, Vladimir Oltean wrote:
> Hi Arınç,
> 
> On Mon, Feb 06, 2023 at 07:41:06PM +0300, Arınç ÜNAL wrote:
>> Finally I got time. It's been a seismically active day where I'm from.
> 
> My deepest condolences to those who experienced tragedies after today's
> earthquakes. A lot of people in neighboring countries are horrified
> thinking when this will happen to them. Hopefully you aren't living in
> Gaziantep or nearby cities.

Thank you for asking, we're all fine as a family in İzmir. This region 
is on a fault line as well so the same could happen here too like it did 
in 2020. Thankfully our apartment is strong.

> 
>> # ping 192.168.2.2
>> PING 192.168.2.2
>> [   39.508013] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: there is no metadata dst attached to skb 0xc2dfecc0
>>
>> # ping 192.168.2.2
>> PING 192.168.2.2
>> [   22.674182] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: received skb 0xc2d67840 without VLAN/DSA tag present
> 
> Thank you so much for testing. Would you mind cleaning everything up and
> testing with this patch instead (formatted on top of net-next)?
> Even if you need to adapt to your tree, hopefully you get the idea from
> the commit message.

Applies cleanly and fixes the issue! You can add my tested-by tag. 
Thanks a lot for the ridiculously fast fix Vladimir!

Arınç
