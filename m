Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1122E4E5D02
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 03:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345751AbiCXCC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 22:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiCXCC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 22:02:26 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58A9192D1F;
        Wed, 23 Mar 2022 19:00:54 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:58346.284100465
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.171 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 4BD332800AD;
        Thu, 24 Mar 2022 10:00:46 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 2371bf2f1af44226acb5ba158fb5e1b9 for jay.vosburgh@canonical.com;
        Thu, 24 Mar 2022 10:00:52 CST
X-Transaction-ID: 2371bf2f1af44226acb5ba158fb5e1b9
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <76345dc2-90e0-5464-96f0-c1f62b645af2@chinatelecom.cn>
Date:   Thu, 24 Mar 2022 10:00:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v6 0/4] Add support for IPV6 RLB to balance-alb mode
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <20220323120906.42692-1-sunshouxin@chinatelecom.cn>
 <7288faa9-0bb1-4538-606d-3366a7a02da5@kernel.org>
 <20220323083332.54dc0a6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4913.1648053525@famine>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <4913.1648053525@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/24 0:38, Jay Vosburgh 写道:
> Jakub Kicinski <kuba@kernel.org> wrote:
>
>> On Wed, 23 Mar 2022 08:35:03 -0600 David Ahern wrote:
>>> On 3/23/22 6:09 AM, Sun Shouxin wrote:
>>>> This patch is implementing IPV6 RLB for balance-alb mode.
>>> net-next is closed, so this set needs to be delayed until it re-opens.
>> What I'm not sure of is why this gets reposted after Jiri nacked
>> it. A conclusion needs to be reached on whether we want this
>> functionality in the first place. Or someone needs to explain
>> to me what the conclusion is if I'm not reading the room right :)
> 	The summary (from my perspective) is that the alb/rlb technology
> more or less predates LACP, and is a complicated method to implement
> load balancing across a set of local network peers.  The existing
> implementation for IPv4 uses per-peer tailored ARP messages to "assign"
> particular peers on the subnet to particular bonding interfaces.  I do
> encounter users employing the alb/rlb mode, but it is uncommon; LACP is
> by far the most common mode that I see, with active-backup a distant
> second.
>
> 	The only real advantage alb/rlb has over LACP is that the
> balance is done via traffic monitoring (i.e., assigning new peers to the
> least busy bond interface, with periodic rebalances) instead of a hash
> as with LACP.  In principle, some traffic patterns may end up with hash
> collisions on LACP, but will be more evenly balanced via the alb/rlb
> logic (but this hasn't been mentioned by the submitter that I recall).
> The alb/rlb logic also balances all traffic that will transit through a
> given router together (because it works via magic ARPs), so the scope of
> its utility is limited.
>
> 	As much as I'm all in favor of IPv6 being a first class citizen,
> I haven't seen a compelling use case or significant advantage over LACP
> stated for alb/rlb over IPv6 that justifies the complexity of the
> implementation that will need to be maintained going forward.
>
> 	-J


Our current online environment has been deployed with mode6, except that 
we have been running ipv4 services before.
Recently, we launched ipv6 service and found that there was no load 
sharing on the receiving direction of the bond interface,
which led to wasted bandwidth on the receiving direction.

We developed this feature to solve this problem.

I'm sure many people face the same problem of not being able to change 
the environment they are already running in.
It may be true that lacp is better than alb, but we also need to 
maintain for the business that is already running.


> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
