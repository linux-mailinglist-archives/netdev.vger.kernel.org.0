Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC811BAFD6
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgD0U5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:57:44 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:56537 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgD0U5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 16:57:44 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b6468260
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 20:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=AvEurhU4+6kd2OO61OqnKjgNqmk=; b=Y/fRWU
        EXc4VsBC4WFXam+OLo6THyUyLYFMcNSriF/40NzretUIGr0PmKLH412PCmS+KPnq
        IwRQhATcedbtU+AnltR7cngB8LIJVxDeULa/DykX2q2XXmvaCrkSIn6W/zohE4Zg
        ukFSBc3dENxBq7Xah9iQyeG7mrQQwMDvow9Bv67C5kzqDCDtuOhFV2QY4ErD1MJx
        8r1LaScffqHJylpKbfe4JFHyP7JR7KvQjKKwxgYOYXqyq4ZLyOykfU4C1PPCwPmH
        glTKviA11HGe/EBoxVgvLKkNUYEENmPGV027b6ourwCiWfAA2TXnyOEnEled1JHj
        7B+V8AHfi38zCp3w==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 37b8decf (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 20:46:08 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id o127so20505350iof.0
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:57:41 -0700 (PDT)
X-Gm-Message-State: AGi0PuarIfALJvN29zTR3Iy/zQcuZvDugljNRZoLc5mh5cw49JxzpWVp
        0Vm3q0X392nx/6HWf/q8jsfYB+X0G8xVvwb3asA=
X-Google-Smtp-Source: APiQypIPMBW30M2uFbZr5icYdDrjjc8yjC/Y1quiUvSSgOqZCxCToVFIQDT4VE/3UxZu1UIUgKfOPQ+ycGDH0ClI0NE=
X-Received: by 2002:a6b:510d:: with SMTP id f13mr22987668iob.25.1588021060916;
 Mon, 27 Apr 2020 13:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
 <20200427204208.2501-1-Jason@zx2c4.com> <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Apr 2020 14:57:29 -0600
X-Gmail-Original-Message-ID: <CAHmME9p8YqGgW6Js-M_87-PD29q0ywZ8co-0bimy_DoKjruOFQ@mail.gmail.com>
Message-ID: <CAHmME9p8YqGgW6Js-M_87-PD29q0ywZ8co-0bimy_DoKjruOFQ@mail.gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 2:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> Is this going to work correctly with XDP_TX? presumably wireguard
> doesn't want the ethernet L2 on egress, either? And what about
> redirects?

I'll probably need to augment this patch to handle XDP_TX. I'm not
sure how redirects work, but I'm guessing I'll need to add the
pseudoheader there too? Or are the semantics there even weirder?

>
> I'm not sure we can paper over the L2 differences between interfaces.
> Isn't user supposed to know what interface the program is attached to?
> I believe that's the case for cls_bpf ingress, right?

That was my initial intuition too (see my v1), but Toke said that XDP
prefers having L2 everywhere, which is what motivated the L2-emulation
route that this v3 patch takes. The advantage of my v1 approach is
that it's closer to the truth and likely performs slightly better. The
advantage of the v3 approach is that existing XDP programs don't need
to worry about differences. I don't have a preference either way, and
I'm happy to implement either approach. Let me know what you guys
prefer.

Jason
