Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A53E302D0C
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbhAYUz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732179AbhAYUyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 15:54:14 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FD4C061573
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 12:53:34 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b17so1875658plz.6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 12:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IzLpkY+shMm6J8jMg+xFn322yT8hbm1cijdkFIvD0/U=;
        b=WmgcGOQQcMhzUjifywabK8HkrdAVXF9wrhfN8mC7S/U0EJb97Y+ZMm9qAxAX0Q3eEs
         0yWzA8TVjIa0tZ+IeKQTeQXiepgGOk7PoagRA+7b+TAELEBJC3X5ycaQLI9FyHR5vTnW
         Kz8AMZ8JEyYPQKCMtHHXnMDadrbrFkDFqKaNPAGnvbEPJ8Skhp7oI1eiw/9hiDHZIfwx
         wbQsiFUbP0cf3DergoV0XmetlNoUCjR5NMbCbnZyeWqr3MUwLmNux/MHyXj6RSiXSnij
         sT5varE75iWz7HTp+aYKkn+8Xq+V1dGuMqUlzi1PWhl9A08NPRZRdGIoTjomR7Bx5i+Z
         v5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IzLpkY+shMm6J8jMg+xFn322yT8hbm1cijdkFIvD0/U=;
        b=hHt2/4E4vkFQpnD0n++i6MB1K/EZphP16o2n59FbHRahRT2EBqaT6/cHPRx7KQfXK3
         33DgXB+V9/6gcwm3Ix7fPifyAyNL4uG39l0yBzjKtY6CThW/V+pL2XhRXzgxMwEReRUJ
         n/k6zSxmaa3uMeqUH1KGhhhI7j+A1k8QGtKzRh3P4hKFBNpqTauH8h7Dvy/1WP1XwZTp
         bvlK7CTjtbbaNxfl5KFQ6zKjcJSZ0TG/dxm8nkTks8W3P7VEN7sCRnxhB/Det3+Bt2Sm
         3wGeO03Jhu+vWC32B+K+bCJE6wAVgslQLV2/g36nAkzm0ZNR2VE+Sf+YCSRCodQ8hwaH
         lyJw==
X-Gm-Message-State: AOAM5319mPIaAkF3QolWfE0D4bOAPXK0SkIjJDAbQbuYgf7XtqO4VryT
        CR2Xv/1GuqoHGfFEzn3bGwJqq5tM/yBLn1i5yUM=
X-Google-Smtp-Source: ABdhPJxa4/bowlkMQlsKhoqKjJef5jSBa4XZD82vTF5bxcFFWh0v7iGB4QrJxEGX4rBYRSV5l8YRIDh0hFiPA0uV0D8=
X-Received: by 2002:a17:902:d64e:b029:df:e5b1:b7f7 with SMTP id
 y14-20020a170902d64eb02900dfe5b1b7f7mr2456640plh.10.1611608013684; Mon, 25
 Jan 2021 12:53:33 -0800 (PST)
MIME-Version: 1.0
References: <20210125074416.4056484-1-ivecera@redhat.com>
In-Reply-To: <20210125074416.4056484-1-ivecera@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 25 Jan 2021 12:53:22 -0800
Message-ID: <CAM_iQpX85wZn0ihG_XxPq=inM5P8dKvf4BE6kNwG2na=NAnGzw@mail.gmail.com>
Subject: Re: [PATCH net] team: protect features update by RCU to avoid deadlock
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 11:44 PM Ivan Vecera <ivecera@redhat.com> wrote:
>
> Function __team_compute_features() is protected by team->lock
> mutex when it is called from team_compute_features() used when
> features of an underlying device is changed. This causes
> a deadlock when NETDEV_FEAT_CHANGE notifier for underlying device
> is fired due to change propagated from team driver (e.g. MTU
> change). It's because callbacks like team_change_mtu() or
> team_vlan_rx_{add,del}_vid() protect their port list traversal
> by team->lock mutex.
>
> Example (r8169 case where this driver disables TSO for certain MTU
> values):
> ...
> [ 6391.348202]  __mutex_lock.isra.6+0x2d0/0x4a0
> [ 6391.358602]  team_device_event+0x9d/0x160 [team]
> [ 6391.363756]  notifier_call_chain+0x47/0x70
> [ 6391.368329]  netdev_update_features+0x56/0x60
> [ 6391.373207]  rtl8169_change_mtu+0x14/0x50 [r8169]
> [ 6391.378457]  dev_set_mtu_ext+0xe1/0x1d0
> [ 6391.387022]  dev_set_mtu+0x52/0x90
> [ 6391.390820]  team_change_mtu+0x64/0xf0 [team]
> [ 6391.395683]  dev_set_mtu_ext+0xe1/0x1d0
> [ 6391.399963]  do_setlink+0x231/0xf50
> ...
>
> In fact team_compute_features() called from team_device_event()
> does not need to be protected by team->lock mutex and rcu_read_lock()
> is sufficient there for port list traversal.

Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>

In the future, please version your patch so that we can easily
find out which is the latest.

Thanks.
