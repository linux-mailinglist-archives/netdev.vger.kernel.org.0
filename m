Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E12340803
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhCROgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhCROgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:36:05 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87ADC06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:36:04 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h10so6905330edt.13
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w2sWdzGJ3EWNxSl9W9d0H2v7XvjGvyXXSEmkHLFffWM=;
        b=J2OQisc1dNNYiRurR0M/NJZPIe+CAoQE4EKQjiYIa4iqt/GWSRHtUCN8B24h/753kz
         L68D+1ruXTjXrU+Rxbqc4U1mi6Fz05p3nrH0VtdmEoxPsEIWmIf6f0Mz0jdZj93X1S4U
         T/cMr4cABYZgvkBY00pz/D8YMwj46uNDPS3m5t6hBmLTg/AmZ9BbhSDY2ydKqtMYpZpO
         qEWcLqyPgJI4/4+v1Sk7wfVglk9YQXSqEr3ByTtTDZ097Z0ZLCwE8lMqtoRVD7fSZZbv
         zWEGBsJ4HHicKv9k9gZBZno85skPgEuUB4elgs5XVe/hZ6MzhdUsE38BaZxjcHs9WWbA
         qGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w2sWdzGJ3EWNxSl9W9d0H2v7XvjGvyXXSEmkHLFffWM=;
        b=UWp60nOuAxDJrnYDHTd2gd/mwVkHoZ/NVedNsPks/9DgtAtCJLrwaJuJYhByRaOYP8
         0ZKg7yBN7NP2lmYYLwRK9llxD+02+5AmO1DbHiTmhfyr7ZkzfY4G1l4b08WdQsamGwzf
         CNGNpXWc3+3zkBiE8Wgn/KB/46fX0VlbZ+HUYoksrp5S2WiiX9dj/Zf/bAx2DXD29c4U
         iOVRHC6KO8fl5sUxS6Va4IEIMDIuQ5U+G3HJdawioUumn/CY5I7sHtjSMfNHxRrMZ3Fh
         wnp6EODiiOIcz0r3+c0ckGsEMS1Vehk7RxRASuzo6TmbMEHc8nUlU402RQFBcPFJWNaA
         CZUg==
X-Gm-Message-State: AOAM531QK/yN0xl3F78MjMbfTj5OY5Gyd/w39ugZu+vE7/psJne9t1ZF
        zGzN/yFnwioZH9NPwrWiFHc=
X-Google-Smtp-Source: ABdhPJwTExHenTyDD0Gvf+/UqI4VW/hJXp88O1ZZrFPF3rMB3E0VaA5isca4IRngnZGgrEBpmuA/yw==
X-Received: by 2002:aa7:d987:: with SMTP id u7mr3979160eds.326.1616078163537;
        Thu, 18 Mar 2021 07:36:03 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id f21sm2038749ejw.124.2021.03.18.07.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:36:03 -0700 (PDT)
Date:   Thu, 18 Mar 2021 16:36:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/8] net: dsa: mv88e6xxx: Avoid useless
 attempts to fast-age LAGs
Message-ID: <20210318143602.nxx2nprfgv5zawyf@skbuf>
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318141550.646383-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:15:44PM +0100, Tobias Waldekranz wrote:
> When a port is a part of a LAG, the ATU will create dynamic entries
> belonging to the LAG ID when learning is enabled. So trying to
> fast-age those out using the constituent port will have no
> effect. Unfortunately the hardware does not support move operations on
> LAGs so there is no obvious way to transform the request to target the
> LAG instead.
> 
> Instead we document this known limitation and at least avoid wasting
> any time on it.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
