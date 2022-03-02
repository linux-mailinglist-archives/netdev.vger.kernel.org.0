Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26644CA412
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbiCBLpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241576AbiCBLpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:45:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FDDAC070;
        Wed,  2 Mar 2022 03:45:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A676961876;
        Wed,  2 Mar 2022 11:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D93C004E1;
        Wed,  2 Mar 2022 11:45:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DPvV7ZIO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646221498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jKc7MGtOlemLQBMVvgMBuRZXG8kkFVyuHdkwiw9Ht6g=;
        b=DPvV7ZIO9o6sq8lvzTqsDDC84fozhr05iE2RG7Qko7/wZLa8sGt7BnXIkyXZdzUWtDYHKK
        kDER9R4cfKR3EsNVMVwn0hgApBG7J7sHRC1yAEeAT3U2a7GC77hegBq02xr9f843c4BhZe
        Uvorml9W9xUYXrc1SpM2AFMxNg2AaXo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 26b0cb37 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 2 Mar 2022 11:44:57 +0000 (UTC)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2dbd97f9bfcso13827427b3.9;
        Wed, 02 Mar 2022 03:44:56 -0800 (PST)
X-Gm-Message-State: AOAM532G28bN2WEKU3By34V3r3WVng0SWE2BE4MOS5fyWAb6yMsdJqwZ
        Sn0LWLYdpwVo6/YtL/tB2XWxiKzH6/wXrKOzOT0=
X-Google-Smtp-Source: ABdhPJxws4pfBz+BuT+rmpnNd8+cc6rFxmT3Lf+5UQ8eG5n64VKU5po/5Iv6gzzsSXHheRzQBsa20adXgGJUTjN6NCI=
X-Received: by 2002:a81:8984:0:b0:2db:6b04:be0c with SMTP id
 z126-20020a818984000000b002db6b04be0cmr16169292ywf.2.1646221495956; Wed, 02
 Mar 2022 03:44:55 -0800 (PST)
MIME-Version: 1.0
References: <20220301231038.530897-1-Jason@zx2c4.com> <20220301231038.530897-4-Jason@zx2c4.com>
 <20220302033314-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220302033314-mutt-send-email-mst@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Mar 2022 12:44:45 +0100
X-Gmail-Original-Message-ID: <CAHmME9r6zXw6cByqpbhEBKkvpejrLqGMn55E-uOCQ0V1mQi1LQ@mail.gmail.com>
Message-ID: <CAHmME9r6zXw6cByqpbhEBKkvpejrLqGMn55E-uOCQ0V1mQi1LQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] wireguard: device: clear keys on VM fork
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>, Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Theodore Ts'o" <tytso@mit.edu>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Wed, Mar 2, 2022 at 9:36 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> Catastrophic cryptographic failure sounds bad :(
> So in another thread we discussed that there's a race with this
> approach, and we don't know how big it is. Question is how expensive
> it would be to fix it properly checking for fork after every use of
> key+nonce and before transmitting it. I did a quick microbenchmark
> and it did not seem too bad - care posting some numbers?

I followed up in that thread, which is a larger one, so it might be
easiest to keep discussion there. My response to you here is the same
as it was over there. :)

https://lore.kernel.org/lkml/CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com/

Jason
