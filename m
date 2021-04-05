Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5D535472E
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 21:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240179AbhDETe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 15:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhDETe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 15:34:26 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81FDC061756;
        Mon,  5 Apr 2021 12:34:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id g10so6161445plt.8;
        Mon, 05 Apr 2021 12:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=qs2UgpNHrs9qIOZOqKSGGqFmmr2tm9Rf+HF/JQPX6rg=;
        b=Bog2xAWbsFjf4t2sh5sRaIdqTHdj0i1/lahuvIcL897SGc7Yh4M2/rxw8y0Pvs2FKA
         XNY7bfly/L7IZSl1kPoI/tADIPhvjaBbo1SKkU1yj2kpO7gL2SsUxlyVtWOT0RJ2VWbU
         LXxfz1CYFLOeXGqyWFiih97wL0fTjlsAU6YscJYvD3Axfku6QiQIAQhV6HKomlGuEsnR
         7Z07fNbBwIS5BC/iETs4MjEvOfX3O1/eKDdWAC8OJdif0U0ituoq8ohJ4DMmdqs/qvGE
         iQsyn+9xaEvoUeuwUtYVeNdQJHob4kABvi6K4N4/qcY+LjCn+Eb5iMrlPC8mypO3wYuA
         5ItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=qs2UgpNHrs9qIOZOqKSGGqFmmr2tm9Rf+HF/JQPX6rg=;
        b=IVCi51rrh5FP3aUELC4pDolcYEqLKImOnzj5K1pANnnJCzxQ3Wa6IfcZc9s/Jcn8bX
         PpIpls1lhEnF5KYGVomUXwJsvwy8bGd9s7wSgRIikc8pKSflJZH4Iy9dAAPXRV2j7oHK
         JxupfJkgf7d3mCR9ibkseDDTmlHB3pk8aMlKQ6w2S0hMVbuKaj0Fkbm5Ca5ZPQjSnhr7
         BDANOtNGvDuLoPvbCGpGmA+kewet/yvyHaQTJw0Qbi6U59lKQ65Kwo14GSsIi75KqXch
         g+mAXwcHF6yAyAuEkamXZXiDcBRpc6PYTdbCN5TOlTk8Sam4HgUDZTaHiFiNDs42N6x0
         9R/g==
X-Gm-Message-State: AOAM533hUFNFU0057kUlyak00wEok51FqgJRLQ2bFRhrEGbF7rg8aERE
        vYFhf+6Bzy8GKIwvyyPRkvyG6HJAtTniH5W9ae4=
X-Google-Smtp-Source: ABdhPJxttNkctIZiZSTjh6iJY+hhTlSN2SkKa5dAVTPTSZEte2VCI3e1D0ry3xRZ2KcE0C1LzCvriUMVgHzwmKL3ENc=
X-Received: by 2002:a17:903:22c7:b029:e6:faf5:eb3a with SMTP id
 y7-20020a17090322c7b02900e6faf5eb3amr25518927plg.23.1617651258303; Mon, 05
 Apr 2021 12:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210402093000.72965-1-xie.he.0141@gmail.com>
In-Reply-To: <20210402093000.72965-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 5 Apr 2021 12:34:07 -0700
Message-ID: <CAJht_EO7ufuRPj2Bbp7PyXbBT+jrpxR2pckT9JOPyve_tWj9DA@mail.gmail.com>
Subject: Re: [PATCH net-next v5] net: x25: Queue received packets in the
 drivers instead of per-CPU queues
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Could you ack? Thanks!
