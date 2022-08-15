Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429B1592E84
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 13:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbiHOLwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 07:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiHOLwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 07:52:43 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7801E24BEC;
        Mon, 15 Aug 2022 04:52:42 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id i18so2525820ila.12;
        Mon, 15 Aug 2022 04:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=5wq7PQ6M+vhyyib3njVgrwWkMdUfwkF1QQEhwXfZT00=;
        b=Ra+Ym/imL/DPa0pkiIpuVUd8Pfvf5Pd9ywEOQfZEK2F4mmkVjOzsFrqMN9ESnj7Q83
         0nXW40MF5WSjON7dA8mPJJQ0bJLi9aq6tDRsJoPcBOzxXmtftxIYN4l0BCexQ/T/UhKM
         BlNXzSB0ibisXp/9Ci+3j6wtfSD6IK1GiXLhE9x3/fTa4yuAHYKIEziKuZpvn/4cBfBm
         me3aQXvwmKp5gd69qf/Ms1Kelv7HQ2tPxpMaVXQ2oIo/Ta+nFH9AG3XS18TuOctBMRP8
         psrnZU73QKBjNylii6nCeGmfXCg3k/puT+mA+G+sQybs12Al5pHknYCQH9PVBvE9K4K+
         cF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=5wq7PQ6M+vhyyib3njVgrwWkMdUfwkF1QQEhwXfZT00=;
        b=RO1+MzndPg5gFce+ooYJynxX7acL2Wpp90CIGU0pTad57GrSZLCQv1JCreH6TsgOBZ
         ZgIvjLD87waCNHb3t0rOY4qHzX5pSFQqx6wryp3k1lCXFXFgT5OKePUXlPUPp6I2FZt1
         NIIjXYCAnusbeLFdFxY200arZQygE9HGZSsNEJUVgRc+LZam31qsic7JOCn6umXg9IKr
         yC3lVx2geTE/PjSOHrtdNiuhJeF5Dp9pOBLIGymMAB7WrrOCOOpLx9CtMnlUeJITO2ho
         EP9syUKm8zbkN+RiRmuttDRnMx2gK3SQhkBWzc1vkT6N1QJxkODtbwGPTZo/kivUWuNF
         B+ng==
X-Gm-Message-State: ACgBeo30THEM29xETSyqOq5UPMI4lakP56ZZDDkF8qZenheSbl3hf+WG
        mmSkkkA2VCvRHEFOEvcEO9gG+dwbzsYo5xurCNS8EWH/u8U=
X-Google-Smtp-Source: AA6agR4nlMzDSLUQHYtB8jVRbKjNzm1n116y+R5UmhhV5RfGc2b8SgRHE2lYDG5pcg3wvoXSnEksRXpnhP/C4b1d65M=
X-Received: by 2002:a05:6e02:1c26:b0:2e0:d8eb:22d6 with SMTP id
 m6-20020a056e021c2600b002e0d8eb22d6mr7085965ilh.151.1660564361951; Mon, 15
 Aug 2022 04:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220815062727.1203589-1-imagedong@tencent.com>
In-Reply-To: <20220815062727.1203589-1-imagedong@tencent.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 15 Aug 2022 13:52:30 +0200
Message-ID: <CANiq72=01dzC5zs6-7Y4qrKYoFE1JpKes0ykN+x=FgGSmt9PCg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: skb: prevent the split of
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

On Mon, Aug 15, 2022 at 8:27 AM <menglong8.dong@gmail.com> wrote:
>
>  include/linux/compiler-gcc.h   | 12 ++++++++++++
>  include/linux/compiler_types.h |  4 ++++

No, this should be in `compiler_attributes.h` like you had it before.

To be clear, what you did here would be fine, but it is the "old way"
(we added `compiler_attributes.h` to reduce the complexity of
`compiler-*` and `compiler_types.h` and make it a bit more
normalized).

Please take a moment and read how other attributes do it in
`compiler_attributes.h` with `__has_attribute`. Check, for instance,
`__copy`, which is very similar to your case (not supported by Clang
and ICC, except in your case GCC always supports at least since 5.1).

Cheers,
Miguel
