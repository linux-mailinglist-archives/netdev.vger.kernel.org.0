Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D271166E651
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbjAQSo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbjAQSdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:33:00 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43B053F9F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:04:51 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id k4so33053129vsc.4
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cArFsr4XFw1jBqsRMXSmz7KVtiRfFxTaKc/M+9kn5dY=;
        b=BTu7MYhHvUXAG+SS88tuN5TapNeFSnD/VuiPRUXNv+CQF5rm7+N6/bAMwT38QVKaoM
         BRSPnYqu6zyWCxbEhxqit1SSvwHrpMV69TAKCcjuq3+4tk+BX5yFT2rjfNz8lnZv5hc0
         iM2YyVDr6wfYyusHmznGc/urOMFemq+8PQL0WCTe5Q6vi4kj97vrKEtRNtIXPuVEbPBz
         BuUInUQIH2xQL4+utOBuQW9phzx/3iIViDYTooPNYMtFYJdh0WalvrI2zNHEimtn87Pe
         Cf2RwqGrsd8Ov6L1SiunJyCj/y+EkYkpbfpKgnTwhO9eMKnPT9YgmvM9RsdxWTzcXXg0
         LBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cArFsr4XFw1jBqsRMXSmz7KVtiRfFxTaKc/M+9kn5dY=;
        b=XNGhjYRj6ARofcAJCTROPTcXJWRMTLTlIBE6mddgoxLnNSlT1vqen2/dqhI9HJ6ZHy
         i/qwQPt6lrb+ZCZsCGSEBVvRwowj3hF3V1lAG8RE7EHgetvtsfciv0PwpKUANonwPIft
         9mxz/OSY5jUVLW58l3T38zOjoGyPVOTLtjh5qRwuVUmcXVUuLkd5R4HAhNQqXQm0KsrD
         aU5Lihi9D1Q+UqKwe9B+vBtHAeVsQvuL1reRXkT249O0zx5MlRiCeIYd9x2obbmWWcFY
         IGfl+oDNqtMOMPvXxYHjcdGG+puuEwUQ+vqW+GZacUELgW5Q1TzYylJSJ1L+uJ+AXzM+
         h0YQ==
X-Gm-Message-State: AFqh2kqwuHWjQy19UMB/W/6X6jGznnvTm0g7w97u6z9QnwL+1Pp3ur56
        Hsc/dqgwslI5yKm5yonsUKSpeB0NMMb27i7H3+c=
X-Google-Smtp-Source: AMrXdXtScrR9Gge259YgGat70oTtfdQfU4KLIlRYEe3Nvxr95NhNjWrmNYdRHTxBShcnh8WBjoKaX28xvRLZI9sY4qY=
X-Received: by 2002:a67:e2c4:0:b0:3d0:b1c0:de6f with SMTP id
 i4-20020a67e2c4000000b003d0b1c0de6fmr493687vsm.22.1673978690849; Tue, 17 Jan
 2023 10:04:50 -0800 (PST)
MIME-Version: 1.0
References: <20230116174013.3272728-1-willemdebruijn.kernel@gmail.com> <95933f509d1a91eb60b3de87219aa15ac969988c.camel@gmail.com>
In-Reply-To: <95933f509d1a91eb60b3de87219aa15ac969988c.camel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 17 Jan 2023 13:04:13 -0500
Message-ID: <CAF=yD-Jc1v9hp9cy-0gZxqWg6PDoiPA90pvJPKRrB-Mn9DcJ7Q@mail.gmail.com>
Subject: Re: [PATCH net] selftests/net: toeplitz: fix race on tpacket_v3 block close
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        Willem de Bruijn <willemb@google.com>
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

On Tue, Jan 17, 2023 at 11:31 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, 2023-01-16 at 12:40 -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Avoid race between process wakeup and tpacket_v3 block timeout.
> >
> > The test waits for cfg_timeout_msec for packets to arrive. Packets
> > arrive in tpacket_v3 rings, which pass packets ("frames") to the
> > process in batches ("blocks"). The sk waits for req3.tp_retire_blk_tov
> > msec to release a block.
> >
> > Set the block timeout lower than the process waiting time, else
> > the process may find that no block has been released by the time it
> > scans the socket list. Convert to a ring of more than one, smaller,
> > blocks with shorter timeouts. Blocks must be page aligned, so >= 64KB.
> >
> > Somewhat awkward while () notation dictated by checkpatch: no empty
> > braces allowed, nor statement on the same line as the condition.
>
> You might look at using a do/while approach rather than just a straight
> while. I believe that is the pattern used at various points throughout
> the kernel when you do nothing between the braces. I know we have
> instances of "do {} while (0)" throughout the kernel so that might be a
> way to go.

Thanks. I tried a couple of approaches. None of them seemed
particularly clean. I include do {} while (condition) in that list.

In this case, I think the patchwork error is a false positive and

  while (condition) {}

is idiomatic.

The rule it triggers is to prevent excess braces for single line branches.

Alternative might be

  while (condition);

That triggers a rule that tries to prevent "if (condition) action;" on
the same line.

I found the current solution the least bad of the allowed options. But
can definitely respin using "do {} while" if preferred.
