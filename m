Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AC1602D59
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 15:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiJRNtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 09:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiJRNs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 09:48:58 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4287CE9B0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 06:48:57 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j7so23570427wrr.3
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 06:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MJpKNJG423HNOZnJg0Toch2+HsyeOuMVLq95+bCp8mI=;
        b=X2X5nYwmCdhjK3OqYzQrNAnsfBzHuaANARniha1xTnk84KURCvsV9OaCgwcNng5svQ
         DNNkCW34p0oYvfH3eXcAU1xmm+QVvMwHwQam/iSaIyLjG/pvx/5waP51uwhyMMDMaGfW
         qDIomKF22bbNBb3QB4IYFbjYF4Dt84/STYoPh0/ETUZOCGm7CXCS4Uhig4gKpC2CQSpQ
         KL9SDaojKuP6Tb77emFaddkJ/ntyadkB9h6BR824tNjzMo9ycwjzply88iauDgaUb5Ki
         JIh789s/a9BYzWmVAGjfluz5bvEagDJwps5uMoT8SAJ6G/SgoaWGc3/T60g4/3WNi4r4
         aJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MJpKNJG423HNOZnJg0Toch2+HsyeOuMVLq95+bCp8mI=;
        b=Bi4diL6bTEqVwznb+zgcGkqPWg8f8kJ47g61bRFvrR6Rm0ZTaIajmfSB786NqmQ4aB
         4UeCGprrKPqmlpMbgdNKjWka+hGDordxlVwh5qcJ4Ly8SfNhIqGdtZp6FhbbvrhuUirI
         2IRvxH3mHgIf+akuda1ORovdquzrcgD0gUN2xtLDxaTEtMVSYjxStiFGOUr32wyTtcCZ
         I8ZzTiaHrdUZKkH/F55AgBaAEa8p/OPW1PeWk05wrL7hM6Lk7DDFRP984DGWojNhMeyo
         qbMpkz5Pb4pDrXEf5G3KCiDawlUceA02KzAyFUmsQegeOldNP9hkUcpz82HJ/2HV9zPU
         tEtw==
X-Gm-Message-State: ACrzQf3rhEAFKCVp3AFW/Z0rRkPDJvtNLkc7NAXDfNBrljefydWUFBkI
        EjF+jegZExI+8tM5WKqDw3ag7m+OV+jFmGjyqqk6tQ==
X-Google-Smtp-Source: AMsMyM7PKWbcahrqqn9SyCMXS71BsYOqvvz2JWZbD8APjJeG5y2wSwlM1iXMzf/sp/tlBigY7cBAyHWS0zKHHhaXLig=
X-Received: by 2002:adf:d4cb:0:b0:22e:489d:e0e3 with SMTP id
 w11-20020adfd4cb000000b0022e489de0e3mr2075680wrk.653.1666100936339; Tue, 18
 Oct 2022 06:48:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221018131607.1901641-1-yangyingliang@huawei.com>
In-Reply-To: <20221018131607.1901641-1-yangyingliang@huawei.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 18 Oct 2022 15:48:19 +0200
Message-ID: <CAMZdPi-T70vuEinH2F9sRCkmgrEuYpZBWuv_qnio2tOmjXChPQ@mail.gmail.com>
Subject: Re: [PATCH net] wwan_hwsim: fix possible memory leak in wwan_hwsim_dev_new()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 at 15:17, Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> Inject fault while probing module, if device_register() fails,
> but the refcount of kobject is not decreased to 0, the name
> allocated in dev_set_name() is leaked. Fix this by calling
> put_device(), so that name can be freed in callback function
> kobject_cleanup().
>
> unreferenced object 0xffff88810152ad20 (size 8):
>   comm "modprobe", pid 252, jiffies 4294849206 (age 22.713s)
>   hex dump (first 8 bytes):
>     68 77 73 69 6d 30 00 ff                          hwsim0..
>   backtrace:
>     [<000000009c3504ed>] __kmalloc_node_track_caller+0x44/0x1b0
>     [<00000000c0228a5e>] kvasprintf+0xb5/0x140
>     [<00000000cff8c21f>] kvasprintf_const+0x55/0x180
>     [<0000000055a1e073>] kobject_set_name_vargs+0x56/0x150
>     [<000000000a80b139>] dev_set_name+0xab/0xe0
>
> Fixes: f36a111a74e7 ("wwan_hwsim: WWAN device simulator")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Indeed, device_register() must be balanced with a put_device(), even
in the error case, as it includes device initialization.

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
