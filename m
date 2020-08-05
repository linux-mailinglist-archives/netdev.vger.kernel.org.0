Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F3023C8BB
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 11:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgHEJLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 05:11:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53249 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbgHEJLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 05:11:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596618661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5uXm2AcpYhJR4gZmB61tzeHXm44+3sXMc+22nlq5ahw=;
        b=evvDGOegnwoTjcVUIwa/yY936QCe4GgqD9SU8Xnm7seEjq4avYX0UPfw48jH8PSbeSqbzZ
        2vIjAsTwXvdYt8WYKCkUK6h86bcwO4GYi1zsVvHDCne+c9GhAq6xdboY03pWmNbk4lYBMT
        OBOVElyv5w+i00O8nWQ3zo93VagovE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-rYCFWsglP4W5Lujczq97oA-1; Wed, 05 Aug 2020 05:10:57 -0400
X-MC-Unique: rYCFWsglP4W5Lujczq97oA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CADB1102C7ED;
        Wed,  5 Aug 2020 09:10:55 +0000 (UTC)
Received: from ovpn-114-157.ams2.redhat.com (ovpn-114-157.ams2.redhat.com [10.36.114.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32CBC72E4F;
        Wed,  5 Aug 2020 09:10:53 +0000 (UTC)
Message-ID: <e197f22c62d4f1b78cee4f8a2a9b55a6bc807ede.camel@redhat.com>
Subject: Re: [PATCH net] mptcp: be careful on subflow creation
From:   Paolo Abeni <pabeni@redhat.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>
Date:   Wed, 05 Aug 2020 11:10:52 +0200
In-Reply-To: <4f2a74b9-d728-fa76-7b0f-f70c256077ee@tessares.net>
References: <61e82de664dffde9ff445ed6f776d6809b198693.1596558566.git.pabeni@redhat.com>
         <4f2a74b9-d728-fa76-7b0f-f70c256077ee@tessares.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-08-04 at 21:25 +0200, Matthieu Baerts wrote:
> Hi Paolo,
> 
> On 04/08/2020 18:31, Paolo Abeni wrote:
> > Nicolas reported the following oops:
> 
> (...)
> 
> > on some unconventional configuration.
> > 
> > The MPTCP protocol is trying to create a subflow for an
> > unaccepted server socket. That is allowed by the RFC, even
> > if subflow creation will likely fail.
> > Unaccepted sockets have still a NULL sk_socket field,
> > avoid the issue by failing earlier.
> > 
> > Reported-and-tested-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> > Fixes: 7d14b0d2b9b3 ("mptcp: set correct vfs info for subflows")
> 
> Thank you for the patch, the addition in the code looks very good to me!
> 
> But are you sure the commit you mention introduces the issue you fix here?

AFAICS, the oops can be observed only with the mentioned commit - which
unconditioanlly de-reference a NULL sk->sk_socket. [try to] create a
subflow on server unaccepted socket is not a bug per-se, so I would not
send the fix to older trees.

Thanks,

Paolo

