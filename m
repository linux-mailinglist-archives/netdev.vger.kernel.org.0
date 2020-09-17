Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772E126E992
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgIQXnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQXnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:43:45 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D6FC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 16:43:44 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t16so4248604edw.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 16:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UiOppvJuc7hNTEgwVzJSxEDgsMC866H/qQxHl/vG3s0=;
        b=F91GdNwClwpek9mZuJc/e5Uml1nsCy/zupotWUY/M0c0vH9A9Oum2kFvPGLblYdZgg
         ON6OAWG1qklwhuntdP5EJipB1qaAcR/KKvfk4ct9alVG0hmQ6mawPCGWAGxmF2ZExVfB
         JiQesksWaBhIgjUPQelnDpEanE+qOrnHEShURgJ2Mt3Fus9WwF3jF2VHid7smub0ZTDS
         LUK7rmE82Ju9eu1lmS5Vta+gpiaQdB1GXZitntrLGysnVhCzF/ik+oDHAqq89UCyUJuQ
         MlOWIQvjCPzBb8PQQkVNpHjsxJbPea+enS0c6FUy0C5TjqpSdfLIkyF74jdbB7r4MHE9
         nQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UiOppvJuc7hNTEgwVzJSxEDgsMC866H/qQxHl/vG3s0=;
        b=RdGmFKEO09HNt1cGcZNRfIl5OhIa9Nsw5vrXTC6rPgZsTieWeXq+yLr2rZ5kHGyOpQ
         BIpiHZ2/yYPyJcI6r1psaSmFlLMacQ5HWY85AJstepkCE+m6phnJU0SuIqBZxB2mtY6V
         7HjPE19PUasJ3bIvyA/XweCBh0tgjRAm1upC5ZsTKLW8k0GvwqRliyqyVsJesJnhlgMB
         9PfT/A7R2qclvG1actkHKblyLrPco1y2eM0iCr7QPxYWl96iLOcjHEo7EwDWFxVKbxkx
         ZO+1Y2wHwELF5r8NwC+GOqY4Qp/qe2qYhdCLn4vmCzBj04MtFL/7wFPQ7hAEQaLN/NzV
         TPfg==
X-Gm-Message-State: AOAM530++9b5ZmKEY+6Wfoos4+MvendWUQc97Mp2vVxETcFBnuMPRdEZ
        QgIx6Jbvoih/ePpQu1lP59M=
X-Google-Smtp-Source: ABdhPJz/8eFoDbUHxiXTM7L4ItrZ0OyvaCwd7bU8ZJHt2JboeBf4uAYtXH1otj+HeTxSNit8lsm6jw==
X-Received: by 2002:a50:9355:: with SMTP id n21mr34884994eda.237.1600386223425;
        Thu, 17 Sep 2020 16:43:43 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id bc18sm802863edb.66.2020.09.17.16.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 16:43:42 -0700 (PDT)
Date:   Fri, 18 Sep 2020 02:43:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net 2/7] net: mscc: ocelot: add locking for the port TX
 timestamp ID
Message-ID: <20200917234322.qqwxyq6k33qm6bca@skbuf>
References: <20200915182229.69529-1-olteanv@gmail.com>
 <20200915182229.69529-3-olteanv@gmail.com>
 <20200916.171926.383551951466329210.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916.171926.383551951466329210.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 05:19:26PM -0700, David Miller wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Tue, 15 Sep 2020 21:22:24 +0300
>
> > This is a problem because, at least theoretically, another timestampable
> > skb might use the same ocelot_port->ts_id before that is incremented. So
> > the logic of using and incrementing the timestamp id should be atomic
> > per port.
>
> Have you actually observed this race in practice?
>
> All transmit calls are serialized by the netdev transmit spinlock.
>
> Let's not add locking if it is not actually necessary.

It's a bit more complicated.
This code is also used from DSA, and DSA now declares NETIF_F_LLTX.
