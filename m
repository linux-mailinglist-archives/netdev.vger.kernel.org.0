Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77444127A5
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 08:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfECGWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 02:22:08 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53768 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfECGWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 02:22:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9A64C201E2;
        Fri,  3 May 2019 08:22:07 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Lma9NFmMlDFp; Fri,  3 May 2019 08:22:07 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 08A8F201DA;
        Fri,  3 May 2019 08:22:07 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 3 May 2019
 08:22:06 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A22DD31805BF;
 Fri,  3 May 2019 08:22:06 +0200 (CEST)
Date:   Fri, 3 May 2019 08:22:06 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Vakul Garg <vakul.garg@nxp.com>
CC:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
Message-ID: <20190503062206.GL17989@gauss3.secunet.de>
References: <20190423162521.sn4lfd5iia566f44@breakpoint.cc>
 <20190424104023.10366-1-fw@strlen.de>
 <20190503060748.GK17989@gauss3.secunet.de>
 <VE1PR04MB6670F77D42F9DA342F8E58238B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <VE1PR04MB6670F77D42F9DA342F8E58238B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 6C314BDC-7424-456F-862A-4D73F37AE8C5
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 06:13:22AM +0000, Vakul Garg wrote:
> 
> 
> > -----Original Message-----
> > From: Steffen Klassert <steffen.klassert@secunet.com>
> > Sent: Friday, May 3, 2019 11:38 AM
> > To: Florian Westphal <fw@strlen.de>
> > Cc: Vakul Garg <vakul.garg@nxp.com>; netdev@vger.kernel.org
> > Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
> > 
> > On Wed, Apr 24, 2019 at 12:40:23PM +0200, Florian Westphal wrote:
> > > I'm not sure this is a good idea to begin with, refcount is right next
> > > to state spinlock which is taken for both tx and rx ops, plus this
> > > complicates debugging quite a bit.
> > 
> > 
> > Hm, what would be the usecase where this could help?
> > 
> > The only thing that comes to my mind is a TX state with wide selectors. In
> > that case you might see traffic for this state on a lot of cpus. But in that case
> > we have a lot of other problems too, state lock, replay window etc. It might
> > make more sense to install a full state per cpu as this would solve all the
> > other problems too (I've talked about that idea at the IPsec workshop).
> > 
> > In fact RFC 7296 allows to insert multiple SAs with the same traffic selector,
> > so it is possible to install one state per cpu. We did a PoC for this at the IETF
> > meeting the week after the IPsec workshop.
> > 
> 
> On 16-core arm64 processor, I am getting very high cpu usage (~ 40 %) in refcount atomics.
> E.g. in function dst_release() itself, I get 19% cpu usage  in refcount api.
> Will the PoC help here?

If your usecase is that what I described above, then yes.

I guess the high cpu usage comes from cachline bounces
because one SA is used from many cpus simultaneously.
Is that the case?

Also, is this a new problem or was it always like that?
