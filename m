Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6748473464
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbhLMSy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbhLMSy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 13:54:59 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F44BC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 10:54:59 -0800 (PST)
Received: from p200300c1f70a1f63817a36c2e13ff2bb.dip0.t-ipconnect.de ([2003:c1:f70a:1f63:817a:36c2:e13f:f2bb] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mwqTQ-0003vo-Iz; Mon, 13 Dec 2021 19:54:56 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
In-Reply-To: <87r1ai21ac.fsf@waldekranz.com>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com> <87y24s9x5c.fsf@kmk-computers.de>
 <87r1ai21ac.fsf@waldekranz.com>
Date:   Mon, 13 Dec 2021 19:54:55 +0100
Message-ID: <877dc8xrls.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1639421699;8dcdab7c;
X-HE-SMSGID: 1mwqTQ-0003vo-Iz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun Dec 12 2021, Tobias Waldekranz wrote:
>> Agreed. Some mechanism is required. Any idea how to implement it? In
>> case of PTP the management/policy entries should take precedence.
>
> One approach would be to create a cache containing all static ATU
> entries. That way we can easily track the owner of each entry. There are
> also major performance advantages of being able to update memberships of
> group entries without having to read the entry back from the ATU
> first. This is especially important once we start handling router ports
> correctly, in which case you have to update all active entries on every
> add/remove.
>
> Before going down that route though, I would suggest getting some
> initial feedback from Andrew.
>
> A complicating factor, no matter the implementation, is the relationship
> between the bridge MDB and all other consumers of ATU entries. As an
> example: If the driver first receives an MDB add for one of the L3 PTP
> groups, and then a user starts up ptp4l, the driver can't then go back
> to the bridge and say "remember that group entry that I said I loaded,
> well I have removed it now". So whatever implementation we choose, I
> think it needs to keep a shadow entry for the MDB that can be
> re-inserted if the corresponding management or policy entry is removed.
>
> You may simply want to allow all consumers to register any given group
> with the cache. The cache would then internally elect the "best" entry
> and install that to the ATU. Sort of what zebra/quagga/FRR does for
> dynamic routing. The priority would probably be something like:
>
> 1. Management entry
> 2. Policy entry
> 3. MDB entry
>
> This should still result in the proper forwarding of a registered groups
> that are shadowed by management or policy entries. The bridge would know
> (via skb->offload_fwd_mark) that the packet had not been forwarded in
> hardware and would fallback to software forwarding. If the policy entry
> was later removed (e.g. PTP was shut down) the MDB entry could be
> reinstalled and offloading resumed.

Thanks. This approach makes sense and should solve the problem at hand.

Thanks,
Kurt
