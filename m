Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB49E5EFDD1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 21:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiI2TUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 15:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiI2TUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 15:20:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97AC872B47;
        Thu, 29 Sep 2022 12:20:45 -0700 (PDT)
Date:   Thu, 29 Sep 2022 21:20:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, nathan@kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] net: netfilter: move bpf_ct_set_nat_info kfunc
 in nf_nat_bpf.c
Message-ID: <YzXwCggIANDo9Gyu@salvia>
References: <ddd17d808fe25917893eb035b20146479810124c.1664111646.git.lorenzo@kernel.org>
 <6cf2c440-79a6-24ce-c9bb-1f1f92af4a0b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6cf2c440-79a6-24ce-c9bb-1f1f92af4a0b@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 12:13:45PM -0700, Martin KaFai Lau wrote:
> On 9/25/22 6:26 AM, Lorenzo Bianconi wrote:
> > Remove circular dependency between nf_nat module and nf_conntrack one
> > moving bpf_ct_set_nat_info kfunc in nf_nat_bpf.c
> > 
> > Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
> > Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Tested-by: Nathan Chancellor <nathan@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   include/net/netfilter/nf_conntrack_bpf.h |  5 ++
> >   include/net/netfilter/nf_nat.h           | 14 +++++
> >   net/netfilter/Makefile                   |  6 ++
> >   net/netfilter/nf_conntrack_bpf.c         | 49 ---------------
> >   net/netfilter/nf_nat_bpf.c               | 79 ++++++++++++++++++++++++
> >   net/netfilter/nf_nat_core.c              |  2 +-
> >   6 files changed, 105 insertions(+), 50 deletions(-)
> >   create mode 100644 net/netfilter/nf_nat_bpf.c
> > 
> > diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> > index c8b80add1142..1ce46e406062 100644
> > --- a/include/net/netfilter/nf_conntrack_bpf.h
> > +++ b/include/net/netfilter/nf_conntrack_bpf.h
> > @@ -4,6 +4,11 @@
> >   #define _NF_CONNTRACK_BPF_H
> >   #include <linux/kconfig.h>
> > +#include <net/netfilter/nf_conntrack.h>
> > +
> > +struct nf_conn___init {
> > +	struct nf_conn ct;
> > +};
> >   #if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
> >       (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
> > diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
> > index e9eb01e99d2f..cd084059a953 100644
> > --- a/include/net/netfilter/nf_nat.h
> > +++ b/include/net/netfilter/nf_nat.h
> > @@ -68,6 +68,20 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
> >   #endif
> >   }
> > +#if (IS_BUILTIN(CONFIG_NF_NAT) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
> > +    (IS_MODULE(CONFIG_NF_NAT) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
> > +
> > +extern int register_nf_nat_bpf(void);
> > +
> > +#else
> > +
> > +static inline int register_nf_nat_bpf(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +#endif
> > +
> 
> This looks similar to the ones in nf_conntrack_bpf.h.  Does it belong there
> better?  No strong opinion here.
> 
> The change looks good to me.  Can someone from the netfilter team ack this
> piece also?

Could you move this into nf_conntrack_bpf.h ?
