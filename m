Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747AA6EF953
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbjDZR0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238345AbjDZR0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:26:49 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C1A7A98;
        Wed, 26 Apr 2023 10:26:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682529964; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=kaxaqzuagDTmsGBF7wJshv8q1kJ8czNH1mwRTjieorUoa+YQQ2NiMBzZ8binM9p4cipWt36bZfg2FP8qPTYIhDSih5ztveZJTvQXwyHSoth9R+vxMto+e/4iBp76k8N+nNlaz89BHulZwOPlpKQbvlugki1kMIBsTSTW0jBXkqI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682529964; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=RT/owfhTxJeu2QuP6rH9YfYIno23f9H7utc/KQpP2W4=; 
        b=CqLik37rZc5tAltgBP7aBXSLtCk5LDYyb3QtukTCLcOyvFYPZEx9L8Tg+uqQCV1RpJAjDB5cVXUqHsWu8YjKS/SvlcQND9eCbu/64JVMCQ2NdLRO5tdPTwb/SSrsdgyq548ZwijLF4Qw30j2oxDE1rgaCw89CfdPthAl3QZYVYA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682529964;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=RT/owfhTxJeu2QuP6rH9YfYIno23f9H7utc/KQpP2W4=;
        b=Fo0RE1Cci2Ywwtk/6uu30TkSUE3fZnQFb47MADPf+iIr2YYNV8J3GsyDDhCwfvYU
        bK1BvGatid0y/QCgjXexl8UvWMeu5pEp52dLACqzoVAoT8vsTIgPdJhOoc1ikInsyjZ
        79E9JdPSWNiQxDRAgnRMG1eA1HDEsEGzd1LioZjY=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682529963036952.8466533209543; Wed, 26 Apr 2023 10:26:03 -0700 (PDT)
Message-ID: <61ea49b7-8a04-214d-ef02-3ef6181619e9@arinc9.com>
Date:   Wed, 26 Apr 2023 20:25:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [net v2] net: ethernet: mtk_eth_soc: drop generic vlan rx
 offload, only use DSA untagging
To:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
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
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>
References: <20230426172153.8352-1-linux@fw-web.de>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230426172153.8352-1-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2023 20:21, Frank Wunderlich wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> Through testing I found out that hardware vlan rx offload support seems to
> have some hardware issues. At least when using multiple MACs and when
> receiving tagged packets on the secondary MAC, the hardware can sometimes
> start to emit wrong tags on the first MAC as well.
> 
> In order to avoid such issues, drop the feature configuration and use
> the offload feature only for DSA hardware untagging on MT7621/MT7622
> devices where this feature works properly.
> 
> Fixes: 08666cbb7dd5 ("net: ethernet: mtk_eth_soc: add support for configuring vlan rx offload")
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
> v2:
> - changed commit message to drop "only one MAC used" phrase based on
>    Arincs comments
> - fixed too long line in commit description and add empty line after
>    declaration
> - add fixes tag
> 
> used felix Patch as base and ported up to 6.3-rc6
> 
> it basicly reverts changes from vladimirs patch
> 
> 1a3245fe0cf8 net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port 0
> 
> tested this on bananapi-r3 on non-dsa gmac1 and dsa eth0 (wan).
> on both vlan is working, but maybe it breaks HW-vlan-untagging

I'm confused by this. What is HW-vlan-untagging, and which SoCs do you 
think this patch would break this feature? How can I utilise this 
feature on Linux so I can confirm whether it works or not?

Arınç
