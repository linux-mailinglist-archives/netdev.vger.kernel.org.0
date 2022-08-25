Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD58E5A1289
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242026AbiHYNl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242052AbiHYNly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:41:54 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B212AE232;
        Thu, 25 Aug 2022 06:41:52 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 7BDFC1884D63;
        Thu, 25 Aug 2022 13:41:49 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 733B225032B7;
        Thu, 25 Aug 2022 13:41:49 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 571599EC0002; Thu, 25 Aug 2022 13:41:49 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 25 Aug 2022 15:41:49 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
In-Reply-To: <Ywdj2+mIQFR6+drZ@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <7016ed2ce9a30537e4278e37878900d8@kapio-technology.com>
 <Ywc/qTNqVbS4E7zS@shredder>
 <7dfe15571370dfb5348a3d0e5478f62c@kapio-technology.com>
 <Ywdj2+mIQFR6+drZ@shredder>
User-Agent: Gigahost Webmail
Message-ID: <6fa538a1489a73fdf8b1fa92785185aa@kapio-technology.com>
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

On 2022-08-25 13:58, Ido Schimmel wrote:
> On Thu, Aug 25, 2022 at 12:27:01PM +0200, netdev@kapio-technology.com 
> wrote:
> 
> Instead of skipping it you can check that roaming fails when "sticky" 
> is
> set.
> 

I think that the sticky flag topic generally is beyond the MAB feature, 
and it doesn't really fit into the bridge_locked_port.sh.
But anyhow I guess I can add it to the bridge_sticky_fdb.sh tests.

>> 
>> The bridge_locked_port.sh test is linked in
>> tools/testing/selftests/drivers/net/dsa/, but if I cannot check if the
>> mv88e6xxx driver or other switchcores are in use, I cannot do more.
> 
> Since the behavior of the HW data path is reflected to the software
> bridge and user space via "sticky" / "blackhole" / "extern_learn", you
> should be able to add test cases to the generic selftest. For example,
> if "blackhole" is set, then simple ping is expected to fail. Otherwise
> it is expected to pass.

The problem here is that the "blackhole" flag can only be set now from 
the mv88e6xxx driver under a locked port, and the locked port itself 
will not allow ping to work anyhow without a FDB entry free of the 
"locked" flag, as the MAB tests verify.
And disabling MAB on the locked port on the mv88e6xxx will clean the 
locked entries.

So I see it as a flag for future use, otherwise I will have to add a 
userspace command to enable the "blackhole" flag.


I have now made station move tests for both the locked port and MAB 
cases.
