Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C64D606A83
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 23:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiJTVxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 17:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJTVxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 17:53:18 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C7D226E44
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 14:53:17 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i127so1142544ybc.11
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 14:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IXy9+ay8l9+jVzoKZqA/Zq/oQZoCvOpSJ5GRzz2v63g=;
        b=bo6rliC+pLgiL2TpSaEUBxiWOoF1YORKJA357WqwwvirxvzVc0RXNIbYBN8yqY+/e/
         7RkmM6Wkz1zJrfe/jv8ZPax2Oza3weoRRspqKtpT3u6zqRZGiaaJ34zgf0VyJ0chfLtm
         /xOIwIFOybVELyXoFlv0zYA7Dpha5mcJCYInJAI6pNK5AtGrgwLRNE6LPk0ng+Rl8utK
         fXE+SZgS/hJjqmZGRzlfiDY7WFxQlpBkIvKLXSIe+g6kKhaNqOSXDhI5/IXnHyixwREs
         VuAFSAGi+IrRZrBJpyJ6qP+ZtqtnDmcPuRa9W7DRn2dAFQKVu0TyuCyfBz2pQ/nPFTq3
         EH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IXy9+ay8l9+jVzoKZqA/Zq/oQZoCvOpSJ5GRzz2v63g=;
        b=akufrWEVHCZz+0XfyWu1Gl6T/qW+DrOOnBwIFnPDh4cU+iaTAE+Pf3N3rWa/L1lk+C
         /dcBW0PA4gbfsCHqBiRblMnczb7mK+ykI38oPgWRuWgGTOC6GpSWehTk18MESXLm1HIM
         ORR4UcNG4eq9xTjevuz0DuhLmsWswq/XB9J0kGsXMjNasBSrZTowEURqEtzLiaULQPK7
         VJLbx/+GF61V/+PNrCgBQ7xg4g8bP5uEb7tp7B+65wc08RKTxPH8zTX3z1npopm8UN4S
         HpMnGfVViiwYeMrbgHWMFf/VQRDr8W/JsC5TESWUKnGSOK/Dp7jDGAhUq+gLz1apqYxH
         5oIg==
X-Gm-Message-State: ACrzQf2zkWlXUyVxgKMXRQcD5kl0q2DzelfJTB+KIm1PwXCFhi+qVPIG
        HUcYznhnFiaPBwL6PGYbaKgsMWlSpFqUtGN88UBNcEw4gXc=
X-Google-Smtp-Source: AMsMyM5Nc87Of3skjt8EfD5BHvd8TYMms70iPJd2tDvnp4zEKOMLKpB+T8P0nI+SbZ8a6wJQUDAu/KHQPMJ/qWOeccE=
X-Received: by 2002:a25:156:0:b0:6ca:258:9d24 with SMTP id 83-20020a250156000000b006ca02589d24mr7958614ybb.598.1666302796948;
 Thu, 20 Oct 2022 14:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20211220143330.680945-1-eric.dumazet@gmail.com> <Y1G4HufHb+sEIUD6@google.com>
In-Reply-To: <Y1G4HufHb+sEIUD6@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Oct 2022 14:53:06 -0700
Message-ID: <CANn89iJsZsmw9+RryFzMhEBqdqUMD=LRkJZ85k1ksdAzypfefg@mail.gmail.com>
Subject: Re: [PATCH net] inet: fully convert sk->sk_rx_dst to RCU rules
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, liuwei.a@oppo.com
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

On Thu, Oct 20, 2022 at 2:05 PM Carlos Llamas <cmllamas@google.com> wrote:
>
> On Mon, Dec 20, 2021 at 06:33:30AM -0800, Eric Dumazet wrote:

>
> Eric, this patch was picked for v5.15 stable and I wonder whether this
> needs to be backported to older branches too. The Fixes commit quoted
> here seems to go back all the way to v3.5. Would you know?

I guess nobody cared to address some merge conflicts on older kernel versions.

If you want, you could handle the backport, this patch can help some
rare race windows
on preemptable kernels.

>
> --
> Carlos Llamas
