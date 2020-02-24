Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2EE16B08C
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgBXTry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:47:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53784 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726687AbgBXTrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582573672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nnxs4S3V4j1u81O81rJrhpwntUjBUuBdMvRvoYKsH34=;
        b=YTI5fMyLAkEKQhvxgOkBWnerPPvu1wGjsp4NxEuHw48YqxS/fR5pr/dUQe2NDwqgpu1fIT
        pVaOJvdRP0glGWyND/VZBIR3WD1zYCpJzu9UYJbWSOjE1jZ2fg0UNaXyVMsMzslOVEN9tj
        t/kYwcCztFBwLAboo8oQNRRrAuJa0t4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-Eb7f9iWqMD2pZdIlP-Y_ow-1; Mon, 24 Feb 2020 14:47:50 -0500
X-MC-Unique: Eb7f9iWqMD2pZdIlP-Y_ow-1
Received: by mail-ed1-f69.google.com with SMTP id dd24so7449902edb.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 11:47:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nnxs4S3V4j1u81O81rJrhpwntUjBUuBdMvRvoYKsH34=;
        b=RIZo+eZzzL51WJPz+uAswcOGSuPx7dnR8WWFqLcKKai77Ppg9+0kfSDZapvnNj/ulf
         FeV3i2eKLZ7RS85LiGdOQu24W61Rb5jJhBgmOcvXsB6+DEhkqtWVI5AOgg7nwcEq62aS
         sT6piQCqw6+N+ZJL/xW0xEOIzuLHkbdhfZ2lWhRfsAJDrG1hdQC8/RKxgi+XJPenNZK3
         geu6gLEzW+qrvcLvwLPcHjKSymxzwb+XFmmHlNrZmlJ9P9Hz732pK8qyw7amiOT5LXJh
         atm0CpAyUHVBE7dYhrbD2zufpi2hq3HIFRMGLAJTHLHcQJKmF7EBohLsdkrd3XeWjKNQ
         UPuw==
X-Gm-Message-State: APjAAAUx/582efzzJBFEim2uUn3BJd/kYR1BvNG93cJkjfXgB+ZYBdnF
        iAIeF08KtdubPgdKrDrNszhkmwyj6vhHvsFGbSKSUFYQJaiGGzKHnFNIJypWKjwMf+jU3xM2H/l
        /pTMmiFpvLoNPZGinzApReR5eiXu/YznO
X-Received: by 2002:a17:906:ce57:: with SMTP id se23mr48387485ejb.362.1582573669098;
        Mon, 24 Feb 2020 11:47:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqytTPwGRqhKju/NQPHj9LOagQ32SFVcrzvfbIgfGBW57jVwx7rncRDFd0C3JXVggWYL8tobRTZVXYqtNRKtLfc=
X-Received: by 2002:a17:906:ce57:: with SMTP id se23mr48387474ejb.362.1582573668885;
 Mon, 24 Feb 2020 11:47:48 -0800 (PST)
MIME-Version: 1.0
References: <20200224185529.50530-1-mcroce@redhat.com> <20200224191154.GH19559@breakpoint.cc>
 <CAGnkfhyUOyd1XWdSSxL844RG-_z32qGasV7a+2m7XNrS8qvtCw@mail.gmail.com>
In-Reply-To: <CAGnkfhyUOyd1XWdSSxL844RG-_z32qGasV7a+2m7XNrS8qvtCw@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 24 Feb 2020 20:47:13 +0100
Message-ID: <CAGnkfhzA6j2B43DFgQedeGE6H5XvHKWd7KPg3ocGVr0K_u2NJA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ensure rcu_read_lock() in ipv4_find_option()
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 8:42 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Mon, Feb 24, 2020 at 8:12 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Matteo Croce <mcroce@redhat.com> wrote:
> > > As in commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in ipv4_link_failure()")
> > > and commit 3e72dfdf8227 ("ipv4: ensure rcu_read_lock() in cipso_v4_error()"),
> > > __ip_options_compile() must be called under rcu protection.
> >
> > This is not needed, all netfilter hooks run with rcu_read_lock held.
> >
>
> Ok, so let's drop it, thanks.

What about adding a RCU_LOCKDEP_WARN() in __ip_options_compile() to
protect against future errors? Something like:

----------------------------------%<-------------------------------------
@@ -262,6 +262,9 @@ int __ip_options_compile(struct net *net,
  unsigned char *iph;
  int optlen, l;

+ RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+ __FUNC__ " needs rcu_read_lock() protection");
+
  if (skb) {
  rt = skb_rtable(skb);
  optptr = (unsigned char *)&(ip_hdr(skb)[1]);
---------------------------------->%-------------------------------------

Bye,
-- 
Matteo Croce
per aspera ad upstream

