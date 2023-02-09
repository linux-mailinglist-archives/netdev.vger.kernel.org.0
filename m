Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDA16905C5
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBIK4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBIK4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:56:18 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CCB457E6
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 02:56:17 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id j32-20020a05600c1c2000b003dc4fd6e61dso3560510wms.5
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 02:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E9LSV38ykIpCSEYqJmlIXyd7/ZpIlsOo8lrT8ObZctQ=;
        b=SxDQbUOprujL10g2ffwX0NZrkSADN1HdScNwC6sZDfxvU/+YqsYxw2u4eUTC3OlF3n
         qA/1+dZCq1FiKe6wFtmzPEBPEHWfn7YvzEmtxCqASgFEnTt10l45Xxf8E/Ohz4JV1wMv
         lVJ9XqCPOlvBUYp94gS7xILR3Ljp6Mvss+aqrHwC/O/Nsw5Lj5dIRjQVR0A4ejxpcqWt
         t86/Kz3SaPpQWdK1o0nsnng5xwPYBSSemRgoZHl2sTur9PrgMy+Y/Bda4VMj82ZxUmjo
         YRszrCQ8gP5+m8uTnotoZuVlB95JjmDL9b7UvlkYSo1S0DBlsY4XswqKcIJJy76XH7q6
         +fTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E9LSV38ykIpCSEYqJmlIXyd7/ZpIlsOo8lrT8ObZctQ=;
        b=KO6vvZVJrh4Tg25CtM3OrPqsWknTFp39l5ciuvt/8TSGCzV399Kl+5AzFL6M6QdC1U
         CQGmS6S6KsvR0OQbcXeAUj6XJQhZHvoAwWe82nl87zNFWhpfgq8fh4JFRk8sKV3P+hO7
         tUy+LLsqPwc0/Ca2w/LCXDh4NrfvZQpRe8qerUwGYcS/qzzV0PenMvxiRwvauNpiDDwc
         PGC8Put4xuGRVmhDutJg5bX3IhrEI4Mmya9G/4rnk2H+Dt3VKKNnZf2f+xWaTHjUienJ
         48A/qDjlXEiXOFYsbnBIdjIuJZ/PaiFnaCHaP/NXZiWDw6q+go6Np4AcNjtlpUha7CW0
         w2Vw==
X-Gm-Message-State: AO0yUKX0qs5yLPDPta+yVvdC4RlSh7/zHcaUfKbf2+J/gIF/SVvkuWwR
        DcPx5XfaZOF5tKzpJImyo4GLvl3XACs4HtFu3g2Ea5qErFii1hRH
X-Google-Smtp-Source: AK7set902zlOTS6k/jUDk4pe0zSoz2KfzwKnyT1He8Gyy/tGqC+ne+HjURcw+ISQcLKlh3JeMOGTo1lbfh0TsAXFMiQ=
X-Received: by 2002:a7b:cb8b:0:b0:3df:dc12:9684 with SMTP id
 m11-20020a7bcb8b000000b003dfdc129684mr414163wmi.22.1675940175419; Thu, 09 Feb
 2023 02:56:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675875519.git.gnault@redhat.com> <f8b69f5aaa0049c2d9d162b1155beab535cdbf04.1675875519.git.gnault@redhat.com>
In-Reply-To: <f8b69f5aaa0049c2d9d162b1155beab535cdbf04.1675875519.git.gnault@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Feb 2023 11:56:03 +0100
Message-ID: <CANn89iLOFh1mN_UhsuQBHay7SudzMb+6BS8FuvhJ0F7Di2bj-w@mail.gmail.com>
Subject: Re: [PATCH net 2/3] ipv6: Fix tcp socket connection with DSCP.
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
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

On Wed, Feb 8, 2023 at 6:14 PM Guillaume Nault <gnault@redhat.com> wrote:
>
> Take into account the IPV6_TCLASS socket option (DSCP) in
> tcp_v6_connect(). Otherwise fib6_rule_match() can't properly
> match the DSCP value, resulting in invalid route lookup.
>
> being done in the main table.
>
> Fixes: 2cc67cc731d9 ("[IPV6] ROUTE: Routing by Traffic Class.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
