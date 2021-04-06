Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F49A354EFB
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 10:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244567AbhDFItj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 04:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbhDFItf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 04:49:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCB9C06174A;
        Tue,  6 Apr 2021 01:49:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h25so9880874pgm.3;
        Tue, 06 Apr 2021 01:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gCYr1I03X+k+4zRvDqbVMs/E1N9JK1gf4mt4xGLcXBw=;
        b=R9QcK1HUWPmv4xUu7Lrnago7GFe0qYseGzj5RjG23v7PgZimeVXCpuAjRijP0Akdi6
         UCK3dGgVSFawUntzQk955de9zWVkxoZcAsE5EqxjVaRPnPwdDlQDnmbpv8MmWA+4XSts
         8NIw5SN3O06dPQYesj3bjUyOoUhjdC+rn3MjkHKZz/B6KME8y5bjZNOhlqhG8ObrZ25D
         X3U6KPG1KkPbZSicK2A8KWQqpbqiDaIPQlmaKAowdcO/VmBWBel3dz1FadyLczeWR/WQ
         ZV9BJO3J6yVm5WtBZRR61sTWD2kxYSZgJsh/qOsMsQT/WXLd3ibdZo67BpM6m6PVYJK2
         F0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gCYr1I03X+k+4zRvDqbVMs/E1N9JK1gf4mt4xGLcXBw=;
        b=CpRSMJFr2tHXSDiQv/ylioKVu6bhEyNA9hkA2QlfBM8HEkUR3RV8eOXqZCFSytCXIA
         62BuJdWq95Rfa9wm4y3/0EC+ZkilPGVWvai1SsXlkd+yLD4YKSla4Br78kDHHFggr11M
         k3oSnHqfiP2iw0198X9QyMb2EVzgJif0cALQ9s9zsMrWT6km57k8RA1UJHZi3alLJLS9
         GBh4+ZbRKGww0W6+yRSBc6PE2E0cIVPcGTUVxeW0oMxu30yQoVZSQuZ6r6rrWkT+Kb8o
         08Pek2WPTNxc0RAkL0dRrmHtI0EFgKMoIqUtkWfXY4lTJpRsXMT/3wYnkbGAoT3R0p8i
         LY9Q==
X-Gm-Message-State: AOAM531J8V1HSxIcVNtiAkHTfKUPknjZw+Q9EKF/NYlD0fKKugAnSzw5
        esqAXQXxwb2hqnqERtZf8a59CeyT+odWggih8sWHwSZy
X-Google-Smtp-Source: ABdhPJzbVFwnnS9oCnqT9FS/H+Qx2rf1dqM/EHSOsA59l+MNV9oc4L2p0OgUhI7RWtf1gkWEVC1tUdBFUSSkzGYVVRQ=
X-Received: by 2002:a65:480a:: with SMTP id h10mr25881241pgs.63.1617698965528;
 Tue, 06 Apr 2021 01:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210402093000.72965-1-xie.he.0141@gmail.com> <CAJht_EO7ufuRPj2Bbp7PyXbBT+jrpxR2pckT9JOPyve_tWj9DA@mail.gmail.com>
 <f77ea411add46de10d1b9e72576a0ec2@dev.tdt.de>
In-Reply-To: <f77ea411add46de10d1b9e72576a0ec2@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 6 Apr 2021 01:49:14 -0700
Message-ID: <CAJht_EPxzyLe-byO8heA-YNHG6RAG5=6MPDZ4=MHnDP2vy5xRg@mail.gmail.com>
Subject: Re: [PATCH net-next v5] net: x25: Queue received packets in the
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

On Mon, Apr 5, 2021 at 11:17 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> Acked-by: Martin Schiller <ms@dev.tdt.de>
>
> Just for the record: I'm certainly not always the fastest,
> but I don't work holidays or weekends. So you also need to have some
> patience.

Oh. Thank you! Sorry, I didn't know there was a holiday in Germany.
Happy holiday! :)
