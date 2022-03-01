Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7317B4C8C1F
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiCANBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiCANBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:01:05 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C169A4D0
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 05:00:23 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id e5so16388616vsg.12
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 05:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=9/gMJFYep4+tLDQKXQhXNsafQyNJTfIInZtvIeZ6Ceg=;
        b=SnaVgEbaAVOKq9R7FysEz0BXxlhIjl9MR6rH55DHZ9YCaSH+2hSSTOH9g3Bs3UfnAV
         CntbefSKGF1EpIJGoA3N10egpnOTaDaOSHrpJM+AmyaTHTcGLcpBqiaki2WXU3G9G/kn
         wi68noMx4bpYDeQkIlja5DzSVc9LBZhR0zR4thcrEUpWAfpuewqbIY5UAJLkrJvX6aUh
         1JI/mJd0orT/YxVCYqO1akRRzcQCbEg8jAksLJZzQkMBh+qQXRw+C1jAEDbmYjSAvpOG
         w0L3cQFZM7JOtWqEUI6yg4Em/AxZzwyRYbmcz+EXbxjL4MoR0PaZVrKCKoo+7z6FsFGG
         xahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9/gMJFYep4+tLDQKXQhXNsafQyNJTfIInZtvIeZ6Ceg=;
        b=iyViyAj5ZwqlXFPOVdN4TUePY3ZCRCdKPIXNOVZ8rzAhB2vK6EJCmaXypcb1xH4EiB
         rqqnnH5Gkk1xE15cvxOAnjdvC/rqBH0dOxeWcg15w2L4I1p4oZw7VbZJSsE/VArXN5Vj
         cpBklStOII27LMi5bBJo0dAbsatMJiaTEiayaJbRu6CV9qzaieyjFZaGM4XwbBY2HpAu
         6p0LYwYNKnYd2vZ1i4UQT/eqanUQnDjte6RvTw2h/LRbIX5qg/ANAvUsuwEXRR1osKcC
         wzDMQ09Mg33b3KkYBsHMA2Sg1ciA9YpDUK7LX95VY7A3V++qsphj90Gu/xvm4gczlp7/
         uHiQ==
X-Gm-Message-State: AOAM530piAf/YmpDzJS7ircGlBRHaMNnlRh4ga3zt8UoAYAM/ghzR1Gf
        ypw8gYni/6Zle7EnixS6RCPuHyUGGUFAE7+okGN01Oe2L4XqBuRv
X-Google-Smtp-Source: ABdhPJwHmZuM1+/PnhF9brKNQgZn/QAYZgULvjJqScr8dgNkRBHk8YkgeT4T7u8OkxKGk1Vc0Jo/I/pXV2M1QpemDC0=
X-Received: by 2002:a05:6102:a21:b0:31c:c1e:6bd4 with SMTP id
 1-20020a0561020a2100b0031c0c1e6bd4mr9395912vsb.25.1646139622182; Tue, 01 Mar
 2022 05:00:22 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 1 Mar 2022 13:00:11 +0000
Message-ID: <CAM1kxwgsiaRYWRFDiNY=d3ixcoPbFNi5PUq31QE-4EmkvF85Gg@mail.gmail.com>
Subject: [RFC] net: udp gso error code change
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i assume this is might be a no-go because it could(?) break existing
code, but i recently debugged an issue where i'd changed my linux box
at home from ethernet to wifi, (with a few months away from the code),
and suddenly my sendmsg ops were failing with EIO.

turned out the wifi chip doesn't support checksum offloading, and this
was the cause.

but it seems in this situation EIO is a bit misleading/meaningless,
when really the error should be something closer to EOPNOTSUPP?

if there is support for this i can submit a simple patch for udp4/6

https://github.com/torvalds/linux/blob/719fce7539cd3e186598e2aed36325fe892150cf/net/ipv6/udp.c#L1217

if (skb->ip_summed != CHECKSUM_PARTIAL || is_udplite ||
dst_xfrm(skb_dst(skb))) {
   kfree_skb(skb);
   return -EIO;
}
