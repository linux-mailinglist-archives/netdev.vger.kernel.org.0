Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 523D75F7C1
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfGDMOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:14:48 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35156 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbfGDMOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:14:47 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so5101123qke.2;
        Thu, 04 Jul 2019 05:14:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9cNGGl+FLilA8PMo/2823HsEW5aV7LEQGtBmo7DnFEc=;
        b=CM+vpFVspPTYEDMdGio5Ui9f86Lxh9bIBdEOQ40wOW2Cth2CmaKfsJuJNRac3WZesM
         hIXh1x3Hc15t1IlJ+FiYTYvLUlu7qefK5hkVyodgPF3jpy7ys7sZTt6XVw9CBOBsf8FL
         Pf/KRHPP7fQPRBFsgVOuDiM6qi2pcXoaKIBNfKdWkXeKVP7ari5H7NwH7xKL64OWllY7
         C9i/2RpOiDXU7VN11NAfQ8LtnjP0OXVBs34D1aDLhUev28c/4cTprNrfamCbWysB8CFU
         F4xXJBas7rKl8wljGWN/QsdPzgWim3n9jV28Ri2qMDLfQt28MehKbFfuAnksp476OTBT
         /l6w==
X-Gm-Message-State: APjAAAXLkvkchE09EP+Vb6NEaywCKXMdOPHue2ExUFrnAQCfoIpeDWce
        OgbXxks9gRpOH9uQj/6jTkVo5it/cw5YJrWh01k=
X-Google-Smtp-Source: APXvYqzvpIz9J26dzCUH95aoNaSNG7JvaLf06oXPM82JIyYSrVI156uv/dpYNT0OS7IMkbIycWc7OMw2LwtS3sy2tBc=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr34670161qkc.394.1562242486886;
 Thu, 04 Jul 2019 05:14:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562149883.git.joabreu@synopsys.com> <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <20190704120018.4523a119@carbon> <20190704103057.GA29734@apalos>
In-Reply-To: <20190704103057.GA29734@apalos>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 4 Jul 2019 14:14:28 +0200
Message-ID: <CAK8P3a3GC6f-xHG7MqZRLhY66Ui4HQVi=4WXR703wqfMNY6A5A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page Pool
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 12:31 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
> > On Wed,  3 Jul 2019 12:37:50 +0200
> > Jose Abreu <Jose.Abreu@synopsys.com> wrote:

> 1. page pool allocs packet. The API doesn't sync but i *think* you don't have to
> explicitly since the CPU won't touch that buffer until the NAPI handler kicks
> in. On the napi handler you need to dma_sync_single_for_cpu() and process the
> packet.

> So bvottom line i *think* we can skip the dma_sync_single_for_device() on the
> initial allocation *only*. If am terribly wrong please let me know :)

I think you have to do a sync_single_for_device /somewhere/ before the
buffer is given to the device. On a non-cache-coherent machine with
a write-back cache, there may be dirty cache lines that get written back
after the device DMA's data into it (e.g. from a previous memset
from before the buffer got freed), so you absolutely need to flush any
dirty cache lines on it first.
You may also need to invalidate the cache lines in the following
sync_single_for_cpu() to eliminate clean cache lines with stale data
that got there when speculatively reading between the cache-invalidate
and the DMA.

       Arnd
