Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70EA63F88A
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 20:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiLATpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 14:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiLATpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 14:45:06 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1B92036E
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 11:45:05 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id d128so3387813ybf.10
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 11:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1YvGZw1XnIVBqeRZP1o59X2Ld3UUgbPgT4xbhXdQQ1M=;
        b=DEpl9Lk88Vk5PGnfUByEBPRs+ntbZwlf6iNc1UE4zkgvs59P5dr294Q138LZspv54q
         nqeJt5jwLXq5mBEro8eH5CRBg9uQUhXBp7h9ZKJd9ZWwDlvqNSdDsRKstwtvWt0d1tLm
         0OgspjyKifMWeDEf1NPp7NlyCQvk8G/ejgaXOcE2x5HxMonrl202/p/t4vcf0NTi09QF
         p09NRSJunft82epXXvZODTZNeehe6M1k1DGLbUdKv7wAnyQybG3fo0l6I8Zfk5B5tpNj
         +pDcW8+eSEa5+iVrA0EJOGmBWEQrL/4YK7PFOaZRW8Q0GAmztcWX71U4Mk7xMbufQBCS
         bhXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1YvGZw1XnIVBqeRZP1o59X2Ld3UUgbPgT4xbhXdQQ1M=;
        b=2LKfGopN9f7ifBuPzDIS6MVQmha6YsZj4Z/d0pmwF7N7CLg0gVUYCyx8PUBwoAo8Wj
         cgBdhvpzcF+1bue9eYuBME8oSSLQe11ZYBdPNNCzMLv++DUJj/E2KrS6UtK6TEKAPrCs
         vz7bylFKCkkkAoKwDAcOcXIlQlmkuAW1dnAWiyMc3fm9EiZJa563yy6agnRwbV2t5EJg
         JD8/PNEiDxPIRiSz4rAmt4h+yQhgIo/4rFmid8A587X+NAoHh3r+I3mmTuQsPDApiwpM
         aJX4A8s9xCu1BZnQ+L59VqwRXTy9CS3qj4rbc9AKtGf3eUSL58Jgl3YYHTAGY7t1Jg1P
         j8rA==
X-Gm-Message-State: ANoB5pmwmjvoXyS4znKwUs1ywMFUtQJL1C7qdgIL/WYkpMynVS/TO22d
        ktVSMtFYF+jtl9+etAzn0D/iCcS69y1pculaIrd9PQ==
X-Google-Smtp-Source: AA0mqf7kRmZHxTJokTF0Zkz4PAZco3C0R5Y01eHdbb/f97t3dmdWuwVpr1K4Ci3W6MDP53lU60ScvbqaqM9APrsHDyI=
X-Received: by 2002:a25:24d:0:b0:6fd:2917:cf60 with SMTP id
 74-20020a25024d000000b006fd2917cf60mr248705ybc.427.1669923904377; Thu, 01 Dec
 2022 11:45:04 -0800 (PST)
MIME-Version: 1.0
References: <20221123173859.473629-1-dima@arista.com> <20221123173859.473629-6-dima@arista.com>
In-Reply-To: <20221123173859.473629-6-dima@arista.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Dec 2022 20:44:49 +0100
Message-ID: <CANn89iJg0=2N2Mxpd3VMe=eCnVHuLqcmo9yg46F7v01hMnDYyA@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] net/tcp: Separate initialization of twsk
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 6:39 PM Dmitry Safonov <dima@arista.com> wrote:
>
> Convert BUG_ON() to WARN_ON_ONCE() and warn as well for unlikely
> static key int overflow error-path.
>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
