Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72876473433
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhLMSkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhLMSkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 13:40:10 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1881EC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 10:40:10 -0800 (PST)
Received: from p200300c1f70a1f63817a36c2e13ff2bb.dip0.t-ipconnect.de ([2003:c1:f70a:1f63:817a:36c2:e13f:f2bb] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mwqF4-00069x-8j; Mon, 13 Dec 2021 19:40:06 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
In-Reply-To: <20211213121045.GA14042@hoboy.vegasvil.org>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
 <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211211153926.GA3357@hoboy.vegasvil.org>
 <20211213121045.GA14042@hoboy.vegasvil.org>
Date:   Mon, 13 Dec 2021 19:40:04 +0100
Message-ID: <87a6h4xsaj.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1639420810;3790b2e9;
X-HE-SMSGID: 1mwqF4-00069x-8j
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon Dec 13 2021, Richard Cochran wrote:
> On Sat, Dec 11, 2021 at 07:39:26AM -0800, Richard Cochran wrote:
>> On Fri, Dec 10, 2021 at 09:14:10PM -0800, Jakub Kicinski wrote:
>> > On Fri, 10 Dec 2021 01:07:59 +0100 Tobias Waldekranz wrote:
>> > > Do we know how PTP is supposed to work in relation to things like STP?
>> > > I.e should you be able to run PTP over a link that is currently in
>> > > blocking?
>> > 
>> > Not sure if I'm missing the real question but IIRC the standard
>> > calls out that PTP clock distribution tree can be different that
>> > the STP tree, ergo PTP ignores STP forwarding state.
>> 
>> That is correct.  The PTP will form its own spanning tree, and that
>> might be different than the STP.  In fact, the Layer2 PTP messages
>> have special MAC addresses that are supposed to be sent
>> unconditionally, even over blocked ports.
>
> Let me correct that statement.
>
> I looked at 1588 again, and for E2E TC it states, "All PTP version 2
> messages shall be forwarded according to the addressing rules of the
> network."  I suppose that includes the STP state.
>
> For P2P TC, there is an exception that the peer delay messages are not
> forwarded.  These are generated and consumed by the switch.
>
> The PTP spanning tree still is formed by the Boundary Clocks (BC), and
> a Transparent Clock (TC) does not participate in forming the PTP
> spanning tree.
>
> What does this mean for Linux DSA switch drivers?
>
> 1. All incoming PTP frames should be forwarded to the CPU port, so
>    that the software stack may perform its BC or TC functions.
>
> 2. When used as a BC, the PTP frames sent from the CPU port should not
>    be dropped.
>
> 3. When used as a TC, PTP frames sent from the CPU port can be dropped
>    on blocked external ports, except for the Peer Delay messages.

Maybe I'm missing something, but how is #2 and #3 supposed to work with
DSA? The switch driver doesn't know whether the user wants to run BC or
TC. For #2 the STP state is ignored, for #3 it is not except for peer
delay measurements.

Thanks,
Kurt
