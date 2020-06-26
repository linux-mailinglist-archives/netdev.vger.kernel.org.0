Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBBE20AE69
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 10:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgFZI1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 04:27:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48109 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725355AbgFZI1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 04:27:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593160043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+SoC1A8xJyoko0NAUju81LiiMymvENrGGCdhnwcV3UY=;
        b=HIV3XzQjighTykESRBjAyh6KsyHTciZ5DCLRow5La0uMMKDnXJ8gk7pNfWapFKRlbUneBM
        nxmOYk72O3ziFgirNa0auYsFTY/03/JcIg+XwbDMiAlwlo6gAXlBu3boF7Mzmu+cwsTzw6
        AjF3qp0Ak6773aP4R9uPxuUCDfuzVR8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-mGDtYEWePhO8fpEjOJrYag-1; Fri, 26 Jun 2020 04:27:16 -0400
X-MC-Unique: mGDtYEWePhO8fpEjOJrYag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EE8C107ACCD;
        Fri, 26 Jun 2020 08:27:15 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.194.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 168595C66E;
        Fri, 26 Jun 2020 08:27:09 +0000 (UTC)
Message-ID: <240fc14da96a6212a98dd9ef43b4777a9f28f250.camel@redhat.com>
Subject: Re: [PATCH net-next 1/5] sch_cake: fix IP protocol handling in the
 presence of VLAN tags
From:   Davide Caratti <dcaratti@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
In-Reply-To: <87k0zuj50u.fsf@toke.dk>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
         <159308610390.190211.17831843954243284203.stgit@toke.dk>
         <20200625.122945.321093402617646704.davem@davemloft.net>
         <87k0zuj50u.fsf@toke.dk>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 26 Jun 2020 10:27:08 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

my 2 cents:

On Thu, 2020-06-25 at 21:53 +0200, Toke Høiland-Jørgensen wrote:
> I think it depends a little on the use case; some callers actually care
> about the VLAN tags themselves and handle that specially (e.g.,
> act_csum).

I remember taht something similar was discussed about 1 year ago [1].

> Whereas others (e.g., sch_dsmark) probably will have the same
> issue.

I'd say that the issue "propagates" to all qdiscs that mangle the ECN-CE
bit (i.e., calling INET_ECN_set_ce() [2]), most notably all the RED
variants and "codel/fq_codel".

>  I guess I can trying going through them all and figuring out if
> there's a more generic solution.

For sch_cake, I think that the qdisc shouldn't look at the IP header when
it schedules packets having a VLAN tag.

Probably, when tc_skb_protocol() returns ETH_P_8021Q or ETH_P_8021AD, we
should look at the VLAN priority (PCP) bits (and that's something that
cake doesn't do currently - but I have a small patch in my stash that
implements this: please let me know if you are interested in seeing it :)
).

Then, to ensure that the IP precedence is respected, even with different
VLAN tags, users should explicitly configure TC filters that "map" the
DSCP value to a PCP value. This would ensure that configured priority is
respected by the scheduler, and would also be flexible enough to allow
different "mappings". 

Sure, my proposal does not cover the problem of mangling the CE bit inside
VLAN-tagged packets, i.e. if we should understand if qdiscs should allow
it or not.

WDYT?

thank you in advance!
-- 
davide


[1] https://lore.kernel.org/netdev/CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com/#t
[2] https://elixir.bootlin.com/linux/latest/C/ident/INET_ECN_set_ce

