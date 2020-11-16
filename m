Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0DE2B45E2
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgKPOb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729614AbgKPOb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 09:31:29 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4700DC0613CF;
        Mon, 16 Nov 2020 06:31:29 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kefXN-0006id-9l; Mon, 16 Nov 2020 15:31:21 +0100
Date:   Mon, 16 Nov 2020 15:31:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next v4] net: linux/skbuff.h: combine SKB_EXTENSIONS
 + KCOV handling
Message-ID: <20201116143121.GC22792@breakpoint.cc>
References: <20201116031715.7891-1-rdunlap@infradead.org>
 <ffe01857-8609-bad7-ae89-acdaff830278@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffe01857-8609-bad7-ae89-acdaff830278@tessares.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthieu Baerts <matthieu.baerts@tessares.net> wrote:
> > --- linux-next-20201113.orig/include/linux/skbuff.h
> > +++ linux-next-20201113/include/linux/skbuff.h
> > @@ -4137,7 +4137,6 @@ static inline void skb_set_nfct(struct s
> >   #endif
> >   }
> > -#ifdef CONFIG_SKB_EXTENSIONS
> >   enum skb_ext_id {
> >   #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> >   	SKB_EXT_BRIDGE_NF,
> > @@ -4151,12 +4150,11 @@ enum skb_ext_id {
> >   #if IS_ENABLED(CONFIG_MPTCP)
> >   	SKB_EXT_MPTCP,
> >   #endif
> > -#if IS_ENABLED(CONFIG_KCOV)
> >   	SKB_EXT_KCOV_HANDLE,
> > -#endif
> 
> I don't think we should remove this #ifdef: the number of extensions are
> currently limited to 8, we might not want to always have KCOV there even if
> we don't want it. I think adding items in this enum only when needed was the
> intension of Florian (+cc) when creating these SKB extensions.
> Also, this will increase a tiny bit some structures, see "struct skb_ext()".

Yes, I would also prefer to retrain the ifdef.

Another reason was to make sure that any skb_ext_add(..., MY_EXT) gives
a compile error if the extension is not enabled.

> So if we think it is better to remove these #ifdef here, we should be OK.
> But if we prefer not to do that, we should then not add stubs for
> skb_ext_{add,find}() and keep the ones for skb_[gs]et_kcov_handle().

Yes, exactly, I did not add these stubs because I could not figure out
a case where an empty skb_ext_{add,find} would be wanted.

If your code calls skb_ext_add() but no skb extensions exist you forgot
a SELECT/DEPENDS SKB_EXTENSIONS in Kconfig & compiler error would tell
you that.
