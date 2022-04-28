Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA02D513F00
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353255AbiD1X0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiD1X0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:26:20 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548F9BC86F
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:23:04 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2ebf4b91212so69260857b3.8
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UsFCmC6YdhvNQMI+F0Kw4xdZkWuwKMT5oK6IglXZNb0=;
        b=R9hJzDu+faRoowHhFvoAoCTRn19vAxgPqADrtmz6WPoNK2dk1tgZEncaW2Bn+Z29ZU
         2kPdsj+k/RgVizDDf4mN7F6W6886OQGo0u/b6brVt9ugQ39x8V+tFFqP0qz+0Rv+T7zo
         FXiFsFewlIgnK2mfchZpS4Ka4GjAwH+dEMofhGF17dpbx4iG4RQtQ6Yz/S6EyrLX3Zra
         CGEXh1te4mvWmx6JjmnDURAC4qi6AjBCLs5gfEVnY5JzxPhq3BCDcSZdgGe8HQmjMAwu
         ynhTWB778zQ66SBme2bE8AzZqJZ1B55fBS1HedxsqQr5sVJOS2tV2BtAw3Zqfylq9Iyk
         V5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UsFCmC6YdhvNQMI+F0Kw4xdZkWuwKMT5oK6IglXZNb0=;
        b=2YNbUzEZ7/vYeatmnaLSuO7UERrLA/dhC0C1BCOpskf3Ga20xyuP8V473CR5NS77mU
         CwWJIzHkgROet+Fbq5jRvxcDpqga0ahhXM+vy+hHlMfxfryuGpAsBIPnfAVvLNXmkaLN
         kJp96aHi/fw+J+lpOmK1uIo+MjpCWh1URu4g7Qb7co9xc9iIKRGSs2HLCuqYW4jtWVis
         qARqyhDSjubSvGxQ/pY6+sVgIzn/9QhLtDvB8Ib7GQDsDSmsNqVa+s3hBe+l5TRo+dqp
         sVYVVV9f72vF2WywnTBpIoy0HZZ0HKdKRpwYsaK5ZgUOdcToP/eCiAOF0hujDWbLp8Bz
         FRHg==
X-Gm-Message-State: AOAM530oeCdtGvU/6QwJPh1XgmB3A5OL896UC4YQqxmplhem+0xliUXN
        28YcpiMsTYdgiFbSS6796abMVI1OheuC/1m13XXPwR2BAAYW3w==
X-Google-Smtp-Source: ABdhPJxuMFrrRxtm64o9cEGDJ72h58aXfxeC34I3VhYBDMwCpQi0Ftc+9l4oOS9BHkoQHvPus8AEwmeOIi/8NUK9v14=
X-Received: by 2002:a81:4f0c:0:b0:2f8:46f4:be90 with SMTP id
 d12-20020a814f0c000000b002f846f4be90mr10541309ywb.332.1651188183295; Thu, 28
 Apr 2022 16:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <2975a359-2422-71dc-db6b-9e4f369cae77@kernel.dk>
In-Reply-To: <2975a359-2422-71dc-db6b-9e4f369cae77@kernel.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 28 Apr 2022 16:22:52 -0700
Message-ID: <CANn89i+RPsrGb1Xgs5GnpAwxgdjnZEASPW0BimTD7GxnFU2sVw@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: pass back data left in socket after receive
To:     Jens Axboe <axboe@kernel.dk>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
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

On Thu, Apr 28, 2022 at 4:13 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> This is currently done for CMSG_INQ, add an ability to do so via struct
> msghdr as well and have CMSG_INQ use that too. If the caller sets
> msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.
>
> Rearrange struct msghdr a bit so we can add this member while shrinking
> it at the same time. On a 64-bit build, it was 96 bytes before this
> change and 88 bytes afterwards.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---


SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
