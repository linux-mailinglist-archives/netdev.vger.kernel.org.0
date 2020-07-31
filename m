Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8389233E29
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 06:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgGaERg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 00:17:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38053 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725800AbgGaERf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 00:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596169053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=reeNLg+TD55rsNB2iiTvcYYEevnQu1S+px9nBOesrWc=;
        b=O7Lppe1a6G6arh8es7gBauQRGWKlLTrTpEEBnJNFHAr1Jtz/Fu8eUUfCFwgZ3IXDR7Ba7L
        tWn/ecbo1i2lKsScfhQlv7RtoHUWYNQknHDoLUSVXBJHUk7lGSuHaNxp62Pv79CR3y+Dtq
        9Pol5VAa4y2X3W2YnQge++nBCy+cBtg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-MFzPlCQiNNC59nag-YGbIg-1; Fri, 31 Jul 2020 00:17:29 -0400
X-MC-Unique: MFzPlCQiNNC59nag-YGbIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBF11800685;
        Fri, 31 Jul 2020 04:17:27 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F8B7100238C;
        Fri, 31 Jul 2020 04:17:22 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next] tun: add missing rcu annotation in tun_set_ebpf()
Date:   Fri, 31 Jul 2020 00:17:20 -0400
Message-Id: <20200731041720.61187-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We expecte prog_p to be protected by rcu, so adding the rcu annotation
to fix the following sparse warning:

drivers/net/tun.c:3003:36: warning: incorrect type in argument 2 (different address spaces)
drivers/net/tun.c:3003:36:    expected struct tun_prog [noderef] __rcu **prog_p
drivers/net/tun.c:3003:36:    got struct tun_prog **prog_p
drivers/net/tun.c:3292:42: warning: incorrect type in argument 2 (different address spaces)
drivers/net/tun.c:3292:42:    expected struct tun_prog **prog_p
drivers/net/tun.c:3292:42:    got struct tun_prog [noderef] __rcu **
drivers/net/tun.c:3296:42: warning: incorrect type in argument 2 (different address spaces)
drivers/net/tun.c:3296:42:    expected struct tun_prog **prog_p
drivers/net/tun.c:3296:42:    got struct tun_prog [noderef] __rcu **

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7adeb91bd368..9b4b25358f9b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2983,7 +2983,7 @@ static int tun_set_queue(struct file *file, struct ifreq *ifr)
 	return ret;
 }
 
-static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog **prog_p,
+static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
 			void __user *data)
 {
 	struct bpf_prog *prog;
-- 
2.18.1

