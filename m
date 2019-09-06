Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFDAB295
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 08:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388555AbfIFGrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 02:47:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43964 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfIFGrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 02:47:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id q17so561709wrx.10
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 23:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LBuxtOCPLu6tHjo7Yq/3w0nPkrOsdOeRxnW0hcFRCho=;
        b=SfxXVfnKc7BGqu/MCZrIUyeI4ZV9JorakO5YK0+b4cQvb2zKx9ho54RjX6kA/H/9Rw
         eSegpA71cZLEZTe0xRyTw/dNJwhZAx2ZFTFnWInDgGtd/BHnWWmTNW0GORY0yLrBt9dF
         4Jyh/m/q3FUaDfID5vr3Sv85bGVBcEriZNElc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LBuxtOCPLu6tHjo7Yq/3w0nPkrOsdOeRxnW0hcFRCho=;
        b=QGFk4FDQMdnUl43KTh7UyulgiBC6Y5HHQo9/rNyFZFofw7E7v/KaXORMjL1GTzmmHW
         +sJlVHzBYzzrv16khehF74EtWMp2rBZaynKEzO3cNSXqYj7JMIrfQ6mTDBzm/jNq70YG
         +xa1xkykPKfXvQSf6SXyG6LFqn8izNYvIRZZ1fTL506VpQo+LVr7df2/DupK4otn5l9r
         Ak0acDMrQQS/QPlCNwXKssKdTiKNoaI3mJ0rk4Ho5pBgiUrud2D734n5GNnE9eqbs9mC
         1Zgaj7FD+JL6lFHqo4ZZeUkl/SBe6iXDL1RLfPn+a3WOk7+PfEWjFmpjyxY9Ao3IEK6a
         bFdg==
X-Gm-Message-State: APjAAAV2bm1hyksNbHbM7dmkWZgA1cnDP33bDFZHoX6m3QMrwXUSI32K
        SqKBE/zhqh9uah+kVubEAy290DwSBoxBbA==
X-Google-Smtp-Source: APXvYqyQhLCDiMEeazq2E9r2iJPTNdYNJZHr9l34TcUWIEVaVqvJ3JFsBIlSY2n9dt6+orBTe3YaCA==
X-Received: by 2002:a5d:4408:: with SMTP id z8mr5591694wrq.106.1567752467480;
        Thu, 05 Sep 2019 23:47:47 -0700 (PDT)
Received: from pixies ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id j1sm6277790wrg.24.2019.09.05.23.47.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 05 Sep 2019 23:47:46 -0700 (PDT)
Date:   Fri, 6 Sep 2019 09:47:44 +0300
From:   Shmulik Ladkani <shmulik@metanetworks.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, eyal@metanetworks.com,
        netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
Message-ID: <20190906094744.345d9442@pixies>
In-Reply-To: <CAF=yD-J9Ax9f7BsGBFAaG=QU6CPVw6sSzBkZJOHRW-m6o49oyw@mail.gmail.com>
References: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
        <CAF=yD-J9Ax9f7BsGBFAaG=QU6CPVw6sSzBkZJOHRW-m6o49oyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Sep 2019 17:51:20 -0400
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> On Thu, Sep 5, 2019 at 2:36 PM Shmulik Ladkani <shmulik@metanetworks.com> wrote:
> >
> > +       if (mss != GSO_BY_FRAGS &&
> > +           (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
> > +               /* gso_size is untrusted.
> > +                *
> > +                * If head_skb has a frag_list with a linear non head_frag
> > +                * item, and head_skb's headlen does not fit requested
> > +                * gso_size, fall back to copying the skbs - by disabling sg.
> > +                *
> > +                * We assume checking the first frag suffices, i.e if either of
> > +                * the frags have non head_frag data, then the first frag is
> > +                * too.
> > +                */
> > +               if (list_skb && skb_headlen(list_skb) && !list_skb->head_frag &&
> > +                   (mss != skb_headlen(head_skb) - doffset)) {  
> 
> I thought the idea was to check skb_headlen(list_skb), as that is the
> cause of the problem. Is skb_headlen(head_skb) a good predictor of
> that? I can certainly imagine that it is, just not sure.

Yes, 'mss != skb_headlen(HEAD_SKB)' seems to be a very good predictor,
both for the test reproducer, and what's observered on a live system.

We *CANNOT* use 'mss != skb_headlen(LIST_SKB)' as the test condition.
The packet could have just a SINGLE frag_list member, and that member could
be a "small remainder" not reaching the full mss size - so we could hit
the test condition EVEN FOR NON gso_size mangled frag_list skbs -
which is not desired.

Also, is we test 'mss != skb_headlen(list_skb)' and execute 'sg=false'
ONLY IF 'list_skb' is *NOT* the last item, this is still bogus.
Imagine a gso_size mangled packet having just head_skb and a single
"small remainder" frag. This packet will hit the BUG_ON, as the
'sg=false' solution is now skipped according to the revised condition.

> Thanks for preparing the patch, and explaining the problem and
> solution clearly in the commit message. I'm pretty sure I'll have
> forgotten the finer details next time we have to look at this
> function again.

Indeed. Apparently I've been there myself few years back and forgot all
the gritty details :) see [0]

[0] https://patchwork.ozlabs.org/patch/661419/ 
