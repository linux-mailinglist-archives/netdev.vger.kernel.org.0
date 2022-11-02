Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A3C615BF9
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 06:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiKBFti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 01:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKBFtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 01:49:36 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E57E62D5;
        Tue,  1 Nov 2022 22:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GHqgpi49F525hGNgrGw5jxJA5z8262KOfovIPeXSDkE=; b=Pw+1ZCBBpSQGbjl9omMRX/HDUR
        PISJ5gZNcun2rUbxtx6gB/F8dAH3yS6U4VFO8xVZ1UdDVMP3HuAG24vDkQMDcXwb23pWdGHgLWIVz
        jkA/6RKt2AEhsyEI49a3q14XV+20onwacw8H7liW5/I+Lveccz09crjogPH4/BCTx110=;
Received: from p200300daa71950003c313de20777bbcd.dip0.t-ipconnect.de ([2003:da:a719:5000:3c31:3de2:777:bbcd] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oq6cl-00Gq2Q-Rs; Wed, 02 Nov 2022 06:49:15 +0100
Message-ID: <770dd173-41b8-80f7-7c78-40319734cfbf@nbd.name>
Date:   Wed, 2 Nov 2022 06:49:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Daniel Golle <daniel@makrotopia.org>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <Y2G9ANkdaaENNnOd@makrotopia.org> <Y2G/CaPrTVsYeGWB@lunn.ch>
 <Y2HBzEdmiKK9IPFK@makrotopia.org> <Y2HHOSaYQGAhWL/E@lunn.ch>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3] net: ethernet: mediatek: ppe: add support for flow
 accounting
In-Reply-To: <Y2HHOSaYQGAhWL/E@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.11.22 02:26, Andrew Lunn wrote:
> On Wed, Nov 02, 2022 at 01:03:08AM +0000, Daniel Golle wrote:
>> Hi Andrew,
>> 
>> On Wed, Nov 02, 2022 at 01:51:21AM +0100, Andrew Lunn wrote:
>> > On Wed, Nov 02, 2022 at 12:42:40AM +0000, Daniel Golle wrote:
>> > > The PPE units found in MT7622 and newer support packet and byte
>> > > accounting of hw-offloaded flows. Add support for reading those
>> > > counters as found in MediaTek's SDK[1].
>> > > 
>> > > [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
>> > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
>> > 
>> > Sorry, but NACK.
>> > 
>> > You have not explained why doing this correctly via ethtool -S cannot
>> > be done. debugfs is a vendor crap way of doing this.
>> 
>> The debugfs interface is pre-existing and **in addition** to the
>> standard Linux interfaces which are also provided. It is true that
>> the debugfs interface in this case doesn't provide much additional
>> value apart from having the counter listed next to the hardware-
>> specific hashtable keys. As the debugfs interface for now aims to
>> be as complete as possible, naturally there is some redundance of
>> things which can also be accessed using other (standard) interfaces.
> 
> debugfs is by definition unstable. It is not ABI. Anything using it is
> expected to break in the near future when it changes its layout. It is
> also totally option, you cannot expect it to be mounted.
> 
> I hope you don't have any user space code using it.
> 
> Maybe i should submit a patch which just for the fun of it rearranged
> the order in debugfs and change the file name?

I believe that OpenWrt is still the main user of the PPE offloading 
code, since most vendors of devices with these SoC still use different 
out-of-tree implementations.
OpenWrt does not ship or contain any user space code that relies on 
these debugfs files.

Whenever I'm debugging PPE related issues, I rely heavily on the debugfs 
API, so keeping it as complete as possible is important to me as well.

Aside from that, exposing per-flow statistics (which is what this patch 
does) via ethtool -S API makes no sense to me at all. I'm not aware of 
any other offload capable driver that does this.

- Felix
