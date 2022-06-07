Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1813C5406F9
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243326AbiFGRld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348233AbiFGRkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:40:42 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB896D856
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:34:00 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-30c143c41e5so183691377b3.3
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4eiFiT4jSPlBWtFeypHpfMtBDHdyOW24PaQVVvtopI=;
        b=VXN8isyADRClAvbbE/vXSeD0gIu2LtU7dU+U0+GQ1BNQM8Y1sWu4nOt16ucYlJzwvZ
         p3Xi67MYJwJ1lni/hfkikZy0G03Cj6x9oIq/a3a+V6pKQM5tPTE3KFL0Zl1h26csO3d3
         8GM0fC0eqO9G6JzfUGsV+zWBraP6Yv+XPZ/xY4ga6VhQeW1SWn6xMRp4+cASx/LMZWbv
         qMRUARZ2+qcpViExpythngDXP0xrHPZmkmFf1rv7BmnVZLK7H7hkwPRXOwn+CPg5MG4b
         UHJgl+aQfMAFM1oDc9udSKwePRp3Gk7QaIrkGwqd2xLPytQWcFdyAMXaOpmPIiBgaWwF
         VlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4eiFiT4jSPlBWtFeypHpfMtBDHdyOW24PaQVVvtopI=;
        b=2loeaxGjrnDNh0uo1yS0qTgbv0inze6rIYYqhk8awrzf1HAGCkVjnxS0LHBdusaqnd
         C5zaxiLuFbhu7dyea1Yi5jyWegvkrXyjK8jcE4olQf9kDzx9Xg8kLtHbEjcTdoFI+DNs
         jzu7tkFALGQVDVllbMbYeGI1caTbfcQLAvjUABDT3xFUoou+sQUhpGJxdwzmb3Ka6vzM
         lU4WgF8ThTX561mzilYAkyPKhFyUXz2Y+bCCR7F6H/sx2RpfEP/lHQcJCi98PUHr+EHD
         IVCbWSEbXKxv8eYMDovFW/tEXgFIw00tJ4c/PlkT8nYuEDrf6GGuUGxFhJYx+QAw+2VJ
         6ZBA==
X-Gm-Message-State: AOAM532m4NiQ+MCQIbHgrpe4ixldBNHb0+Wi640WMyg0qCQRW49vL/N3
        QwY9grGS+31yJOh26HnPf7+ausr6U5ZOO+J2XYMZTg==
X-Google-Smtp-Source: ABdhPJyJFO8tW9nqOkaqOTCF+l8gxW4Y0idSJjy+MJbOZD/zgoc7wsuDrwLfQ3YlPt8x31ihmiwiB9/rspAFkAsOMmI=
X-Received: by 2002:a81:4811:0:b0:30c:8021:4690 with SMTP id
 v17-20020a814811000000b0030c80214690mr32756159ywa.47.1654623215131; Tue, 07
 Jun 2022 10:33:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220606132107.3582565-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20220606132107.3582565-1-willemdebruijn.kernel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Jun 2022 10:33:24 -0700
Message-ID: <CANn89iKAFshw_R8S9q1ZVMtCX3SDs5ynY-xHzgB3rz99qnZhfg@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: test csum_start instead of transport header
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 6:21 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> GRE with TUNNEL_CSUM will apply local checksum offload on
> CHECKSUM_PARTIAL packets.
>
> ipgre_xmit must validate csum_start after an optional skb_pull,
> else lco_csum may trigger an overflow. The original check was
>
>         if (csum && skb_checksum_start(skb) < skb->data)
>                 return -EINVAL;
>
> This had false positives when skb_checksum_start is undefined:
> when ip_summed is not CHECKSUM_PARTIAL. A discussed refinement
> was straightforward
>
>         if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
>             skb_checksum_start(skb) < skb->data)
>                 return -EINVAL;
>
> But was eventually revised more thoroughly:
> - restrict the check to the only branch where needed, in an
>   uncommon GRE path that uses header_ops and calls skb_pull.
> - test skb_transport_header, which is set along with csum_start
>   in skb_partial_csum_set in the normal header_ops datapath.
>
> Turns out skbs can arrive in this branch without the transport
> header set, e.g., through BPF redirection.
>
> Revise the check back to check csum_start directly, and only if
> CHECKSUM_PARTIAL. Do leave the check in the updated location.
> Check field regardless of whether TUNNEL_CSUM is configured.
>
> Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> Link: https://lore.kernel.org/all/20210902193447.94039-2-willemdebruijn.kernel@gmail.com/T/#u
> Fixes: 8a0ed250f911 ("ip_gre: validate csum_start only on pull")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
