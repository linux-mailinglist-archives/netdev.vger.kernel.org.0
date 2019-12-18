Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6004012565F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfLRWPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:15:54 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40975 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726387AbfLRWPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 17:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576707353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ry0uO4z02XV4Mg4vpRNKbqQw/wv0jL3YJhnaQ70q0jY=;
        b=YWpCAb4AwK0TXg0EUD6bhhLZDplOliXQrd5Al01G8IGWRaPuC6wpFrV9M8ic8YOhJ6d4Fu
        7rnh8+Em87Yd0HyPfsozVK6D/SMPZBjrxMbDwFLBhH6FhtEqVw6A+qm3nxaP2i2s6E6xFF
        bSv+PdweMJP9F2Pcjp0a2zXZZJZM98s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-WwRtCOtTP5yI2xyInQFSDQ-1; Wed, 18 Dec 2019 17:15:50 -0500
X-MC-Unique: WwRtCOtTP5yI2xyInQFSDQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 166F6107ACC5;
        Wed, 18 Dec 2019 22:15:49 +0000 (UTC)
Received: from ovpn-116-48.ams2.redhat.com (ovpn-116-48.ams2.redhat.com [10.36.116.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4FA960C05;
        Wed, 18 Dec 2019 22:15:47 +0000 (UTC)
Message-ID: <5e6ae66a8adea061388919fe0ce5b766feab4c31.camel@redhat.com>
Subject: Re: [MPTCP] Re: [PATCH net-next v3 07/11] tcp: Prevent
 coalesce/collapse when skb has MPTCP extensions
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Wed, 18 Dec 2019 23:15:46 +0100
In-Reply-To: <20191218.124510.1971632024371398726.davem@davemloft.net>
References: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com>
         <20191217203807.12579-8-mathew.j.martineau@linux.intel.com>
         <5fc0d4bd-5172-298d-6bbb-00f75c7c0dc9@gmail.com>
         <20191218.124510.1971632024371398726.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-12-18 at 12:45 -0800, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 18 Dec 2019 11:50:24 -0800
> 
> > On 12/17/19 12:38 PM, Mat Martineau wrote:
> >> The MPTCP extension data needs to be preserved as it passes through the
> >> TCP stack. Make sure that these skbs are not appended to others during
> >> coalesce or collapse, so the data remains associated with the payload of
> >> the given skb.
> > 
> > This seems a very pessimistic change to me.
> > 
> > Are you planing later to refine this limitation ?
> > 
> > Surely if a sender sends TSO packet, we allow all the segments
> > being aggregated at receive side either by GRO or TCP coalescing.
> 
> This turns off absolutely crucial functional elements of our TCP
> stack, and will avoid all of the machinery that avoids wastage in TCP
> packets sitting in the various queues.  skb->truesize management, etc.

Thank you for the feedback!

Just to clarify, with the code we have currently posted TSO trains of
MPTCP packets can be aggregated by the GRO engine almost exactly as
currently happens for plain TCP packets.

We still have chances to aggregate packets belonging to a MPTCP stream,
as not all of them carry a DSS option.

We opted to not coalesce at the TCP level for the moment to avoid
adding additional hook code inside the coalescing code.

If you are ok without such hooks in the initial version, we can handle
MPTCP coalescing, too. The real work will likely land in part 2.

Would that fit you?

Thanks,

Paolo

