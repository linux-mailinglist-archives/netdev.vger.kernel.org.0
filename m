Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5A11CB5F1
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEHR2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:28:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38589 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726864AbgEHR2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588958933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ODoyekAk6eYmn5jhtXpvSM+z/VfA6RkQBct09F0JkGg=;
        b=bUaO3cQi+WIsmDEOa1ml41sH6yJRFu4uGunGrXFAhgCUmi65JymjJa9ll6Ds0Gdz1oKZYU
        UB87XHqJ8xS6FsLuaqRMbRx+jjdkPtHc99fZcZzZUbo0a/Cf4I2LHpkfxbdcmeOrJra/iZ
        yh/ULMrC/bmJnYJF0jCC0Xy2WMfvrCg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-b6EgUqa7MdCAwihB654XaA-1; Fri, 08 May 2020 13:28:48 -0400
X-MC-Unique: b6EgUqa7MdCAwihB654XaA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A91B80058A;
        Fri,  8 May 2020 17:28:47 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-6.ams2.redhat.com [10.36.114.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57B1B62B0B;
        Fri,  8 May 2020 17:28:46 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Walters <walters@redhat.com>
Subject: [PATCH net] net: ipv4: really enforce backoff for redirects
Date:   Fri,  8 May 2020 19:28:34 +0200
Message-Id: <7f71c9a7ba0d514c9f2d006f4797b044c824ae84.1588954755.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit b406472b5ad7 ("net: ipv4: avoid mixed n_redirects and
rate_tokens usage") I missed the fact that a 0 'rate_tokens' will
bypass the backoff algorithm.

Since rate_tokens is cleared after a redirect silence, and never
incremented on redirects, if the host keeps receiving packets
requiring redirect it will reply ignoring the backoff.

Additionally, the 'rate_last' field will be updated with the
cadence of the ingress packet requiring redirect. If that rate is
high enough, that will prevent the host from generating any
other kind of ICMP messages

The check for a zero 'rate_tokens' value was likely a shortcut
to avoid the more complex backoff algorithm after a redirect
silence period. Address the issue checking for 'n_redirects'
instead, which is incremented on successful redirect, and
does not interfere with other ICMP replies.

Fixes: b406472b5ad7 ("net: ipv4: avoid mixed n_redirects and rate_tokens usage")
Reported-and-tested-by: Colin Walters <walters@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 788c69d9bfe0..fa829f31a3f5 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -915,7 +915,7 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	/* Check for load limit; set rate_last to the latest sent
 	 * redirect.
 	 */
-	if (peer->rate_tokens == 0 ||
+	if (peer->n_redirects == 0 ||
 	    time_after(jiffies,
 		       (peer->rate_last +
 			(ip_rt_redirect_load << peer->n_redirects)))) {
-- 
2.21.1

