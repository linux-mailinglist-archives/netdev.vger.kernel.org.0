Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3676F68B15D
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 20:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBET0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 14:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBET0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 14:26:19 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D243718B05;
        Sun,  5 Feb 2023 11:26:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675625138; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=WYSCdx3OS1UYar4V0w3b4hm8PrLdGbI5gqGCze+bmBh2Rj9ZP4nSXIf1aIGmV3O6NLHrDH06EA5hMEIHFYRn5wffj0pzK2CBrcSAFAUppkNt5cOSIqYKFsdWrPF7tVg1ewv/1faIn9zCtauLqpKrpIUaAUoO5CHpUSmJUi8pzdM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1675625138; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Ze1SJBY1Wx6lFrEWbcsfu2oAo4V69UzmhGUxMPFB7ss=; 
        b=H2Lrf7ExotIqc7kPh8iE9L3a65Qu4OjFw4cSwVhIKQLfiD8cIywQQODQlP8yWzrMt7BZxm9VULtZqoLB5Q9ewR+rr+Gn/02RA0ELxLhZErU6prdYpbXf3oHXrufTBeJvzlZDWjVgM47oeLaZutSv+JOnmZ3d83DmPBSyqOl1QSQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1675625138;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Ze1SJBY1Wx6lFrEWbcsfu2oAo4V69UzmhGUxMPFB7ss=;
        b=SmXO9Ncc4TygNio0NDTeJtlMrf2MZ+uCjatBxa9ke4M2AyitRZL+Vj6T9QSTr+Rd
        PfSvOhut+LT7ZcKTVYzAUrF0APlQJTib+L9sMldryoBwyv+h0NyIcHwquqPjZHMpUez
        ppsFD0WRD6kbaIdNN6HnE5TQ6NrvmtIkYKb25kXE=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1675625135719398.2461928154073; Sun, 5 Feb 2023 11:25:35 -0800 (PST)
Message-ID: <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
Date:   Sun, 5 Feb 2023 22:25:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
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

On 5.02.2023 17:07, Vladimir Oltean wrote:
> Frank reports that in a mt7530 setup where some ports are standalone and
> some are in a VLAN-aware bridge, 8021q uppers of the standalone ports
> lose their VLAN tag on xmit, as seen by the link partner.
> 
> This seems to occur because once the other ports join the VLAN-aware
> bridge, mt7530_port_vlan_filtering() also calls
> mt7530_port_set_vlan_aware(ds, cpu_dp->index), and this affects the way
> that the switch processes the traffic of the standalone port.
> 
> Relevant is the PVC_EG_TAG bit. The MT7530 documentation says about it:
> 
> EG_TAG: Incoming Port Egress Tag VLAN Attribution
> 0: disabled (system default)
> 1: consistent (keep the original ingress tag attribute)
> 
> My interpretation is that this setting applies on the ingress port, and
> "disabled" is basically the normal behavior, where the egress tag format
> of the packet (tagged or untagged) is decided by the VLAN table
> (MT7530_VLAN_EGRESS_UNTAG or MT7530_VLAN_EGRESS_TAG).
> 
> But there is also an option of overriding the system default behavior,
> and for the egress tagging format of packets to be decided not by the
> VLAN table, but simply by copying the ingress tag format (if ingress was
> tagged, egress is tagged; if ingress was untagged, egress is untagged;
> aka "consistent). This is useful in 2 scenarios:
> 
> - VLAN-unaware bridge ports will always encounter a miss in the VLAN
>    table. They should forward a packet as-is, though. So we use
>    "consistent" there. See commit e045124e9399 ("net: dsa: mt7530: fix
>    tagged frames pass-through in VLAN-unaware mode").
> 
> - Traffic injected from the CPU port. The operating system is in god
>    mode; if it wants a packet to exit as VLAN-tagged, it sends it as
>    VLAN-tagged. Otherwise it sends it as VLAN-untagged*.
> 
> *This is true only if we don't consider the bridge TX forwarding offload
> feature, which mt7530 doesn't support.
> 
> So for now, make the CPU port always stay in "consistent" mode to allow
> software VLANs to be forwarded to their egress ports with the VLAN tag
> intact, and not stripped.
> 
> Link: https://lore.kernel.org/netdev/trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36/
> Fixes: e045124e9399 ("net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode")
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested on MT7621AT and MT7623NI boards with MT7530 switch. Both had this 
issue and this patch fixes it.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Unrelated to this, as in it existed before this patch, port@0 hasn't 
been working at all on my MT7621AT Unielec U7621-06 board and MT7623NI 
Bananapi BPI-R2.

Packets are sent out from master eth1 fine, the computer receives them. 
Frames are received on eth1 but nothing shows on the DSA slave interface 
of port@0. Sounds like malformed frames are received on eth1.

Cheers.
Arınç
