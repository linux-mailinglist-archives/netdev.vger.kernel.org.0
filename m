Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6105E6D8B6D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbjDFAHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbjDFAHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:07:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196E418C
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:07:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id fi11so21787968edb.10
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 17:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680739648;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T4OZm66D1iuYjWvpX8km2uh3RDDcdiQCrxjSQ3ETEMI=;
        b=qbyNmQueWRkeUpg8SW/U23pk8mPAl9x0WkQmuIK2YiW6eA34PTitc9sbjcUzL5dVvJ
         nQW5jLdWOowiQvhdvWqZFpZMjg/a1G01bwMSEe34alyrNNLhSPX31NBFfPR6jgBxoLMm
         bUQnZpITHIEjwvKDEqfr9xTklKbGXqkkHqr/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680739648;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4OZm66D1iuYjWvpX8km2uh3RDDcdiQCrxjSQ3ETEMI=;
        b=sUSNOttBwxI7hVemsKHfJDUYuvJOhpHZtMR6oLDUtxITg717d5KTNmYrFol2wrgD0B
         G2+uQiSDMg67T3WrQW2t6QSKmgrsdgPWVaBuKoI9GGjBV6L3WxypqkyfFnnDo83Heyz7
         ayV+pwFMMFrykYIewZoHTmzYD5ZvD5IrBgt9LFOfAx3QlX88qToaVuIwyakaYkZSXnVx
         k2qFSr0wiknRcEWONOG2DJpkM4eYguxY4QYK2S86VOslJolWZZenVNPK0AOuN/dLrjBO
         CeBCQpnaQNfLXPshNYMcDpSqRX7PXn+Fb9qL59Sa2V4pdOyMCvIG6n6YncByq9Lc41No
         rlXw==
X-Gm-Message-State: AAQBX9eeWr/U25GqxVBG7X92Y0QVjc9EIgdsi0uEdj7vf8ad8hBkj1fl
        Apyd6j+s8+NydflmmdtCNkuvAmIIbVb3e6bZCwjQkA==
X-Google-Smtp-Source: AKy350byOa8zlSbWdoReei9+/UfRy7XhdT2nydpKhU51toc0nAQkMpw7TaTBXeCWzL7RcdXZTUO04/3oRInr+tQrzi0=
X-Received: by 2002:a17:907:c607:b0:932:e546:b8bb with SMTP id
 ud7-20020a170907c60700b00932e546b8bbmr2816057ejc.0.1680739648606; Wed, 05 Apr
 2023 17:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230403143601.32168-1-kal.conley@dectris.com>
 <CAJ8uoz1BKJ1_jq6Sum-OkZQTR_ftmr5Enj+Cmn4Qsi15_jOpbQ@mail.gmail.com>
 <c0596a62-0873-5638-920b-235c55ff33a2@linux.dev> <CAHApi-mzLH7yVOT0cM03yafzTJJqfGwOBTa3q5U6jBdWnAx3VQ@mail.gmail.com>
 <f1a32d5a-03e7-fce1-f5a5-6095f365f0a9@linux.dev>
In-Reply-To: <f1a32d5a-03e7-fce1-f5a5-6095f365f0a9@linux.dev>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Thu, 6 Apr 2023 02:12:07 +0200
Message-ID: <CAHApi-kjLp3WspBayU780aX7hLOu5GTkfqma7JAM3t74kU6MdA@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: Fix unaligned descriptor validation
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Since you already have a test case, it is better to submit them together such
> that this case can be covered earlier than later.
>
> Other xskxceiver fixes have already landed to bpf-next. imo, I think for this
> particular case, bpf-next for both the fix and the test is fine.

Done. See: https://lore.kernel.org/all/20230405235920.7305-1-kal.conley@dectris.com/
