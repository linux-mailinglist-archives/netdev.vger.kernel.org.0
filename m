Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1875C407E88
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhILQUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhILQUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:20:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADCDC061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:19:17 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id qq21so9611573ejb.10
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DrlaDQpCv5XFzFup1ts7W4HLyCKJgrQMqZl/IORIKBQ=;
        b=NzMeSEWrKR+KzUv3XCoWQbT8R1xIrPPOx7KP1Fb8Wg2v1eT0+4Vk9L7UB0ZjTS0MEW
         h3rQIowVPoETZZhyAXGs7CLJxU4BxhmHXId+Jdg1VruLEl7FKdOtkxTcmflgqGQnXOsQ
         UJOVn3nnGs94LzZQgYpdptaU+/SOUDDsdO5qqIeY+I0e0LOa7V796R6Fk/W5nDfPj1Kv
         jBozG5DxrzjTptavjvIv3u1p6LmGOtm9dLToHb9zCcYpsNVLMeFPf1wXwH0OuIg8m3WB
         6zqzxHMe3llHL3xP/poFrdwrGe8wO5f3HxquI4PsVc/ewPUU330cMglWwH0Alukpr6Nu
         jPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DrlaDQpCv5XFzFup1ts7W4HLyCKJgrQMqZl/IORIKBQ=;
        b=Y7yS2Rv7Ykb/Yl+wn56Nup/fCUvqaISZtDkIs4aAWi1f4APDjmsGladRUWlCvUWIFS
         /LyUTdVxTPz1T+TBK61tI2g6xSqDg/RD0/2b6wSAjvu23Q0jut50IokClmzkmEoJBqpD
         rV6t/eLXZIBfBImBiCskSOxQcfyTXZ9Om1Yci8/Kxx7n+FuUPv0mJXzYQjs6kfVZjh5M
         OJVjbht9PU+4ILbbuvWYJJkkPEmRONUSkSO5m/AFiAE5T0McWZnczoPf13XKRR0/Ztwo
         HelEYeoYBNEQcLUFPOjTASE0CFskqOJwokbMbKYrfqQshSrjPbua43SCKG8Ooz7RLdo9
         Xz6g==
X-Gm-Message-State: AOAM533kLRUMiOllCUkKcNYFo4m0y6hC0nWNlOBYGZMYHBvdicJzT7Dl
        BTRNVrumBluKGQbegW4n+KCQ2HdY7AA=
X-Google-Smtp-Source: ABdhPJwb3dcCLQE+b2pnXRFgzEuXeEUAi4os9HO8kJV8+LKc7Iobwk+paS9nEu7spE8V6gtSP2F1ew==
X-Received: by 2002:a17:906:6943:: with SMTP id c3mr8149893ejs.550.1631463556149;
        Sun, 12 Sep 2021 09:19:16 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id la17sm2198974ejb.80.2021.09.12.09.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 09:19:15 -0700 (PDT)
Date:   Sun, 12 Sep 2021 19:19:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH net] net: dsa: flush switchdev workqueue before
 tearing down CPU/DSA ports
Message-ID: <20210912161913.sqfcmff77ldc3m5e@skbuf>
References: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
 <5223b1d0-b55b-390c-b3d3-f6e6fa24d6d8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5223b1d0-b55b-390c-b3d3-f6e6fa24d6d8@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 09:13:36AM -0700, Florian Fainelli wrote:
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Did you post this as a RFC for a particular reason, or just to give
> reviewers some time?

Both.

In principle there's nothing wrong with what this patch does, only
perhaps maybe something with what it doesn't do.

We keep saying that a network interface should be ready to pass traffic
as soon as it's registered, but that "walk dst->ports linearly when
calling dsa_port_setup" might not really live up to that promise.

So while we do end up bringing all ports up at the end of
dsa_tree_setup_switches, I think for consistency we should do the same
thing there, i.e. bring the shared ports up first, then the user ports.
That way, the user ports should really be prepared to pass traffic as
soon as they get registered.

But I don't really know what kind of story to build around that to
include it as part of this patch, other than consistency. For teardown,
I think it is much more obvious to see an issue.
