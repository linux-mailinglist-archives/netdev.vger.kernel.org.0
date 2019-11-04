Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388B5EE1BE
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 15:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfKDOAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 09:00:11 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43046 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbfKDOAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 09:00:11 -0500
Received: by mail-qt1-f194.google.com with SMTP id l24so5726630qtp.10
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 06:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G6Qz4EI18RwklMMJFIiU5fzMp4LfQdCJYG91bSVFyxw=;
        b=LunTGoqIbMs61RsEWGkC0deOxg0pXj68cvddX9HPKkPj/bXm34FykMFLMfzwpc/Oee
         EyCERLH45Jm+GedOoRWbQ1FEovC5qGUlPxg1NWK3D2g7CeT5W8MQO7G4t867IldyiLxF
         PjVG/1WWrFUi5cImrKhyIkF6N/BQ26lHbCjdISr76hU/5pRRKhU71tUC/VI8C3xvqQgK
         OIG2x8paJTKMRU6H5NMOi0nsHUlgirryM4//qlqq9R2VA/4D7Ba9nieg4n3w5Z+NX0Co
         HwW0G+bOzYDtM+XPFWMlLo6mYQHXk+m4ASFYIBRRJU1ipJdsCjQXYRrYlsau/thrTbFM
         Il0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G6Qz4EI18RwklMMJFIiU5fzMp4LfQdCJYG91bSVFyxw=;
        b=LtFZM3D6YF4UFLYvsQ0yqSknCkMNrVp+xMwOjlywXPfdn/W8nczDIxgYunRujknMhf
         BHFm7KgdPVodW8oInXANGxDAi4qCh2uevYrUtd6DUX23bRCTLmKabrUgYmmthMAHlya1
         JCC70xWYWe1i6c29qEPkoXSQWTzDFcXnt0qkDRUvNxYGsJo7jnFDDpoA9vVj5DRvnt6x
         c/YJHidH7R0by7doKiKobSCkvtkN8d208C8+qZAfMX6I9pMrzYVdjqkdhG1nWpgD1dK4
         3P5ikg/ugMCgUDYTrAKhTLxDwJOqa8335BO05A17DkB9PDKFLhx8M09gAgygZvhtnBGb
         008w==
X-Gm-Message-State: APjAAAXdG0EWx5FkYsxAguStJ34aYrk38l+e4BbtZcLVyzOs0xHf7ZzF
        GDHqdn0j5O2vNkDDChXChTmyKMxniFBqBq85g9k=
X-Google-Smtp-Source: APXvYqz2nN+fnAadDYhij2AQ/KsHrWMqTofFlVL9peGMRRYN9l65mwFPIk1Ot2IuAmrqTCphBwaUdJg9w7UqTBjBS0Y=
X-Received: by 2002:ad4:5891:: with SMTP id dz17mr22260198qvb.160.1572876010190;
 Mon, 04 Nov 2019 06:00:10 -0800 (PST)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1572618234-6904-6-git-send-email-xiangxia.m.yue@gmail.com> <CAOrHB_CkZJ+w3LvUyzUZRgnFa1JnkkKY85XsjEMvXD4geAzW4g@mail.gmail.com>
In-Reply-To: <CAOrHB_CkZJ+w3LvUyzUZRgnFa1JnkkKY85XsjEMvXD4geAzW4g@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Mon, 4 Nov 2019 05:59:27 -0800
Message-ID: <CALDO+SYq2FGK5i=LDxKx8GYAEF=juMRNSXe0URb+rvGog1FYTw@mail.gmail.com>
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

On Sat, Nov 2, 2019 at 11:50 PM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Fri, Nov 1, 2019 at 7:24 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > The full looking up on flow table traverses all mask array.
> > If mask-array is too large, the number of invalid flow-mask
> > increase, performance will be drop.
> >
> > One bad case, for example: M means flow-mask is valid and NULL
> > of flow-mask means deleted.
> >
> > +-------------------------------------------+
> > | M | NULL | ...                  | NULL | M|
> > +-------------------------------------------+
> >
> > In that case, without this patch, openvswitch will traverses all
> > mask array, because there will be one flow-mask in the tail. This
> > patch changes the way of flow-mask inserting and deleting, and the
> > mask array will be keep as below: there is not a NULL hole. In the
> > fast path, we can "break" "for" (not "continue") in flow_lookup
> > when we get a NULL flow-mask.
> >
> >          "break"
> >             v
> > +-------------------------------------------+
> > | M | M |  NULL |...           | NULL | NULL|
> > +-------------------------------------------+
> >
> > This patch don't optimize slow or control path, still using ma->max
> > to traverse. Slow path:
> > * tbl_mask_array_realloc
> > * ovs_flow_tbl_lookup_exact
> > * flow_mask_find
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > Tested-by: Greg Rose <gvrose8192@gmail.com>
> > ---
> Acked-by: Pravin B Shelar <pshelar@ovn.org>

Nack to this patch.

It makes the mask cache invalid when moving the flow mask
to fill another hole.
And the penalty for miss the mask cache is larger than the
benefit of this patch (avoiding the NULL flow-mask).

William
