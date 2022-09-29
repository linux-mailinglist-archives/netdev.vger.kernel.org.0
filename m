Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD4E5EF9FB
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbiI2QOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiI2QOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:14:19 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5231DADE0;
        Thu, 29 Sep 2022 09:14:13 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 462101884BA5;
        Thu, 29 Sep 2022 16:14:11 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 3F4F32500370;
        Thu, 29 Sep 2022 16:14:11 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 34F409EC0002; Thu, 29 Sep 2022 16:14:11 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 29 Sep 2022 18:14:11 +0200
From:   netdev@kapio-technology.com
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-kselftest@vger.kernel.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Jiri Pirko <jiri@resnulli.us>, Amit Cohen <amcohen@nvidia.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Hans Schultz <schultz.hans@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: Re: [Bridge] [PATCH iproute2-next 2/2] bridge: fdb: enable FDB
 blackhole feature
In-Reply-To: <20220929084312.2a216698@hermes.local>
References: <20220929152137.167626-1-netdev@kapio-technology.com>
 <20220929152137.167626-2-netdev@kapio-technology.com>
 <20220929084312.2a216698@hermes.local>
User-Agent: Gigahost Webmail
Message-ID: <6de8a39832ebb15fc5e8c2f19e469514@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-29 17:43, Stephen Hemminger wrote:
> On Thu, 29 Sep 2022 17:21:37 +0200
> Hans Schultz <netdev@kapio-technology.com> wrote:
> 
>> 
>> @@ -493,6 +496,8 @@ static int fdb_modify(int cmd, int flags, int 
>> argc, char **argv)
>>  			req.ndm.ndm_flags |= NTF_EXT_LEARNED;
>>  		} else if (matches(*argv, "sticky") == 0) {
>>  			req.ndm.ndm_flags |= NTF_STICKY;
>> +		} else if (matches(*argv, "blackhole") == 0) {
>> +			ext_flags |= NTF_EXT_BLACKHOLE;
>>  		} else {
>>  			if (strcmp(*argv, "to") == 0)
>>  				NEXT_ARG();
> 
> The parsing of flags is weird here, most of the flags are compared with 
> strcmp()
> but some use matches()..  I should have used strcmp() all the time; but 
> at the
> time did not realize what kind of confusion matches() can cause.

Maybe just change all of them then, and then how about using strncmp() 
and maybe also strnlen() instead?
