Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27061FB271
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 15:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgFPNrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 09:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgFPNrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 09:47:42 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11221C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 06:47:42 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id g44so6908454uae.12
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 06:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GrGO+3XEiXBM7kaS2ev2gC6BDwICyUc4GZ/hMarpFmg=;
        b=BaVIJ+EgrhmWc0tQPbrLunAA6fMhUgwfuwwtZqY/aspsOebg6BTHwcTOkltWqs4XPd
         lI36wdWr7UE/q58T3NyoOhQvXO6QA6eVv6pCTcRt4YsZZfFwOJFOYtL2nHEAiIeeNZkm
         ERerH9QHo5SbgS2hvNfoBB/nkxUBZCpFR1R02O2vqiaWpp3wMe33yequ/HpvjlqPOZLX
         A9WvY1Z77yB+3L+zTefueDqWfX1YKIWA54a2EveYCvizGxUV9ReMsEgF4rEPk+O0Ourx
         /wxFCMA+hnrf4DmShXknvSnzHCUAEciMgTFTqi/SHMcQM0QV05OndeRwJBxzTgxhVPcJ
         xi5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GrGO+3XEiXBM7kaS2ev2gC6BDwICyUc4GZ/hMarpFmg=;
        b=fN0jsRLTe3ozKxYYvagCmxUGQEGfUrevsk94/r35a1D/jMJTERpHLYi8h9NxQo5myf
         V125xnO6BfauuPH3m+jIrguKTp6q7xIWpl9zKrB5Y6A3RB5Be3Yjw7BCWrxNb4h3KyGD
         L0tojeSrfHIGCU0hLFe20dT8+EzFnNns/O2tmdGXiDy73or/E61MjXx84XzFeMEFrBSj
         8VYQz/6aZqXx51LZGM4Uezc7QXpMKdkwJrpJytxchKtrox6fa6dOepho++1YgHk+7swl
         ENYN0IEjM8h2972hlHtS81BdaWe43Ys+fVOo5wBSTcPrQXN4PmQDllId0TrpKlUPrNuN
         KOug==
X-Gm-Message-State: AOAM530Mvkx5L6Lzozf+1poZDqyGalTtYs1zpaLLlTuZ0jB3k8kBFNCp
        GOUaxSM0k01SYITu18hzen3HQe6PYegyl7Qfid9KK4N0wIo=
X-Google-Smtp-Source: ABdhPJykhGv328HMU+JTV5MW50HShewuFaGp0WugGBXSOw2DZFRUBzYIrMIFEem6sskCD5gD3PVPzl6zSkyVedSYer8=
X-Received: by 2002:ab0:4922:: with SMTP id z31mr1852561uac.33.1592315260950;
 Tue, 16 Jun 2020 06:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200616033707.145423-1-edumazet@google.com>
In-Reply-To: <20200616033707.145423-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 16 Jun 2020 09:47:24 -0400
Message-ID: <CADVnQymw6xMVDjRX-rPJ0rHeMu_NfDp_XmdGjPqSUS9Wf7Q7Tw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: grow window for OOO packets only for SACK flows
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 11:37 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Back in 2013, we made a change that broke fast retransmit
> for non SACK flows.
>
> Indeed, for these flows, a sender needs to receive three duplicate
> ACK before starting fast retransmit. Sending ACK with different
> receive window do not count.
>
> Even if enabling SACK is strongly recommended these days,
> there still are some cases where it has to be disabled.
>
> Not increasing the window seems better than having to
> rely on RTO.
...
> Fixes: 4e4f1fc22681 ("tcp: properly increase rcv_ssthresh for ofo packets")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> ---

Thanks for the fix, Eric!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
