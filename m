Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6250F480CFE
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 21:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhL1USs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 15:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhL1USq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 15:18:46 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9515EC061574;
        Tue, 28 Dec 2021 12:18:45 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id k27so32350679ljc.4;
        Tue, 28 Dec 2021 12:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=CsJFz6LU/DncWkAXKxojlOBWx4MiD9NT/cxxE28TU0E=;
        b=O0ynzQey2/9LJPjA8eXOjMzKzBC+oXTkdvQfkcaXpQ2gW78bG7UwHbOPOYfiNXeTci
         aHxbEVjfpWwoaywZwOG7HH4KZvXwvOIIg6Vjo1KzMnjf0zGH+M5EwhHJ396ZqLwdpx5A
         NK6Cqfmt5HAKCMcmRz/trHDL5X2qZZfdxMtLbAvknTKjG+p3kba1auWsYlLk4R8Z3r7S
         Z7n3430VuGcpdwIs/mMIWqeTw8OhSSkGHRGQfq/n6ET0NUtuYgnbFmhFukR+YsFmBEWp
         WkXKtG2J5i5k/UU0NB4NBAbj1LPDFftHGS0bnws559Zl5VnGsGlfw85OHzKsWxv4ajvO
         zi4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=CsJFz6LU/DncWkAXKxojlOBWx4MiD9NT/cxxE28TU0E=;
        b=nDdckBwePDG+FYc21DxuULscHS4xOmsyJhsiq9I3CzPT8eoHM+mCp3fLJyKEEZ2Pmu
         4WRLhWCS5OHVX16+7otgla1+wS0CmxhQBddrCVvRXfHPrp/oBnYD4EHFiV2vHkn5CFFs
         f68h3NMCd0l+O6Ftp0cjv1YznF5jDfEtT85/InvOGJCsuyNO8U5mEWrkkCXo49LE86lF
         opEqyLYD8A356VI+AjozPVBDV+vNAa3nGhmuezaDuVV0uqkwVU5sE80PPASYK3akrH71
         r7IGaI13mol2iqWmZYwjyyJxeciLkcoWoeL/fNPI7vahdCuT63uY/O7qxtSLaLf2m/LF
         BXNg==
X-Gm-Message-State: AOAM533GEqiCf3WkZ9Ao1gcq8gHr/4Uxfr+r0hnFDI4oWBFvbdnD9p+I
        SuJrbFwu7do7+Gjc2GsIzGRL5YOXAgMTRBxW6lHaSt6tpeI=
X-Google-Smtp-Source: ABdhPJyPI9a7grucxlsuWTzWbC18GdjYRYHUYgROhemAhvZ01ug9XhHh0Z4zv5isYgVic5SUrjsOwDKxYnuHdeqqACM=
X-Received: by 2002:a05:651c:39d:: with SMTP id e29mr5306875ljp.74.1640722723129;
 Tue, 28 Dec 2021 12:18:43 -0800 (PST)
MIME-Version: 1.0
From:   Tamir Duberstein <tamird@gmail.com>
Date:   Tue, 28 Dec 2021 15:18:32 -0500
Message-ID: <CAJ-ks9kd6wWi1S8GSCf1f=vJER=_35BGZzLnXwz36xDQPacyRw@mail.gmail.com>
Subject: [PATCH] net: check passed optlen before reading
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Tamir Duberstein <tamird@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 52e464972f88ff5e9647d92b63c815e1f350f65e Mon Sep 17 00:00:00 2001
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 28 Dec 2021 15:09:11 -0500
Subject: [PATCH] net: check passed optlen before reading

Add a check that the user-provided option is at least as long as the
number of bytes we intend to read. Before this patch we would blindly
read sizeof(int) bytes even in cases where the user passed
optlen<sizeof(int), which would potentially read garbage or fault.

Discovered by new tests in https://github.com/google/gvisor/pull/6957.

Signed-off-by: Tamir Duberstein <tamird@gmail.com>
---
 net/ipv6/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 60f1e4f5be5a..547613058182 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1020,6 +1020,9 @@ static int do_rawv6_setsockopt(struct sock *sk,
int level, int optname,
        struct raw6_sock *rp = raw6_sk(sk);
        int val;

+       if (optlen < sizeof(val)) {
+               return -EINVAL;
+
        if (copy_from_sockptr(&val, optval, sizeof(val)))
                return -EFAULT;

-- 
2.34.1.448.ga2b2bfdf31-goog
