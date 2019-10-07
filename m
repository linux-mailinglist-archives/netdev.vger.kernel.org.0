Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE04CEED6
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 00:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfJGWIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 18:08:53 -0400
Received: from correo.us.es ([193.147.175.20]:44250 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbfJGWIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 18:08:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4668C81402
        for <netdev@vger.kernel.org>; Tue,  8 Oct 2019 00:08:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 359C9DA840
        for <netdev@vger.kernel.org>; Tue,  8 Oct 2019 00:08:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 299A5DA7B6; Tue,  8 Oct 2019 00:08:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2666EB7FFE;
        Tue,  8 Oct 2019 00:08:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Oct 2019 00:08:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 05E81426CCBB;
        Tue,  8 Oct 2019 00:08:45 +0200 (CEST)
Date:   Tue, 8 Oct 2019 00:08:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Linux NetDev <netdev@vger.kernel.org>
Subject: Re: nf_conntrack_in() - is there a leak here?
Message-ID: <20191007220847.s73l3x5tt74bzdxf@salvia>
References: <CANP3RGdV1Rwkik21CmWq+3hreB-j5aRzLjwuxEvU3DuKdjK+mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGdV1Rwkik21CmWq+3hreB-j5aRzLjwuxEvU3DuKdjK+mg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Oct 07, 2019 at 07:10:37AM -0700, Maciej Żenczykowski wrote:
> unsigned int
> nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
> {
>         enum ip_conntrack_info ctinfo;
>         struct nf_conn *ct, *tmpl;
>         u_int8_t protonum;
>         int dataoff, ret;
> 
>         tmpl = nf_ct_get(skb, &ctinfo);
>                           <-----------
>         if (tmpl || ctinfo == IP_CT_UNTRACKED) {
>                 /* Previously seen (loopback or untracked)?  Ignore. */
>                 if ((tmpl && !nf_ct_is_template(tmpl)) ||
>                      ctinfo == IP_CT_UNTRACKED) {
>                         NF_CT_STAT_INC_ATOMIC(state->net, ignore);
>                         return NF_ACCEPT;
>                              <----------
>                 }
>                 skb->_nfct = 0;
>         }
> 
>         /* rcu_read_lock()ed by nf_hook_thresh */
>         dataoff = get_l4proto(skb, skb_network_offset(skb), state->pf,
> &protonum);
>         if (dataoff <= 0) {
>                 pr_debug("not prepared to track yet or error occurred\n");
>                 NF_CT_STAT_INC_ATOMIC(state->net, error);
>                 NF_CT_STAT_INC_ATOMIC(state->net, invalid);
>                 ret = NF_ACCEPT;
>                 goto out;
>         }
> 
> ...
> 
> out:
>         if (tmpl)
>                 nf_ct_put(tmpl);
>                        <---------
> 
>         return ret;
> }
> EXPORT_SYMBOL_GPL(nf_conntrack_in);
> 
> ---
> 
> Do we leak a nf_ct_get() on tmpl at that first 'return NF_ACCEPT' ?
> ie. should it be 'ret = NF_ACCEPT; goto out;'

This patch only entered for loopback and untracked traffic, in such
case the special handling for the template is not required (because
there is no template conntrack in place).

> I'm confused by:
>   include/net/netfilter/nf_conntrack.h:65:
>   * beware nf_ct_get() is different and don't inc refcnt.

Yes, this call has this semantics since the very beginning IIRC.

> (internal reference b/141976661 & b/135110479 where we're getting kmemleak
> complaints on 4.14 LTS,
>  which would possibly be shut up by this 4.17 'silence fix', but:)
> 
> I have this gut feeling that:
>   commit 114aa35d06d4920c537b72f9fa935de5dd205260
>   'netfilter: conntrack: silent a memory leak warning'
> is bogus...
> 
> By my understanding of kmemleak, such gymnastics shouldn't be needed.
> And there's no other users in the network stack of kmemleak_not_leak()
> [except for 2 staging drivers].

Probably, are you observing a memleak there in conntrack? I see you
searching for reason :-)
