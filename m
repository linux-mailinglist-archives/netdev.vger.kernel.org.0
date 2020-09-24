Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7007C276B55
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 10:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgIXICJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 04:02:09 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:45656 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgIXICJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 04:02:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0EDFC2054D;
        Thu, 24 Sep 2020 10:02:07 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id N2Hha3N5lro5; Thu, 24 Sep 2020 10:02:06 +0200 (CEST)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 94CD62026E;
        Thu, 24 Sep 2020 10:02:06 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 24 Sep 2020 10:02:06 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 24 Sep
 2020 10:02:06 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0ADA23180126;
 Thu, 24 Sep 2020 10:02:06 +0200 (CEST)
Date:   Thu, 24 Sep 2020 10:02:05 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     syzbot <syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: stack-out-of-bounds Read in xfrm_selector_match (2)
Message-ID: <20200924080205.GD20687@gauss3.secunet.de>
References: <0000000000009fc91605afd40d89@google.com>
 <20200924074026.GC20687@gauss3.secunet.de>
 <20200924074351.GB9879@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200924074351.GB9879@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 05:43:51PM +1000, Herbert Xu wrote:
> On Thu, Sep 24, 2020 at 09:40:26AM +0200, Steffen Klassert wrote:
> >
> > This is yet another ipv4 mapped ipv6 address with IPsec socket policy
> > combination bug, and I'm sure it is not the last one. We could fix this
> > one by adding another check to match the address family of the policy
> > and the SA selector, but maybe it is better to think about how this
> > should work at all.
> > 
> > We can have only one socket policy for each direction and that
> > policy accepts either ipv4 or ipv6. We treat this ipv4 mapped ipv6
> > address as ipv4 and pass it down the ipv4 stack, so this dual usage
> > will not work with a socket policy. Maybe we can require IPV6_V6ONLY
> > for sockets with policy attached. Thoughts?
> 
> I'm looking at the history of this and it used to work at the start
> because you'd always interpret the flow object with a family.  This
> appears to have been lost with 8444cf712c5f71845cba9dc30d8f530ff0d5ff83. 

I'm sure it can be fixed to work with either ipv4 or ipv6.
If I understand that right, it should be possible to talk
ipv4 and ipv6 through that socket, but the policy will
accept only one address family.

> I'm working on a fix.

Thanks!
