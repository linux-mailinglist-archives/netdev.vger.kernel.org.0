Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC5B24EDE5
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 17:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgHWP2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 11:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgHWP2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 11:28:49 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E976C061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 08:28:48 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id v9so6878483ljk.6
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 08:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=0i/vx9dNh0duIZo+YYHyl28QUKMLxr//hpEhD6kAgqs=;
        b=LjjwogIYDeFUTHNbp4QMu4XgZ3F4VsaZ7Vn3iUVW0uslddwXpg5K3ze0E6oe4ojuqQ
         1bdXLBBI224W2qFCm/ojTpiEoyZoKGnkbrc2FmerfxRcZ6BVkm2hxrOgc6fXDDgZpLR8
         EaBDN4gZwCBDltGjAVNSk9alMpNx6ASRoQeM9TsyYAlvMLuoUnX865BcbPggHVKYxvN/
         jWtPAc24w5IRliyFQ9kDu8B/w4B0dAoU7LHvQc/ZWHTXPLdTFnagTcmZNaOspM3RyIlo
         RQKEOitqiFJRPOPKICrrPsTLpaRTnLaLQy9bzKP9cMPgGz8wSm4VDoY1UmXD7bDFFwDa
         vtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=0i/vx9dNh0duIZo+YYHyl28QUKMLxr//hpEhD6kAgqs=;
        b=KrSFaBvVbzMVcQJs5sQlq5JX+AcDNtR1oEG0tgaOsJAmOP+COxJZFLTIsMas7hfpGX
         ffplfAKRPSd8RJuYtEr/K83ldmsJz3S3JebjMkOWSd3Bfk5oowQMC0geUgCTmdOXB8sB
         64qn9H8lhUnVAU/m8fm+4zzrLxcaZtde073qxp0vJLDbemuSuhWOFPy1wQUuyVvMaTMB
         zgRPhCBB3mDlk4vpUciEglQZscupIsv7ZPyV3AHBDed6uClZMFB67ZD8T6UuO4OMzGZY
         psf6Ju6BK+MCv8CRCy46NDyJ5mptv7sDzhMxPb2kHm214lWO6QTzqPk9Lk3ilsclKzli
         eReg==
X-Gm-Message-State: AOAM5308MuXC53HjqR0CrTN8fh+LEiI85vDkm7V+Wy/9BYDOopxxG6fj
        +bbEFzMWWw/2zP/HJqLY1x9Z/Pwe3tIbq+Vjj2vPxnoftg==
X-Google-Smtp-Source: ABdhPJwUwLbit0CVmGr4/iOy4oMlhcSATLyCptnRsZP5QAAiBxld5gaWNEqf474rK4p5WQqa6FkvjYILwIe/SXUGkVY=
X-Received: by 2002:a2e:983:: with SMTP id 125mr858881ljj.32.1598196524777;
 Sun, 23 Aug 2020 08:28:44 -0700 (PDT)
MIME-Version: 1.0
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Date:   Sun, 23 Aug 2020 20:58:33 +0530
Message-ID: <CAD=jOEY=8T3-USi63hy47BZKfTYcsUw-s-jAc3xi9ksk-je+XA@mail.gmail.com>
Subject: Regarding possible bug in net/wan/x25_asy.c
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, xie.he.0141@gmail.com
Cc:     andrianov <andrianov@ispras.ru>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have the following doubt:

sl->xhead is modified in both x25_asy_change_mtu() and
x25_asy_write_wakeup(). However, sl->lock is not held in
x25_asy_write_wakeup(). So, I am not sure if it is indeed possible to
have a race between these two functions. If it is possible that these
two functions can execute in parallel then the lock should be held in
x25_asy_write_wakeup() as well. Please let me know if this race is
possible.

Thanks and regards,
Madhuparna
