Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA52E69FDA8
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjBVVUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjBVVUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:20:35 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6273346A
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 13:20:33 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id qi12-20020a17090b274c00b002341621377cso10223220pjb.2
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 13:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gmMtimqIRY6xvavxlIApvCrnBuDAnmp3N59YVySC2cY=;
        b=N3/KkX0Ky3sBAO/NLIaAcL5EG0Oh1gTegLD17jWgCZwt2DMn1gjde72tAwEAjZljaF
         TamhxotDzba3M94ibPjj2fgu2MiELCWhoBcA7mxXZLZ/rSfT36UEygSm+kHwH5uztFHl
         hwdBB9SWPlhmnNwKNa1m8dHimEXKRpH/XmfSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gmMtimqIRY6xvavxlIApvCrnBuDAnmp3N59YVySC2cY=;
        b=PqBAwPjYz2zzLrujAwdpTu6bwhyr+bi4TDr7yE28nc0YKybBR4t8SO4ye4qJakH/oK
         JSmo9aXQk+FbIhCsv7QArEDgRwqbzbdDw5eVBomRt4b1NNo7P8AAnYdW26OTj4FNcVlF
         mHA4Q1IKsFuUJ60FzOVlpevsHoOQd335EbpGHkysjv+WXDwmUfUND9XtMwC15dcTcjm3
         EOlAGKwbvUfiSC/+n6yJPOj+eCNLGonY2FcY82bWynO7+9DDPuoFmKE+CYr3Pw1YU3Mz
         /Xxb7VrNcNgJjMRf1CPQpMrwQS0AU55994CDeaxOVRtku8FzcfaYDL9SxT8EviUoYRGY
         fstg==
X-Gm-Message-State: AO0yUKW86aj/ihVq6eCAH/iA3qg3TT4c03gFKMt22DWpEZGos25WWXXQ
        vnhyX0x7jveHV227opixGObpAg==
X-Google-Smtp-Source: AK7set8SN3h9a6A/SPE7pi5gc6eEgnarlEnmUB72XVe7bdlAA8qx1JOlrR2JxU6BesUhXuJvyvXJoA==
X-Received: by 2002:a17:90b:4ac3:b0:234:1d1d:6ae6 with SMTP id mh3-20020a17090b4ac300b002341d1d6ae6mr12691231pjb.1.1677100832777;
        Wed, 22 Feb 2023 13:20:32 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:e684:e07:7790:98ee])
        by smtp.gmail.com with ESMTPSA id ie14-20020a17090b400e00b002372107fc3dsm3208805pjb.49.2023.02.22.13.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 13:20:32 -0800 (PST)
Date:   Wed, 22 Feb 2023 13:20:29 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Zheng Hacker <hackerzheng666@gmail.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, ganapathi017@gmail.com,
        alex000young@gmail.com, amitkarwar@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mwifiex: Fix use-after-free bug due to race condition
 between main thread thread and timer thread
Message-ID: <Y/aHHSkUOsOsU+Kq@google.com>
References: <20230218075956.1563118-1-zyytlz.wz@163.com>
 <Y/U+w7aMc+BttZwl@google.com>
 <CAJedcCzmnZCR=XF+zKHiJ+8PNK88sXFDm5n=RnwcTnJfO0ihOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJedcCzmnZCR=XF+zKHiJ+8PNK88sXFDm5n=RnwcTnJfO0ihOw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 12:17:21PM +0800, Zheng Hacker wrote:
> Could you please provide some advice about the fix?

This entire driver's locking patterns (or lack
thereof) need rewritten. This driver was probably written by someone
that doesn't really understand concurrent programming. It really only
works because the bulk of normal operation is sequentialized into the
main loop (mwifiex_main_process()). Any time you get outside that,
you're likely to find bugs.

But now that I've looked a little further, I'm not confident you pointed
out a real bug. How does mwifiex_sdio_card_reset_work() get past
mwifiex_shutdown_sw() -> wait_for_completion(adapter->fw_done) ? That
should ensure that _mwifiex_fw_dpc() is finished, and so we can't hit
the race you point out.

Note to self: ignore most "static analysis" reports of race conditions,
unless they have thorough analysis or a runtime reproduction.

Brian
