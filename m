Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74352623024
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiKIQ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKIQ00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:26:26 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F93A19286
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 08:26:26 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id r3so21608540yba.5
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 08:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EXqN0wfNffpKtiXYP49RfhxCSKE/AuHwGRFJdbOJE0E=;
        b=mFF9+AmdwF/Zhzj+cH6XPuvfdGRF69z9Rnh7oe7abk/W1j4zvN3NAncSUEeEhIWqxC
         IFME2fDmlqTdOGQfkUWGlVIF6Oseb0bo/JOKf3DB9cUfgFbBKGMWe+m9rKGr3cjSggau
         ePle6paXttd5ekmcHqXs0O2hwlRCHiTE3+nxwMXqAt63mYr4daxV3Lh9UmTT9xn/sflW
         5WmmTgGCWGzMh6zjhx7ob0P0LC0iH7WVsXExC33cBrQp21bzA9CriusMsEreEF958RAA
         Nm6bLUUyEP9X4IKZvHKjqnO3vroQNR8deKwnoGDZRmYFuC+S1sF8KUUY0Ox7CReWwdcg
         NfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EXqN0wfNffpKtiXYP49RfhxCSKE/AuHwGRFJdbOJE0E=;
        b=HtTl0bdPQeue3uHtPInwc0RyMLzkegaeXEzReJ9L1Ucg5sLS3OufbsroCS45nwVHhJ
         HR8A+BbN2Jk/yXrlE14I++tyL1qQWJZDkX4aAvl4jxN20i1jy497N44qbBcLgIQwB+wN
         4Db4CYc0JlaVvOyAaj4JG8dr+Tbn1iIhP5hvjxoXUlqRHfBIMd+dwOXNl0wI5XL6UTWK
         zGkH/o46bo5szsq/VSOSovVP3uugMfGCKSBF9CRoT6AVbc5S3HAxJTWej5p9Ci2cnQj0
         jxpHhSNq5kYwwWMN59VsbD/6fAy8+egSTCvnAzJcg6/5ODx0+678jTETi9QB/AG/t5uJ
         ZnEg==
X-Gm-Message-State: ACrzQf0Ac6n9vVIIzHSrlWF/dK0uxD0XAJ/j7vv8qy/6KufCkyZL0HtU
        jXlVUpaY/3mvqgosKLLMGWaDuZYDNUNg3scc0p4ftQ==
X-Google-Smtp-Source: AMsMyM5RqBur/8wQfkovk8//1t+wI46ZfxpzSeRgX6tNp4IgBpHAKm/WYurznT/5ChwnN7Y05mNjS7h4Y6tMbOAkpwU=
X-Received: by 2002:a25:d914:0:b0:6cb:13e2:a8cb with SMTP id
 q20-20020a25d914000000b006cb13e2a8cbmr59477136ybg.231.1668011182986; Wed, 09
 Nov 2022 08:26:22 -0800 (PST)
MIME-Version: 1.0
References: <20221108132208.938676-1-jiri@resnulli.us> <20221108132208.938676-4-jiri@resnulli.us>
 <Y2uT1AZHtL4XJ20E@shredder>
In-Reply-To: <Y2uT1AZHtL4XJ20E@shredder>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Nov 2022 08:26:10 -0800
Message-ID: <CANn89iJgTLe0EJ61xYji6W-VzQAGtoXpZJAxgKe-nE9ESw=p7w@mail.gmail.com>
Subject: Re: [patch net-next v2 3/3] net: devlink: add WARN_ON to check return
 value of unregister_netdevice_notifier_net() call
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com
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

On Wed, Nov 9, 2022 at 3:49 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Tue, Nov 08, 2022 at 02:22:08PM +0100, Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@nvidia.com>
> >
> > As the return value is not 0 only in case there is no such notifier
> > block registered, add a WARN_ON() to yell about it.
> >
> > Suggested-by: Ido Schimmel <idosch@idosch.org>
> > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Please consider WARN_ON_ONCE(), or DEBUG_NET_WARN_ON_ONCE()
