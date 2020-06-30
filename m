Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34E020EA6F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgF3Amj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgF3Amj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:42:39 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7911C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:42:38 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j80so17115571qke.0
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=78apnWmpwCUP3dUzyvTpfADGNcW+CMyYmvWkenI41Oo=;
        b=OV0xGnSWlU4DNcGaDoGRn4bkBOFKotmxWIbF36OJzfIfFfk1Yy+NYT/krFb5zWZ31R
         Ba+AQGPf9MNwM9YMD72isb8pk/WxsmvYmL211YAqapCwHotls9P9YYNzG0V+S/h9/JVg
         NR1W48WBNcdE1DL+cMzGSvN6yEY22FELzhi9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=78apnWmpwCUP3dUzyvTpfADGNcW+CMyYmvWkenI41Oo=;
        b=exVWbSZPWyOS/UsQSMqNjt0P234CXF6hWDwBFqcPPlLRxb9A6gNupaQpvs4X0qIKRT
         iXlJkhpPWvYiYUR8wdr8gGejAWTjms5M5Cy3CYrjMYKu4t4MElv6L0A1OpJh08RKVE2t
         yxr1jP7LNGrmJ0rRSTWGA4UExTCFrty4sX+FYN+GoOQwPE2vlqQYLiQElfBRjMRg0GU2
         hKlz8yvPl0TlISxpk2AYAFPS95pllyAMaI314/cAdYnUvmgl8AR2iKSdOUxVohqfEQeF
         pwiRTsk6rr7YB+eAvIg2wSEsOXEWOSvbYcaKBteiE9mYEvsq0inlMr1JLSTFLxOHiKI/
         wHuw==
X-Gm-Message-State: AOAM5312Ywe017t+sUxjLMBusoCsKVPghhwdWvOjoMjmfkKzTMVegmal
        +xJhwNsaL+wxfsU+UNNSS02AK7c5phzRLq7+p4FAnyKh
X-Google-Smtp-Source: ABdhPJxM1GeGLx8qCEH86yWYsKmuvjkqUv62JPVIk2wkBkgg0/n/yj+8v0DQdafEvMgCKnwhNh77x2TJG4nqEg7Qz7w=
X-Received: by 2002:a37:2c41:: with SMTP id s62mr11287325qkh.165.1593477757938;
 Mon, 29 Jun 2020 17:42:37 -0700 (PDT)
MIME-Version: 1.0
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
 <1593412464-503-5-git-send-email-michael.chan@broadcom.com> <20200629165811.4ae9e0f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200629165811.4ae9e0f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 29 Jun 2020 17:42:26 -0700
Message-ID: <CACKFLin3WPEQkjPHuVHwfKAN8pM1H_mBVR4qDuUbKGdBE_VaGw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] bnxt_en: Fill HW RSS table from the RSS
 logical indirection table.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 4:58 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 29 Jun 2020 02:34:20 -0400 Michael Chan wrote:
> > @@ -8252,6 +8267,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
> >                       rc = bnxt_init_int_mode(bp);
> >               bnxt_ulp_irq_restart(bp, rc);
> >       }
>
> if (!netif_is_rxfh_configured(nn->dp.netdev))

Patch #6 adds this line together with the ability to set the RSS map.
At this point, we are only displaying the RSS map and we always set it
to the default map if we need to reserve rings.

>
> > +     bnxt_set_dflt_rss_indir_tbl(bp);
> > +
> >       if (rc) {
> >               netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
> >               return rc;
>
