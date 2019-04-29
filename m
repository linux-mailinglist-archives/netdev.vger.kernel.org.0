Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C944E0D9
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfD2KvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:51:02 -0400
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:60394 "EHLO
        mail.osadl.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbfD2KvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:51:02 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2019 06:51:01 EDT
Received: by mail.osadl.at (Postfix, from userid 1001)
        id 040CF5C0B38; Mon, 29 Apr 2019 12:44:14 +0200 (CEST)
Date:   Mon, 29 Apr 2019 12:44:14 +0200
From:   Nicholas Mc Guire <der.herr@hofr.at>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Nicholas Mc Guire <hofrat@osadl.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net_sched: force endianness annotation
Message-ID: <20190429104414.GB17493@osadl.at>
References: <1556430899-11018-1-git-send-email-hofrat@osadl.org>
 <07d36e94-aad4-a263-bf09-705ee1dd59ed@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07d36e94-aad4-a263-bf09-705ee1dd59ed@solarflare.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:11:20AM +0100, Edward Cree wrote:
> On 28/04/2019 06:54, Nicholas Mc Guire wrote:
> > While the endiannes is being handled correctly sparse was unhappy with
> > the missing annotation as be16_to_cpu()/be32_to_cpu() expects a __be16
> > respectively __be32.
> [...]
> > diff --git a/net/sched/em_cmp.c b/net/sched/em_cmp.c
> > index 1c8360a..3045ee1 100644
> > --- a/net/sched/em_cmp.c
> > +++ b/net/sched/em_cmp.c
> > @@ -41,7 +41,7 @@ static int em_cmp_match(struct sk_buff *skb, struct tcf_ematch *em,
> >  		val = get_unaligned_be16(ptr);
> >  
> >  		if (cmp_needs_transformation(cmp))
> > -			val = be16_to_cpu(val);
> > +			val = be16_to_cpu((__force __be16)val);
> >  		break;
> There should probably be a comment here to explain what's going on.  TBH
>  it's probably a good general rule that any use of __force should have a
>  comment explaining why it's needed.
> AFAICT, get_unaligned_be16(ptr) is (barring alignment) equivalent to
>  be16_to_cpu(*(__be16 *)ptr).  But then calling be16_to_cpu() again on
>  val is bogus; it's already CPU endian.  There's a distinct lack of
>  documentation around as to the intended semantics of TCF_EM_CMP_TRANS,
>  but it would seem either (__force u16)cpu_to_be16(val); (which preserves
>  the existing semantics, that trans is a no-op on BE) or swab16(val);
>  would make more sense.
>
be16_to_cpu((__force __be16)val) should be a NOP on big-endian as well - 
atleast that is how I understood it (usr/include/linux/byteorder/big_endian.h).

The problem with using swab16 is that it is impating the binary significantly
so I'm not sure if the change is really side-effect free - while the somewhat
brute force solution is evaluatable simply by diffing.
The swab16() solution seems cleaner than adding another layer of casting - 
but I just am unsure if
-                   val = be16_to_cpu(val);
+                   val = swab16(val);
is actually equivalent. For the original patch this can be checked

-rw-r--r-- 1 hofrat hofrat 2984 Apr 28 01:49 /tmp/em_cmp_force.o
-rw-r--r-- 1 hofrat hofrat 2984 Apr 28 01:49 /tmp/em_cmp_org.o
-rw-r--r-- 1 hofrat hofrat 3392 Apr 29 06:25 /tmp/em_cmp_swab.o
hofrat@debian:~/linux-next$ diff /tmp/em_cmp_force.o /tmp/em_cmp_org.o
hofrat@debian:~/linux-next$

which is why I prefered that solution. if swab16() is equivalent I' resend
a V2

thx!
hofrat
