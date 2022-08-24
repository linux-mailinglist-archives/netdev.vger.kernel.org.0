Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7483059F3ED
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 09:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbiHXHH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 03:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiHXHH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 03:07:28 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A77885FE2;
        Wed, 24 Aug 2022 00:07:26 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 84B0B1884C76;
        Wed, 24 Aug 2022 07:07:23 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 6880E25032B8;
        Wed, 24 Aug 2022 07:07:23 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 5802FA1A0052; Wed, 24 Aug 2022 07:07:23 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Wed, 24 Aug 2022 09:07:23 +0200
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
In-Reply-To: <YwTJ5f5RzkC/DSdi@shredder>
References: <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <ce4266571b2b47ae8d56bd1f790cb82a@kapio-technology.com>
 <YwMW4iGccDu6jpaZ@shredder>
 <c2822d6dd66a1239ff8b7bfd06019008@kapio-technology.com>
 <YwR4MQ2xOMlvKocw@shredder>
 <9dcb4db4a77811308c56fe5b9b7c5257@kapio-technology.com>
 <YwSAtgS7fgHNLMEy@shredder>
 <553c573ad6a2ddfccfc47c7847cc5fb7@kapio-technology.com>
 <YwTJ5f5RzkC/DSdi@shredder>
User-Agent: Gigahost Webmail
Message-ID: <5390cb1d1485db40a71bb3fbf674b67a@kapio-technology.com>
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

On 2022-08-23 14:36, Ido Schimmel wrote:
> On Tue, Aug 23, 2022 at 09:37:54AM +0200, netdev@kapio-technology.com 
> wrote:
> 
> "learning on locked on" is really a misconfiguration, but it can also
> happen today and entries do not roam with the "locked" flag for the
> simple reason that it does not exist. I see two options:
> 
> 1. Do not clear / set "locked" flag during roaming. Given learning
> should be disabled on locked ports, then the only half interesting case
> is roaming to an unlocked port. Keeping the "locked" flag basically
> means "if you were to lock the port, then the presence of this entry is
> not enough to let traffic with the SA be forwarded by the bridge".
> Unlikely that anyone will do that.
> 
> 2. Always set "locked" flag for learned entries (new & roamed) on 
> locked
> ports and clear it for learned entries on unlocked ports.
> 
> Both options are consistent in how they treat the "locked" flag (either
> always do nothing or always set/clear) and both do not impact the
> integrity of the solution when configured correctly (disabling learning
> on locked ports). I guess users will find option 2 easier to understand
> / work with.

Roaming to a locked port with an entry without the locked bit set would 
open the port for said MAC without necessary authorization. Thus I think 
that the only real option is the 2. case.
