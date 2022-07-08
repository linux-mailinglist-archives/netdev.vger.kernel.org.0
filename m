Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1871056B510
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 11:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbiGHJG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 05:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGHJG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 05:06:28 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253AC1FCDB;
        Fri,  8 Jul 2022 02:06:27 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id DB73F1887457;
        Fri,  8 Jul 2022 09:06:24 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id D3BF425032B7;
        Fri,  8 Jul 2022 09:06:24 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id CA8D7A1E00AE; Fri,  8 Jul 2022 09:06:24 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 08 Jul 2022 11:06:24 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
In-Reply-To: <20220708084904.33otb6x256huddps@skbuf>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-4-netdev@kapio-technology.com>
 <20220708084904.33otb6x256huddps@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-08 10:49, Vladimir Oltean wrote:
> Hi Hans,
> 
> On Thu, Jul 07, 2022 at 05:29:27PM +0200, Hans Schultz wrote:
>> Ignore locked fdb entries coming in on all drivers.
>> 
>> Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
>> ---
> 
> A good patch should have a reason for the change in the commit message.
> This has no reason because there is no reason.
> 
> Think about it, you've said it yourself in patch 1:
> 
> | Only the kernel can set this FDB entry flag, while userspace can read
> | the flag and remove it by replacing or deleting the FDB entry.
> 
> So if user space will never add locked FDB entries to the bridge,
> then FDB entries with is_locked=true are never transported using
> SWITCHDEV_FDB_ADD_TO_DEVICE to drivers, and so, there is no reason at
> all to pass is_locked to drivers, just for them to ignore something 
> that
> won't appear.

Correct me if I am wrong, but since the bridge can add locked entries, 
and
the ensuring fdb update will create a SWITCHDEV_FDB_ADD_TO_DEVICE, those 
entries
should reach the driver. The policy to ignore those in the driver can be
seen as either the right thing to do, or not yet implemented.

I remember Ido wrote at a point that the scheme they use is to trap 
various
packets to the CPU and let the bridge add the locked entry, which I then
understand is sent to the driver with a SWITCHDEV_FDB_ADD_TO_DEVICE 
event.

> 
> You just need this for SWITCHDEV_FDB_ADD_TO_BRIDGE, so please keep it
> only in those code paths, and remove it from net/dsa/slave.c as well.
> 
>>  drivers/net/dsa/b53/b53_common.c       | 5 +++++
>>  drivers/net/dsa/b53/b53_priv.h         | 1 +
>>  drivers/net/dsa/hirschmann/hellcreek.c | 5 +++++
>>  drivers/net/dsa/lan9303-core.c         | 5 +++++
>>  drivers/net/dsa/lantiq_gswip.c         | 5 +++++
>>  drivers/net/dsa/microchip/ksz9477.c    | 5 +++++
>>  drivers/net/dsa/mt7530.c               | 5 +++++
>>  drivers/net/dsa/mv88e6xxx/chip.c       | 5 +++++
>>  drivers/net/dsa/ocelot/felix.c         | 5 +++++
>>  drivers/net/dsa/qca8k.c                | 5 +++++
>>  drivers/net/dsa/sja1105/sja1105_main.c | 5 +++++
>>  include/net/dsa.h                      | 1 +
>>  net/dsa/switch.c                       | 4 ++--
>>  13 files changed, 54 insertions(+), 2 deletions(-)
