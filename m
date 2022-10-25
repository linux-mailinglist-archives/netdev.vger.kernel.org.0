Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6196660D82A
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiJYXuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbiJYXuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:50:04 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE1B3B706
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 16:50:00 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-369c2f83697so123784597b3.3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 16:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/62MVg5pgFg8Vpt7pgBRV0gOYFDrcMUSU00wTJps7/w=;
        b=CUXOWwnENJaTPXi24segoZe3AC2BYed1yu3V/IJRrd0aR9PXBw9vjwAbwF59o/HVe3
         3+qRBEnSvTZQzu8mMs4OvdGjrrrIPClVCnsz8KKUcgnAzPuL7J+Ils8jzDRnJsFmG97l
         LxVVF7+oyw1p3ubgozdI1ER9MfHjTN4/szLB3pSk7o9CjHhNy1h5klZRgpqm54TFjJbL
         q5QHR+8Py7WbnBm8bG1SjXAUsqg+JjauvyYzS9e9CPWrEfLHwZpVQlwfFfT2gFz4mO2z
         WRIYEXGJSZvaa5rLOrDOc1tlP49NFrC3PDuLr6kK9dRJbFqTUpW5EmGf9Z+7Ve7yGVCd
         kvzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/62MVg5pgFg8Vpt7pgBRV0gOYFDrcMUSU00wTJps7/w=;
        b=RMsd0PfnyE6N1JeJQGkc6bIBj5sbmbIrjqj0ELwnHPLG2KDw9pRz5n//B41YFVYUcO
         RBekmkKs9if33q8uFbs/f9c+KQA37cCWKPtZUCW74/3M+n6aZnOiPzB17CCO/fVdcLlC
         EVnBr9sgsxHdQwYCY5RlgmHXlzbkWdFSsIGKDCYInv2JxLPNC9nz67SgqeOys/X7irkb
         B6Wi/4LKkugqq45aI46nbT+26DAeypvDM4L7vltDFP+QA3lKpDRnlg1t7JvfC8MVOPOS
         z9fPRiNrGmwW+I/D+5ucC0h8fUDlezrC9LefAcWsvfFAVUmf0iMPqjpZQ9Hom41+tLvl
         d6aA==
X-Gm-Message-State: ACrzQf0tCM8k0sMepka1F40cwK00X9i/dz+1uAduy+cdteZ8eJ9EGw4O
        kis9jePTT9Gz3wfhPJDCA/7UiqfK6/Ox42SNDAYnZw==
X-Google-Smtp-Source: AMsMyM4r+RBZWH8ylsgrOMs8ws5hL0jxA43n+91dfLpe488v+Pl/0jldyx3L2Yhs90HWyP1m3Om/gpp7nt5GP5SSYYc=
X-Received: by 2002:a81:9a4f:0:b0:367:fbf9:b9f1 with SMTP id
 r76-20020a819a4f000000b00367fbf9b9f1mr30181010ywg.55.1666741799829; Tue, 25
 Oct 2022 16:49:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221023023044.149357-1-xiyou.wangcong@gmail.com> <20221025160222.5902e899@kernel.org>
In-Reply-To: <20221025160222.5902e899@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 25 Oct 2022 16:49:48 -0700
Message-ID: <CANn89iJr+RdwnyoBmFmtc0m7KDSOg-5GboBpCOc4Diut9W8W6A@mail.gmail.com>
Subject: Re: [Patch net] kcm: fix a race condition in kcm_recvmsg()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>
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

On Tue, Oct 25, 2022 at 4:02 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 22 Oct 2022 19:30:44 -0700 Cong Wang wrote:
> > +                     spin_lock_bh(&mux->rx_lock);
> >                       KCM_STATS_INCR(kcm->stats.rx_msgs);
> >                       skb_unlink(skb, &sk->sk_receive_queue);
> > +                     spin_unlock_bh(&mux->rx_lock);
>
> Why not switch to __skb_unlink() at the same time?
> Abundance of caution?
>
> Adding Eric who was fixing KCM bugs recently.

I think kcm_queue_rcv_skb() might have a similar problem if/when
called from requeue_rx_msgs()

(The mux->rx_lock spinlock is not acquired, and skb_queue_tail() is used)

I agree we should stick to one lock, and if this is not the standard
skb head lock, we should not use it at all
(ie use __skb_queue_tail() and friends)
