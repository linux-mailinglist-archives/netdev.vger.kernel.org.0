Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42CE5B7817
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388754AbfISLB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:01:28 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:55996 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387931AbfISLB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 07:01:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6459D205CD;
        Thu, 19 Sep 2019 13:01:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dpsuucX7imKx; Thu, 19 Sep 2019 13:01:26 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 004152054D;
        Thu, 19 Sep 2019 13:01:26 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 13:01:24 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 9FBAC318022F;
 Thu, 19 Sep 2019 13:01:25 +0200 (CEST)
Date:   Thu, 19 Sep 2019 13:01:25 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
Message-ID: <20190919110125.GN2879@gauss3.secunet.de>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
 <20190918165817.GA3431@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190918165817.GA3431@localhost.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 01:58:17PM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Sep 18, 2019 at 12:17:08PM -0400, Willem de Bruijn wrote:
> > 
> > More specifically, whether we can remove that in favor of using your
> > new skb_segment_list. That would actually be a big first step in
> > simplifying skb_segment back to something manageable.
> 
> The main issue (that I know) on obsoleting GSO_BY_FRAGS is that
> dealing with frags instead of frag_list was considered easier to be
> offloaded, if ever attempted.  So this would be a step back on that
> aspect.  Other than this, it should be doable.

I wonder why offloading the frag_list should be harder.
I looked at the i40e driver, it just iterates over the page
fragments found in skb_shinfo(skb)->frags in i40e_tx_map().

If the packet data of all the fraglist GRO skbs are backed by a
page fragment then we could just do the same by iterating with
skb_walk_frags(). I'm not a driver expert and might be misstaken,
but it looks like that could be done with existing hardware that
supports segmentation offload.
