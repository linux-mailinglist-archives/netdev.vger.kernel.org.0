Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11A9231632
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgG1XVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:21:53 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39422 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729597AbgG1XVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 19:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595978512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=418Gr2Rc3vzXs76Jg561ppBuyj2o+WpDnufgk6T7MhQ=;
        b=Yb/y5xYY+91Pt19ByBM9kLtmZJAQ5WR/Bay/04KNyilkppuMiqIPRvEB5IuoEqjQSUfTBe
        qJ/4Wx4RZgpwLunvf66t4ZVP/xh7TSq9qd4aPkpu9k5fe6Gmufnx2nGGKntBjBDVPsxJXJ
        Mp16zIKAOroGqVMr9CoQf0Jq6c98Cq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-t-TxJdM6MUKWwS6-kjEYQQ-1; Tue, 28 Jul 2020 19:21:50 -0400
X-MC-Unique: t-TxJdM6MUKWwS6-kjEYQQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23CE3800688;
        Tue, 28 Jul 2020 23:21:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-32.rdu2.redhat.com [10.10.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CA8360C87;
        Tue, 28 Jul 2020 23:21:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     David Miller <davem@davemloft.net>
cc:     dhowells@redhat.com, netdev@vger.kernel.org
Subject: How to make a change in both net and net-next
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3476831.1595978507.1@warthog.procyon.org.uk>
Date:   Wed, 29 Jul 2020 00:21:47 +0100
Message-ID: <3476832.1595978507@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

In the fix I just posted, subject:

	[PATCH net] rxrpc: Fix race between recvmsg and sendmsg on immediate
		call failure

there's a change I need to make as part of the patch:

	-	spin_lock_bh(&conn->params.peer->lock);
	-	hlist_del_rcu(&call->error_link);
	-	spin_unlock_bh(&conn->params.peer->lock);
	+	if (!hlist_unhashed(&call->error_link)) {
	+		spin_lock_bh(&call->peer->lock);
	+		hlist_del_rcu(&call->error_link);
	+		spin_unlock_bh(&call->peer->lock);
	+	}

but I also make the same change as part of a set of patches I want to post for
net-next.

Should I just rebase the net-next patches on top of the one I sent you once
you've picked it into net, or is there a better way?

Thanks,
David

