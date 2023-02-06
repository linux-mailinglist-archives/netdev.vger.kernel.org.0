Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A2168C7B8
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 21:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjBFUgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 15:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjBFUge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 15:36:34 -0500
Received: from sender4-op-o16.zoho.com (sender4-op-o16.zoho.com [136.143.188.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC2825972;
        Mon,  6 Feb 2023 12:36:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675715759; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=FAnsFNqlGZU7TNN7zUIOAANQSxRgoy/H2OjNGK+mwkyLYT88VertW8/bXvwAcmbUyb5l7pcCL43yzKLs89gsoudHkQcKQUoxQlLtSbbnLXuwq4iDXOxMUU5+SdpS9pxWd0qezKtAyUUXA9RU24hQjcJcIbU5wAflcnLIHHKWbB4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1675715759; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=/kOUU24RP+m6mL6JWbSnsV+ayZgFgt6Mmw6zP6zd3JE=; 
        b=JOaTJcqQ7OUYs8/jspsffSR2OErth1gmp+0PDsXc3HhtAaUdqZyimks3IyDi1LHzoJ6hiwq2VSqFmr1NvsOJbuLmmM0cJmMw807FzCreV2lwGg+3baZc8RNBnAebD+kouHLrs6mrtniuEUQVh9YkBxsMNDkrAqJ6aju6XgizoaM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1675715759;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=/kOUU24RP+m6mL6JWbSnsV+ayZgFgt6Mmw6zP6zd3JE=;
        b=JKFnMrrruUvsUuXNpYd+YcArW5UcpC36HXksIGqANL4dTmTkzqo2Q0KdorJYgt2q
        Vl1k3eBcaSm3Y2A8MP0qdVrYw3lIdq2P23T/PPWdvhmZU3ehaOknvFYH0t3hoE3nwWe
        zoNkDr96bDNlpBFrilUhc4bEEaR1xBRc6TYHkSJk=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 16757157573215.933846910490274; Mon, 6 Feb 2023 12:35:57 -0800 (PST)
Message-ID: <4ee5df8d-618b-db78-9c14-17a45e383b67@arinc9.com>
Date:   Mon, 6 Feb 2023 23:35:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
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
 <5e474cb7-446c-d44a-47f6-f679ae121335@arinc9.com>
 <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
 <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
 <20230206203335.6uxfiylftyktut5u@skbuf>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230206203335.6uxfiylftyktut5u@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/02/2023 23:33, Vladimir Oltean wrote:
> On Mon, Feb 06, 2023 at 10:41:47PM +0300, Arınç ÜNAL wrote:
>> One last thing. Specific to MT7530 switch in MT7621 SoC, if port@5 is the
>> only CPU port defined on the devicetree, frames sent from DSA master appears
>> malformed on the user port. Packet capture on computer connected to the user
>> port is attached.
>>
>> The ARP frames on the pcapng file are received on the DSA master, I captured
>> them with tcpdump, and put it in the attachments. Then I start pinging from
>> the DSA master and the malformed frames appear on the pcapng file.
>>
>> It'd be great if you could take a look this final issue.
> 
> What phy-mode does port@5 use when it doesn't work? What about the DSA master?

It's rgmii on port@5 and gmac1.

Arınç
