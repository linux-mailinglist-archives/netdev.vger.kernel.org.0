Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA30F2DED5
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 15:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfE2Ntl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 09:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfE2Ntk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 09:49:40 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C3580300CAC0;
        Wed, 29 May 2019 13:49:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-173.rdu2.redhat.com [10.10.120.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBEAE1001E80;
        Wed, 29 May 2019 13:49:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190529114332.19163-4-fw@strlen.de>
References: <20190529114332.19163-4-fw@strlen.de> <20190529114332.19163-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 3/7] afs: switch to in_dev_for_each_ifa_rcu
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20801.1559137779.1@warthog.procyon.org.uk>
Date:   Wed, 29 May 2019 14:49:39 +0100
Message-ID: <20802.1559137779@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 29 May 2019 13:49:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:

> The in_dev_for_each_ifa_rcu helper gets used so sparse won't
> complain when we add the proper __rcu annotation to the ifa_list
> member in struct in_device later.
> 
> While doing this I realized the helper only has one call site,
> so move it to where its needed.
> 
> This then revealed that we allocate a temporary buffer needlessly
> and pass an always-false bool argument.
> 
> So fold this into the calling function and fill dst buffer directly.
> 
> Compile tested only.

Actually, whilst thanks are due for doing the work - it looks nicer now - I'm
told that there's not really any point populating the list.  Current OpenAFS
ignores it, as does AuriStor - and IBM AFS 3.6 will do the right thing.

The list is actually useless as it's the client's view of the world, not the
servers, so if there's any NAT in the way its contents are invalid.  Further,
it doesn't support IPv6 addresses.

On that basis, feel free to make it an empty list and remove all the interface
enumeration.

David
