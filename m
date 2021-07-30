Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540303DB909
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbhG3NIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:08:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230445AbhG3NIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 09:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627650505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XNX7LrOg5E55DuFIga5daNfccGkmR+clBL7QGfOZ0nU=;
        b=THgE8IYqW3nGiPNa+vyhC0GUIBUUczrCurrTVjj8mTF7x3pQySbQkrdV8OF2UECfr7h1mO
        C+agl618wIapozUka9MRfqFvqWimyY9kgj9YPwhnzj5Q3GqUry6E2F8xU8fK5ER83icQw4
        ay2HWVwNjVLxVxDZudM94ULhTaBy350=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-2lUwpdnTOHWneHSIUsD6TQ-1; Fri, 30 Jul 2021 09:08:23 -0400
X-MC-Unique: 2lUwpdnTOHWneHSIUsD6TQ-1
Received: by mail-wm1-f72.google.com with SMTP id r2-20020a05600c35c2b029023a3f081487so3255209wmq.4
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 06:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XNX7LrOg5E55DuFIga5daNfccGkmR+clBL7QGfOZ0nU=;
        b=MprmBaMiCmeeJR9F8rexq9WWfWBny2+ys0zXA0f9xpVbLo5tcHzAl1eOVXTZaBo9zT
         59cIOApHZ3Dn5n4ZuAy40NzMcH9WPJMpEaed0QM9upLxH2QsYokb7eZs771NZGGwgJg1
         sMwAMXfhyu42LGKyvCBqR/ZltXPJ0Z+FEzKnoKKqhItt8oyi/jS+zQn7WnfWN+N0R6+V
         Q3AkXC44ugdA3kesxRMMrCmy+oKy1dvFAszMTXUVr/xhMa6z+zR7sawRK7SHZ9F/1Q/O
         ueoP/jPUi996r1/2GGPeefdrU54lCaIKL/bPlB5QyHJMcMsdP9anWOqLvyQv5Bpxd6km
         s3Xg==
X-Gm-Message-State: AOAM533bRmdBvfewS8Xuj0KaJBPvKKgXNFT+5nn/siJQZHs1sJ4qL6VZ
        uOXqb2NduF1wPwCnJ/a3A8VIhnFDY8X+STOyPdAswndU4szFhoHJamfR1wNXvfB3JWqhxy384oF
        Eln5dOtoKnLn5cokX
X-Received: by 2002:a5d:6789:: with SMTP id v9mr3048046wru.254.1627650502567;
        Fri, 30 Jul 2021 06:08:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz603QoWahIQk60kQHC/1IQJSwgPGBtQGo4bfsue/+cGFNy843nJi1UQeuWIbEMdK3pavj0nA==
X-Received: by 2002:a5d:6789:: with SMTP id v9mr3048022wru.254.1627650502398;
        Fri, 30 Jul 2021 06:08:22 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-57.dyn.eolo.it. [146.241.97.57])
        by smtp.gmail.com with ESMTPSA id j140sm1634850wmj.37.2021.07.30.06.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 06:08:22 -0700 (PDT)
Message-ID: <f0ff7f0a006a470f85fd4ec4b149834bef875e26.camel@redhat.com>
Subject: Re: [PATCH net-next 2/6] sk_buff: track dst status in slow_gro
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Date:   Fri, 30 Jul 2021 15:08:20 +0200
In-Reply-To: <20210730040824.097e0e9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1627405778.git.pabeni@redhat.com>
         <a6d684d37ca7598dc89b1ff886f9b049393f0d99.1627405778.git.pabeni@redhat.com>
         <20210730040824.097e0e9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-07-30 at 04:08 -0700, Jakub Kicinski wrote:
> On Wed, 28 Jul 2021 18:24:00 +0200 Paolo Abeni wrote:
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 3ff18300d210..b1e5bbfcc926 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -992,6 +992,7 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
> >   */
> >  static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
> >  {
> > +	skb->slow_gro |= !!dst;
> >  	skb->_skb_refdst = (unsigned long)dst;
> >  }
> >  
> > @@ -1008,6 +1009,7 @@ static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
> >  static inline void skb_dst_set_noref(struct sk_buff *skb, struct dst_entry *dst)
> >  {
> >  	WARN_ON(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
> > +	skb->slow_gro = !!dst;
> 
> why is this one = and not |= ?

Mostly because I'm dumb. Sabrina Dubroca noted that already. I'll send
a follow-up ASAP.

Thanks!

Paolo

