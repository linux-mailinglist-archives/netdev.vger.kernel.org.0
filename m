Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DC03013AA
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 08:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbhAWHMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 02:12:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbhAWHML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 02:12:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611385844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v0CCefsu/cbO9yyid+RTjeSEAQzZFUKG2o9xgFQS9eg=;
        b=ibfVGhac3q4WohPbqozVdFy2J712EtkSU9VXAMIJa5pKYc1+no/uZWAWdtssMVVVg5yNmo
        isftoLmeWcJ0cUmo3eadM7wFaUxB9SNTFL12QaUnlVRK+5aurg/5A2lWWUApZSjknM5pKy
        e9On8eN6Bnu2eXXiFYkz3p+iBKSbnOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-6xL-rDCjPn-sJ8Q4KDV6QQ-1; Sat, 23 Jan 2021 02:10:42 -0500
X-MC-Unique: 6xL-rDCjPn-sJ8Q4KDV6QQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8751B180A086;
        Sat, 23 Jan 2021 07:10:41 +0000 (UTC)
Received: from ovpn-112-12.ams2.redhat.com (ovpn-112-12.ams2.redhat.com [10.36.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 942CB60BE2;
        Sat, 23 Jan 2021 07:10:39 +0000 (UTC)
Message-ID: <fab5f9f2abdc478702fc7f9a831de418a1234e38.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 5/5] mptcp: implement delegated actions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Date:   Sat, 23 Jan 2021 08:10:37 +0100
In-Reply-To: <20210122152355.761ff148@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1611153172.git.pabeni@redhat.com>
         <fbae7709d333eb2afcc79e69a8db3d952292564f.1611153172.git.pabeni@redhat.com>
         <20210121173437.1b945b01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <e093e7615490baad413ef6ba49154e3e4e98399a.camel@redhat.com>
         <20210122152355.761ff148@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-01-22 at 15:23 -0800, Jakub Kicinski wrote:
> On Fri, 22 Jan 2021 09:25:07 +0100 Paolo Abeni wrote:
> > > Do you need it because of locking?  
> > 
> > This infrastructure is used to avoid the workqueue usage in the MPTCP
> > receive path (to push pending data). With many mptcp connections
> > established that would be very bad for tput and latency. This
> > infrastructure is not strictly needed from a functinal PoV, but I was
> > unable to find any other way to avoid the workqueue usage.
> 
> But it is due to locking or is it not? Because you're running the
> callback in the same context, so otherwise why not just call the
> function directly? Can't be batching, it's after GRO so we won't 
> batch much more.

Thank you for the feedback. 

Let me try to elaborate a bit more on this. When processing the input
packet (MPTCP data ack) on the MPTCP subflow A, under the subflow A
socket lock, we possibly need to push some data via a different subflow
B - depending on the MPTCP packet scheduler decision. We can't try to
acquire the B subflow socket lock due to ABBA deadlock.

Either the workqueue usage and this infra avoid the deadlock breaking
the locks chain.

Should not have any bad iteraction with threaded NAPI nor busy polling,
but I don't have experimented yet. Placing that on my TODO list.

Thanks!

Paolo

