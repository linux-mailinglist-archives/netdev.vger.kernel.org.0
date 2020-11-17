Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5FD2B5B1D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgKQIiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:38:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgKQIiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 03:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605602333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vaOGo31PBT7Vq3G2jzSyf5AtCROEyUyp3uQByGZ0L3w=;
        b=CYeZd1WToivQTKOJzcV0O+LVDtSzj1UczI+LqzfVy2uFqvmtTThGE63UqNdr3pQVr0pw20
        AwTlVNz6pKSO9HqKvrul8FlZ+b+lRmadADE1gPAZdfLQvWm5nCSo8+05p/o67CZlawb5Qa
        rStLXnv6y+LgofTw8lQRYHd4/tIQsos=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-AmW52dlXNNa4oaP6IaAcxA-1; Tue, 17 Nov 2020 03:38:49 -0500
X-MC-Unique: AmW52dlXNNa4oaP6IaAcxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B531108E1A5;
        Tue, 17 Nov 2020 08:38:48 +0000 (UTC)
Received: from ovpn-114-34.ams2.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EE555D9CC;
        Tue, 17 Nov 2020 08:38:46 +0000 (UTC)
Message-ID: <a41e88a82b4d7433dded23e9fbd0465ad8529e36.camel@redhat.com>
Subject: Re: [PATCH net-next] net: add annotation for sock_{lock,unlock}_fast
From:   Paolo Abeni <pabeni@redhat.com>
To:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-sparse@vger.kernel.org
Date:   Tue, 17 Nov 2020 09:38:45 +0100
In-Reply-To: <20201116222750.nmfyxnj6jvd3rww4@ltop.local>
References: <95cf587fe96127884e555f695fe519d50e63cc17.1605522868.git.pabeni@redhat.com>
         <20201116222750.nmfyxnj6jvd3rww4@ltop.local>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thank you for the feedback!

On Mon, 2020-11-16 at 23:27 +0100, Luc Van Oostenryck wrote:
> > @@ -1606,10 +1607,12 @@ bool lock_sock_fast(struct sock *sk);
> >   */
> >  static inline void unlock_sock_fast(struct sock *sk, bool slow)
> >  {
> > -	if (slow)
> > +	if (slow) {
> >  		release_sock(sk);
> > -	else
> > +		__release(&sk->sk_lock.slock);
> 
> The correct solution would be to annotate the declaration of
> release_sock() with '__releases(&sk->sk_lock.slock)'.

If I add such annotation to release_sock(), I'll get several sparse
warnings for context imbalance (on each lock_sock()/release_sock()
pair), unless I also add an '__acquires()' annotation to lock_sock(). 

The above does not look correct to me ?!? When release_sock() completes
the socket spin lock is not held. The annotation added above is
somewhat an artifact to let unlock_sock_fast() matches lock_sock_fast()
from sparse perspective. I intentionally avoided changing
the release_sock() annotation to avoid introducing more artifacts.

The proposed schema is not 100% accurate, as it will also allow e.g. a
really-not-fitting bh_lock_sock()/unlock_sock_fast() pair, but I could
not come-up with anything better.

Can we go with the schema I proposed?

Thanks,

Paolo

