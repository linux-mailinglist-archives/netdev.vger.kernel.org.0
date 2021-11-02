Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0164429D9
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 09:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhKBIwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 04:52:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229813AbhKBIwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 04:52:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635843015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gkgz68rvnt7G9X+ym70utCtNaVuCReoBXjCckZay26o=;
        b=KKNn6CMPI9RMMj1bcEv2GriaVKbl0Uf5q6N5hB2nDiRGja1wSLJd9gdeHUOFtVqZIBkV8n
        polJPNJnWIV2Mn/m5FuRPdA1lMHQRsrWcOZ95HfAexChOGc38EeRE6eX2eyrAqOUcreLS6
        iKLPSBFGXzpv8EdDlsE4gcYgoHNdgww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-W4lh5bqyPD-QMzXsgnlZvQ-1; Tue, 02 Nov 2021 04:50:12 -0400
X-MC-Unique: W4lh5bqyPD-QMzXsgnlZvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2793D91271;
        Tue,  2 Nov 2021 08:50:11 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C85469FB2;
        Tue,  2 Nov 2021 08:50:08 +0000 (UTC)
Date:   Tue, 2 Nov 2021 09:50:05 +0100
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] MCTP sockaddr padding check/initialisation
 fixup
Message-ID: <20211102085005.GA14342@asgard.redhat.com>
References: <cover.1635788968.git.esyr@redhat.com>
 <b8c77eb3b3379e52e91b9ecc9c35c2f707cc3ae5.camel@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8c77eb3b3379e52e91b9ecc9c35c2f707cc3ae5.camel@codeconstruct.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 09:57:34AM +0800, Jeremy Kerr wrote:
> Hi Eugene,
> 
> > Padding/reserved fields necessitate appropriate checks in order to be
> > usable in the future.
> 
> We don't have a foreseeable need for extra fields here; so this is a bit
> hypothetical at the moment. However, I guess there may be something that
> comes up in future - was there something you have in mind?

Not really, but reality suggests that many interfaces tend to extend
over time (including socket addresses, see flags in sockaddr_vm
as an example), so future-proofing padding allows extending into it
with minimal implementation complication, comparing to other approaches.

> The requirements for the padding bytes to be zero on sendmsg() will
> break the ABI for applications that are using the interface on 5.15;
> there's a small, contained set of those at the moment though, so I'm OK
> to handle the updates if this patch is accepted, but we'd need to make a
> call on that soon.

Yeah, I regret I have not caught it earlier.

> Setting the pad bytes to zero on recvmsg() is a good plan though, I'm
> happy for that change to go in regardless.

I can split it out in case there is hesitance with regards to applying padding
checks.

