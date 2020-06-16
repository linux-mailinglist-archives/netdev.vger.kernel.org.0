Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD89F1FB9E5
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbgFPQHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:07:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40233 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732267AbgFPPrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592322422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=djkgmBs6vxKrnF2svfHTCwO6iJZv0MD8YpKSjFl2MGs=;
        b=anxZyJvaFpuLChSMwUR/a7qLSGGcT0Nzy4aiSkqCpI/xVk6zVIcE9J7iV1341dFYQpdAwe
        QNobub7hXN4Ms1OW18fOfvph9zqDj6d3Es9xcqmAm7V7WWOGLDbJFRK2rhytEAPFfTLrAb
        z8prG6hZN2mOJEmSXgQ9/SksTn2gcSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-nWeeH7oNN9eY6skcHYs3nQ-1; Tue, 16 Jun 2020 11:46:56 -0400
X-MC-Unique: nWeeH7oNN9eY6skcHYs3nQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B3678DEEE2;
        Tue, 16 Jun 2020 15:46:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EC3B60C05;
        Tue, 16 Jun 2020 15:46:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <56c2304c-73cc-8f48-d8d0-5dd6c39f33f3@redhat.com>
References: <56c2304c-73cc-8f48-d8d0-5dd6c39f33f3@redhat.com> <20200616015718.7812-1-longman@redhat.com> <20200616015718.7812-2-longman@redhat.com> <20200616033035.GB902@sol.localdomain>
To:     Waiman Long <longman@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, ebiggers@kernel.org,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.cz>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-mm@kvack.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mm/slab: Use memzero_explicit() in kzfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <879078.1592322400.1@warthog.procyon.org.uk>
Date:   Tue, 16 Jun 2020 16:46:40 +0100
Message-ID: <879079.1592322400@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Waiman Long <longman@redhat.com> wrote:

> The kzfree() function is normally used to clear some sensitive
> information, like encryption keys, in the buffer before freeing it back
> to the pool. Memset()

"memset()" is all lowercase.

> is currently used for buffer clearing. However unlikely, there is still a
> non-zero probability

I'd say "a possibility".

> that

and I'd move "in [the] future" here.

> the compiler may choose to optimize away the
> memory clearing especially if LTO is being used in the future. To make sure
> that this optimization will never happen

"in these cases"

> , memzero_explicit(), which is introduced in v3.18, is now used in

"instead of"?

> kzfree() to future-proof it.

Davod

