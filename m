Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9E7303882
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 10:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390713AbhAZJAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 04:00:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390751AbhAZI7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 03:59:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10Q8wWqM064843;
        Tue, 26 Jan 2021 08:58:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=y+vlMWgBzha371Xqd7D/swYIZVBD7UgF7PbQwNkgrWk=;
 b=YRIeIQmDahpwILNB168clKoy2+7LKqoUPaOIXva0X6mYRR968+Rx+uHzaFE3v59oq8Yz
 nKbvfldk0M38+Wzkty5qe8X8T9rC9vU5pkClP0Plj9n1aXAf3X+WlL04Ko93ADNSNAlA
 R+3GJGol60I3KxX/fQMOQv2MuVCMmQWyMGKpoUjhhUWzcCMyGKhhCIewY2bHluOHBqvG
 48aioL9D60Aizz9afEUH1ws4i+RFjhV+tQx/wkTkxdVfWae6HENk2VW9UbFkuhhR7fPJ
 SC3pFDQf40NpAk8teMckMAz0R/97rY7t1d7U2ZOVAZobDultHNSWEWldJEzskAZ9GxSv bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 368brkgy9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jan 2021 08:58:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10Q8o6qB072668;
        Tue, 26 Jan 2021 08:58:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 368wqw5hqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jan 2021 08:58:39 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10Q8wReA011138;
        Tue, 26 Jan 2021 08:58:29 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Jan 2021 00:58:26 -0800
Date:   Tue, 26 Jan 2021 11:58:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lukas Wunner <lukas@wunner.de>, Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH nf-next v4 1/5] net: sched: Micro-optimize egress handling
Message-ID: <20210126085817.GO20820@kadam>
References: <cover.1611304190.git.lukas@wunner.de>
 <a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c.1611304190.git.lukas@wunner.de>
 <CANn89iK3CC3fapmQpwwbVkGs4-+fmJF+nj0pmBHJ9fy6poWseg@mail.gmail.com>
 <20210124103301.GA1056@wunner.de>
 <20210125113908.6951b6f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125113908.6951b6f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101260047
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101260048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 11:39:08AM -0800, Jakub Kicinski wrote:
> On Sun, 24 Jan 2021 11:33:01 +0100 Lukas Wunner wrote:
> > On Fri, Jan 22, 2021 at 10:40:05AM +0100, Eric Dumazet wrote:
> > > On Fri, Jan 22, 2021 at 9:55 AM Lukas Wunner <lukas@wunner.de> wrote:  
> > > > sch_handle_egress() returns either the skb or NULL to signal to its
> > > > caller __dev_queue_xmit() whether a packet should continue to be
> > > > processed.
> > > >
> > > > The skb is always non-NULL, otherwise __dev_queue_xmit() would hit a
> > > > NULL pointer deref right at its top.
> > > >
> > > > But the compiler doesn't know that.  So if sch_handle_egress() signals
> > > > success by returning the skb, the "if (!skb) goto out;" statement
> > > > results in a gratuitous NULL pointer check in the Assembler output.
> > > >
> > > > Avoid by telling the compiler that __dev_queue_xmit() is never passed a
> > > > NULL skb.  
> > [...]
> > > > we're about to add a netfilter egress hook to __dev_queue_xmit()
> > > > and without the micro-optimization, it will result in a performance
> > > > degradation which is indeed measurable:  
> > [...]
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > +__attribute__((nonnull(1)))
> > > >  static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> > > >  {
> > > >         struct net_device *dev = skb->dev;  
> > > 
> > > It is a bit sad the compilers do not automatically get this knowledge
> > > from the very first instruction :
> > > 
> > >  struct net_device *dev = skb->dev;  
> > 
> > The compiler (gcc) is capable of doing that, but the feature was disabled by:
> > 
> >     commit a3ca86aea507904148870946d599e07a340b39bf
> >     Author: Eugene Teo <eteo@redhat.com>
> >     Date:   Wed Jul 15 14:59:10 2009 +0800
> >     
> >     Add '-fno-delete-null-pointer-checks' to gcc CFLAGS
> > 
> > If -fno-delete-null-pointer-checks is dropped from the top-level Makefile
> > then the gratuitous NULL pointer checks disappear from the Assembler output,
> > obviating the need to litter hot paths with __attribute__((nonnull(1)))
> > annotations.
> > 
> > Taking a closer look at that commit, its rationale appears questionable:
> > It says that broken code such as ...
> > 
> > 	struct agnx_priv *priv = dev->priv;
> > 
> > 	if (!dev)
> > 		return;
> > 
> > ... would result in the NULL pointer check being optimized away.
> > The commit message claims that keeping the NULL pointer check in
> > "makes it harder to abuse" the broken code.
> > 
> > I don't see how that's the case:  If dev is NULL, the NULL pointer
> > dereference at the function's top causes termination of the task
> > in kernel/exit.c:do_exit().  So the NULL pointer check is never
> > reached by the task.  If on the other hand dev is non-NULL,
> > the task isn't terminated but then the NULL pointer check is
> > unnecessary as well.
> > 
> > So the point of the commit remains elusive to me.  I could submit
> > an RFC patch which drops -fno-delete-null-pointer-checks and see
> > if any security folks cry foul.  Thoughts?
> 

This was a famous tun.c bug back in the day.  In those days we weren't
careful to disallow remapping NULL to a different pointer.  See
/proc/sys/vm/mmap_min_addr.  The exploit was to remap NULL to be a valid
user controlled pointer.  It should have been impossible to exploit
because the code had a check for NULL, but the compiler optimized it
away.

https://lwn.net/Articles/342330/

> I wonder if modern compilers can't simply warn about this particular
> case. Not to mention our static checkers..
> 
> 
> Dan, do you think the concern from the above-quoted commit is still
> valid? Is this something that smatch flags these days? We're apparently
> paying a real performance price in networking for tying compiler's hands
> with -fno-delete-null-pointer-checks

If I had to guess why GCC doesn't warn about this I would say that
probably it's because a lot of macros have NULL checks built in.  Most
static analysis tools have a warning about inconsistent NULL checks but
Smatch won't warn about it unless it can lead to a NULL dereference.
The fact that pointless NULL checks slow down the code has never
bothered anyone up to now.

regards,
dan carpenter
