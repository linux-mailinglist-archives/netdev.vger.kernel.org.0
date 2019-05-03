Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7851F1277D
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 08:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfECGHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 02:07:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53232 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfECGHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 02:07:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 25292201BB;
        Fri,  3 May 2019 08:07:49 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Khg5qQ1whgOW; Fri,  3 May 2019 08:07:48 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AEC4420182;
        Fri,  3 May 2019 08:07:48 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 3 May 2019
 08:07:48 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5139C31805BF;
 Fri,  3 May 2019 08:07:48 +0200 (CEST)
Date:   Fri, 3 May 2019 08:07:48 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <vakul.garg@nxp.com>, <netdev@vger.kernel.org>
Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
Message-ID: <20190503060748.GK17989@gauss3.secunet.de>
References: <20190423162521.sn4lfd5iia566f44@breakpoint.cc>
 <20190424104023.10366-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190424104023.10366-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: D2706F5B-396A-4195-B7ED-19BB99182D38
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 24, 2019 at 12:40:23PM +0200, Florian Westphal wrote:
> I'm not sure this is a good idea to begin with, refcount
> is right next to state spinlock which is taken for both tx and rx ops,
> plus this complicates debugging quite a bit.


Hm, what would be the usecase where this could help?

The only thing that comes to my mind is a TX state
with wide selectors. In that case you might see
traffic for this state on a lot of cpus. But in
that case we have a lot of other problems too,
state lock, replay window etc. It might make more
sense to install a full state per cpu as this
would solve all the other problems too (I've
talked about that idea at the IPsec workshop).

In fact RFC 7296 allows to insert multiple SAs
with the same traffic selector, so it is possible
to install one state per cpu. We did a PoC for this
at the IETF meeting the week after the IPsec workshop.

One problem that is not solved completely is that,
from userland point of view, a SA consists of two
states (RX/TX) and this has to be symetic i.e.
both ends must have the same number of states.
So if both ends have a different number of cpus,
it is not clear how many states we should install.

We are currently discuss to extend the IKEv2 standard
so that we can negotiate the 'optimal' number of
(per cpu) SAs for a connection.
