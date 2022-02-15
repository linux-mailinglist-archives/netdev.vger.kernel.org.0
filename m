Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADE04B70FD
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbiBOPo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:44:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240323AbiBOPov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:44:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04374108BF1;
        Tue, 15 Feb 2022 07:39:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FCF461719;
        Tue, 15 Feb 2022 15:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC15C340ED;
        Tue, 15 Feb 2022 15:39:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fKlwMQmG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1644939546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MR8uETDJg9Xeaqk+LtV2lrW0K+3vcdxP9bkf45PeWiI=;
        b=fKlwMQmGGl+XsuXaJRJANlEQmKW31rbgKKnwOwuHDVYuAgsiz75OzV6KyNYigUqakpATd+
        lrKV0EL0geEgSp2Iq13ZZFv3iyCO+axNLOZtKL6VfJRlHJOthZNR0OUCsth1F82w/glyFa
        VGZJ6UBhjWAcHfat12nc6HCCT987kgg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 840e6152 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 15 Feb 2022 15:39:06 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id c6so57273205ybk.3;
        Tue, 15 Feb 2022 07:39:05 -0800 (PST)
X-Gm-Message-State: AOAM53206orcEkIrcBafJxYIYkg6F8QbOvOpOjloJcQjqERCVqQsFlvL
        qUCJJc3dnR6GcGnJDiNlLvQI2yX7a1G5iKiBab4=
X-Google-Smtp-Source: ABdhPJx6EkevGOE04tDjGHfHD2+6REo3QOFWHcWoX1VRu7eS0/CeK2AEid1T7UKuH9ZZD7sSfy+PGSjfiEvFPJW00fQ=
X-Received: by 2002:a25:ba49:: with SMTP id z9mr4233199ybj.32.1644939544595;
 Tue, 15 Feb 2022 07:39:04 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9rkTP7bJBDvnejQ6BGPu13qpHKbtnjt3h33NEaTnYLirg@mail.gmail.com>
In-Reply-To: <CAHmME9rkTP7bJBDvnejQ6BGPu13qpHKbtnjt3h33NEaTnYLirg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 15 Feb 2022 16:38:53 +0100
X-Gmail-Original-Message-ID: <CAHmME9r4+ENUhZ6u26rAbq0iCWoKqTPYA7=_LWbGG98KvaCE6g@mail.gmail.com>
Message-ID: <CAHmME9r4+ENUhZ6u26rAbq0iCWoKqTPYA7=_LWbGG98KvaCE6g@mail.gmail.com>
Subject: ath9k should perhaps use hw_random api?
To:     miaoqing@codeaurora.org, Jason Cooper <jason@lakedaemon.net>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
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

Hi Ath9k Maintainers,

I'm emailing you because I've noticed that ath9k's rng.c is the *only*
driver in the whole of the tree that calls
add_hwgenerator_randomness() directly, rather than going through
Herbert's hw_random API, as every single other hardware RNG does.

I'm wondering if you'd consider converting your driver into something
suitable for the hw_random API (in drivers/char/hw_random/), rather
than adhoc rolling your own ath9k rng kthread. Is this something
you're actively maintaining and would be interested in doing?

Regards,
Jason
