Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1D915203D
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 19:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgBDSMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 13:12:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46562 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727415AbgBDSMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 13:12:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580839942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bzg9bDZQ96CGaLiNh7lVZC6J4F7OP3CKfbn8hB4NuvU=;
        b=WkV9b0N9IixlXqUkFKwpe/0sChPid+JSuXBvd31l7CmqxnMlDVpD+IHLl4w0CYL3cJBnsm
        AhUT00zoHXr8pHglItg8ygPZ9nuIL83bGuHLok68qn5HpTdLRyhNjhU3JKr4L2wyzkBIKj
        NgOBEqso249IBh3xe2+Jzv39ZhbTQNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-E-q9i6prMwOivKPvmq3UPw-1; Tue, 04 Feb 2020 13:12:17 -0500
X-MC-Unique: E-q9i6prMwOivKPvmq3UPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B46818A6EC1;
        Tue,  4 Feb 2020 18:12:15 +0000 (UTC)
Received: from x2.localnet (ovpn-116-11.phx2.redhat.com [10.3.116.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9117C19C69;
        Tue,  4 Feb 2020 18:12:03 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
Date:   Tue, 04 Feb 2020 13:12:02 -0500
Message-ID: <35934535.C1y6eIYgqz@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhRHfjuv5yyn+nQ2LbHtcezBcjKtOQ69ssYrXOiExuCjBw@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <3665686.i1MIc9PeWa@x2> <CAHC9VhRHfjuv5yyn+nQ2LbHtcezBcjKtOQ69ssYrXOiExuCjBw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, February 4, 2020 10:52:36 AM EST Paul Moore wrote:
> On Tue, Feb 4, 2020 at 10:47 AM Steve Grubb <sgrubb@redhat.com> wrote:
> > On Tuesday, February 4, 2020 8:19:44 AM EST Richard Guy Briggs wrote:
> > > > The established pattern is that we print -1 when its unset and "?"
> > > > when
> > > > its totalling missing. So, how could this be invalid? It should be
> > > > set
> > > > or not. That is unless its totally missing just like when we do not
> > > > run
> > > > with selinux enabled and a context just doesn't exist.
> > > 
> > > Ok, so in this case it is clearly unset, so should be -1, which will be
> > > a
> > > 20-digit number when represented as an unsigned long long int.
> > > 
> > > Thank you for that clarification Steve.
> > 
> > It is literally a  -1.  ( 2 characters)
> 
> Well, not as Richard has currently written the code, it is a "%llu".
> This was why I asked the question I did; if we want the "-1" here we
> probably want to special case that as I don't think we want to display
> audit container IDs as signed numbers in general.

OK, then go with the long number, we'll fix it in the interpretation. I guess 
we do the same thing for auid.

-Steve


