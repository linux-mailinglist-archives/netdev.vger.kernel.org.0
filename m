Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED7C33D548
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 14:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhCPN4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 09:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbhCPN4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 09:56:04 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4399C06174A;
        Tue, 16 Mar 2021 06:56:03 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 81so37195031iou.11;
        Tue, 16 Mar 2021 06:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+46g674RBma+ciBzuJpVGTzQLL8+JCKCJVBU3dFl0nU=;
        b=JA7icuejqFeeyZ/IOIMpnOI+hFshDRZOSH4fBbyaemq7qfkwoNIv/qx4mVwll7lXU3
         tjN9Us2sp5TSrTsKVgS4PtP6LZpRnbepFzLciXfKlq4zdF6HqV7ebKC15/nJrYYQ7fY7
         +U4Y8Yy4HiKWLqILRjUmFhESbgzDPKdh/zXyP39x8JaRZwJUXGu9bMxzmpmZr3r5rPdF
         t1WbrEO1e/iGMbayLrT+uU2iURngEG0cGSIha1fgr4K5r/bzN/fWLChJDtpHwgUHWn6W
         rt61kcK1rhZiqwa76VL/1121io2iwwWQ7V2C+59VFPRTEUa7r4hC+Rgf86Cj5WtSZzTe
         A7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+46g674RBma+ciBzuJpVGTzQLL8+JCKCJVBU3dFl0nU=;
        b=DKqmJMX+N6SgsmHPEcGRGFsy1hhY9Jl8t0xy06vK55ndjsF6soM9/hKH6mb93pYVHK
         SjWvU1YGoQa64mJ6djH6EXIeRptI5ELfhkiSFNDn++Cg6osR+ocAZ+xEBJ2yd0dMbGOL
         BTvi4s6uXzEFHUpKoVJc4xEu5i2P4SQDEJqey5pW1TnsRRSp0Za9jGgSM908HW6mNb2a
         AR9r5cOYx8An2upEl3YaeBPDNLgDEm+e/9+gcfk8KGXxLqCo03j3WMowDe4+XZm6YJ2C
         LYPVS6WXq/xKhnFT4RwX/irnWz0qHNPdglD1gVfTtKl/TrhDLEtMcTJYN7L+GQDZUBUi
         0MVw==
X-Gm-Message-State: AOAM533khKG9dvPTVJF7h0GpRxEbMjjUHkgfB23/mXP0Cj6GtKyeu1ui
        9d0Z90HUzjuJvPKZBXOnp4tguCd2X/4ddppdcIc=
X-Google-Smtp-Source: ABdhPJxsQTVIidXXPM7aMIJVsw3A2CX7qX6qFM4TJR8DsZi2gn8eJ682nAaU6vckx6geePwgdiehZqOFuqwusFqi4nE=
X-Received: by 2002:a05:6602:1689:: with SMTP id s9mr3265333iow.171.1615902963396;
 Tue, 16 Mar 2021 06:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210316074239.2010897-1-weiyongjun1@huawei.com> <CAOc6etYcE-0wbcWxgTH49h1Odepg=Esc_gmfDoUioHOsnNj33Q@mail.gmail.com>
In-Reply-To: <CAOc6etYcE-0wbcWxgTH49h1Odepg=Esc_gmfDoUioHOsnNj33Q@mail.gmail.com>
From:   Edmundo Carmona Antoranz <eantoranz@gmail.com>
Date:   Tue, 16 Mar 2021 07:55:51 -0600
Message-ID: <CAOc6eta+QttyE_TJwLSTietCE2WiHEYgd-q8Bp-Xu1kdVDfnew@mail.gmail.com>
Subject: Re: [PATCH net-next] net: stmmac: fix missing unlock on error in stmmac_suspend()
To:     "'w00385741" <weiyongjun1@huawei.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 7:50 AM Edmundo Carmona Antoranz
<eantoranz@gmail.com> wrote:

> I think you can let it go and check ret after unlocking:
>
>                 /* Disable clock in case of PWM is off */
>                clk_disable_unprepare(priv->plat->clk_ptp_ref);
>                ret = pm_runtime_force_suspend(dev);
>        }
>        mutex_unlock(&priv->lock);
>        if (ret)
>                return ret;

Oh, I C. It would require ret to be set to 0 before starting to use
it, right? Maybe it's worth it?

>
>        priv->speed = SPEED_UNKNOWN;
>        return 0;
>
