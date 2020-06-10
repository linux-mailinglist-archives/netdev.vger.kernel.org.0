Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52801F4C9A
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 06:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgFJEwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 00:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgFJEw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 00:52:28 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F45C03E96B
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 21:52:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x22so574262pfn.3
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 21:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=62o4zuSkKEk/lqEK6BCZYnVbq5z1honlOGbIKeq6bQQ=;
        b=HmSGSlitfcOLJTWcy5a+DUJfOu4KF+p2nFfQSs61TLwjlZR7uZC0yZXNBx3TyWBzS0
         e10FLPDu8Rt6YgWhdpHXrJhlwLIS3crl/ve5HsSJkCRupvhsemu1acoqeCK+KrmC7lU4
         oaCgFR/OQoTqfFJkgpugH6CeWQOAmkWr8cqx4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=62o4zuSkKEk/lqEK6BCZYnVbq5z1honlOGbIKeq6bQQ=;
        b=XCivz643BR88MJ4bxmgjAzg9DmX1SqI9pkiEMU8Z+ukkHLLCNPXuT2kqBOFoW0TKDK
         0/XZfoyE56MAeijtmFxJ3GASR/ExH1fP8L6mc4cLPSZB/F+U5k4Ha29nMbjvERcl9K1P
         5Cz3rx5YQsTRPLN0X+GMFtA8D//sC8oBXV15LCOG/+6nF6yxasMhEQu9gSybhbFCx+SY
         w80W5BHG5IOKuAnp8n/v/xoxGjmRhRn6oPLl8QHva3vPqrFTpVIvXxZTnz46gGwrc50v
         OJZplTA3FDWB5J6B0R7mCjAeBl1n1OcJTNHkQ3nAJFaRiGoJUCQLWCguqJlN6ANpxWq4
         d4kA==
X-Gm-Message-State: AOAM532d9bUuxG+NZ3fOOT3zuuqGSmM4nGJJlcN2Tl7oCIA9GZXxwhTM
        H72m9gN98KFjkcQKzT8OiiG+fQ==
X-Google-Smtp-Source: ABdhPJzyyBj41piy+zKuHU9AV3KKZZWDCXzRyq+Nnh1gfKm0UyKvsFf3aB1FBfGADti7p26pSq0ECA==
X-Received: by 2002:a63:d04b:: with SMTP id s11mr1134095pgi.384.1591764746246;
        Tue, 09 Jun 2020 21:52:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d5sm11550449pfd.124.2020.06.09.21.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 21:52:25 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian@brauner.io>,
        Sargun Dhillon <sargun@sargun.me>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Use __scm_install_fd() more widely
Date:   Tue,  9 Jun 2020 21:52:12 -0700
Message-Id: <20200610045214.1175600-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This extends the recent work hch did for scm_detach_fds(), and updates
the compat path as well, fixing bugs in the process. Additionally,
an effectively incomplete and open-coded __scm_install_fd() is fixed
in pidfd_getfd().

Thanks!

-Kees

Kees Cook (2):
  net/scm: Regularize compat handling of scm_detach_fds()
  pidfd: Replace open-coded partial __scm_install_fd()

 include/net/scm.h |  1 +
 kernel/pid.c      | 12 ++---------
 net/compat.c      | 55 +++++++++++++++++++++--------------------------
 net/core/scm.c    | 43 +++++++++++++++++++++++-------------
 4 files changed, 56 insertions(+), 55 deletions(-)

-- 
2.25.1

