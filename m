Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F8A6169A3
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbiKBQs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiKBQs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:48:29 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED09495A7;
        Wed,  2 Nov 2022 09:46:02 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id q9so46963654ejd.0;
        Wed, 02 Nov 2022 09:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=STgAX5KnaEytv7+9IPe90yRFlFnZhTRxQJ1tKlplzNY=;
        b=QNm8eDzl4jNnafdm7MMx52kdHT8Ihe0nmOxlz9EcdsJAOgWQT5HQjtMJvJkLYTHTG2
         baudCUAg1XMPRdytVbrV2tIQVAYn5YBK7R6V3ciZcGihilPgOy2L8G1zkIyvMKnsIPT7
         /WJVR7wy3PB0edTUI8KzL690jZeYepx6Jpq8RMoq0//yxfsgo8bfWPOiHm1tpne0Spmc
         FzlHPSyUTRDlfPf27vxORLDaBk2nz5twOFiptmuJZmWOZNDX5eI7lJ4qKuqt6NMS4xwh
         4WTjrKKlUm+8F4Hfywy62v3MH+m9ridWPuBlKj4hN1ktU8jyhz8QvMWh/73a+tkJBcmW
         Azxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=STgAX5KnaEytv7+9IPe90yRFlFnZhTRxQJ1tKlplzNY=;
        b=jaKX97xh5ycVc+8XUvgV8OqnyvU+KeartYDpJZh0gGgHXd539ffPuZPs6DJWS2/p0U
         3ImPpMCRFuxXyq/Mhbn5kiSYrsKir25Kx/3fVtaFNUlQs+aqRcMznA4FA6dyc7rF4d2f
         P+Mrl72osQDTK5+ZDxwZkqa0q2uTma0TOl6MkWQV77ye37BQ/mrJW6T6+Wh+MG1toUOb
         MKeH2TEJ1jXxP+KuU6nWsqcp3fzSKe66CPV+FSq6d0RdNIYh2bo5SuFozs0Tyd0hA/A/
         18toGcwDTOKqm8J1HLpaVPhRN4X7d4NGFyMscbnr6POjkN9W7XOTPvwwBA62wmYjA4gZ
         FrXA==
X-Gm-Message-State: ACrzQf0lKdVzDcgqPajdTLgaCE1O7c1zXLbBm99ddK3piQwNl6WMWl/q
        dH7B8Ti4oG656co/fjXMeQge9ibhquEgF+u247i0bV4ddn8=
X-Google-Smtp-Source: AMsMyM5QDgVdsKVSleg8ZaCcbl7FYf4VDgRfGRvq6cyLNimBlQHolH7UgdXa7kUc8vA8vA87GLygfy/AnDe/Kdboc7U=
X-Received: by 2002:a17:906:6791:b0:78d:4051:fcf0 with SMTP id
 q17-20020a170906679100b0078d4051fcf0mr24494728ejp.591.1667407561357; Wed, 02
 Nov 2022 09:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221024051744.GA48642@debian> <20221101085153.12ccae1c@kernel.org>
In-Reply-To: <20221101085153.12ccae1c@kernel.org>
From:   Richard Gobert <richardbgobert@gmail.com>
Date:   Wed, 2 Nov 2022 17:45:27 +0100
Message-ID: <CAJLv34RKj6u_7EZwYWiNujC-R4nxKHJ24DVYqydgHPy88NqMPA@mail.gmail.com>
Subject: Re: [PATCH net-next] gro: avoid checking for a failed search
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lixiaoyan@google.com, alexanderduyck@fb.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Why does it matter? You see a measurable perf win?

In the common case, we will exit the loop with a break,
so this patch eliminates an unnecessary check.

On some architectures this optimization might be done
automatically by the compiler, but I think it will be better
to make it explicit here. Although on x86 this optimization
happens automatically, I noticed that on my build target
(ARM/GCC) this does change the binary.
