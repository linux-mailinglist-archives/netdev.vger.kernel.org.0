Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35F935B674
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 20:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhDKSBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 14:01:55 -0400
Received: from mail.nic.cz ([217.31.204.67]:39192 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235284AbhDKSBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 14:01:54 -0400
Received: from thinkpad (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 7D44C140679;
        Sun, 11 Apr 2021 20:01:36 +0200 (CEST)
Date:   Sun, 11 Apr 2021 20:01:35 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20210411200135.35fb5985@thinkpad>
In-Reply-To: <20210410133454.4768-1-ansuelsmth@gmail.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Apr 2021 15:34:46 +0200
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> Hi,
> this is a respin of the Marek series in hope that this time we can
> finally make some progress with dsa supporting multi-cpu port.
> 
> This implementation is similar to the Marek series but with some tweaks.
> This adds support for multiple-cpu port but leave the driver the
> decision of the type of logic to use about assigning a CPU port to the
> various port. The driver can also provide no preference and the CPU port
> is decided using a round-robin way.

In the last couple of months I have been giving some thought to this
problem, and came up with one important thing: if there are multiple
upstream ports, it would make a lot of sense to dynamically reallocate
them to each user port, based on which user port is actually used, and
at what speed.

For example on Turris Omnia we have 2 CPU ports and 5 user ports. All
ports support at most 1 Gbps. Round-robin would assign:
  CPU port 0 - Port 0
  CPU port 1 - Port 1
  CPU port 0 - Port 2
  CPU port 1 - Port 3
  CPU port 0 - Port 4

Now suppose that the user plugs ethernet cables only into ports 0 and 2,
with 1, 3 and 4 free:
  CPU port 0 - Port 0 (plugged)
  CPU port 1 - Port 1 (free)
  CPU port 0 - Port 2 (plugged)
  CPU port 1 - Port 3 (free)
  CPU port 0 - Port 4 (free)

We end up in a situation where ports 0 and 2 share 1 Gbps bandwidth to
CPU, and the second CPU port is not used at all.

A mechanism for automatic reassignment of CPU ports would be ideal here.

What do you guys think?

Marek
