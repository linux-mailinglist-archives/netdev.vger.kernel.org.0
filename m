Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2C58FE6E
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiHKOfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiHKOfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:35:38 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E91F57221;
        Thu, 11 Aug 2022 07:35:34 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id g14so10029985ile.11;
        Thu, 11 Aug 2022 07:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=bGt03AnE6awFQ+BESy13JBvtdv3GosuVcAkYPrlHlOE=;
        b=BnsDFZHJtOFtKp+banm/mJTP4wfghX/dFd7Ytii13o/SWcQnhtRx7ZgKNAvU4Id9/r
         5vXDzPk2oLHsj7yuQE+286cwMz/rqiPf9ov3tPZTHJZxeVY2TRYe85/jctJPrqm6a3JC
         iKNG26YmGkEDqWrm323VRsmzHQdVUPeHEbMe5tssKr8spuQxv+caPLoDE+gB/uKxdkcO
         uqLGNrZSOxuZ92wuFXHFicWXde1s5fTpz6N4v5DyVV5HrdU5F69/Wi9+aJeWgrdoOkdG
         FQ4hXGYFJ0zGH+pol2YtliXdqyFzOSa3nEPf6NLhffLYdpyXJZfTNByrnGLyPAxhKvJq
         bfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=bGt03AnE6awFQ+BESy13JBvtdv3GosuVcAkYPrlHlOE=;
        b=gzdePRFMz+peo5IZJDEpo9jEKuT0K+mMFJHwx8KT1A+W+skP6AzNtwMO0usvASMNkx
         MM/E9t6lFRQ3z+79gVVKTvV5Hnwn3nYzRSbLwdFUT+BrK77dQB15ypQN0HBjI9zbEL8a
         Rp9+rrP4j8AtfKwLSEbMeR5qMDPV3D0pIiuZ2qTm2Y9RNSeoEz62GiWTbha81Fl5kXMB
         GmciuFcxHZWPRrAGIv+h3iIDGIhh+D87cX2W65HpnIT/ErFspfxgQNtd5wNXSdKwCbQh
         T7qxlkyPtEU+YKQnUMOaaQa/C3Nhi8McvDlfaiL7qNAxnZrbbMii8eAAAiEJVMW1l0v9
         yT4g==
X-Gm-Message-State: ACgBeo0cktKaOp7shx0IkSES+ffCm7eWhkZzVu9gkowXg1FCnEtQoMWO
        Jo+whi6tWtJG65Nnx5tQ+Dg2np7bBdLjOOgeHWU=
X-Google-Smtp-Source: AA6agR7W6NF0oJOSZ+hjj188vUnVXvhmnlu0Df0QGiADEykjaoi5iksX0yYi/1higTUajAZ4eOS1a7DRcHH3EGNNACU=
X-Received: by 2002:a92:cd8f:0:b0:2df:ff82:2e5f with SMTP id
 r15-20020a92cd8f000000b002dfff822e5fmr11438901ilb.72.1660228532728; Thu, 11
 Aug 2022 07:35:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220811120708.34912-1-imagedong@tencent.com> <CANiq72=Eq1265hYhEVTGuh-_ZW+3HjWkwaktEfs7H7yPERfO0w@mail.gmail.com>
In-Reply-To: <CANiq72=Eq1265hYhEVTGuh-_ZW+3HjWkwaktEfs7H7yPERfO0w@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 11 Aug 2022 16:35:21 +0200
Message-ID: <CANiq72noui51tmbhySEH1B=cRJm2JgNMGPboLoguZ+P53whRsA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, ojeda@kernel.org, ndesaulniers@google.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

On Thu, Aug 11, 2022 at 4:34 PM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> Two notes on this: please use the double underscore form:
> `__optimize__` and keep the file sorted (it should go after
> `__overloadable__`, since we sort by the actual attribute name).

s/after/before

Cheers,
Miguel
