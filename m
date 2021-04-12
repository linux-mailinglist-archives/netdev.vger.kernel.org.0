Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AD235D431
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbhDLXzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:55:11 -0400
Received: from mail.nic.cz ([217.31.204.67]:58582 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237250AbhDLXzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 19:55:10 -0400
Received: from thinkpad (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 949C0140655;
        Tue, 13 Apr 2021 01:54:50 +0200 (CEST)
Date:   Tue, 13 Apr 2021 01:54:50 +0200
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
Message-ID: <20210413015450.1ae597da@thinkpad>
In-Reply-To: <87o8ejjdu6.fsf@waldekranz.com>
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

On Tue, 13 Apr 2021 01:13:53 +0200
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> > ...you could get the isolation in place. But you will still lookup the
> > DA in the ATU, and there you will find a destination of either cpu0 or
> > cpu1. So for one of the ports, the destination will be outside of its
> > port based VLAN. Once the vectors are ANDed together, it is left with no
> > valid port to egress through, and the packet is dropped.
> >  
> >> Am I wrong? I confess that I did not understand this into the most fine
> >> details, so it is entirely possible that I am missing something
> >> important and am completely wrong. Maybe this cannot be done.  
> >
> > I really doubt that it can be done. Not in any robust way at
> > least. Happy to be proven wrong though! :)  
> 
> I think I figured out why it "works" for you. Since the CPU address is
> never added to the ATU, traffic for it is treated as unknown. Thanks to
> that, it flooded and the isolation brings it together. As soon as
> mv88e6xxx starts making use of Vladimirs offloading of host addresses
> though, I suspect this will fall apart.

Hmm :( This is bad news. I would really like to make it balance via
input ports. The LAG balancing for this usecase is simply unacceptable,
since the switch puts so little information into the hash function.

I will look into this, maybe ask some follow-up questions.

Marek
