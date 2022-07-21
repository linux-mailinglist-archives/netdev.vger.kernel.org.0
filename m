Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213D857D167
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiGUQWB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Jul 2022 12:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGUQWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:22:00 -0400
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA235006E;
        Thu, 21 Jul 2022 09:21:59 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-31e7c4b593fso22401917b3.13;
        Thu, 21 Jul 2022 09:21:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4tuVfX9bKKufRa9+rIEczxOme0B9PbnJssWHNEU67L8=;
        b=B/LYU8ep/rMbDJFc4u67PkThRiMT2SW8PMlTWpwFtfEfzrMs+6Y1vUdBxvrFi9BD6d
         XZeuY0dusnEbQmU1vhPwD5J44378a+5V9Y3zxNWSZ80gmJm7SpewpSzl5Sxpyp3vs/X4
         RXIcWpYnPYTHuEyzXPVuayXZxOihF+tH9Hiy10T4TW6FUD8N5DnZOzyiAvOtGtcZ96LF
         72FTUACnoie6qRiSWJcm/kQEjbs4+J1jMlzSCVrf9vhRpKY6/seL514d8iy0cdgyu2zv
         shroU3jNUDd9Bg0PbKJt4TVZZTPvWn7Q2TFnjC9TTQoOvR9Gle/guok2S49FU/GTNprW
         sk/w==
X-Gm-Message-State: AJIora8EnWzUCVwVuurT58OXImpV75qdYg9MkQqsRAyzXA14hPYMzKua
        ZB6C3eCmu2sL49RbRNlEuiS1ft0P1ZK27cztPfI=
X-Google-Smtp-Source: AGRyM1s0j5C7KrwKVl0xitO8o0mGA4aHRoHTICik/N5JCVKPzDCOlvNHTuvVd9Dlk8MJG/2azgZTjqSgngDu5QqLX3o=
X-Received: by 2002:a81:8349:0:b0:31e:732a:258a with SMTP id
 t70-20020a818349000000b0031e732a258amr7468400ywf.518.1658420519100; Thu, 21
 Jul 2022 09:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220721161526.930416-1-trix@redhat.com>
In-Reply-To: <20220721161526.930416-1-trix@redhat.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 22 Jul 2022 01:21:48 +0900
Message-ID: <CAMZ6Rq+di4CYnZ6eDgBS68qGuPLvGHfxP0JYWJFkgH4c-riSmw@mail.gmail.com>
Subject: Re: [PATCH] can: pch_can: move setting of errc to before use
To:     Tom Rix <trix@redhat.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 22 juil. 2022 à 01:18, Tom Rix <trix@redhat.com> wrote:
> clang build fails with
> drivers/net/can/pch_can.c:501:17: error: variable 'errc' is uninitialized when used here [-Werror,-Wuninitialized]
>                 cf->data[6] = errc & PCH_TEC;
>
> The commit in the fixes moved the use without moving the setting. So move
> the setting of errc to before the use.
>
> Fixes: 3a5c7e4611dd ("can: pch_can: do not report txerr and rxerr during bus-off")
> Signed-off-by: Tom Rix <trix@redhat.com>

Sorry, you are a couple minutes late. You are actually the third to
submit the same patch:
https://lore.kernel.org/linux-can/20220721155228.3399103-1-mkl@pengutronix.de/
https://lore.kernel.org/linux-can/20220721160032.9348-1-mailhol.vincent@wanadoo.fr/

But thanks for this!


Yours sincerely,
Vincent Mailhol
