Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4240962EC95
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 04:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbiKRD5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 22:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240810AbiKRD47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 22:56:59 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D5291C04
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 19:56:51 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-369426664f9so38257007b3.12
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 19:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SsiMsAzDlSLJwzmRWqJ5h3ckG3cOmcb5jkuz+Jp1qRQ=;
        b=L77aU4khxl6eRuvJsseXrktXsgPma8Gg950JxipNomcV73sYlvCIrR4oP2ctCYZ+bX
         V4pFTO5sOt8LIeXmOz2vk1up7yfhRt4n8C3eJSF0Clops+5vX6Ix5ElCfHJji68LoOFq
         jg6pHas/4s42mOYnMs2S6I2PPc4g9LxIrMy+q8uay//e5NGcey88oclpbMMLtdo4AA3b
         /M5w1MIqCPOY54yVB+Br20A/bEnqKk3Yvp2lb2eWdwZCWmmxH3fvLLxDPAx6WwmxaYl4
         3PWP+PBzsUfIPdzbINwG0WIPljMexrYh8ZaDapohTgUpLk84Qf9sGs0ImRpRLtCsarrw
         5Ajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SsiMsAzDlSLJwzmRWqJ5h3ckG3cOmcb5jkuz+Jp1qRQ=;
        b=T5Z+iqAzNYTU78CuV1S444nz8U6WTcIwUievnESaKmZUDU5ngEn9Ik1q4OgWQkF8va
         /9GvgkgFACqCuDPD78ztnsfU9OlXVTBl+YSlTjG/6CcwryuQ1jRNVLgxcNPvxxda2YWX
         bAaR61agLaHqlluLWpZMApuojF8uKdXstvdehXaJsOWGD01IEachmXIVjT9dP0jFWPDY
         L0HBLeRB4q2DX4sw8KC2xS1WXFd1dHAK8JA45fK7sGHsO7JtIn9HcxagMsWSTrIOxve9
         hpB+dxuizKuw33v2VPTveZYpVmTRTaoSBgBBvCJiO7qo6snIBvSr/xap7V1cu6pbGNnP
         RB/A==
X-Gm-Message-State: ANoB5plxnpHfuXnv2lmyZM4nUuil6LXqxxDu+D3U4iyo8WTRX734vWkQ
        Y7CZM9ZgnsXeO9tYs0JXnBuT2DD+MoQAojeiEsu0aST5N3U=
X-Google-Smtp-Source: AA0mqf7FUXpAsITkNYmHLHxvauYBrwdV+xmHnXooqkZwlQNRO6RU746eEMqSWlg8PM8AmsZbM2aVYUMhl2R93v9I62Q=
X-Received: by 2002:a81:5f04:0:b0:393:ab0b:5a31 with SMTP id
 t4-20020a815f04000000b00393ab0b5a31mr2885085ywb.55.1668743810364; Thu, 17 Nov
 2022 19:56:50 -0800 (PST)
MIME-Version: 1.0
References: <20221118034353.1736727-1-liuhangbin@gmail.com>
In-Reply-To: <20221118034353.1736727-1-liuhangbin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 19:56:39 -0800
Message-ID: <CANn89iKK_Y6q5yE_z9tXzNk8GNHVQZ_5zRtwK_pNRDYC5+p14Q@mail.gmail.com>
Subject: Re: [PATCHv4 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Tom Herbert <tom@herbertland.com>, Liang Li <liali@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
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

On Thu, Nov 17, 2022 at 7:44 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
> transport header to be set first. But there is no rule to ask driver set
> transport header before netif_receive_skb() and bond_handle_frame(). So
> we will not able to get correct icmp6hdr on some drivers.
>
> Fix this by using skb_header_pointer to get the IPv6 and ICMPV6 headers.
>
> Reported-by: Liang Li <liali@redhat.com>
> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
