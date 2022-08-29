Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F2B5A51B0
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiH2Q0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiH2Q0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:26:49 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960C679A7F;
        Mon, 29 Aug 2022 09:26:43 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id C6634188488E;
        Mon, 29 Aug 2022 16:26:41 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id BD87425032B7;
        Mon, 29 Aug 2022 16:26:41 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id B1D6C9EC0002; Mon, 29 Aug 2022 16:26:41 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Mon, 29 Aug 2022 18:26:41 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 1/6] net: bridge: add locked entry fdb flag to
 extend locked port feature
In-Reply-To: <Ywzlfzns/vDDiKB1@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-2-netdev@kapio-technology.com>
 <e9eb5b72-073a-f182-13b7-37fc53611d5f@blackwall.org>
 <972663825881d135d19f9e391b2b7587@kapio-technology.com>
 <Ywzlfzns/vDDiKB1@shredder>
User-Agent: Gigahost Webmail
Message-ID: <1bfb557cbae4a640b7e042d202c677cb@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-29 18:12, Ido Schimmel wrote:
> On Mon, Aug 29, 2022 at 04:02:46PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-08-27 13:30, Nikolay Aleksandrov wrote:
>> > On 26/08/2022 14:45, Hans Schultz wrote:
>> >
>> > Hi,
>> > Please add the blackhole flag in a separate patch.
>> > A few more comments and questions below..
>> >
>> 
>> Hi,
>> if userspace is to set this flag I think I need to change stuff in
>> rtnetlink.c, as I will need to extent struct ndmsg with a new u32 
>> entry as
>> the old u8 flags is full.
> 
> You cannot extend 'struct ndmsg'. That's why 'NDA_FLAGS_EXT' was
> introduced. See:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2c611ad97a82b51221bb0920cc6cac0b1d4c0e52
> 
> 'NTF_EXT_BLACKHOLE' belongs in 'NDA_FLAGS_EXT' like you have it now, 
> but
> the kernel should not reject it in br_fdb_add().
> 
>> Maybe this is straight forward, but I am not so sure as I don't know 
>> that
>> code too well. Maybe someone can give me a hint...?

Thanks! I see that I was in trouble there... :D
