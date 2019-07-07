Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F68161723
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 21:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfGGTpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 15:45:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728619AbfGGTpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 15:45:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 767371527BB99;
        Sun,  7 Jul 2019 12:45:46 -0700 (PDT)
Date:   Sun, 07 Jul 2019 12:45:41 -0700 (PDT)
Message-Id: <20190707.124541.451040901050013496.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data
 paths
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 12:45:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun,  7 Jul 2019 10:58:17 +0300

> Users have several ways to debug the kernel and understand why a packet
> was dropped. For example, using "drop monitor" and "perf". Both
> utilities trace kfree_skb(), which is the function called when a packet
> is freed as part of a failure. The information provided by these tools
> is invaluable when trying to understand the cause of a packet loss.
> 
> In recent years, large portions of the kernel data path were offloaded
> to capable devices. Today, it is possible to perform L2 and L3
> forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
> Different TC classifiers and actions are also offloaded to capable
> devices, at both ingress and egress.
> 
> However, when the data path is offloaded it is not possible to achieve
> the same level of introspection as tools such "perf" and "drop monitor"
> become irrelevant.
> 
> This patchset aims to solve this by allowing users to monitor packets
> that the underlying device decided to drop along with relevant metadata
> such as the drop reason and ingress port.

We are now going to have 5 or so ways to capture packets passing through
the system, this is nonsense.

AF_PACKET, kfree_skb drop monitor, perf, XDP perf events, and now this
devlink thing.

This is insanity, too many ways to do the same thing and therefore the
worst possible user experience.

Pick _ONE_ method to trap packets and forward normal kfree_skb events,
XDP perf events, and these taps there too.

I mean really, think about it from the average user's perspective.  To
see all drops/pkts I have to attach a kfree_skb tracepoint, and not just
listen on devlink but configure a special tap thing beforehand and then
if someone is using XDP I gotta setup another perf event buffer capture
thing too.

Sorry, this isn't where we are going.
