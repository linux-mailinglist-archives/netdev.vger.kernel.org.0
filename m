Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2436619809E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgC3QLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:11:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54568 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3QLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:11:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id c81so20544921wmd.4
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 09:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wuIL3dpgBGs3RFudv7zV0iYRJt82al6XSb3+T17EDpk=;
        b=Fsf0vB9XtMer+vnYhWTjCr0ij5HefSSwzYRAq9HrkPpYd5OsFPAWabbBkyAWW/EOG+
         xOpF2Fs7cS1/oz2kE/44IFSaNI/+kO+VK7ARYYL3cGAHF/vRakQ25nYAcB3u7477qqTU
         NjciCEnQNh67vY35nwmqkCUnrwB+SJ2dURem+NQOStVfQO3T9a7lPgrCiCVv/npemKoI
         ltwkk5D0Zp9vpQyxRueDGD4fUZyXlIzWti7kHaxiK9/V5vdCspJO2e+kx7fXyqzl0bfE
         S6qughigq2cfn8PR4EouDn9U+jid+jQmMQuOjPL7N6XlRMHxF5TBXPorl9pnafHPSjmE
         STnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wuIL3dpgBGs3RFudv7zV0iYRJt82al6XSb3+T17EDpk=;
        b=HphdmI3mYbx3GZk1HsYRDq5qycesG5S4bkUoVBMo11wovuh5zeMKlT1MI+1w476AvC
         +tGU9MrLD807518JIKTVOieEOPhW/ZZGZKnWu2vk3s0xXcwbjsDkkLqRHxQ3JBn1Ld0Q
         GCvcl8hGvzvWcs4SPIQ/gHhoTIHLhIKBV/dHEosy2CNZ7DfWkKlV6yu+C5Yj1fzF4wkQ
         M4iTGhVL69a8u9Bc0fkk+cy2OpEwAiwT9dPsJGqCLTXvGIgQmBER5WPhehgBROr4KUSm
         Nep1RPd8ACVCXGlIrWpRbwFupUE6DHj0Cf3yXpzyDh9C7qLzDa1AtT6KA8mosIhpnBov
         yfgw==
X-Gm-Message-State: ANhLgQ1cKQrPG2nnHQM1xHSipZUKzm+9Ej8XNOA3MXl47xkvIpGkuMZ3
        ycDi0LGxLQNp6o2uIb5/gVbauid6kE4TcscTXWwfo/Wu
X-Google-Smtp-Source: ADFU+vviJiDSZQTm6KccRRWaWn+NFgNNGvl5N57yByI6bXbAH5JQrfERFXR+2quIuEnSlEEdYDQr67cspQgQtE/8LXw=
X-Received: by 2002:a7b:cde8:: with SMTP id p8mr24762wmj.87.1585584678509;
 Mon, 30 Mar 2020 09:11:18 -0700 (PDT)
MIME-Version: 1.0
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
 <20200330132759.GA31510@strlen.de>
In-Reply-To: <20200330132759.GA31510@strlen.de>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 31 Mar 2020 00:14:46 +0800
Message-ID: <CADvbK_c9H4MtiQ1bMD3-jXUM_8LRxVC-KaHKyX1r7bhKuxwimg@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix a skb extensions leak
To:     Florian Westphal <fw@strlen.de>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 9:28 PM Florian Westphal <fw@strlen.de> wrote:
>
> Xin Long <lucien.xin@gmail.com> wrote:
> > On udp rx path udp_rcv_segment() may do segment where the frag skbs
> > will get the header copied from the head skb in skb_segment_list()
> > by calling __copy_skb_header(), which could overwrite the frag skbs'
> > extensions by __skb_ext_copy() and cause a leak.
> >
> > This issue was found after loading esp_offload where a sec path ext
> > is set in the skb.
> >
> > On udp tx gso path, it works well as the frag skbs' extensions are
> > not set. So this issue should be fixed on udp's rx path only and
> > release the frag skbs' extensions before going to do segment.
> > Reported-by: Xiumei Mu <xmu@redhat.com>
> > Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
>
> Hmm, I suspect this bug came in via
> 3a1296a38d0cf62bffb9a03c585cbd5dbf15d596 , net: Support GRO/GSO fraglist chaining.
>
> I suspect correct fix is:
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 621b4479fee1..7e29590482ce 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3668,6 +3668,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>
>                 skb_push(nskb, -skb_network_offset(nskb) + offset);
>
> +               skb_release_head_state(nskb);
>                  __copy_skb_header(nskb, skb);
>
>                 skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
>
> AFAICS we not only leak reference of extensions, but also skb->dst and skb->_nfct.
Works for this issue.

Tested-by: Xin Long <lucien.xin@gmail.com>
