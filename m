Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738BA407A89
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 23:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbhIKViJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 17:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhIKViJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 17:38:09 -0400
X-Greylist: delayed 602 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Sep 2021 14:36:56 PDT
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E673C061574;
        Sat, 11 Sep 2021 14:36:55 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 90F0B300002A5;
        Sat, 11 Sep 2021 23:26:50 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 7DBB8275D2A; Sat, 11 Sep 2021 23:26:50 +0200 (CEST)
Date:   Sat, 11 Sep 2021 23:26:50 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH nf-next v4 4/5] netfilter: Introduce egress hook
Message-ID: <20210911212650.GA17551@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
 <979835dc887d3affc4e76464aa21da0e298fd638.1611304190.git.lukas@wunner.de>
 <4b36df57-ee60-78da-cc6a-fb443226c978@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b36df57-ee60-78da-cc6a-fb443226c978@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 08:13:19PM +0100, Daniel Borkmann wrote:
> On 1/22/21 9:47 AM, Lukas Wunner wrote:
> > Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
> > handle_ing() under unique static key") introduced the ability to
> > classify packets with netfilter on ingress.
> > 
> > Support the same on egress to satisfy user requirements such as:
[...]
> > The hook is positioned after packet handling by traffic control.
> > Thus, if packets are redirected into and out of containers with tc,
> > the data path is:
> > ingress: host tc -> container tc -> container nft
> > egress:  container tc -> host tc -> host nft
> > 
> > This was done to address an objection from Daniel Borkmann:  If desired,
> > nft does not get into tc's way performance-wise.  The host is able to
> > firewall malicious packets coming out of a container, but only after tc
> > has done its duty.  An implication is that tc may set skb->mark on
> > egress for nft to act on it, but not the other way round.
> [...]
> > @@ -4096,13 +4098,18 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   	qdisc_pkt_len_init(skb);
> >   #ifdef CONFIG_NET_CLS_ACT
> >   	skb->tc_at_ingress = 0;
> > -# ifdef CONFIG_NET_EGRESS
> > +#endif
> > +#ifdef CONFIG_NET_EGRESS
> >   	if (static_branch_unlikely(&egress_needed_key)) {
> >   		skb = sch_handle_egress(skb, &rc, dev);
> >   		if (!skb)
> >   			goto out;
> > +		if (nf_hook_egress_active()) {
> > +			skb = nf_hook_egress(skb, &rc, dev);
> > +			if (!skb)
> > +				goto out;
> > +		}
> 
> This won't work unfortunately, the issue is that this now creates an
> asymmetric path, for example:
>   [tc ingress] -> [nf ingress] -> [host] -> [tc egress] -> [nf egress].
> So any NAT translation done on tc ingress + tc egress will break on
> the nf hooks given nf is not able to correlate inbound with outbound
> traffic.
> 
> Likewise for container-based traffic that is in its own netns,
> one of the existing paths is:
>   [tc ingress (phys,hostns)] -> [tc ingress (veth,podns)] -> [reply] ->
>   [tc egress (veth,podns)] -> [tc ingress (veth,hostns)] ->
>   [nf egress (phys,hostns)*] -> [tc egress (phys,hostns)].
> As can be seen the [nf ingress] hook is not an issue at all given
> everything operates in tc layer but the [nf egress*] one is in this case,
> as it touches in tc layer where existing data planes will start to break
> upon rule injection.
> 
> Wrt above objection, what needs to be done for the minimum case is to
> i) fix the asymmetry problem from here, and
> ii) add a flag for tc layer-redirected skbs to skip the nf egress hook *;
> with that in place this concern should be resolved. Thanks!

Daniel, your reply above has left me utterly confused.  After thinking
about it for a while, I'm requesting clarification what you really want.
We do want the netfilter egress hook in mainline and we're happy to
accommodate to your requirements, but we need you to specify them clearly.

Regarding the data path for packets which are going out from a container,
I think you've erroneously mixed up the last two elements above:
If the nf egress hook is placed after tc egress (as is done in the present
patch), the data path is actually as follows:

  [tc egress (veth,podns)] -> [tc ingress (veth,hostns)] ->
  [tc egress (phys,hostns)] -> [nf egress (phys,hostns)*]

By contrast, if nf egress is put in front of tc egress (as you're
requesting above), the data path becomes:

  [nf egress (veth,podns)] -> [tc egress (veth,podns)] ->
  [tc ingress (veth,hostns)] ->
  [nf egress (phys,hostns)*] -> [tc egress (phys,hostns)]

So this order results in an *additional* nf egress hook in the data path,
which may cost performance.  Previously you voiced concerns that the
nf egress hook may degrade performance.  To address that concern,
we ordered nf egress *after* tc egress, thereby avoiding any performance
impact as much as possible.

I agree with your argument that an inverse order vis-a-vis ingress is
more logical because it avoids NAT incongruencies etc.  So I'll be happy
to reorder nf egress before tc egress.  I'm just confused that you're now
requesting an order which may be *more* detrimental to performance.

As a reminder:
- If no nf egress rules are in use on the system, there is no performance
  impact at all because the hook is patched out of the data path.
- If an interface on the system uses nf egress rules, all other interfaces
  suffer a minor performance impact because a NULL pointer check is
  performed for sk_buff->nf_hooks_egress for every packet.
- The actual netfilter processing only happens on the interface(s)
  for which nf egress rules have been configured.

You further request above to "add a flag for tc layer-redirected skbs
to skip the nf egress hook *".

However the data path *starts* with an nf egress hook.  So even if a flag
to skip subsequent nf egress processing is set upon tc redirect,
the initial nf egress hook is never skipped.  The benefit of such a flag
is therefore questionable, which is another source of confusion to me.

Again, please clarify what your concerns are and how they can be addressed.

Thanks,

Lukas
