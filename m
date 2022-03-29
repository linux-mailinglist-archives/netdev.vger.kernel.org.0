Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38FE4EB1D2
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiC2QcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237573AbiC2Qb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:31:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD074241B72;
        Tue, 29 Mar 2022 09:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A3C6B81877;
        Tue, 29 Mar 2022 16:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43DCC3410F;
        Tue, 29 Mar 2022 16:30:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hbjb2Gn/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1648571408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gWpDt/rwNM/nig7k6lt+szP4lNhhSqQ0Y3OUIZSEPzM=;
        b=hbjb2Gn/Xqxghf441c701bvJaHV9I+EjzkQv2fZW1/lkHHUOiu/mnkE7OSpMQ4fAX2J3Qi
        8DGTbR1YAlU/gpWwgtswix4J5VWianiSrD9Q0sXBaWuPbe+tTTuBcV0S3me+6DywIwWwLw
        FvkrfGrqoPDbSy/uiAjpOtVrB2dl3+E=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ecaad57d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 29 Mar 2022 16:30:07 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-2db2add4516so189956827b3.1;
        Tue, 29 Mar 2022 09:30:07 -0700 (PDT)
X-Gm-Message-State: AOAM531JPTkLuCAXkdrZEz9mU2ChL0N0h1Eu/ZKZedM3sreJsBRunBqd
        Dkz9Yktm1o/STqLwX4O9CtWIullYOmrhxL6IvgI=
X-Google-Smtp-Source: ABdhPJx19sXr2RsIii2GkQbjQnPceSjSSWkgV89Y13xyhfMg4Uq23lWzaHw/ZQPb9dPHhvxRKHs0O6YsjXedp4I+Fis=
X-Received: by 2002:a0d:d508:0:b0:2e5:d9ec:d668 with SMTP id
 x8-20020a0dd508000000b002e5d9ecd668mr32980539ywd.499.1648571406134; Tue, 29
 Mar 2022 09:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220329121552.661647-1-wanghai38@huawei.com>
In-Reply-To: <20220329121552.661647-1-wanghai38@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 29 Mar 2022 12:29:55 -0400
X-Gmail-Original-Message-ID: <CAHmME9rpRTLN7tHOsdVTJZfKLVsr_ZBTkWsheLKNjX5-3-rwkg@mail.gmail.com>
Message-ID: <CAHmME9rpRTLN7tHOsdVTJZfKLVsr_ZBTkWsheLKNjX5-3-rwkg@mail.gmail.com>
Subject: Re: [PATCH net] wireguard: socket: fix memory leak in send6()
To:     wanghai38@huawei.com
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

Applied, thanks for the patch.
