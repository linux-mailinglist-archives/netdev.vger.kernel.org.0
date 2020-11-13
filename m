Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF6A2B192B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 11:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgKMKiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 05:38:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKMKiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 05:38:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605263901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qYrnBg5j8eYn+WxnpmnQUQHMUinj/YwQeHNU+oWcIDU=;
        b=UlXl1EsSELA1yr0ci7j5KPa3wuExQuCCzPPfnAx8oniY+PVuCD65n2an28xncCEQwdnGgN
        sL/mgdgj5c0k+rcHu9JEd7Xcf2H8R1y11ZNbWwjTJLbysvsZ2vE5v8okfzi7MX1S6AbFVU
        1TKGlbfJtKzu46qcI7WgPcdEGLv2GJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-82d2--DPOhu_8SA066qDNw-1; Fri, 13 Nov 2020 05:38:17 -0500
X-MC-Unique: 82d2--DPOhu_8SA066qDNw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8F3A1891E9C;
        Fri, 13 Nov 2020 10:38:15 +0000 (UTC)
Received: from ovpn-114-183.ams2.redhat.com (ovpn-114-183.ams2.redhat.com [10.36.114.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8AAE5D9E4;
        Fri, 13 Nov 2020 10:38:14 +0000 (UTC)
Message-ID: <3a20827d0a695b646579c94b7bbf2a185a3226dc.camel@redhat.com>
Subject: Re: [PATCH net-next v2 01/13] tcp: factor out tcp_build_frag()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        mptcp@lists.01.org
Date:   Fri, 13 Nov 2020 11:38:13 +0100
In-Reply-To: <20201112151254.14e3b059@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1605199807.git.pabeni@redhat.com>
         <8fcb0ad6f324008ccadfd1811d91b3145bbf95fd.1605199807.git.pabeni@redhat.com>
         <20201112150831.1c4bb8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201112151254.14e3b059@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 15:12 -0800, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 15:08:31 -0800 Jakub Kicinski wrote:
> > On Thu, 12 Nov 2020 18:45:21 +0100 Paolo Abeni wrote:
> > > +		skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
> > > +				tcp_rtx_and_write_queues_empty(sk));  
> > 
> > no good reason to misalign this AFAICT
> 
> Maybe not worth respining just for this, I thought there are build
> warnings but seems it's mostly sparse getting confused.

Thanks for looking into this!

The misalign comes from the orginal TCP code, which I tried to keep as
unmodfied as possible to simplify the review. Anyhow I had to drop an
indentation level, so there are really no excuse for me.

I'll address this in the next iteration, if other changes will be
needed

> Is there a chance someone could look into adding annotations to socket
> locking?

Annotating lock_sock_fast()/unlock_sock_fast() as they would
unconditionally acquire/release the socket spinlock removes the warning
related to fast lock - at least for me;).

Hopefully that does not interact with lockdep, but perhpas is a bit too
extreme/rusty?

Something alike the following:

---
diff --git a/include/net/sock.h b/include/net/sock.h
index fbd2ba2f48c0..26db18024b74 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1591,7 +1591,8 @@ void release_sock(struct sock *sk);
 				SINGLE_DEPTH_NESTING)
 #define bh_unlock_sock(__sk)	spin_unlock(&((__sk)->sk_lock.slock))
 
-bool lock_sock_fast(struct sock *sk);
+bool lock_sock_fast(struct sock *sk) __acquires(&sk->sk_lock.slock);
+
 /**
  * unlock_sock_fast - complement of lock_sock_fast
  * @sk: socket
@@ -1601,11 +1602,14 @@ bool lock_sock_fast(struct sock *sk);
  * If slow mode is on, we call regular release_sock()
  */
 static inline void unlock_sock_fast(struct sock *sk, bool slow)
+		   __releases(&sk->sk_lock.slock)
 {
-	if (slow)
+	if (slow) {
 		release_sock(sk);
-	else
+		__release(&sk->sk_lock.slock);
+	} else {
 		spin_unlock_bh(&sk->sk_lock.slock);
+	}
 }
 
 /* Used by processes to "lock" a socket state, so that
diff --git a/net/core/sock.c b/net/core/sock.c
index 727ea1cc633c..9badbe7bb4e4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3078,7 +3078,7 @@ EXPORT_SYMBOL(release_sock);
  *
  *   sk_lock.slock unlocked, owned = 1, BH enabled
  */
-bool lock_sock_fast(struct sock *sk)
+bool lock_sock_fast(struct sock *sk) __acquires(&sk->sk_lock.slock)
 {
 	might_sleep();
 	spin_lock_bh(&sk->sk_lock.slock);
@@ -3096,6 +3096,7 @@ bool lock_sock_fast(struct sock *sk)
 	 * The sk_lock has mutex_lock() semantics here:
 	 */
 	mutex_acquire(&sk->sk_lock.dep_map, 0, 0, _RET_IP_);
+	__acquire(&sk->sk_lock.slock);
 	local_bh_enable();
 	return true;
 }



