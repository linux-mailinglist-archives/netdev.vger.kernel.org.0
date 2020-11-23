Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EF42C09ED
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388612AbgKWNOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:14:10 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:48980 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388560AbgKWNOI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:14:08 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A375220322;
        Mon, 23 Nov 2020 14:14:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qLtENAe0kUkg; Mon, 23 Nov 2020 14:14:01 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B4C6D2018D;
        Mon, 23 Nov 2020 14:14:01 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 23 Nov 2020 14:14:01 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 23 Nov
 2020 14:14:01 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A67D431844A2;
 Mon, 23 Nov 2020 13:37:45 +0100 (CET)
Date:   Mon, 23 Nov 2020 13:37:45 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nic Dade <nic.dade@gmail.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: ESN, seqhi and out-of-order calls to advance()
Message-ID: <20201123123745.GH15658@gauss3.secunet.de>
References: <CANDJvww=BakOTKahtEqNxg7K2TYRuan=_jZg4e=rSdXa8xwAXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANDJvww=BakOTKahtEqNxg7K2TYRuan=_jZg4e=rSdXa8xwAXw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've Cced netdev, maybe other people have an opinion on this too.

On Thu, Nov 19, 2020 at 01:39:29PM -0800, Nic Dade wrote:
> I've been investigating a problem which happens when I use IPsec
> (strongswan in userspace), ESN, the default anti-replay window (32
> seqnums), on a multi-core CPU. The small window size isn't necessary, it
> just makes it easier to reproduce.

Using the same SA on multiple cores has synchronization problems anyway.
We curently try to solve that on the protocol level:

https://datatracker.ietf.org/doc/html/draft-pwouters-multi-sa-performance

> 
> It looks like it's the same problem which was found and patched in commit
> 3b59df46a4, but that commit only applies to async case, and doesn't quite
> solve the problem when it is the CPU cores which are causing it.
> 
> The trouble is that xfrm_replay_seqhi() is called twice for each packet,
> once to decide what seqhi value to use for authentication, and a second
> time to decide what seq num to advance to for anti-replay. Sometimes they
> are not the same value.
> 
> Here's what happens to cause this: two packets belonging to the same ESP SA
> are being received, and the packet's seqnums are > window apart. The
> packets pass through xfrm_input() which does the 1st call to
> xfrm_replay_seqhi(). Once the packet and seqhi have been authenticated,
> x->repl->advance() == xfrm_replay_advance_esn() is called. If the higher
> seqnum packet gets to advance() first, then it moves the auti-replay window
> forward. Then when the second packet arrives at advance(), the call
> xfrm_replay_advance_esn() makes to xfrm_replay_seqhi() thinks the seqnum <
> bottom means 32-bit seqnums wrapped, and it returns seqhi+1.
> xfrm_replay_advance_esn() stores that away in the xfrm_replay_state_esn for
> the future. From now until the ESP SA renews, or the sender gets to the
> point where seqhi really did increment, all packets will fail
> authentication.

Well analyzed! Yes, that can happen if the packets are processed on
different cpus.

> 
> This is b/c the seqhi which was authenticated != the seqhi which advance()
> believed to be correct.
> 
> I think it would be safer if the authenticated seqhi computed in
> xfrm_input() was passed to the advance() function as an argument, rather
> than having advance() recompute seqhi. That would also fix the async case.
> Or the non-async case also needs to recheck.

Right, using the authenticated seqhi in the advance() function makes
sense. We can do away the recheck() if that fixes the problem entirely.
But I did not look into this problem for some years, so not absolutely
sure if that is sufficient.


> 
> Also it seems to be that calling xfrm_replay_seqhi() while not holding
> x->lock (as xfrm_input() does) is not safe, since both x->seq_hi and x->seq
> are used by xfrm_replay_seqhi(), and that can race with the updates to seq
> and seq_hi in xfrm_replay_advance_esn()

True, indeed.

> ----------------------------------------------------------
> 
> Note I still have some mysteries. I do know for sure (from instrumenting
> the code and reproducing) that the 2nd call to xfrm_replay_seqhi() does
> result in a different answer than the 1st call, and that this happens when
> the packets are processed simultaneously and out of order as described
> above. My mystery is that my instrumentation also indicates it's the same
> CPU core (by smp_processor_id()) processing the two packets, which I cannot
> explain.

That is odd. Should not happen if the packets are processed on the same cpu 
with a sync cipher.

