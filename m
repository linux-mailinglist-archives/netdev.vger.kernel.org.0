Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B9D2E23B8
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 03:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgLXCkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 21:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgLXCkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 21:40:39 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D9AC061794
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 18:39:58 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id 6so1692657ejz.5
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 18:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NjG06L3A2y7EyOAPA8qQEkMYP0fOIFXomd5VJhGvonw=;
        b=lbD06MwxnMTBKm9UFkUyMaagYzhQ04v/L3QpVGK1v5pFcVLlx5paigmmmNGxgXAtPQ
         LI6jvLtwaGR3BQFrgr/blcDNVCbqEip4x8Xi1NQXDLFPZHkeqTqb3o9O/3Bd1nL9qXxV
         Mq6z2RpsHwX+B/eA3m0he+uaX6CyPTXpVL1564accO79rZ9EjQk7728fznCwVbWZ8P6u
         hb2MNeO3f/O0iK9TdJxP4p5x7NiFGLBhMbunyHNGulN/ZD2KJIWzD+AjD5qRDqIbXnfr
         FKFKJuiI89NCu5somS7XlnSKf2Hoi124gMW0kaUJ6NdtTznaO7XqMhNWz7+dl5ia6fvA
         X6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NjG06L3A2y7EyOAPA8qQEkMYP0fOIFXomd5VJhGvonw=;
        b=QDJYZqApcMKFkXIV60MTxq0YAV2OnTES+nE5DoOpkd181esnXhYqKlfJAit4o7M18e
         5nUbAA1AwE/aOE/N+IpFhPYiZSrgf2Ot5RHcoRK4gx76eoWjD0qZY3W/SB4tzCxD/0JC
         sCFcKcZBDqlfAysfpkKbueX3tXOCsOxyv6tLcgk/4y4pASwLBVu0ocjVBQC7Btv9B06Z
         ng6vlSpMr8OFFW0t7tWh6RkWfsuuSyv+WKuzwViY6L/w7D08s56ekZGhUPo9E/FSxadg
         803N+CZBtVa8zCWsDDrPVmJvNNxNaHKF8IF+vKSyAwulA9mB9YPqDrwhAeTvRCrENepC
         xa4A==
X-Gm-Message-State: AOAM530gU8lKsYPQTS6NscrNABgusHET+gy1uJjqRaRB4zYzg27TfWd+
        TmzywungpdvpUqbl9eFkmqLNyxmrYcEBlGw7VhY=
X-Google-Smtp-Source: ABdhPJySF3Jr0hQHF20L2EcoroCWMiycgS8JXpi950PizcC7YnvQxEG+bFtjg+na3OtA/0t/ZiN4OnN6RrDgUpQNb+Y=
X-Received: by 2002:a17:906:8255:: with SMTP id f21mr26071925ejx.265.1608777597515;
 Wed, 23 Dec 2020 18:39:57 -0800 (PST)
MIME-Version: 1.0
References: <1608776746-4040-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1608776746-4040-1-git-send-email-wangyunjian@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 23 Dec 2020 21:39:19 -0500
Message-ID: <CAF=yD-J88Pvo+jseUQviy1+uvtH+CwkOwirDyV1EjN=J_93xsw@mail.gmail.com>
Subject: Re: [PATCH net v4 2/2] vhost_net: fix tx queue stuck when sendmsg fails
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 9:25 PM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently the driver doesn't drop a packet which can't be sent by tun
> (e.g bad packet). In this case, the driver will always process the
> same packet lead to the tx queue stuck.
>
> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver
> can skip this descriptor by ignoring the error.
> 2. in the case of transient failure (e.g -EAGAIN and -ENOMEM), the
> driver schedules the worker to try again.
>
> Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks.
