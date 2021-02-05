Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70AA311042
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhBERDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:03:36 -0500
Received: from mail.thelounge.net ([91.118.73.15]:34701 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbhBERBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 12:01:13 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4DXJ714tklzXRM;
        Fri,  5 Feb 2021 15:42:53 +0100 (CET)
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
References: <20210205001727.2125-1-pablo@netfilter.org>
 <20210205001727.2125-2-pablo@netfilter.org>
 <69957353-7fe0-9faa-4ddd-1ac44d5386a5@thelounge.net>
 <alpine.DEB.2.23.453.2102051448220.10405@blackhole.kfki.hu>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update
 deleted entry
Message-ID: <a51d867a-3ca9-fd36-528a-353aa6c42f42@thelounge.net>
Date:   Fri, 5 Feb 2021 15:42:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.23.453.2102051448220.10405@blackhole.kfki.hu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 05.02.21 um 14:54 schrieb Jozsef Kadlecsik:
> Hi Harald,
> 
> On Fri, 5 Feb 2021, Reindl Harald wrote:
> 
>> "Reap only entries which won't be updated" sounds for me like the could
>> be some optimization: i mean when you first update and then check what
>> can be reaped the recently updated entry would not match to begin with
> 
> When the entry is new and the given recent table is full we cannot update
> (add) it, unless old entries are deleted (reaped) first. So it'd require
> more additional checkings to be introduced to reverse the order of the two
> operations.
well, the most important thing is that the firewall-vm stops to 
kernel-panic, built that beast in autumn 2018 and until april 2019 i 
went trough hell with random crashes all the time (connlimit regression, 
driver issues, vmware issues and that one where i removed --reap on the 
most called one with some other changes when it crashed 5 or 10 times a 
day and then 3 days not at all so never figured out what was the gamechanger

on the other hand if you can't reap old entries because everything is 
fresh (real DDOS) you can't update / add it anyways

what makes me thinking about the ones without --reap - how is it 
handeled in that case, i mean there must be some LRU logic present 
anyways given that --reap is not enabled by default (otherwise that bug 
would not have hitted me so long randomly)

my first xt_recent-rule on top don't have --reap by intention because 
it's the DDOS stuff with total connections to any machine per two 
seconds, my guess what that --reap don't come for free and the 
roudnabout 200 MB RAM overhead is OK, for the other 12 not hitting that 
much the VM would consume 1.5 GB RAM after a few days instead 240 MB - 
but they where obviosuly the trigger for random crashes

how does that one work after "it's full" to track recent attackers 
instead just consume memory and no longer work properly?
