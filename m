Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE812EED60
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 07:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbhAHGRg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Jan 2021 01:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbhAHGRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 01:17:36 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D66C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 22:16:55 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kxl4v-0007XH-QZ; Fri, 08 Jan 2021 07:16:53 +0100
Date:   Fri, 8 Jan 2021 07:16:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Ben Greear <greearb@candelatech.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: 5.10.4+ hang with 'rmmod nf_conntrack'
Message-ID: <20210108061653.GB19605@breakpoint.cc>
References: <41dbfc93-0d57-6d78-f6fa-529dd5e0685c@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <41dbfc93-0d57-6d78-f6fa-529dd5e0685c@candelatech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ben Greear <greearb@candelatech.com> wrote:
> I noticed my system has a hung process trying to 'rmmod nf_conntrack'.
> 
> I've generally been doing the script that calls rmmod forever,
> but only extensively tested on 5.4 kernel and earlier.
> 
> If anyone has any ideas, please let me know.  This is from 'sysrq t'.  I don't see
> any hung-task splats in dmesg.

rmmod on conntrack loops forever until the active conntrack object count reaches 0.
(plus a walk of the conntrack table to evict/put all entries).

> I'll see if it is reproducible and if so will try
> with lockdep enabled...

No idea, there was a regression in 5.6, but that was fixed by the time
5.7 was released.

Can't reproduce hangs with a script that injects a few dummy entries
and then removes the module:

added=0

add_and_rmmod()
{
        while [ $added -lt 1000 ]; do
                conntrack -I -s $(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%255+1)) \
                        -d $(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%255+1)) \
                         --protonum 6 --timeout $(((RANDOM%120) + 240)) --state ESTABLISHED --sport $RANDOM --dport $RANDOM 2> /dev/null || break

                added=$((added + 1))
                if [ $((added % 1000)) -eq 0 ];then
                        echo $added
                fi
        done

        echo rmmod after adding $added entries
        conntrack -C
        rmmod nf_conntrack_netlink
        rmmod nf_conntrack
}

add_and_rmmod

I don't see how it would make a difference, but do you have any special conntrack features enabled
at run time, e.g. reliable netlink events? (If you don't know what I mean the answer is no).
