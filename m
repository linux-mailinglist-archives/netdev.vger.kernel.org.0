Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C902B4DE4EC
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 01:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241683AbiCSAvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 20:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiCSAvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 20:51:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E22F1E7A51
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94D2161737
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 00:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95148C340F4
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 00:50:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="np3jgBd3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1647651021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Dxn0GUYQuQUf+SN3o7RzjEhopyWr5bx4GCJ4F+11gA=;
        b=np3jgBd3TIOs8tYmcH7lBIjusJwNC7A8PXtgRMI4GCPh/KTwILKGf09ZX26UivQMf9GFhk
        nLXVfR2+WRG2L2IOl1PoZChWAcZLJ69JOaR5ZHs2cQf5ifB1YKLk8An9w+eP3XowYcRC7j
        yUzHWRduSSUNVpXWou5eUgZQ3B2CnxE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e2690fb5 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sat, 19 Mar 2022 00:50:21 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id z8so18653919ybh.7
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:50:21 -0700 (PDT)
X-Gm-Message-State: AOAM532O2pROfmETlBIvSb+LrQvkAVaP28rx9ZI1CQKsa7CQc5DKdFN7
        4/wDhbXKeppkIQD42YA9s3cnEGxnos/xXOEEJ+o=
X-Google-Smtp-Source: ABdhPJzL4A9+JkaFqFi/vZdoGr6znBdnHu5K5+nIAwvIFmo7bFzaB7fod9A1VbejNa3P2CICYALEOJ72XCEpZbk0JRU=
X-Received: by 2002:a25:4cd:0:b0:633:c9af:1af2 with SMTP id
 196-20020a2504cd000000b00633c9af1af2mr3255451ybe.271.1647651019781; Fri, 18
 Mar 2022 17:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220319004738.1068685-1-Jason@zx2c4.com>
In-Reply-To: <20220319004738.1068685-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 18 Mar 2022 18:50:08 -0600
X-Gmail-Original-Message-ID: <CAHmME9rUrWE=AtBhTo95GfCeQCMoRh_KMSOKfpTVpq-7LywMzw@mail.gmail.com>
Message-ID: <CAHmME9rUrWE=AtBhTo95GfCeQCMoRh_KMSOKfpTVpq-7LywMzw@mail.gmail.com>
Subject: Re: [PATCH] net: remove lockdep asserts from ____napi_schedule()
To:     Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
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

Hi Jakub,

Er, I forgot to mark this as net-next, but as it's connected to the
discussion we were just having, I think you get the idea. :)

Jason
