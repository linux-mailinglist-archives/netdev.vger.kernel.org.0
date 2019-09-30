Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F485C1B68
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbfI3GYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:24:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:40260 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbfI3GY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 02:24:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 09334200AC;
        Mon, 30 Sep 2019 08:24:29 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lmDc1PnVeKsP; Mon, 30 Sep 2019 08:24:28 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8EA26200AA;
        Mon, 30 Sep 2019 08:24:28 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 08:24:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1448A31800B9;
 Mon, 30 Sep 2019 08:24:28 +0200 (CEST)
Date:   Mon, 30 Sep 2019 08:24:28 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH RFC 3/5] net: Add a netdev software feature set that
 defaults to off.
Message-ID: <20190930062427.GF2879@gauss3.secunet.de>
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
 <20190920044905.31759-4-steffen.klassert@secunet.com>
 <CA+FuTSdqc5Z1giGW3kCh3HXXe8N=g+cESEXZAZPMkPrO=ZWjxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSdqc5Z1giGW3kCh3HXXe8N=g+cESEXZAZPMkPrO=ZWjxA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 08:38:56AM -0400, Willem de Bruijn wrote:
> On Fri, Sep 20, 2019 at 12:49 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> > index b239507da2a0..34d050bb1ae6 100644
> > --- a/include/linux/netdev_features.h
> > +++ b/include/linux/netdev_features.h
> > @@ -230,6 +230,9 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
> >  /* changeable features with no special hardware requirements */
> >  #define NETIF_F_SOFT_FEATURES  (NETIF_F_GSO | NETIF_F_GRO)
> >
> > +/* Changeable features with no special hardware requirements that defaults to off. */
> > +#define NETIF_F_SOFT_FEATURES_OFF      NETIF_F_GRO_FRAGLIST
> > +
> 
> NETIF_F_GRO_FRAGLIST is not really a device feature, but a way to
> configure which form of UDP GRO to apply.

NETIF_F_GRO is also not really a device feature. It is a feature with
no special hardware requirements, as NETIF_F_GRO_FRAGLIST is.
Fraglist GRO is a special way to do GRO and should be configured in the
same way we configure standard GRO.

> 
> The UDP GRO benchmarks were largely positive, but not a strict win if
> I read Paolo's previous results correctly. Even if enabling to by
> default, it probably should come with a sysctl to disable for specific
> workloads.

Maybe we can just keep the default for the local input path
as is and enable GRO as this:

For standard UDP GRO on local input, do GRO only if a GRO enabled
socket is found.

If there is no local socket found and forwarding is enabled,
assume forwarding and do standard GRO.

If fraglist GRO is enabled, do it as default on local input and
forwarding because it is explicitly configured.

Would such a policy make semse?

> 
> If so, how about a ternary per-netns sysctl {off, on without gro-list,
> on with gro-list} instead of configuring through ethtool?

I'd not like to have a global knob to configure this.
On some devices it might make sense to enable fraglist
GRO, but on others not. Also it would be nice if we can
configure both vatiants with the same tool (ethtool).

