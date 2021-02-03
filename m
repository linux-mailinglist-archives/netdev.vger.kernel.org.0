Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E9330E45C
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhBCUzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbhBCUzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 15:55:13 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0986C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 12:54:32 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id e7so539981ile.7
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 12:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fPZNyJ8NMHQ37PoH5xC2bhsmFJbL8QJzybD68NSCVXw=;
        b=nlGUYFFVPb+QmUY0zwNXMeN60HeS5ojgcYJZUZGFwi2QRJFRUMBkGSNhhb42/uO5kT
         qCKEf+EzYJwlKdfbbYHBt5d88EmjSmHUtVqA08lzPcHQNCa3stUBdFQ5q6836cYG1g71
         b3LflfeWxXcxHAr8z/fHO/h3bHvIPEFm1FsZNEPCpehfwZs2SprI9ExiCC1QKUb/kOSE
         kSxapYIrw6uKuL82HzgIzRA0l0wNP8QMJBsVBiUvcpny+vaNjTGfUQ4v6VnbKxuPhaqR
         NAh6BRcqCxcbY0Hr/eTQJqhRFkRwZG1WBsV4oTloossYpcrsfYd8CFzJVRAAkJQyshxa
         0nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fPZNyJ8NMHQ37PoH5xC2bhsmFJbL8QJzybD68NSCVXw=;
        b=ooazukgatQmCnf/ysRG73sQhI6JE93z+cAx1I/89Efjrsjva/giU70CBRWZQjtuOd6
         bCvnwW1AYgCeLttD1v+xOlfjrJ1OTllkrDWqICloPJzBzl8oXYgsHR4Rou11q6tlZ90K
         b7VH0q0ORbI6VhlYyIZIHBRjwYgnL+ghZUVCsu2xsmpq3t80b0nIhyqi+PxbDwjEoP7D
         yFgwH37/O/B+20zKjZc4hIOQtv/RdT3iPmULyvLVLaorrhZq7d8QU0fc6Xm21LVOYojH
         LnThmE4uKXqv1cc1OWBXrVskgXAHTL03/xYY7WhPVGMkzlkT9mIjTyWd2RJPWU52kJ6Y
         5xpQ==
X-Gm-Message-State: AOAM532X8I7JZtQXJTDFR6Z/x0E7rV3L/Mu8SqFTT028uETsVNKrO4fx
        rIZPN3hYSAQfU5eqJfElowFM25zXthpIYP/Vqns=
X-Google-Smtp-Source: ABdhPJw80yEcQvwEZO6i9Ak9ol16v6o/UzgK/5xFLoM/Y4K3s6OI/4k3EJiXqFucjgyILdPsEvT4vARo719LBv05Hwk=
X-Received: by 2002:a05:6e02:2196:: with SMTP id j22mr4051027ila.64.1612385672197;
 Wed, 03 Feb 2021 12:54:32 -0800 (PST)
MIME-Version: 1.0
References: <20210203192952.1849843-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210203192952.1849843-1-willemdebruijn.kernel@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 3 Feb 2021 12:54:21 -0800
Message-ID: <CAKgT0Ue6YFY-t3KS4avzDFE1hLtC=KVZqOdxLTbnOhk9=hW5KQ@mail.gmail.com>
Subject: Re: [PATCH net v2] udp: fix skb_copy_and_csum_datagram with odd
 segment sizes
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, oliver.graute@gmail.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 11:29 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> When iteratively computing a checksum with csum_block_add, track the
> offset "pos" to correctly rotate in csum_block_add when offset is odd.
>
> The open coded implementation of skb_copy_and_csum_datagram did this.
> With the switch to __skb_datagram_iter calling csum_and_copy_to_iter,
> pos was reinitialized to 0 on each call.
>
> Bring back the pos by passing it along with the csum to the callback.
>
> Changes v1->v2
>   - pass csum value, instead of csump pointer (Alexander Duyck)
>
> Link: https://lore.kernel.org/netdev/20210128152353.GB27281@optiplex/
> Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")
> Reported-by: Oliver Graute <oliver.graute@gmail.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
