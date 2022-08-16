Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EDE59574A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbiHPJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbiHPJ4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:56:16 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A71E30556;
        Tue, 16 Aug 2022 02:02:30 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id o14so5055579ilt.2;
        Tue, 16 Aug 2022 02:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9HxXIhlJ8egb+tUhCrrqxA/twApe2EwzTrM2sMlQQzE=;
        b=GhjmGk3SkLWdGC6hiDpPT7eKuLZO8Lx9BJgpNsKi16+G1De2HNSVvNTleAnQpbWgFe
         /lpzlSCy7JYg+wjvpiuoqUYNhkq4hVMsnK/1DA16tZkfO77VUgjGispkBUAx+1xiDnCz
         aec0AKrdXZDsRMoLNmfeNwkK0R6sy7GeARPAUll6nYxFpopNLG+CNNLOqyF7msEnseCY
         rV9vuvtQCzrI0EID1KS9KvSJ3wgmIGBNmRk1fDUSFbwQNu3bPFzrwN78uQO2yMZBm+mi
         NpOKtL3CvkD6oeF5xR6Fj6Ld1ahlv1jZgAf9qs8LwRuwHzD/ke9fSg0h4MbUwyGUSslb
         VyLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9HxXIhlJ8egb+tUhCrrqxA/twApe2EwzTrM2sMlQQzE=;
        b=vVG2nUVDVcP9vbeusOC1dODXytBMmtbt6TyfP68MVU+1LFzcFb/veF7n2akE7mm2Ee
         VILicmJYsoBf5LlZCxn+MiMsyhlNBsFWS+AhgU5yZYu1Pp9LYJe/hAm61P1ikbjONYDm
         dL5Ft33gqHBg+Zg3Dt6bPLedcgeD0EyhK+eSjF1EPQiKAoFg4fheGTL0dhqmwp0oSfxK
         zzExiBJxz5KzB4bNuAX+W0AXCdLUWN2Eul4oLML/ItzDcR//DI5+UMkjsqxJnLSyO6gq
         4FEYO3TVEOFUxAJZFOuWEzIT9002FnFjGdY/I65VpKAC24Zrz8zV+ky6fzDLJTd98JEv
         YLvg==
X-Gm-Message-State: ACgBeo1F8VBL8q5GHNwcZuzRlZC4qlkVQ+WWXFFhFj/KZk7rlIjivoin
        swHCif8sBKZvVn4W4WWZCgXhkK/DvDGJ2Uybqo8=
X-Google-Smtp-Source: AA6agR6vrFP8ihEQ/t5hzL2CGHbBK/VDTFu94MFdeRo6ma61vC0x8/MWQTOphRW6mllMw8pv8V8062edXmTR4HqUVqs=
X-Received: by 2002:a05:6e02:1c26:b0:2e0:d8eb:22d6 with SMTP id
 m6-20020a056e021c2600b002e0d8eb22d6mr9161577ilh.151.1660640550007; Tue, 16
 Aug 2022 02:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220816032846.2579217-1-imagedong@tencent.com>
In-Reply-To: <20220816032846.2579217-1-imagedong@tencent.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Tue, 16 Aug 2022 11:02:19 +0200
Message-ID: <CANiq72mQpZ-z1vVeOwdaOB3b=jjQHtPwz3-jaPRV330-yL_FqQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, ojeda@kernel.org, ndesaulniers@google.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 5:29 AM <menglong8.dong@gmail.com> wrote:
>
> Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Hmm... Why did you add me as a reporter?

> + * Optional: not supported by clang.
> + * Optional: not supported by icc.

Much better, thank you! Please add the links to GCC's docs, like in
most attributes (some newer attributes may have been added without
them -- I will fix that).

In any case, no need to send a new version just for this for the
moment, I would recommend waiting until others comment on whether they
want `__optimize__` used here as the workaround.

Cheers,
Miguel
