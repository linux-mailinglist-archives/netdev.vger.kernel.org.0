Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E47F69AB60
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjBQMXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjBQMXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:23:45 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7A46605C
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:23:42 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id bm37so96257vsb.0
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676636622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sgY+TO8yISM6HZsPpSOg1kNbConbu1J0jamlIWfyT+A=;
        b=dbSPFyN7puk8NhJQP+ZCyy81uhrT0RNdw9cQK026j1bDOoyHDwClWNSN252sYa3X4b
         bGi3fJWF8wM3vNcrPQGqBfaZL+lO7LiBF+g4omqvaqh8TMKg2KdGl546aNo9lQdjudv/
         j7OIP1NOGd4emh+zI6xOoAbFG34JPXdsX4oObg9XQLwNwApBgWrNb+2f1URnPD14od70
         WP+YpiN7CdBYDarKkWn8KUvywMnVsnu4Rh9QVLOnyRulkyS3xvWROhbzgDZVr5yVWpid
         7+wyjEoypoWxri9vaqYR4nFD9lOSBYhsXR4C4lvlPJdoqCVhp36tngX+Tze00/fsTSMO
         8wyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676636622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sgY+TO8yISM6HZsPpSOg1kNbConbu1J0jamlIWfyT+A=;
        b=WebiJMM5EQG4Aqt8TteWvJYmDKzIa2mIfWvOlfA95i4XVbsgSHo2lKBk5m/ToBhVAG
         sAAWYMlMps/iF+l7/AQvbCqSywjjz2PqGrMUann1Nk/d67lMRa3potzwf4Ndu3HEYbMz
         GIPPTjl2bVqVHom2I2C2DhTp2Hl7Uk/1o6zoW5db9N6tStPBed63XNTICvnpsP5jpJfj
         IrQgy2fFJdkbfac3QUxfOOF4gL6NRfl48hfKNYeHnJlW7M+4UKdXYl8QDP6nOKRGdeUo
         wUqxDtJzkJ2HU1osr0K1xUvmNCc48k/wqfc1J4fe6GW8Q3QQkbkSHJORtqQ6mCpkd+mx
         h2Yg==
X-Gm-Message-State: AO0yUKXScry4GAQ/YNcJly54v5aharoT6u4YOj+KsGN0qrh9LLwdP/8A
        twE5+iC3PyzZKWnaT+KGZnBjf33hushv3qqmOd/MM4Sfp/aMjYEW
X-Google-Smtp-Source: AK7set9D76P+BVWHdTQ2SVg87fd5PA3MbpTdrnpRN5SFDEPJEgbVJdbHakLt7Yska6pkOaVX4F4g5vtd6pPStimGPQE=
X-Received: by 2002:a67:e046:0:b0:412:6a3:3e1d with SMTP id
 n6-20020a67e046000000b0041206a33e1dmr1616158vsl.25.1676636621874; Fri, 17 Feb
 2023 04:23:41 -0800 (PST)
MIME-Version: 1.0
References: <20230217100606.1234-1-nbd@nbd.name>
In-Reply-To: <20230217100606.1234-1-nbd@nbd.name>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Feb 2023 13:23:30 +0100
Message-ID: <CANn89iJXjEWJcFbSMwKOXuupCVr4b-y4Gh+LwOQg+TQwJPQ=eg@mail.gmail.com>
Subject: Re: [RFC v2] net/core: add optional threading for rps backlog processing
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
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

On Fri, Feb 17, 2023 at 11:06 AM Felix Fietkau <nbd@nbd.name> wrote:
>
> When dealing with few flows or an imbalance on CPU utilization, static RPS
> CPU assignment can be too inflexible. Add support for enabling threaded NAPI
> for RPS backlog processing in order to allow the scheduler to better balance
> processing. This helps better spread the load across idle CPUs.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>
> RFC v2:
>  - fix rebase error in rps locking

Why only deal with RPS ?

It seems you propose the sofnet_data backlog be processed by a thread,
instead than from softirq ?
