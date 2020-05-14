Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C2C1D32B8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgENOYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:24:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45262 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726304AbgENOYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589466261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fGWHZrRoLExAS3mHwk8ufZ/s4MYBxFdJolCaEnLqA8M=;
        b=OXJCh5GLUPv3k4SUBHt3EOoS6pcj0UXeOEj+luCmjZqmh9udrIAukKWN4wRIXhrk8SZgiq
        3qezn7J2Rtb6PtKX5HRY5eYO4PDubZpacgbGxZhxmrzkcmCnLbqDe1mMnzi5ohEH16meoJ
        HQgq42UtuWxXzvF1jYtaWz6pjKjh7EM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-gDkumX-iOmOMry4mSLa6sw-1; Thu, 14 May 2020 10:24:17 -0400
X-MC-Unique: gDkumX-iOmOMry4mSLa6sw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B5F8800053;
        Thu, 14 May 2020 14:24:13 +0000 (UTC)
Received: from redhat.com (null.msp.redhat.com [10.15.80.136])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E42045D9CA;
        Thu, 14 May 2020 14:24:04 +0000 (UTC)
Date:   Thu, 14 May 2020 09:24:03 -0500
From:   David Teigland <teigland@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: Re: is it ok to always pull in sctp for dlm, was: Re: [PATCH 27/33]
 sctp: export sctp_setsockopt_bindx
Message-ID: <20200514142403.GA1447@redhat.com>
References: <20200513062649.2100053-1-hch@lst.de>
 <20200513062649.2100053-28-hch@lst.de>
 <20200513180058.GB2491@localhost.localdomain>
 <20200514104040.GA12979@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514104040.GA12979@lst.de>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:40:40PM +0200, Christoph Hellwig wrote:
> On Wed, May 13, 2020 at 03:00:58PM -0300, Marcelo Ricardo Leitner wrote:
> > On Wed, May 13, 2020 at 08:26:42AM +0200, Christoph Hellwig wrote:
> > > And call it directly from dlm instead of going through kernel_setsockopt.
> > 
> > The advantage on using kernel_setsockopt here is that sctp module will
> > only be loaded if dlm actually creates a SCTP socket.  With this
> > change, sctp will be loaded on setups that may not be actually using
> > it. It's a quite big module and might expose the system.
> > 
> > I'm okay with the SCTP changes, but I'll defer to DLM folks to whether
> > that's too bad or what for DLM.
> 
> So for ipv6 I could just move the helpers inline as they were trivial
> and avoid that issue.  But some of the sctp stuff really is way too
> big for that, so the only other option would be to use symbol_get.

Let's try symbol_get, having the sctp module always loaded caused problems
last time it happened (almost nobody uses dlm with it.)
Dave 

