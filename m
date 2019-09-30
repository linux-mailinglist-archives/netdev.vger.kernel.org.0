Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A6C2B1E
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfI3X5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:57:09 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34843 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbfI3X5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:57:09 -0400
Received: by mail-io1-f67.google.com with SMTP id q10so43186816iop.2
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 16:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bdGkRO3c9VgU0ezFX7A/dKMILtCJSCMs3+QGCOpCIWw=;
        b=ViHQiKAEx1n562HpDMBYzNGmWGbUjQu2WyN2BxdJm0CGoFQrzJepbuznYDiQ6Tconj
         X9chgZOa4jRjgvc5MZXFk2B8Pf7AKViimqUBzXT+szgnLM6ND2VUDCa9lntWOLCB7QvM
         bgF51BgnNGbAGgr1wGbq94Txv1/itH9gmKo8yDqVMvyqNiVvkIG8hm5Q8Jb+aPX07+kA
         1X9OPo7k66k+Fl4q+P2Rcy951p+svQw72lFVpdda48DoFqU2Dq6weNp35j6GVKIC3nq9
         3ULLg0tp9zUG0rz9kYHgLyTSMK08zxvGHogt/fxcqqE9B+lCLHwOIyVaICCy3WvjiphW
         GkJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bdGkRO3c9VgU0ezFX7A/dKMILtCJSCMs3+QGCOpCIWw=;
        b=dc0LDkiW+UQ4clzUERycpWc9a796eV98pHYT3tUAAUPFTrIhIqJW/xby2UvLx7wgW7
         uY8XKVqFEKEqgx3DwOagCUbwPN6PHRBatlXLeGrfAQD0GwmgTxENA8dK3gZkQ7f4oqRr
         62F5UKYz6mcvi36vYYEpbLtPbeImacqyjRWDELMFyLYYjA7iWm3pfpnf/QGMuOC2h3zS
         w5/r0X3GwmdGOrOer7JMyj697NWkbO8FkyyzdyV30Ij4u+iydY2Bp5QG8iXudU88MzAD
         wzYOq2xuTVHQz9Ln34WblSHABCRJqT5ngLR2oyCDDgyO3TS6yhEXzc4pE6sELXFnxusf
         GSug==
X-Gm-Message-State: APjAAAV1QPCqo88h+zwnkQ8gvQkC3UoBIMV6PZRTBzqHNonxNbMt+g3l
        Nr1qT0/7/nbNwHy2/kLDaBFEGhopLHd0XIjE59c=
X-Google-Smtp-Source: APXvYqw9HonPf8idhyRHOLF3337kPdc2FXY47IEsPbO8e98Qmd1sOeEdgkcijjK8fUMjTR+6YRduAm9Yg6gRc6H+YSU=
X-Received: by 2002:a92:b743:: with SMTP id c3mr23457392ilm.237.1569887827927;
 Mon, 30 Sep 2019 16:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <1569881518-21885-1-git-send-email-johunt@akamai.com> <1569881518-21885-2-git-send-email-johunt@akamai.com>
In-Reply-To: <1569881518-21885-2-git-send-email-johunt@akamai.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 30 Sep 2019 16:56:56 -0700
Message-ID: <CAKgT0UfXYHDiz7uf51araHXTizRQpQgi8tDqNp6nX2YzeOoZ3A@mail.gmail.com>
Subject: Re: [PATCH 2/2] udp: only do GSO if # of segs > 1
To:     Josh Hunt <johunt@akamai.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 3:13 PM Josh Hunt <johunt@akamai.com> wrote:
>
> Prior to this change an application sending <= 1MSS worth of data and
> enabling UDP GSO would fail if the system had SW GSO enabled, but the
> same send would succeed if HW GSO offload is enabled. In addition to this
> inconsistency the error in the SW GSO case does not get back to the
> application if sending out of a real device so the user is unaware of this
> failure.
>
> With this change we only perform GSO if the # of segments is > 1 even
> if the application has enabled segmentation. I've also updated the
> relevant udpgso selftests.
>
> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  net/ipv4/udp.c                       |  5 +++--
>  net/ipv6/udp.c                       |  5 +++--
>  tools/testing/selftests/net/udpgso.c | 16 ++++------------
>  3 files changed, 10 insertions(+), 16 deletions(-)
>
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index be98d0b8f014..ac0baf947560 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -821,6 +821,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
>         int is_udplite = IS_UDPLITE(sk);
>         int offset = skb_transport_offset(skb);
>         int len = skb->len - offset;
> +       int datalen = len - sizeof(*uh);
>         __wsum csum = 0;
>
>         /*
> @@ -832,7 +833,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
>         uh->len = htons(len);
>         uh->check = 0;
>
> -       if (cork->gso_size) {
> +       if (cork->gso_size && datalen > cork->gso_size) {
>                 const int hlen = skb_network_header_len(skb) +
>                                  sizeof(struct udphdr);
>

So what about the datalen == cork->gso_size case? That would only
generate one segment wouldn't it?

Shouldn't the test really be "datalen < cork->gso_size"? That should
be the only check you need since if gso_size is 0 this statement would
always fail anyway.

Thanks.

- Alex
