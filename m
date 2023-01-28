Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC667F9EC
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 18:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbjA1RjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 12:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjA1RjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 12:39:02 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3B12A175;
        Sat, 28 Jan 2023 09:39:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674927502; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=XGngZ+CfeF5ETeoZj5mEJCZXNloNBXlYT5+bh/sQwlCnYUEX6rtdAK0ic0s9rBBckX2MqOaFZhulKNV9xvf6xP/8S3AG2mRN80orreVy5aRQCG0lhu5apvcYWiZ8gnE5hNueAiThV1/1MimRfDNUisE+qzCNlOiFz3JdRyvo88U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674927502; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=XZyRjGD6IJEi2ji1I50O5QBvIy0FeOzgKH5lESzzl1M=; 
        b=GDI36+F02nx/AZvz7aFYjb2VfMzR4i4QmmsQsjTfniv/euYDJ0PU7oa8jNZcNTylRc51MxC6dBvjgavpkL/D4kc91caOmj8jQY9JLMwXlLJewEgCyLlitRV/Ov+2oVekpdvDZ6tThChp3WFC3UlIW7rHPwTIy70XI4+7hBBUXLo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674927502;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=XZyRjGD6IJEi2ji1I50O5QBvIy0FeOzgKH5lESzzl1M=;
        b=a10mS5qX5UtpKUNIjBZYBA9Yd4XsZOBwUsHQUk+VEcbHLkc2Gv9vhvQjGOIimyPp
        06w0ZrDaxHhoU9VTkIzbhet2PChtW10T9SCzv1DIWn7/URdn+vMSxEJz3hnEkqhZgKJ
        nKZCFFQsG5uF53gnsAi0akpzT7rvWxAD9YuSia3c=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1674927499694831.882213376883; Sat, 28 Jan 2023 09:38:19 -0800 (PST)
Message-ID: <79506b27-d71a-c341-48fd-0e6d3a973f2e@arinc9.com>
Date:   Sat, 28 Jan 2023 20:38:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net v3 4/5] net: ethernet: mtk_eth_soc: drop generic vlan
 rx offload, only use DSA untagging
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        erkin.bozoglu@xeront.com
References: <20221230073145.53386-1-nbd@nbd.name>
 <20221230073145.53386-4-nbd@nbd.name>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20221230073145.53386-4-nbd@nbd.name>
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

On 30.12.2022 10:31, Felix Fietkau wrote:
> Through testing I found out that hardware vlan rx offload support seems to
> have some hardware issues. At least when using multiple MACs and when receiving
> tagged packets on the secondary MAC, the hardware can sometimes start to emit
> wrong tags on the first MAC as well.
> 
> In order to avoid such issues, drop the feature configuration and use the
> offload feature only for DSA hardware untagging on MT7621/MT7622 devices which
> only use one MAC.
> 
> Tested-By: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

You can add this to all patches on the series.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Tested on Unielec U7621-06 (MT7621AT) and Bananapi BPI-R2 (MT7623NI) on 
latest netnext with buildroot as initramfs. These are tested with my fix 
[0] applied on top.

VLAN on DSA master gmac0.
   Works on MT7621 SoC with multi-chip module MT7530 switch and MT7623
   SoC with standalone MT7530 switch.

VLAN on DSA master gmac0 and non-DSA gmac1.
   Works on MT7621 SoC with multi-chip module MT7530 switch and MT7623
   SoC with standalone MT7530 switch.

VLAN on DSA master gmac1.
   Can’t test on MT7621 as an unrelated issue prevents from testing.
     Define port@6 and gmac0, otherwise gmac1 DSA master receives
     malformed frames from port@5. This issue appears only on MT7621 SoC
     with multi-chip module MT7530 switch.
   Works on MT7623 SoC with standalone MT7530 switch.

VLAN on DSA master gmac0 and DSA master gmac1.
   Works on MT7621 SoC with multi-chip module MT7530 and MT7623 SoC with
   standalone MT7530 switch switch after compensating an unrelated issue.
     When both MACs are DSA masters, ping from gmac1 DSA master first,
     otherwise frames received from user ports won’t reach to gmac1 DSA
     master. This issue appears on MT7621 SoC with multi-chip module
     MT7530 switch and MT7623 SoC with standalone MT7530 switch.

It'd be great if you could take a look at these issues.

Network configuration:

For DSA master gmac0/gmac1
ip l add link lan3 name lan3.50 type vlan id 50
ip a add 192.168.3.1/24 dev lan3.50
ip l set up lan3 && ip l set up lan3.50

For non-DSA gmac1
ip l del lan3.50
ip l add link eth1 name eth1.50 type vlan id 50
ip a add 192.168.3.1/24 dev eth1.50
ip l set up eth1 && ip l set up eth1.50

Other side
ip l add link enp9s0 name enp9s0.50 type vlan id 50
ip a add 192.168.3.2/24 dev enp9s0.50
ip l set up enp9s0 && ip l set up enp9s0.50

[0] 
https://lore.kernel.org/netdev/20230128094232.2451947-1-arinc.unal@arinc9.com/

Arınç
