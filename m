Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0297330FF6D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhBDViI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBDViH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:38:07 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07385C061786
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 13:37:27 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id y5so4010335ilg.4
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 13:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8+18+nYXl01EEwvM/d6ty8SQDUM/GT3KwNzRdbRTwJ0=;
        b=kXhoGfhlvqFKAhqCBpXAcguXcxf0OawyfczZKm6z4dv7UNPTaFPS0inTAcUmeuMs0i
         oWe6Uj/HA03oL5epgTOHx8Jr0r+z0+bDCusXYrGbaklX7cYsg/Cttv/XB+fn+IMxwFI5
         uF1LS11CiKmAuJt9fdrOnZxiGYtF4S3dX6ECsUPkEfdFFux4AU3aerFgvjzW8+/3xKnL
         tJRcyW8m4vZoLlW2zUoYoWJPasPA08/zLaEmh5UT+IY4z4SyytZ9Qhf5MWBJhEgi0tL5
         9nU7ocGRPTfuaXN+om4S5jR6oRi7oWkGnxtHm3sZpoZzI8+uS7YL862bTDNEtxZgttLr
         wrPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8+18+nYXl01EEwvM/d6ty8SQDUM/GT3KwNzRdbRTwJ0=;
        b=FeO1/61hB1Wt2IOJ6jJ6zaoUMeUuUluPhzqvDxuDwC+h9nQ4YIC/dt6hfigVMoNiYV
         AzfdNJfAqNGbYwPKCWFCPzDL6GJlQZHtut/81r7UPSrLlPb0fUrUppJaWJOx3jbTBQQ4
         XmLI+vnEc2IpaQpI+njUPTMcBYHwW7H+8czD6/Z9crbKRk/7JV3rmgDewThzgZ02GGgc
         y1bi2GfNKOKpSUQmLoRg8i3RWxveJdhfl9qTv1vV4sAgh4HomtHjdjbbKM1NPMumq1YS
         7EepZO55i+h8lIrR6ShZRO4UP0412TY7IxqUWm6lss06BTTIkCSzLnYW9M3RK7QFM3oP
         HpEQ==
X-Gm-Message-State: AOAM533jbxxWzeFgWNw0KevtQ7YXx379EXrLcA4MHKxMuQaBARl+R2mi
        x1gSG2gZTQ0o5/f4xnr/wHj8xx069hZDpVyrdIk=
X-Google-Smtp-Source: ABdhPJyMQDrK/qYiza+R6Fp0bHEjEpXM8fv/qbKBgZ5McIZC4VRS90z0N8cypVlSVW39h7i710+OYGKv3OjsrvBIuBE=
X-Received: by 2002:a05:6e02:f48:: with SMTP id y8mr1038411ilj.97.1612474646358;
 Thu, 04 Feb 2021 13:37:26 -0800 (PST)
MIME-Version: 1.0
References: <20210204213117.1736289-1-weiwan@google.com> <20210204213117.1736289-3-weiwan@google.com>
In-Reply-To: <20210204213117.1736289-3-weiwan@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 4 Feb 2021 13:37:15 -0800
Message-ID: <CAKgT0UdrQHnnkpRdxLStfeVOQ0a=5O8E1DJv0RPkOJ8C4XZ_Sg@mail.gmail.com>
Subject: Re: [PATCH net-next v10 2/3] net: implement threaded-able napi poll
 loop support
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 1:34 PM Wei Wang <weiwan@google.com> wrote:
>
> This patch allows running each napi poll loop inside its own
> kernel thread.
> The kthread is created during netif_napi_add() if dev->threaded
> is set. And threaded mode is enabled in napi_enable(). We will
> provide a way to set dev->threaded and enable threaded mode
> without a device up/down in the following patch.
>
> Once that threaded mode is enabled and the kthread is
> started, napi_schedule() will wake-up such thread instead
> of scheduling the softirq.
>
> The threaded poll loop behaves quite likely the net_rx_action,
> but it does not have to manipulate local irqs and uses
> an explicit scheduling point based on netdev_budget.
>
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Co-developed-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---
>  include/linux/netdevice.h |  21 +++----
>  net/core/dev.c            | 112 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 119 insertions(+), 14 deletions(-)
>

Looks good.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
