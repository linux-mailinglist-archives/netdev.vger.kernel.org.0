Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A7250DE08
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbiDYKkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238896AbiDYKkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:40:03 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5932917E12;
        Mon, 25 Apr 2022 03:36:59 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id B5551FF813;
        Mon, 25 Apr 2022 10:36:55 +0000 (UTC)
Message-ID: <590d44a1-ca27-c171-de87-fe57fc07dff5@ovn.org>
Date:   Mon, 25 Apr 2022 12:36:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>, i.maximets@ovn.org,
        Antti Antinoja <antti@fennosys.fi>
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>,
        Mark Mielke <mark.mielke@gmail.com>
References: <20220409094036.20051-1-mark.mielke@gmail.com>
 <YlL6uN9WDPtFri0p@strlen.de>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH] openvswitch: Ensure nf_ct_put is not called
 with null pointer
In-Reply-To: <YlL6uN9WDPtFri0p@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/22 17:41, Florian Westphal wrote:
> Mark Mielke <mark.mielke@gmail.com> wrote:
>> A recent commit replaced calls to nf_conntrack_put() with calls
>> to nf_ct_put(). nf_conntrack_put() permitted the caller to pass
>> null without side effects, while nf_ct_put() performs WARN_ON()
>> and proceeds to try and de-reference the pointer. ovs-vswitchd
>> triggers the warning on startup:
>>
>> [   22.178881] WARNING: CPU: 69 PID: 2157 at include/net/netfilter/nf_conntrack.h:176 __ovs_ct_lookup+0x4e2/0x6a0 [openvswitch]
>> ...
>> [   22.213573] Call Trace:
>> [   22.214318]  <TASK>
>> [   22.215064]  ovs_ct_execute+0x49c/0x7f0 [openvswitch]
>> ...
>> Cc: stable@vger.kernel.org
>> Fixes: 408bdcfce8df ("net: prefer nf_ct_put instead of nf_conntrack_put")
> 
> Actually, no.  As Pablo Neira just pointed out to me Upstream kernel is fine.
> The preceeding commit made nf_ct_out() a noop when ct is NULL.

Hi, Florian.

There is a problem on 5.15 longterm tree where the offending commit
got backported, but the previous one was not, so it triggers an issue
while loading the openvswitch module.

To be more clear, v5.15.35 contains the following commit:
  408bdcfce8df ("net: prefer nf_ct_put instead of nf_conntrack_put")
backported as commit 72dd9e61fa319bc44020c2d365275fc8f6799bff, but
it doesn't have the previous one:
  6ae7989c9af0 ("netfilter: conntrack: avoid useless indirection during conntrack destruction")
that adds the NULL pointer check to the nf_ct_put().

Either 6ae7989c9af0 should be backported to 5.15 or 72dd9e61fa31
reverted on that tree.

Best regards, Ilya Maximets.
