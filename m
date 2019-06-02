Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8210D32358
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 15:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFBNNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 09:13:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52003 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfFBNNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 09:13:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id f10so8793221wmb.1
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 06:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=iMDuebfalYVbvDyIm8oZK6A1oCkIXWhd4+TpMKu6Z0Y=;
        b=RWl38cZuMv/sJPWLK80+hzKKLU3hakBbeFKqg0lZGs0nEqPPDD12R0CfdxzgFrS3kW
         WjNoA8Cs4lzCWNC1hcyfT+fXSVsiLCFk9qw2bYExdVCdv6cgc8ZiXc+MTLJlWuhuGcg2
         U1oEFYiUqxVlME/hAi+F272jasCHLqHNGl6O7OWLAht2sAxqeXyomZ/JgZJfchzH2eY7
         ZsEBFyLFR4s3HB3qCwG1tA1MUUj6mcXd5ZHPiVg6Ty5SybzDKsV8KZPS/j+MEC6AdU4S
         c88qyqdvggSZ207ZkrGGQiy100HW8I5FYPNZTeiXkxqlHICGJiibgQ+/EOuybl3f3ywn
         5vSg==
X-Gm-Message-State: APjAAAU/Lmz0YLRqosc59QE0iOgy6yYa2lkPxBM+tJrDdugDyapZQw7n
        Boz4zYHhEqRGokvlOmUzjvDZy46iH2o=
X-Google-Smtp-Source: APXvYqyYaeL3NU4KBZyB56XCOqKug+UFoybzHMzRTXMLQJ7Z4FnbqJ5i9GcrIFzW3+pyQSraoituTQ==
X-Received: by 2002:a1c:c909:: with SMTP id f9mr11271945wmb.115.1559481230772;
        Sun, 02 Jun 2019 06:13:50 -0700 (PDT)
Received: from linux.home (2a01cb05850ddf00045dd60e6368f84b.ipv6.abo.wanadoo.fr. [2a01:cb05:850d:df00:45d:d60e:6368:f84b])
        by smtp.gmail.com with ESMTPSA id f10sm21506134wrg.24.2019.06.02.06.13.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 02 Jun 2019 06:13:50 -0700 (PDT)
Date:   Sun, 2 Jun 2019 15:13:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Peter Oskolkov <posk@google.com>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] netfilter: ipv6: nf_defrag: fix leakage of unqueued
 fragments
Message-ID: <51d82a9bd6312e51a56ccae54e00452a0ef957dd.1559480671.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit 997dd9647164 ("net: IP6 defrag: use rbtrees in
nf_conntrack_reasm.c"), nf_ct_frag6_reasm() is now called from
nf_ct_frag6_queue(). With this change, nf_ct_frag6_queue() can fail
after the skb has been added to the fragment queue and
nf_ct_frag6_gather() was adapted to handle this case.

But nf_ct_frag6_queue() can still fail before the fragment has been
queued. nf_ct_frag6_gather() can't handle this case anymore, because it
has no way to know if nf_ct_frag6_queue() queued the fragment before
failing. If it didn't, the skb is lost as the error code is overwritten
with -EINPROGRESS.

Fix this by setting -EINPROGRESS directly in nf_ct_frag6_queue(), so
that nf_ct_frag6_gather() can propagate the error as is.

Fixes: 997dd9647164 ("net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
Not sure if this should got to the net or nf tree (as the original patch
went through net). Anyway this patch applies cleanly to both.

 net/ipv6/netfilter/nf_conntrack_reasm.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 3de0e9b0a482..5b3f65e29b6f 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -293,7 +293,11 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 		skb->_skb_refdst = 0UL;
 		err = nf_ct_frag6_reasm(fq, skb, prev, dev);
 		skb->_skb_refdst = orefdst;
-		return err;
+
+		/* After queue has assumed skb ownership, only 0 or
+		 * -EINPROGRESS must be returned.
+		 */
+		return err ? -EINPROGRESS : 0;
 	}
 
 	skb_dst_drop(skb);
@@ -480,12 +484,6 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 		ret = 0;
 	}
 
-	/* after queue has assumed skb ownership, only 0 or -EINPROGRESS
-	 * must be returned.
-	 */
-	if (ret)
-		ret = -EINPROGRESS;
-
 	spin_unlock_bh(&fq->q.lock);
 	inet_frag_put(&fq->q);
 	return ret;
-- 
2.20.1

