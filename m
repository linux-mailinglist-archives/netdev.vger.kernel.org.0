Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEBC36602C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhDTT2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbhDTT2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 15:28:01 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46636C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 12:27:30 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m12so6634366pgr.9
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 12:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQBBWQa+Vc2JUWB/WV/OLInJTjy/LR29eDaJd0OwFIY=;
        b=Zwg7HNVDupnYE4ID6wFu245ywx35JlIu5C1t4W2y/m5rqjR6wv0CSuAPr/u2EBqMbk
         DpPS3aKbUP5zp7fmSfOLnhVl28Lu3SBSXwivT/XfiZ+8hxrPxr4Kkobc5PFvJSUkh9Dw
         /sDzW/JpxkGS7ZQuQNg9OUlOGaQoJ5dudnGKqEApExNw5H9KhgqjM2Ra3ZrfNm+/0EpA
         tnlD5LuSs2zquJpsyetMeXMrqo6RU5RbZk+m5mqR2qe5WCVdhtr/1awoU6MyhGRMw4DJ
         +49H87uVfc3yu2B1aZb5qWqtQwhU6oL23tm+XfyD0WoljxIcJBUG5vkql2PUnZv1jGs+
         Ycsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQBBWQa+Vc2JUWB/WV/OLInJTjy/LR29eDaJd0OwFIY=;
        b=qff0CCANeZTPaf64NcSJXHH6Kx/7kNunjtwKGyA8GPozBuP1pvP7B+tGrfM0+s9fEo
         T4ENtN0R4G5ccLLjiUEH+OEljoglYxIibPOhUR3JEfzIhsqtOkGqGtPTYuy3HPI+oKzm
         MDWNQ/LsmVsnU6BT8A2iJENpwyTOh3/h8ycCQEktxpPp20Td03kVEhE/kTbPqA9Zafkk
         bJ/w3onARAzfJDH/HO9pavjoxdi0tEembloILHiysUFjW+O2gOpUbSidDfLl7FpvGrrn
         lc39BWKaRtuaD3AHaK4gHIugnot/ttwASaBPzb1yV64j5kDuGPsjacUEcEy3KAbGtUU5
         VVRQ==
X-Gm-Message-State: AOAM531F9YRN9L+w9FFcf8u/bI1lQgL3MsxLpDqxAFfAcBk5nthqUIuu
        PZJPr3RWPfjLQDv+Ev7060O70s9PVE55H6TzZrk=
X-Google-Smtp-Source: ABdhPJwgkP8xzKpxTIBe3qC7lJ737vw4DhO8QIL/wq2kXGb9nTeOhg8+EUMfKBF57u+fexz+pqYfkViTSG7pOWAAMYw=
X-Received: by 2002:a17:90a:f2ca:: with SMTP id gt10mr6840247pjb.231.1618946849857;
 Tue, 20 Apr 2021 12:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618844973.git.dcaratti@redhat.com> <80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com>
In-Reply-To: <80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 20 Apr 2021 12:27:19 -0700
Message-ID: <CAM_iQpVz9H3ebCKaXhTf2NzTzU_+pEUQhxNP+OCVX1KY0gaxzg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: sch_frag: fix stack OOB read while
 fragmenting IPv4 packets
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 8:24 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> when 'act_mirred' tries to fragment IPv4 packets that had been previously
> re-assembled using 'act_ct', splats like the following can be observed on
> kernels built with KASAN:
[...]
> for IPv4 packets, sch_fragment() uses a temporary struct dst_entry. Then,
> in the following call graph:
>
>   ip_do_fragment()
>     ip_skb_dst_mtu()
>       ip_dst_mtu_maybe_forward()
>         ip_mtu_locked()
>
> the pointer to struct dst_entry is used as pointer to struct rtable: this
> turns the access to struct members like rt_mtu_locked into an OOB read in
> the stack. Fix this changing the temporary variable used for IPv4 packets
> in sch_fragment(), similarly to what is done for IPv6 few lines below.
>
> Fixes: c129412f74e9 ("net/sched: sch_frag: add generic packet fragment support.")
> Cc: <stable@vger.kernel.org> # 5.11
> Reported-by: Shuang Li <shuali@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
