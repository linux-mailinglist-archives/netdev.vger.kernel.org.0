Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CF86119F4
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 20:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJ1SN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 14:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJ1SN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 14:13:27 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F046322EC9B
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:13:26 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id j130so7002587ybj.9
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GRcV5xqQsaOgKI1wjHQNKQ2baGNXvTvrAr7N640Ai0s=;
        b=CrDfDlrAw515cZ1vZiX6k8IppBaUIH3QpEY2RuR7OMNwrJT1CcS5s7Vi1s0Ov3WRMM
         xzYYTOYM5R6085EGA9/TzECH5ybIyzWrwQRXmh07SgIdKYmMpXNrL+HIOy5HXN60xN5d
         lMbjx0IqbKUfBZKQjTaHEzixLfTbcYB0ooq+GmnoQRawc2YlaU6QXlxSTqiGy0qI6Kl+
         AzqjkFWZMA7x2Vm8xl5WhtA7a7R0YtTJpIta4G3oURv81vVjvwHcXoFWKJhBOSwj6yqi
         PVtKxuyTTxY+MAg6yDrjqaVosI3+dveSe/KUt4P2ig70IG7FVm8fwMS2bVjv8upQl2LB
         fcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GRcV5xqQsaOgKI1wjHQNKQ2baGNXvTvrAr7N640Ai0s=;
        b=wgp8Adz890zQ8xSnKKCY3u8SUFN0lZStrICcKtF+lNedbu0JBOSFW593a3xJ7tVQUC
         IPKxJ/J6vqlvYgKDE0aRH1OkiFeiwNn0juZFMsXTOXKNCLstBb+Ya3VRS3+5myCOsDlw
         qxEgcOfcttVuA/zKjOPO08I2eElINPdbUra78ASRyFzYoEiUHRKv/ufySTcGUsezvZ59
         SxHJ5/tengVieEQMtrNq5WvqZyJydX9oxdBEF9zw2IKAySpwoXX9nAt4n+ICnnf2ktri
         wYOKpGtnTXHYx+z2e3ntt+vN/mXxkcAQYgZd99VzHqDoXcFJF76S/jYSIih0daS+uYzl
         0vjA==
X-Gm-Message-State: ACrzQf1wOB8f1EGX4DcqQHAJCLoFFy2CXGylFBi8ZgjN5sHakN1sr/ix
        k0sfHhg6k/ALmqgtmw3oMgMQnBZ3Y6eKMwRytvNsDpUOoEs0Ig==
X-Google-Smtp-Source: AMsMyM5XvKCGwZtr2CLA9TM3XnI20xhaT2HqoTdj6+7h2t7UKjO5oo6Nk5V388Kg5i/+TnIodr5V0b7Y71x6e9YggCw=
X-Received: by 2002:a25:aa2c:0:b0:6cc:16c2:5385 with SMTP id
 s41-20020a25aa2c000000b006cc16c25385mr498211ybi.55.1666980805906; Fri, 28 Oct
 2022 11:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <Y1vvnBnSVl976Pt3@kili>
In-Reply-To: <Y1vvnBnSVl976Pt3@kili>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 28 Oct 2022 11:13:14 -0700
Message-ID: <CANn89iLaHEh6fGCFChFCDSVT=hrm0v7wXd4-FR6Gw25Ertgnpw@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: Fix use after free in red_enqueue()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
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

On Fri, Oct 28, 2022 at 8:05 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> We can't use "skb" again after passing it to qdisc_enqueue().  This is
> basically identical to commit 2f09707d0c97 ("sch_sfb: Also store skb
> len before calling child enqueue").
>
> Fixes: d7f4f332f082 ("sch_red: update backlog as well")

Reviewed-by: Eric Dumazet <edumazet@google.com>
