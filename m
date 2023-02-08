Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F4C68F7EB
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 20:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjBHTVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 14:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjBHTVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 14:21:06 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BAC530C2;
        Wed,  8 Feb 2023 11:21:04 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id x8so14963474ybt.13;
        Wed, 08 Feb 2023 11:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kGWBWZQ8ofBk0zF7E8OZNhZQeAfxsqbsho91CLxLS0A=;
        b=dOEUj1/o6FmDvE8krIW+FwtUFJbxJxqL2o9H9oV+HyJIxwCL2z3SVJNAcmBu1xhA40
         0bOV7YINVmfEyud8xp+UJbfN1nTaAqLTztS0yEpyhvD53t+ezJL/fQAK3/VhNv6HxKlE
         OVnSYqQfWKpqPbKarhaTkrDpdFJg+yIPHna4W0Ke2/BlvHGZ67VyFCCqtVlEZ8XEmNwd
         x4DGsfzQLky++gSoANmVBSgahtpJ9HL0UdxPzTo6+RnHlIcSHpd/3EdUH+YGrQ8UCQKV
         7RPFY+xMAWAxIqbpKbhJVD3AMeIdoRg6ZCoVIiM6Vs3LSVUqflhCcACmYzr+qSfcczjF
         ak8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kGWBWZQ8ofBk0zF7E8OZNhZQeAfxsqbsho91CLxLS0A=;
        b=SlOOJ5uyCA4oFYge5sTJTohAmJFVqyxJKkiW7itgb8shL7ZTOEuNZ0X5+qjqw3Zaa6
         voT/yM2//oKX4dCOWJ3vLyO8ffukvNyxam6e6n7meLbRbhLOGM0WE2lJfJL8Kf1ebpYL
         HFqYI+c/J5Uci+GRSq0AhetNmkP2IC2NwehK8ddOkVtord4neextE6shShzRSqNkItRC
         jR2a+ktEWOAw9ZHk31pmACuPHnzVQEfMYXAj1hvGHKSNhywy31CxaQWnoUQ1PCApBWWT
         balFtIZXaq1kM3EXuo7QJnxosEA+1Yxy0VnTwA8z00joyolKU/xQMItu2GEveNdpCwFw
         lMQQ==
X-Gm-Message-State: AO0yUKXOD90uTaZzIToxQ3TOWg8DjI05a6ATwngN/ihnWpTfuLQw5qqe
        3lsvl+NddyIY6VBZZQgGshXFQ++NrxjXKiWGPRs=
X-Google-Smtp-Source: AK7set+/CZuIAEZv/oyCl1yr4WdWnC9m85krzCW8uhqFAzqF7Kn0061aMMljtrbi5OnZGdw+7LYhW31h//zCkEfHatc=
X-Received: by 2002:a25:e808:0:b0:8c1:b2fa:f579 with SMTP id
 k8-20020a25e808000000b008c1b2faf579mr305658ybd.446.1675884063528; Wed, 08 Feb
 2023 11:21:03 -0800 (PST)
MIME-Version: 1.0
References: <20230208-sctp-filter-v1-1-84ae70d90091@diag.uniroma1.it>
In-Reply-To: <20230208-sctp-filter-v1-1-84ae70d90091@diag.uniroma1.it>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 8 Feb 2023 14:20:39 -0500
Message-ID: <CADvbK_ebZEmO_n9c3XDBF65W8AcXFXdUYjpsRDUin8T0devCYQ@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: check ep asocs list before access
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 1:13 PM Pietro Borrello
<borrello@diag.uniroma1.it> wrote:
>
> Add list_empty() check before accessing first entry of ep->asocs list
> in sctp_sock_filter(), which is not gauranteed to have an entry.
>
> Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> ---
>
> The list_entry on an empty list creates a type confused pointer.
> While using it is undefined behavior, in this case it seems there
> is no big risk, as the `tsp->asoc != assoc` check will almost
> certainly fail on the type confused pointer.
> We report this bug also since it may hide further problems since
> the code seems to assume a non-empty `ep->asocs`.
>
> We were able to trigger sctp_sock_filter() using syzkaller, and
> cause a panic inserting `BUG_ON(list_empty(&ep->asocs))`, so the
> list may actually be empty.
> But we were not able to minimize our testcase and understand how
> sctp_sock_filter may end up with an empty asocs list.
> We suspect a race condition between a connecting sctp socket
> and the diag query.
As it commented in sctp_transport_traverse_process():

"asoc can be peeled off " before callinsctp_sock_filter(). Actually,
the asoc can be peeled off from the ep anytime during it by another
thread, and placing a list_empty(&ep->asocs) check and returning
won't avoid it completely, as peeling off the asoc can happen after
your check.

We actually don't care about the asoc peeling off during the dump,
as sctp diag can not work that accurately. There also shouldn't be
problems caused so far, as the "assoc" won't be used anywhere after
that check.

To avoid the "type confused pointer" thing,  maybe you can try to use
list_is_first() there:

-       struct sctp_association *assoc =
-               list_entry(ep->asocs.next, struct sctp_association, asocs);

        /* find the ep only once through the transports by this condition */
-       if (tsp->asoc != assoc)
+       if (!list_is_first(&tsp->asoc->asocs, &ep->asocs))
                return 0;

Thanks.
