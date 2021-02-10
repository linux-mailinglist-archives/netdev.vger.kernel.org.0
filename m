Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A71D316A50
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 16:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhBJPfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 10:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhBJPez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 10:34:55 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A45C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:34:14 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id m22so3523809lfg.5
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7K3QQqxG3TOhrDKHtDRLwk3PfSbGn/DxfzYnMN9+o7c=;
        b=alJ9n0gH6bXRnAgpvY1L5cfzrKHDxndIdS2AaRgSRYmw9OiA8PrSiU1Oiju1n2C0RH
         BnoqXTynL3VXqL/ODEav+IiQZA4rkfIqNvgSjc9clVFQCyojTbCvoqiOOglajoPd3efJ
         z8nzbhtePvYjqcVvWTKH+f2PvLsqD6cQkHTIrwHyDqgGvddI9Tdq2n954ivbNERFv/+8
         3uT9aeT7RCo2r1o/TTJDyeq3igu5elelRceTE29xU0kuYqQ1JUk1XdKb7uCuXf3QSa+F
         4m2eluGG1seGVs1a/bMVb1JGiObEt5wVvdXbCXkbD2HT5N1DU9WlyQRgiufkwoSOu7Xt
         Ih4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7K3QQqxG3TOhrDKHtDRLwk3PfSbGn/DxfzYnMN9+o7c=;
        b=ehCEti/LTnC5GvBkOPkwzOMDXNZopN8dyuH0MOLcrGwVpQSKd6dhZyO5y9EA7r/ie0
         KpgL35Vrb7yjjdD1QZEKgxBmcYKvhNfelqPBcmrh/H4OGTV3k3SVBjY2O/eJNKOkpQ08
         8A2J2HII+NL+k0PSHYIieyrSQH5XClL3CwLfAGNlHvqbw1qg13+GoyFadf8/xrdn7rfw
         xxiQneEOJiLo8kr5DkqPnhuezAVx29kwnn7OTORb6y9Ga5o7gAt7y7XOXPFkmFTYwCFE
         G5j+y40lG0DctFGMvbYQBc0wkYHT7kdmXKzguTltC6sebOoMuMQk+9Q013z2XVCj80Hv
         tdag==
X-Gm-Message-State: AOAM5331dtPTzZuqCyZkvwaQ/CAd1HRWKu7F6Y5EAsoY7bhYApwpqXGD
        7yrkXnoFrfUePBqkdhBmqmPXw2LApWsyOljfw0d62F4pdkdgiZBtOb0=
X-Google-Smtp-Source: ABdhPJzD0xhPyZkTGrsSxTfey2FQUPX8Q0SgKN/U4OZPz8pYFWdOn6ch1z406BjPPV+IN9TRsoq7jzmZxpUdDYwApio=
X-Received: by 2002:a19:7f48:: with SMTP id a69mr1993318lfd.444.1612971252605;
 Wed, 10 Feb 2021 07:34:12 -0800 (PST)
MIME-Version: 1.0
From:   Zhibin Liu <zhibinliu@google.com>
Date:   Wed, 10 Feb 2021 23:34:01 +0800
Message-ID: <CAM5yEy3MHKUJwuk0ThoBPrXV++b6jUmauFVz0YPXduuJK0tdRg@mail.gmail.com>
Subject: [Linux Kernel Network Bug Report] tcp_rmem[1] is not resulting in
 correct TCP window size since 3.4
To:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Chunlei Zhu <chunleiz@google.com>,
        Tianpeng Jin <tianpengjin@google.com>,
        Weiming Liu <weimingliu@google.com>, stephen@networkplumber.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Linux Kernel Networking TCP maintainers,

tcp_rmem[1] has value 87380, which will result in a window of 65535
when tcp_adv_win_scale=2. (87380 - 87380/2^2 = 65535)

But since 3.4, commit b49960a05e32121d29316cfdf653894b88ac9190,
tcp_adv_win_scale default value is changed from 2 to 1.

The change causes tcp_rmem[1] with value 87380 will result in a window
of 43690, instead of expected 65535.

Now the doc Documentation/networking/ip-sysctl.rst is still mentioning
87380 tcp_rmem[1] will result in 65535 window size with default
tcp_adv_win_scale.

tcp_rmem[1] should be changed from 87380 to 131070.
At same time, tcp_rmem[2] should be changed from "between 87380B and
6MB" to "between 131070B and 6MB".

I've fired a bug (id 211677) in Kernel Bugzilla, too. The bug is
assigned to Stephen Hemminger <stephen@networkplumber.org> instead of
you. So I sent this mail.

Thanks,

Zhibin Liu | Software Engineer | zhibinliu@google.com | +86 21 6123 2345
