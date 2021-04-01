Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7D2351F85
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDATVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbhDATVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:21:04 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E39C06178A;
        Thu,  1 Apr 2021 11:15:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id f17so1445033plr.0;
        Thu, 01 Apr 2021 11:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fCN7HFcnvMpvphnepoCBtJplYkwECQXR2iZTdliGiTg=;
        b=dchZIDlXtJvfkwTLzGyyTve5opr2+bltojKqDNPOcF3IJah1ARE+lv/AfJNEYHb/TV
         X8l/y3PNjPzZn1ybq4INWmCQ5Jsi0zNqPyXruuFXDm9l3XVQ6HJx2rKc3r8kmX/Lshk4
         WYHPFuWfsI60CZQ1749BHQdDkUz8EWZMs+7J/IViwV3xaOa1gtOtMOCffQf8vSYN9qBc
         2LIrHnWB6srdpRIbHBuVCFEsqFW6O/cl6vdrRdSYhZbKHzsnWf0QimI0vTvty7gSty+C
         ofIXArAXVbH6xCJofuvId4hFanWuN4A+0qZW/8hZ4Q5TARRI3A1rCsCM5o9xGYspGPPf
         3dUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fCN7HFcnvMpvphnepoCBtJplYkwECQXR2iZTdliGiTg=;
        b=P1yiZDJrDoUDkfevG4K7qLLmec6vZMoRUp+lRS16dBHSf2XioS63Cge8SzTKpeOb2J
         RxDoAOJZKGKgQn8S1ocvTEYgDO1a8XIDZX69UjH6D5O39BSOa/MrFE+K/zPcs0f+OFN6
         A/HL2qmoxd3qKcU10Kv2pCQ3e2SSjAtz+ODIeTepzGbsZd+4d2cGBUI+F0uTTY8Ci+wJ
         hBm7ZYtTaT1pnca+Fr3BL5e4LIVtgK9exI4Fi9/VlkDaDCsFyrB7kda0XFcUYucBpJbr
         ywrsX6Rs5J+TLt+n1ZGu6Jk7d1QSgBAgsMRU/c+uuFJJIjO0ezp7eB2b1b7T8q4yqQDd
         XPGg==
X-Gm-Message-State: AOAM533XsKwEX2IdejhYi1LapdPApZXvkO1UhZyFm67J8BibWKj8zeN3
        pUNziG+YSIo4yYeue4wPJq1NX/LgJkvBEty6x08NtwF1
X-Google-Smtp-Source: ABdhPJwBYzTyRNc5CtDOYzz/PZZSIIocniBSGHjSb4F+WJEtDwFrRCi+7tXiHbjIobJvsh8lGp1yHXUy8nGzsKNPlxg=
X-Received: by 2002:a17:902:8f8d:b029:e7:4a2f:1950 with SMTP id
 z13-20020a1709028f8db02900e74a2f1950mr8884582plo.77.1617300914858; Thu, 01
 Apr 2021 11:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210328221205.726511-1-xie.he.0141@gmail.com>
 <CAJht_EMVAV1eyredF+VEF=hxTTMVRMx+89XdpVAWpD5Lq1Y9Tw@mail.gmail.com> <21ec9eafa230f2e20dd88d31fd95faa0@dev.tdt.de>
In-Reply-To: <21ec9eafa230f2e20dd88d31fd95faa0@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 1 Apr 2021 11:15:04 -0700
Message-ID: <CAJht_EMpRd8KhLQLZeDOVrhi2KHi5aLUkDknv=Ujw6MniesRHg@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: x25: Queue received packets in the
 drivers instead of per-CPU queues
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
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

On Thu, Apr 1, 2021 at 3:06 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> Hi!
>
> Sorry for my late answer.
> Can you please also fix this line length warning?
> https://patchwork.hopto.org/static/nipa/442445/12117801/checkpatch/stdout

OK! Sure! I'll fix the line length warning and resubmit.

Thanks!
