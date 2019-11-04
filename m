Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41716EEF6E
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389081AbfKDWV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:21:29 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:38014 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388233AbfKDWV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 17:21:28 -0500
Received: by mail-vk1-f193.google.com with SMTP id o82so2297985vka.5
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 14:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qlHVggnYKU4yg6Aco9hLyLl36Ze/VmjU5mUbYlr/NoI=;
        b=CZO6qmnCPwuKWRuyF1lQ9cHFrsSh1v+TrfRjil+EkFmbzHAEBK5aT/BamIyt8KzG++
         9dZjCTjXSAOdb3msR7/rYSjY7us/Bv1xvL4En0xVLyI09kOpuyD0JXo48yS0LcLoWpD+
         q1srBSPEr9Uy16ATjfImLzUtc7xE62QPP8RkXW0Q4P7JcKe6OUWPEybPiBVHSDJ5NSlW
         d0Pd9g2uMOYLHgslaw7+jlzK9RycM0EiJ+KUqzlEpfaMrc43U7p4btCsdzK4I2uak4yL
         +MF29+UFeZP+X5s28S8gQZKvK7t28tic7zJ2PvtaaquRsZdwNV9UPF9RVxwJHzofHuz5
         KKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qlHVggnYKU4yg6Aco9hLyLl36Ze/VmjU5mUbYlr/NoI=;
        b=OgPhJsaX6Uab87sns5yrqzA3+4i8UGgLJaBYh7aBnCipU1N1XWEFwWL3RyKQ1tQCWE
         vQq20BW6snu5FUSSeIYCqCxrTZTSrzUtx9TQq75M/RNWft/3N4Ab28eVkCQoLsrrVCq5
         ZRHpkvu9Cnizy0qk62hLUhYgLpXcbk/VE1+uIdun0ahmXL/y6eZlAtfPIyQiAatrZueS
         8us/kzdzw1GyxBaqXxQaIyKzcpJdE0Xah6k5TpL787xk07OxSK9tht97z8ZN+vXGkXZ7
         8YVvfpQ7SVFNsmBQlh5S/HPrj6egI1titwKEDxpXFBgbFlKhQW3WKTyIG71ZH+NqvMxw
         NkvQ==
X-Gm-Message-State: APjAAAUBaODXgiIiwXicdxgFMQ/YNG2Zm7u5TOX65/lr2RgsJM4aTVSE
        eBaHd7NT4VkT5NfH4V+Qn+PlZAugjWPNle3GQc/8Q4JcYRQ=
X-Google-Smtp-Source: APXvYqwyLRwB8QPnGnFfW/sKyFh5vJFx0Ur1w+RDPFinWqOm8+HPiehJRA8QCgrFeBQGd7Z9YwD7VQwEIAujLuA+Ykw=
X-Received: by 2002:a1f:41c4:: with SMTP id o187mr12614740vka.102.1572906086939;
 Mon, 04 Nov 2019 14:21:26 -0800 (PST)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1572618234-6904-6-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_CkZJ+w3LvUyzUZRgnFa1JnkkKY85XsjEMvXD4geAzW4g@mail.gmail.com>
 <CALDO+SYq2FGK5i=LDxKx8GYAEF=juMRNSXe0URb+rvGog1FYTw@mail.gmail.com> <CAOrHB_CHSY3UQJgwYeP1p7LHHkf8OFdNSUJLvZGxw8SOvdrd0g@mail.gmail.com>
In-Reply-To: <CAOrHB_CHSY3UQJgwYeP1p7LHHkf8OFdNSUJLvZGxw8SOvdrd0g@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Mon, 4 Nov 2019 14:20:50 -0800
Message-ID: <CALDO+Sb2=w_15-R-CtmLHjZ0JdQMzOvhmgnp7TyU-F13w61NAg@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v6 05/10] net: openvswitch: optimize
 flow-mask looking up
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 4, 2019 at 2:10 PM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Mon, Nov 4, 2019 at 6:00 AM William Tu <u9012063@gmail.com> wrote:
> >
> > On Sat, Nov 2, 2019 at 11:50 PM Pravin Shelar <pshelar@ovn.org> wrote:
> > >
> > > On Fri, Nov 1, 2019 at 7:24 AM <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > The full looking up on flow table traverses all mask array.
> > > > If mask-array is too large, the number of invalid flow-mask
> > > > increase, performance will be drop.
> > > >
> > > > One bad case, for example: M means flow-mask is valid and NULL
> > > > of flow-mask means deleted.
> > > >
> > > > +-------------------------------------------+
> > > > | M | NULL | ...                  | NULL | M|
> > > > +-------------------------------------------+
> > > >
> > > > In that case, without this patch, openvswitch will traverses all
> > > > mask array, because there will be one flow-mask in the tail. This
> > > > patch changes the way of flow-mask inserting and deleting, and the
> > > > mask array will be keep as below: there is not a NULL hole. In the
> > > > fast path, we can "break" "for" (not "continue") in flow_lookup
> > > > when we get a NULL flow-mask.
> > > >
> > > >          "break"
> > > >             v
> > > > +-------------------------------------------+
> > > > | M | M |  NULL |...           | NULL | NULL|
> > > > +-------------------------------------------+
> > > >
> > > > This patch don't optimize slow or control path, still using ma->max
> > > > to traverse. Slow path:
> > > > * tbl_mask_array_realloc
> > > > * ovs_flow_tbl_lookup_exact
> > > > * flow_mask_find
> > > >
> > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > Tested-by: Greg Rose <gvrose8192@gmail.com>
> > > > ---
> > > Acked-by: Pravin B Shelar <pshelar@ovn.org>
> >
> > Nack to this patch.
> >
> > It makes the mask cache invalid when moving the flow mask
> > to fill another hole.
> > And the penalty for miss the mask cache is larger than the
> > benefit of this patch (avoiding the NULL flow-mask).
> >
> Hi William,
>
> The cache invalidation would occur in case of changes to flow mask
> list. I think in general datapath processing there should not be too
> many changes to mask list since a mask is typically shared between
> multiple mega flows. Flow-table changes does not always result in mask
> list updates. In last round Tonghao has posted number to to support
> this patch.
> If you are worried about some other use case can you provide
> performance numbers, that way we can take this discussion forward.
>
I see, I don't have any use case to provide.
Thanks,
William
