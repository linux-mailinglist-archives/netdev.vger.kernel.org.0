Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2107759C10F
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbiHVNzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiHVNzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:55:41 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD478399F5;
        Mon, 22 Aug 2022 06:55:39 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id q16so5694475ile.1;
        Mon, 22 Aug 2022 06:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3lEomZITbp3d7+6G3a9sOaKmP8wAKd/KHGPtjPveVlA=;
        b=EoviTJwakDapKtuM50+1qQHhbvy2oeIqscxwwm2PP5kouzMyMpXHwT9/X19SvmY6a6
         kAYewLK+41LhQh4Y+2c2Jw7MKKHmJ9ZNvikk6V4xH58aRNlelqIVK6FEES3gbLflJAuq
         +Fweb6snMvNwSbj+REwPAERgKgytoo1NW0bNyLjUwr+9JB5ic1TiNzCBu0u4GXHo6o70
         EsXcRFgSmk0pppimtawe/g9Wnydo0ZvlJ0oWN7fqEUL5n0JZ+oAwWTBveT0210jiGzxC
         IJlBVdgoWwJ82DeLU4g5t1AB/pAvXmTAfSfaJmFHIrdS+0tqws+SADijquroonVlwJT1
         LVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3lEomZITbp3d7+6G3a9sOaKmP8wAKd/KHGPtjPveVlA=;
        b=HZJLHvs4FZtoJe4/eGSzwZQRAf6jAfkD1D5jr88+x6Tq3pqorh+VS/fsq6yW64tC38
         rgnXYc2kf//ndNlip6do1kSy1Ey7LVMhlrfmkNJ42CHNs1oH3dmR4pOqC+tywWaZAdVS
         iqc8+ib9pW2IU3dM0dMl5G6kstYJgABKBdlSyw0UpWTVmnxNKkm3vwNQ1HNINfOHrtRT
         Yam940NSdnW81YYuhmlktnJLiSpFzehPqXxjtVB/k8aqwqMAYAMskv26W0eY8zMI3ZV6
         PXqkP4zfZaDdpVaAwJd6zlQg3gMM66syBeFpvmdVBpanjI2dyLQ2JVgXYvCVADQVw8In
         c+XA==
X-Gm-Message-State: ACgBeo3mUwRlZvtR2tCit4IQQOUbrOQGGa7yRVbYUL2HmCp56u0oXgVq
        G/Zy37tZhtW+PwpJ2cd0Z5AfRJCUd7f6T3bOnsg=
X-Google-Smtp-Source: AA6agR4iyMKjjhFIsnvVU/Kv4jNf7oiAENM6MaUvnVsb6CZ7oYnfUSvnBYdd4CiHU3lth7fNA0dsc5/QNl8ymg/5Rlg=
X-Received: by 2002:a05:6e02:148c:b0:2de:c3b:91d with SMTP id
 n12-20020a056e02148c00b002de0c3b091dmr10143943ilk.95.1661176539069; Mon, 22
 Aug 2022 06:55:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220822112952.2961-1-yin31149@gmail.com> <20220822130414.28489-1-yin31149@gmail.com>
In-Reply-To: <20220822130414.28489-1-yin31149@gmail.com>
From:   Khalid Masum <khalid.masum.92@gmail.com>
Date:   Mon, 22 Aug 2022 19:55:27 +0600
Message-ID: <CAABMjtE-XKa-_kW-aREvHDiyGwcs-GZWjtSjZEeF577FKcUTAA@mail.gmail.com>
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        linux-afs@lists.infradead.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> /*
> + * @holding_mutex: An indication whether caller can still holds
> + * the call->user_mutex when returned to caller.

Maybe we can use mutex_is_locked instead of using the holding_mutex
parameter to get whether call->user_mutex is still held.

https://www.kernel.org/doc/htmldocs/kernel-locking/API-mutex-is-locked.html
> + * This argument can be NULL, which will effect nothing.
> + *
> * Wait for space to appear in the Tx queue or a signal to occur.
> */
>

thanks,
-- Khalid Masum
