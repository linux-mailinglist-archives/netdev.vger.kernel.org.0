Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6478A6978A4
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjBOJIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBOJIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:08:18 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886A6EC6C
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:08:17 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-52ebee9a848so236754377b3.3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7cJEFkSpH40uAfTFP3bp7+vYpqhak0l97GecKPqOWXM=;
        b=IpV6BykBR0qfyr0sw9Na5IsjnIuBXJDUdpd/9VnYyVlLJJzH692nQ8U2PP/Gj/Fb6q
         SnD5njH3JoXMs1CMHucepxehbWjYRxXwVg7HZuqiMFAyAE5xb3y9KcljvF1tkBdB8FVA
         LmVxeIM0Ge1Vkidvx4+jjOif/sR7PEw7T9HzcZsmHGClTHsKiXVA9ov0VW6vXUaxQNzF
         TUo5z0L2vYcdMDPt8mQZzROMYAfTbDgYKrIZ63ujx06t8+lm5rSKMeJuXH4ElTDwUNxc
         WvxqzvCe/Kld4ZDsPHNACyC0eq7JOaEI3a6PNTmrKZn/jirvHsuyj+XHlCRrZAwMXDe6
         dyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7cJEFkSpH40uAfTFP3bp7+vYpqhak0l97GecKPqOWXM=;
        b=4FhcDoCqcoZWBOlB+HIYsuiyLK262YRn+F+aBaUsYq5SoS0IhyXNBLn4j+tk2Bpxnd
         Ue7fIE6eSUAsmHQWg3TFcqYyfS6OFo5r3uKfKo8l+IlZfU/hrsrIJKgxwA6EOZCN6AGZ
         +dQ75AbejpnImDprQmIQphxlzGG+kUc2JObB/Bq40z8UWUm8lIiTRLSnXTwEIUMeZben
         WVzmfQm+F+kjSESjXJ9/G4UmMcBDu4/hNPHJdJq9sfx09sNk2D9FH/qzxpyuGR105QLP
         6XetTDYL634We48+aYZE08Qo66R0QoyAJldkmRdSHaTXQIlS76JPo9eHqb9BjKYWBhxm
         hhrA==
X-Gm-Message-State: AO0yUKWL/LgFZRrPB2D+9e6cMh2OkU25MMdNvjHp5pn5owiKK3df6X0b
        LtPQneW072mkDh+GJTRXPr1g7W/HHpL6tUAAG9FUkQ==
X-Google-Smtp-Source: AK7set8WQK3g2we/TcsV2b/u4ONHaiQoHN7vESTBn8auxxZenN5RLMG868ZuHJtyC+dA5g18Pvu1yQiaWI/jjyD3VCc=
X-Received: by 2002:a81:86c4:0:b0:52e:eb3f:41ab with SMTP id
 w187-20020a8186c4000000b0052eeb3f41abmr123859ywf.287.1676452096518; Wed, 15
 Feb 2023 01:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20230214155740.3448763-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20230214155740.3448763-1-willemdebruijn.kernel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Feb 2023 10:08:05 +0100
Message-ID: <CANn89iKQb11YuKYJT8krDgUZFVFJf4VdFi9fJkCaF60p52u+VQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: msg_zerocopy: elide page accounting if RLIM_INFINITY
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 4:57 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> MSG_ZEROCOPY ensures that pinned user pages do not exceed the limit.
> If no limit is set, skip this accounting as otherwise expensive
> atomic_long operations are called for no reason.
>
> This accounting is already skipped for privileged users.

 (privileged as in CAP_IPC_LOCK)

Rely on the
> same mechanism: if no mmp->user is set, mm_unaccount_pinned_pages does
> not decrement either.
>
> Tested by running tools/testing/selftests/net/msg_zerocopy.sh with
> an unprivileged user for the TXMODE binary:
>
>     ip netns exec "${NS1}" sudo -u "{$USER}" "${BIN}" "-${IP}" ...
>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
