Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25C8BD57F2
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 22:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbfJMUB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 16:01:58 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:41716 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfJMUB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 16:01:58 -0400
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 5A0FB1A40559; Sun, 13 Oct 2019 13:01:58 -0700 (PDT)
Date:   Sun, 13 Oct 2019 13:01:58 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: datagram: tidy up copy functions a bit
Message-ID: <20191013200158.mhvwkdnsjk7ecuqu@shells.gnugeneration.com>
References: <20191012115509.jrqe43yozs7kknv5@shells.gnugeneration.com>
 <8fab6f9c-70a6-02fd-5b2d-66a013c10a4f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fab6f9c-70a6-02fd-5b2d-66a013c10a4f@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 12:30:41PM -0700, Eric Dumazet wrote:
> 
> 
> On 10/12/19 4:55 AM, Vito Caputo wrote:
> > Eliminate some verbosity by using min() macro and consolidating some
> > things, also fix inconsistent zero tests (! vs. == 0).
> > 
> > Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
> > ---
> >  net/core/datagram.c | 44 ++++++++++++++------------------------------
> >  1 file changed, 14 insertions(+), 30 deletions(-)
> > 
> > diff --git a/net/core/datagram.c b/net/core/datagram.c
> > index 4cc8dc5db2b7..08d403f93952 100644
> > --- a/net/core/datagram.c
> > +++ b/net/core/datagram.c
> > @@ -413,13 +413,11 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
> >  					    struct iov_iter *), void *data)
> >  {
> >  	int start = skb_headlen(skb);
> > -	int i, copy = start - offset, start_off = offset, n;
> > +	int i, copy, start_off = offset, n;
> >  	struct sk_buff *frag_iter;
> >  
> >  	/* Copy header. */
> > -	if (copy > 0) {
> > -		if (copy > len)
> > -			copy = len;
> > +	if ((copy = min(start - offset, len)) > 0) {
> 
> No, we prefer not having this kind of construct anymore.
> 
> This refactoring looks unnecessary code churn, making our future backports not
> clean cherry-picks.
> 
> Simply making sure this patch does not bring a regression is very time consuming.

Should I not bother submitting patches for such cleanups?

I submitted another, more trivial patch, is it also considered unnecessary churn:

---

Author: Vito Caputo <vcaputo@pengaru.com>
Date:   Sat Oct 12 17:10:41 2019 -0700

    net: core: skbuff: skb_checksum_setup() drop err
    
    Return directly from all switch cases, no point in storing in err.
    
    Signed-off-by: Vito Caputo <vcaputo@pengaru.com>

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f5f904f46893..c59b68a413b5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4888,23 +4888,14 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
  */
 int skb_checksum_setup(struct sk_buff *skb, bool recalculate)
 {
-       int err;
-
        switch (skb->protocol) {
        case htons(ETH_P_IP):
-               err = skb_checksum_setup_ipv4(skb, recalculate);
-               break;
-
+               return skb_checksum_setup_ipv4(skb, recalculate);
        case htons(ETH_P_IPV6):
-               err = skb_checksum_setup_ipv6(skb, recalculate);
-               break;
-
+               return skb_checksum_setup_ipv6(skb, recalculate);
        default:
-               err = -EPROTO;
-               break;
+               return -EPROTO;
        }
-
-       return err;
 }
 EXPORT_SYMBOL(skb_checksum_setup);

---

Asking to calibrate my thresholds to yours, since I was planning to volunteer
some time each evening to reading kernel code and submitting any obvious
cleanups.

Thanks,
Vito Caputo
