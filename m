Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE848EF3E
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 18:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243884AbiANRbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 12:31:36 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:38078 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbiANRbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 12:31:35 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A4D0721118;
        Fri, 14 Jan 2022 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642181494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=Qj2DWEG9FLtdZ5XGz/yaWFJhMf407qW9nDx+tLyuh/Q=;
        b=GP8r1PfNkwUtq73XRfk1vBsuEOEvTUaWi7qhsPjJ8U6q3FvXLE14UPU2VJNG1QF2oXPZbK
        xBPO+8ytJIrmDFgrWNIxHTs9cnLRqa9vniSQfcOnKCGiyp4NLjMxtYLJekvPVy6v8S5moo
        bvtRx/vSDiR+ljBYKqMAsl0NfTqKttY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642181494;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=Qj2DWEG9FLtdZ5XGz/yaWFJhMf407qW9nDx+tLyuh/Q=;
        b=Zz0S41fRJ9RavDDAhR/m1N0DsWd/m6PGcRMljQ7oozj4xksvb19FFxCvD5ugU2if+CWj2r
        FaFec9wPBrRHlkCQ==
Received: from localhost (dwarf.suse.cz [10.100.12.32])
        by relay2.suse.de (Postfix) with ESMTP id 13F68A3B84;
        Fri, 14 Jan 2022 17:31:34 +0000 (UTC)
Date:   Fri, 14 Jan 2022 18:31:33 +0100
From:   Jiri Bohac <jbohac@suse.cz>
To:     Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: xfrm regression: TCP MSS calculation broken by commit b515d263,
 results in TCP stall
Message-ID: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

our customer found that commit
b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm: xfrm_state_mtu
should return at least 1280 for ipv6") in v5.14 breaks the TCP
MSS calculation in ipsec transport mode, resulting complete
stalls of TCP connections. This happens when the (P)MTU is 1280
or slighly larger.

The desired formula for the MSS is:
	MSS = (MTU - ESP_overhead) - IP header - TCP header

However, the above patch clamps the (MTU - ESP_overhead) to a
minimum of 1280, turning the formula into
	MSS = max(MTU - ESP overhead, 1280) -  IP header - TCP header

With the (P)MTU near 1280, the calculated MSS is too large and
the resulting TCP packets never make it to the destination
because they are over the actual PMTU.

Trying to fix the exact same problem as the broken patch, which I
was unaware of, I sent an alternative patch in this thread of
April 2021:
https://lore.kernel.org/netdev/20210429170254.5grfgsz2hgy2qjhk@dwarf.suse.cz/
(note the v1 is broken and followed by v2!)

In that thread I also found other problems with
b515d2637276a3810d6595e10ab02c13bfd0b63a - in tunnel mode it
causes suboptimal double fragmentation:
https://lore.kernel.org/netdev/20210429202529.codhwpc7w6kbudug@dwarf.suse.cz/

I therefore propose to revert
b515d2637276a3810d6595e10ab02c13bfd0b63a and
apply the v2 version of my patch, which I'll re-send in reply to
this e-mail.

Thanks,

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

