Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC55B1FFE2B
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgFRW3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgFRW3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:29:44 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D3FC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:29:43 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h39so3932822ybj.3
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0DW2Q87RDIqsYkxNfDBfLjQHExQB4ve4CO+kxbtwYA=;
        b=mjlBJPqMQn1HKw599yxONDAdbKeDRS0gWBEUFi3EQpmCXhRrnEWsT7xzzgi9PU9uON
         yDKbvEBRQRh7t2vojDwcI3Vprv+CDf10FEoobL8SasgDiZkJMtlRc0YNa60ZwcCDxhmN
         M/LgqFAtIBGUS3LNRPu5a+MMuYROr8iB6u7hqdXVbSD6ed1rDMpQBQ14hDYS1nfdIOWn
         +gDGLSH91jDsbmwoSk0BO6vrJbOavJl4GJgh4QfKW6D2DlTCRhibIuMKyxNpJ/QvxqBy
         0XBhPYWTBfPt22mVdWtIRJJnx2zYgzGopJTYNRJAriG51rm9QwP9YRCuDEXUpEnlJoL7
         esmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A0DW2Q87RDIqsYkxNfDBfLjQHExQB4ve4CO+kxbtwYA=;
        b=T7Gqu6uairuVxmpxWfEy9z1bL0jeN6C3MATQhhvsuoZWTnu3EqhxxFz/C91Yh3hIW2
         Aa+mGrKyrtLHmHKW2Kz12UZAuXPElRqQzFOxf/zsBwzxy9clcsxZurUwjbWiX5W+GEMk
         7CkrXma4nPLfrdtL/jflAa5WDo6qV3SG/BoBQlW1tx+cOcPXLm0JOiCZMS40mJUnEQhA
         41I+kNE4uQniqCquw15PUQCT0NpEJh58EXq+RS5ITdR6kOTNIInqeGoUTxJOf7h7hVGb
         gRd2wKKOcTm1Frl5fbYrDa6B1rBpnr1Tj8RojUXbv5LVr4bs08UkpN4ZHRorlsPi6W8V
         OJ4g==
X-Gm-Message-State: AOAM5331Xou4Etp1AWpFeMVc2wwwlSFrKwkCer+cYWSyv05mWOFHVyoi
        AkhQbzpRnQbTWl6p0LZZYauyq7eh0PxUo7xdokSlTBbbFpo=
X-Google-Smtp-Source: ABdhPJxlzKUAIrnYs65G0maMX2Bhh5yBmX/19RG2B8luGK9hiNx0YbCOBpk2RsTxRhtfWbO+KIRjd5VSyr9Q1QM5OnQ=
X-Received: by 2002:a25:b88d:: with SMTP id w13mr1395208ybj.520.1592519382302;
 Thu, 18 Jun 2020 15:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <159251533557.7557.5381023439094175695.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <159251533557.7557.5381023439094175695.stgit@anambiarhost.jf.intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 18 Jun 2020 15:29:30 -0700
Message-ID: <CANn89i+3CZE1V5AQt0MA_ptsjfHEqUL+LV2VwiD41_3dyXq2pQ@mail.gmail.com>
Subject: Re: [net-next PATCH] net: Avoid overwriting valid skb->napi_id
To:     Amritha Nambiar <amritha.nambiar@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 2:21 PM Amritha Nambiar
<amritha.nambiar@intel.com> wrote:
>
> This will be useful to allow busy poll for tunneled traffic. In case of
> busy poll for sessions over tunnels, the underlying physical device's
> queues need to be polled.
>
> Tunnels schedule NAPI either via netif_rx() for backlog queue or
> schedule the gro_cell_poll(). netif_rx() propagates the valid skb->napi_id
> to the socket. OTOH, gro_cell_poll() stamps the skb->napi_id again by
> calling skb_mark_napi_id() with the tunnel NAPI which is not a busy poll
> candidate.


Yes the tunnel NAPI id should be 0 really (look for NAPI_STATE_NO_BUSY_POLL)

> This was preventing tunneled traffic to use busy poll. A valid
> NAPI ID in the skb indicates it was already marked for busy poll by a
> NAPI driver and hence needs to be copied into the socket.
>
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
> ---
>  include/net/busy_poll.h |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
> index 86e028388bad..b001fa91c14e 100644
> --- a/include/net/busy_poll.h
> +++ b/include/net/busy_poll.h
> @@ -114,7 +114,11 @@ static inline void skb_mark_napi_id(struct sk_buff *skb,
>                                     struct napi_struct *napi)
>  {
>  #ifdef CONFIG_NET_RX_BUSY_POLL
> -       skb->napi_id = napi->napi_id;
> +       /* If the skb was already marked with a valid NAPI ID, avoid overwriting
> +        * it.
> +        */
> +       if (skb->napi_id < MIN_NAPI_ID)
> +               skb->napi_id = napi->napi_id;


It should be faster to not depend on MIN_NAPI_ID (aka NR_CPUS + 1)

    if (napi->napi_id)
       skb->napi_id = napi->napi_id;

Probably not a big deal.

Reviewed-by: Eric Dumazet <edumazet@google.com>






>
>  #endif
>  }
>
>
