Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4552B606901
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 21:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJTThV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 15:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJTThT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 15:37:19 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8E31BF224;
        Thu, 20 Oct 2022 12:37:18 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 6A2B11884C9D;
        Thu, 20 Oct 2022 19:37:17 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 4A5F225001FA;
        Thu, 20 Oct 2022 19:37:17 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 4377E9EC0002; Thu, 20 Oct 2022 19:37:17 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 20 Oct 2022 21:37:17 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 01/12] net: bridge: add locked entry fdb flag
 to extend locked port feature
In-Reply-To: <Y1FE6WFnsH8hcFY2@shredder>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-2-netdev@kapio-technology.com>
 <Y1FE6WFnsH8hcFY2@shredder>
User-Agent: Gigahost Webmail
Message-ID: <1c71e62ee5d6c0a7fc54d3e666aca619@kapio-technology.com>
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

On 2022-10-20 14:54, Ido Schimmel wrote:
> On Tue, Oct 18, 2022 at 06:56:08PM +0200, Hans J. Schultz wrote:
>> Add an intermediate state for clients behind a locked port to allow 
>> for
>> possible opening of the port for said clients. The clients mac address
>> will be added with the locked flag set, denying access through the 
>> port
> 
> The entry itself is not denying the access through the port, but
> rather the fact that the port is locked and there is no matching FDB
> entry.
> 
>> for the mac address, but also creating a new FDB add event giving
>> userspace daemons the ability to unlock the mac address. This feature
>> corresponds to the Mac-Auth and MAC Authentication Bypass (MAB) named
>> features. The latter defined by Cisco.
> 
> Worth mentioning that the feature is enabled via the 'mab' bridge port
> option (BR_PORT_MAB).
> 
>> 
>> Only the kernel can set this FDB entry flag, while userspace can read
>> the flag and remove it by replacing or deleting the FDB entry.
>> 
>> Locked entries will age out with the set bridge ageing time.
>> 
>> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> 
> Overall looks OK to me. See one comment below.
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> 
> [...]
> 
>> @@ -1178,6 +1192,14 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr 
>> *tb[],
>>  		vg = nbp_vlan_group(p);
>>  	}
>> 
>> +	if (tb[NDA_FLAGS_EXT])
>> +		ext_flags = nla_get_u32(tb[NDA_FLAGS_EXT]);
>> +
>> +	if (ext_flags & NTF_EXT_LOCKED) {
>> +		pr_info("bridge: RTM_NEWNEIGH has invalid extended flags\n");
> 
> I understand this function makes use of pr_info(), but it already gets
> extack and it's a matter of time until the pr_info() instances will be
> converted to extack. I would just use extack here like you are doing in
> the next patch.
> 
> Also, I find this message more helpful:
> 
> "Cannot add FDB entry with \"locked\" flag set"
> 

Okay, since Jakub says that this patch set must be resent, the question 
remains
to me if I shall make these changes and resend the patch set as v8?

