Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C957935F76C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350404AbhDNPPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:15:04 -0400
Received: from mail.nic.cz ([217.31.204.67]:46284 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350114AbhDNPPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:15:03 -0400
Received: from thinkpad (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id C5E55140AF8;
        Wed, 14 Apr 2021 17:14:40 +0200 (CEST)
Date:   Wed, 14 Apr 2021 17:14:39 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Message-ID: <20210414171439.1a2e7c1a@thinkpad>
In-Reply-To: <87fszujbif.fsf@waldekranz.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
        <20210411200135.35fb5985@thinkpad>
        <20210411185017.3xf7kxzzq2vefpwu@skbuf>
        <878s5nllgs.fsf@waldekranz.com>
        <20210412213045.4277a598@thinkpad>
        <8735vvkxju.fsf@waldekranz.com>
        <20210412235054.73754df9@thinkpad>
        <87wnt7jgzk.fsf@waldekranz.com>
        <20210413005518.2f9b9cef@thinkpad>
        <87r1jfje26.fsf@waldekranz.com>
        <87o8ejjdu6.fsf@waldekranz.com>
        <20210413015450.1ae597da@thinkpad>
        <20210413022730.2a51c083@thinkpad>
        <87im4qjl87.fsf@waldekranz.com>
        <20210413171443.1b2b2f88@thinkpad>
        <87fszujbif.fsf@waldekranz.com>
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

On Tue, 13 Apr 2021 20:16:24 +0200
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> You could imagine a different mode in which the DSA driver would receive
> the bucket allocation from the bond/team driver (which in turn could
> come all the way from userspace). Userspace could then implement
> whatever strategy it wants to maximize utilization, though still bound
> by the limitations of the hardware in terms of fields considered during
> hashing of course.

The problem is that even with the ability to change the bucket
configuration however we want it still can happen with non-trivial
probability that all (src,dst) pairs on the network will hash to one
bucket.

The probability of that happening is 1/(8^(n-1)) for n (src,dst) pairs.

On Turris Omnia the most common configuration is that the switch ports
are bridged.

If the user plugs only two devices into the lan ports, one would expect
that both devices could utilize 1 gbps each. In this case there is
1/8 probability that both devices would hash to the same bucket. It is
quite bad if multi-CPU upload won't work for 12.5% of our customers that
are using our device in this way.

So if there is some reasonable solution how to implement multi-CPU via
the port vlan mask, I will try to pursue this.

Marek
