Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC6D59B57D
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiHUQm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiHUQm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:42:26 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32214186C3;
        Sun, 21 Aug 2022 09:42:25 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id q16so4571822ile.1;
        Sun, 21 Aug 2022 09:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=y69JmQlO6FygAih7FHMgiwqqOzWkTBxWLh4obbN+5DM=;
        b=WatGo1HqGwc6NN7+6dxL4nxUpCMnVnAQ7FAErNyVGjjar/FZ7SHLo4HhBbWcIy5cHm
         ysld1P9Kta6ZTyHqq1aEfzXWW+D5AOJF70AL2AO9Pv+ME0vTC7W77A30+QS17+/p/52B
         NLk+HybNDZcQUzmjXr1dskNR/Mvyc9+dQTNYslgmVUttVMbVI97zf4uTdMxhSlmSSzdf
         dqM53EByXmUp4k0xcXkFnek/HTMpR1GA3PdCqYqJipjg/NlodF7qRoL3oFsrEWyJQ6qX
         1k1EoSmwv6MnaPhUeCPYgOI3zm34smjIaSN55y/OngHNwlXF2O9ZQjTqJ8SAMmEMTY/x
         KK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=y69JmQlO6FygAih7FHMgiwqqOzWkTBxWLh4obbN+5DM=;
        b=F9PNjbsy73CbjHP9eS1pzDoEuDgehg9++L2PU1cwXhkdZqeLt27ZrKRrpeup9rNzRF
         MDHcikM4TXnFzx9RZSfE+/3fFLEFvD2c0cC2ruyTS8Kk9fVhIbO0TUYMU/OHkDgbME5B
         GhMqaYAUwYIjVjVniz7521sIawOKHBNbFqQQccSZJvUHq/ZsN78vyzQQlVjeS7CR841I
         ZsoRVEygUyqG/0h5PZ+HZI7FcKkIW5rjYgKbVXN2ExWHDBzg5wNC8FwZiWY6u5UDP1Is
         6EaaUtFuURkS7o4pif20p6JaMw4mgqxs2Y9NRAeaauKUiua95a6fef+mOSu9fLoLM5j8
         pcyg==
X-Gm-Message-State: ACgBeo0n4O2QVHCBPS0luUA+8yRuiMKsqZ8p/qdC5flWFwP2qUWNfSVK
        BQgfpNwdcabWAcCjHcg19lsvS0LGFujNKpXwtgM=
X-Google-Smtp-Source: AA6agR7DYHJ2swGsZJ2PE/RBRuclXQzErDD1UMI88mkRUEhDDinVfG0/1URQxM6z670bXbs1YppT/hrOhE8GrazzuG8=
X-Received: by 2002:a05:6e02:1c0e:b0:2df:622c:37cd with SMTP id
 l14-20020a056e021c0e00b002df622c37cdmr8248699ilh.234.1661100144528; Sun, 21
 Aug 2022 09:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ce327f05d537ebf7@google.com> <20220821125751.4185-1-yin31149@gmail.com>
 <CAABMjtF2GeNyTf6gQ1hk0BiXKY9HWQStBAk_R3w6MCFQ3bOYzA@mail.gmail.com>
In-Reply-To: <CAABMjtF2GeNyTf6gQ1hk0BiXKY9HWQStBAk_R3w6MCFQ3bOYzA@mail.gmail.com>
From:   Khalid Masum <khalid.masum.92@gmail.com>
Date:   Sun, 21 Aug 2022 22:42:13 +0600
Message-ID: <CAABMjtHJX6Rm1Ndg+bECbERWkFYdWbDDYd1-5bVFTu-qwKW=sA@mail.gmail.com>
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        linux-afs@lists.infradead.org
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

On Sun, Aug 21, 2022 at 9:58 PM Khalid Masum <khalid.masum.92@gmail.com> wrote:
>
> On Sun, Aug 21, 2022 at 6:58 PM Hawkins Jiawei <yin31149@gmail.com> wrote:
> >
> The interruptible version fails to acquire the lock. So why is it okay to
> force it to acquire the mutex_lock since we are in the interrupt context?

Sorry, I mean, won't the function lose its ability of being interruptible?
Since we are forcing it to acquire the lock.
> >                         return sock_intr_errno(*timeo);
> > +               }
> >         }
> >  }
>
> thanks,
>   -- Khalid Masum
