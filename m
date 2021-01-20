Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA77D2FDB1D
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388847AbhATUoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbhATUnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 15:43:09 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF13C061757;
        Wed, 20 Jan 2021 12:42:29 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id my11so3674935pjb.1;
        Wed, 20 Jan 2021 12:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=l4bZ7k3MLtL4D33E1D9YrozkMl3wQeHdeBeC/C0ogfE=;
        b=EMmI/yHTTV1Mpux7tKIPYfLFSTGkfH72QLHU1dgIqX1Y4igOtMYt0XoxjV37/m82QB
         BWmN+pKbES/bkyzb6tgjhZtElcy1O2JUH/FXnURIcZnrbc+u0sO3jN89LikTF0dg54ro
         IXp8PYLEGDRd1mZHqP109ZYQU7qAltNfcx11QCF5MqLt8Wt9h47lqxB9V/yGzS+WSNFv
         rMAMUGQ8UmnpaZLdwYW7YfsWwZxNSgZ3J0hUcoI9wKvdAOXngrq7kds/abp8Xnud15sZ
         FtjSm1uI/Yp5CIEEifMZLc3dxnHJGZlv8fjXGEe8632+cDpo6bcFSTlAhAURM29vrgu4
         L1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=l4bZ7k3MLtL4D33E1D9YrozkMl3wQeHdeBeC/C0ogfE=;
        b=Xk/g9PsTEZYBA1xBx7p0hBPVPM8bsbFMhwOseub0Ijj6aWCigkkVzvlf1wp3gb/xA8
         Erx7qppX/1+OAL4m+7OXPI9NgrdG1TCMl6s1sc0KwyqmfZCHdLbWx81XDOB83UPFDGv/
         B72paKzRVNIPciDZGMBnbIGep+gprlPStNBBHC2vxiLzFCh4bw5LuWhMMbF+JduNKQLH
         x9M+YyMZtDWrRhR4jMYK5tHM0fwzFjZiInE7ksK25vxcvqReY02Q5w+N6Wv1WzzrVFQc
         lKRMBmP7G5q9KdctliS90nfATQmzYPfdgKezqjGHDjCl7dDXAD+kBkSAVFdLkDsgCIdw
         +iEg==
X-Gm-Message-State: AOAM533oFha7aB4zLRfvuXjm47nmAoeyy0MAXXgrcZmLX/XUSeoGumIc
        jNTUYiSTL/LQF3AVCaSaeVor6NUwF4Drl/AGju4=
X-Google-Smtp-Source: ABdhPJzaqLEL+yFKxUornhh6qyddcR3bLRrY+ZgaujIQH1JiMZiV74ZO0uBj1hEqq12lAkMy9dKvFnwcece33ostbI8=
X-Received: by 2002:a17:902:9894:b029:da:5698:7f7b with SMTP id
 s20-20020a1709029894b02900da56987f7bmr11554332plp.78.1611175348636; Wed, 20
 Jan 2021 12:42:28 -0800 (PST)
MIME-Version: 1.0
References: <20210120102837.23663-1-xie.he.0141@gmail.com>
In-Reply-To: <20210120102837.23663-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 20 Jan 2021 12:42:17 -0800
Message-ID: <CAJht_EOdpq5wQfcFROpx587kCZ9dGRz6kesyPVhgZyKdoqS8Cg@mail.gmail.com>
Subject: Re: [PATCH net v4] net: lapb: Add locking to the lapb module
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patch, there is still a problem that lapb_unregister may run
concurrently with other LAPB API functions (such as
lapb_data_received). This other LAPB API function can get the
lapb->lock after lapb->lock is released by lapb_unregister, and
continue to do its work. This is not correct.

We can fix this problem by adding a new field "bool stop" to "struct
lapb_cb" (just like "bool t1timer_stop, t2timer_stop"), and make every
API function abort whenever it sees lapb->stop == true after getting
the lock.

Alternatively we can also require the callers (the LAPB drivers) to
never call lapb_unregister concurrently with other LAPB APIs. They
should make sure all LAPB API functions are only called after
lapb_register ends and before lapb_unregister starts. This is a
reasonable requirement, because if they don't follow this requirement,
even if we do the fix in the LAPB module (as said above), the LAPB
driver will still get the "LAPB_BADTOKEN" error from the LAPB module.
This is not desirable and I think LAPB drivers should avoid this from
happening.

So I think this problem may not need to be fixed here in the LAPB
module because the LAPB drivers should deal with this problem anyway.

Please feel free to share your comment. Thanks!
