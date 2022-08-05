Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBE358AE3A
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 18:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbiHEQfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 12:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiHEQfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 12:35:15 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DE7B1A
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 09:35:13 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k26so5946356ejx.5
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 09:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=YULM/X0a99ROrDBU1vlbZtwnzv+PMxw5j/XQy+3G098=;
        b=DH58QeOUomO8H1sFAsPR3cGvtRWtC06FLuWlRRXvEiqMoVZWUsHdyR+bAqaBgk05qh
         3SBQ7fO6ASqZU+ODlaY5mLk6LbD+3R/vt9oxMTRIuk6TGBGAX/UewmvRIIufU5fQmQJt
         3OayP7gxpm9Js+yr6ThSM6A3fGcqxNz1GHQfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=YULM/X0a99ROrDBU1vlbZtwnzv+PMxw5j/XQy+3G098=;
        b=XP9ypXsvW+KBO2hv/PQPf5hg58+fC1VnOqotFE8poKLiahCLtXun3PkFvT2wDv/jIb
         Ahi47bIcHDQ+mFCwyaggrY1HlpjtEGpPeqqfR+ph1KM9S/hLmgIF5KU1l0bfOOfPqabY
         C2z5UTS6HIf77nuYNcWIsOSs7S/59TCJcMLF5tC1E/sJLzf+7p4/FIUtevLLslkRMYtw
         poObraG43w0g+M87rOJiqmyPODX9NvxAjf+1Dbq3ER05vdxFJalLSadp+CXLqyg1ffn5
         6yD2w4fp+JgHd7dzYgZ5w7oJdBDdG8q/jIQrcjfi5XMHDFInVrJA8a5esuOvl46finDZ
         Hvog==
X-Gm-Message-State: ACgBeo0I5NLXokVQLKLTX9LWv6GrMWZhYO5QmPA168iAjd8Zjox/hy04
        ZOguGpMcmug+MiMBFP5df3Q2ARg2iAa4ZBCt
X-Google-Smtp-Source: AA6agR5zZ4dBoMCWJxFHpfi7ocd7Gi2rnEU34e1mPpJdIqZeKxkmUz6egQqVZgKKg0hd0uTjASgx0g==
X-Received: by 2002:a17:907:7fa5:b0:730:5d54:4c24 with SMTP id qk37-20020a1709077fa500b007305d544c24mr5761900ejc.641.1659717312226;
        Fri, 05 Aug 2022 09:35:12 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id h23-20020aa7cdd7000000b0043a6df72c11sm114945edw.63.2022.08.05.09.35.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 09:35:11 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id l22so3825156wrz.7
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 09:35:11 -0700 (PDT)
X-Received: by 2002:a5d:56cf:0:b0:21e:ce64:afe7 with SMTP id
 m15-20020a5d56cf000000b0021ece64afe7mr4740434wrw.281.1659717310912; Fri, 05
 Aug 2022 09:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220803101438.24327-1-pabeni@redhat.com> <CAHk-=wjhSSHM+ESVnchxazGx4Vi0fEfmHpwYxE45JZDSC8SUAQ@mail.gmail.com>
 <87les4id7b.fsf@kernel.org> <877d3mixdh.fsf@kernel.org>
In-Reply-To: <877d3mixdh.fsf@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 5 Aug 2022 09:34:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiW62CSONUNdpPcohmnTOtF_Fa4tSrz-H+pqE3VmpuARA@mail.gmail.com>
Message-ID: <CAHk-=wiW62CSONUNdpPcohmnTOtF_Fa4tSrz-H+pqE3VmpuARA@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 6.0
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <aspriel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 5, 2022 at 7:22 AM Kalle Valo <kvalo@kernel.org> wrote:
>
> Linus, do you want to take that directly or should I take it to wireless
> tree? I assume with the latter you would then get it by the end of next
> week.

This isn't holding anything up on my side for the merge window - it's
just a warning, and the machine works fine.

So there's little reason to bypass the normal channels, and getting it
to me by next week is fine.

                   Linus
