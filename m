Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A907F31730F
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhBJWPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhBJWPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:15:05 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263B7C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:14:25 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id b187so3613464ybg.9
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VWjM7/wBKHL4scsTLe5KXcjevC2FogNYYzs0R/QPoac=;
        b=XStRtBd97ht21JGd6R50j43IpSGd/zQ+tXkHzGCHtpVVCHPOnuPS8ekC3qlryUbaE9
         6mfGre+OYSuDNrZgaCGwGjLaubT2VoZLZ1OFzmkXira5oSpR2IYILbEv2rtwVh2gbws4
         3Hw5jnE1RwwC2ROy0y2mCdsbIqk4CAm2TzofA7naiWhQLr3mHyJwsn8EooBG7EMENpJW
         DWkmHWCLgdAJBd4NCIF1ONv8b3pcHD74cL0nxWGhTuAuehlsn4dKDzE/YUkmhSN502zR
         Fe77wG2OR3+eLe2FyIUyM+4IJZC0aJqMNIamsP0OV/Cp5JpgscsP+0zaPdMvovwkhFVQ
         FZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VWjM7/wBKHL4scsTLe5KXcjevC2FogNYYzs0R/QPoac=;
        b=bdhxtVCIkYeksqirbA6gBbwbcXQ6xK/k4jBEnS6AklilJ3y9eAG3Hbvl4wdxxF9xvr
         u+e+SVE2iPZY0Geo7uMDfQGHgulLMRrJXrno65v9H68DG6C8p6BUaWyA5460ZLPFIRy8
         xfC7OXLC0j0Hcxk+uINYlZYo0o/954rh+gLchhkXqtbKdHMDOs0V3dnSpfIYLqy43co7
         S1c38R2QgPlw6xdW2/sBrYhOirXfjrTeTDE3p9y0F49duVbhy4PjZQWaYq92S/kw5YvV
         RUz2Ox+DNwOnS/kWRU1CY0aTOeW96VVshLerDZfcwOyM4bnd+iqge3Uq3gs7JBVTaFjS
         MapQ==
X-Gm-Message-State: AOAM531rhB+Ns/6F7OuxIY6eQPQtYQ1khg3f9ecA7WTDrj0FTu5X6mqE
        gKHR/AmqjsIGoF1Wq2NfFJ3Aex0dG+mwfvrCxA1Brw==
X-Google-Smtp-Source: ABdhPJz3URz0lofJcCssdyg7nZLDEZn/GHBJSrxxYizLGPovCOiOwHAwalAXeiod/kZgAJAenDpnQBty+NJ6rTZjf+4=
X-Received: by 2002:a25:b74c:: with SMTP id e12mr7988864ybm.20.1612995264346;
 Wed, 10 Feb 2021 14:14:24 -0800 (PST)
MIME-Version: 1.0
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 10 Feb 2021 14:13:48 -0800
Message-ID: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
Subject: phy_attach_direct()'s use of device_bind_driver()
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This email was triggered by this other email[1].

Why is phy_attach_direct() directly calling device_bind_driver()
instead of using bus_probe_device()? I'm asking because this is
causing device links status to not get updated correctly and causes
this[2] warning.

We can fix the device links issue with something like this[3], but
want to understand the reason for the current implementation of
phy_attach_direct() before we go ahead and put in that fix.

Thanks,
Saravana

[1] - https://lore.kernel.org/lkml/e11bc6a2-ec9d-ea3b-71f7-13c9f764bbfc@nvidia.com/#t
[2] - https://lore.kernel.org/lkml/56f7d032-ba5a-a8c7-23de-2969d98c527e@nvidia.com/
[3] - https://lore.kernel.org/lkml/6a43e209-1d2d-b10a-4564-0289d54135d3@nvidia.com/
