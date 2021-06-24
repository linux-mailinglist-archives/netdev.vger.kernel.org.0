Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB4D3B258A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 05:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhFXDmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 23:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFXDmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 23:42:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F50C061574;
        Wed, 23 Jun 2021 20:40:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t19-20020a17090ae513b029016f66a73701so5032713pjy.3;
        Wed, 23 Jun 2021 20:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hD5Dz8s0jLkgwZmMuYBNBBoj0OJz7eUphJ4TvvVMutk=;
        b=bPpIdGl7kvc/uGCpy2BiT737J4N8LjLGgXS1+NvNDdSJGbzbsd7qPYQ7O45M1PXTBs
         sQg+XP8EcJzpCLu1G3COJaVzEqcM4XXUjJVqNze5mgNtiRP+fQGSXhZX3oi1y7ro+5gX
         FPRJwp5pWU/tghWKZwnsvWRFsQ+FFerjXdOZyXMc1Nq3KO54GIS7sw1Q3Mn5vvJeGIO+
         RABEwwhnhiQUzO3xYVkYQdj7UafJhuiiwSf/E6d6SF09YH/EgBnuV40vRrpOpP5fGT32
         EebByvSjq1IUqJzgp5z05IORQv9u9m7EucjT8JcRGg/Lt2XsA6sTYfQ6ltyc03KQJ0cv
         Px/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hD5Dz8s0jLkgwZmMuYBNBBoj0OJz7eUphJ4TvvVMutk=;
        b=KMLRpI/AqUqxR0FG9UaCD6rKr09wPs/ZfcRucfSQG45u0xZE5MCmJ/SB8124EWdQ9o
         fmVoLmeDkIXrMfcH5pYsenV26F31Px43hM8q0u6VhSZ+kRkMbiz8fGijiG5HH1LyWD4K
         3V9TAAOL7lNWZ9c09LXuQqgUu7utFWNk7QeG6v7bF/xhhEHheaJDUPxECdvmva5TTQvs
         0PUN1pMD2TerjLKIjop3Yk3yvh6lCndYxewSo6KW1h0kEzLAa/sdKX9BhWehK47IIbdw
         QnZwpbdkmUNyTMwJmGAk6WGhMw21vwhRXQa60HdG8X4g109YjIJeqlz/HahZNQEyihg+
         eEGA==
X-Gm-Message-State: AOAM530MAYvHIB3e/V1qDOtbtsLrQSo+BcfmL9bOq+/mSJjBT/S9PAB0
        Dy+EFNOyeLv0tXkUi9dGi7CBIACPAbg=
X-Google-Smtp-Source: ABdhPJxkc9JfNhlg3b6amdnt6eFYmO8YOs3A/CtjomzPdH293RrQSarCAXQwB2+CrT4LO3U8Y5ZtMA==
X-Received: by 2002:a17:90a:e284:: with SMTP id d4mr3158495pjz.124.1624506029547;
        Wed, 23 Jun 2021 20:40:29 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w2sm862969pjq.5.2021.06.23.20.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 20:40:29 -0700 (PDT)
Date:   Wed, 23 Jun 2021 20:40:26 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Message-ID: <20210624034026.GA6853@hoboy.vegasvil.org>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 10:46:24AM -0400, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> The current adjtime implementation is read-modify-write and immediately
> triggered, which is not accurate due to slow i2c bus access. Therefore,
> we will use internally generated 1 PPS pulse as trigger, which will
> improve adjtime accuracy significantly. On the other hand, the new trigger
> will not change TOD immediately but delay it to the next 1 PPS pulse.

Delaying the adjustment by one second (in the worst case) will cause
problems.  User space expects the adjustment to happen before the call
to adjtimex() returns.

In the case of PTP, if new Sync messages arrive before the delayed
adjustment completes, there will be a HUGE offset error, and that will
hurt the PI servo.

So it is better to accept a less accurate jump then to delay the
adjustment.

Thanks,
Richard
