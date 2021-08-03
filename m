Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCEE3DF101
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhHCPDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbhHCPDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:03:38 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CEDC061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 08:03:27 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id f9-20020a05600c1549b029025b0f5d8c6cso1942677wmg.4
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 08:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rc/n2W0z3+0Qrucuih1TEdsBlZLC6gzaIUNirP/B0lA=;
        b=e8cPPd1SeVInU+ZAqoIQvo2A+j7GUCAqlD4h8HzONdWnACZAHcsjSr1ivsf0CzwyPb
         8lwVlx1Wa45COt49TPzmBMPZxaXcwzaNrG2lhqL77QIrsaapTFghfPhiQpMBYFYqFlXc
         6S1T6HEyZcbTsQTMoGForFnprIONkh/A8mNwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rc/n2W0z3+0Qrucuih1TEdsBlZLC6gzaIUNirP/B0lA=;
        b=hkZEwjc+wY1yTSNM7jme/Qu5cywJkt8J9DW8Is0W+MkgBoUHxYu/ysVFlA7e5zKe3m
         h5iWX9mtuejXee7gXqJr1N8K5maaHlybaodNO03HEVJxRHIRYBXoGh8UXwHdlr3UjdPH
         A0b9ft+PGuvfpRdz4Xybq/EUZ6OixpAuc6KG90aqCWC6fx4sIpNO/ju8cMlOWfFBcrPr
         WeGu7Fb23E1jdeHhBVbUOj8nFfKqZ70A0Xkd6vLRVadelzksYr6dvk6bQoL0RpLgWdiL
         FmdTOD3J3/xvYZ75TpD7CaLlrpdgcChE2y19dKroI5Dzk7N/cW6f7k5wBVlZZgHTPXnE
         9wXg==
X-Gm-Message-State: AOAM530U0+B9p02HHMLVW4i24chaOgWp+nXEJ8AFYDelMMAW+A2gmQC5
        3O7ZPnR69tKyj0satFRCyzQVdHhNA548NA==
X-Google-Smtp-Source: ABdhPJySsaZETLB5XOwGFnQA1mDIPtWm1HKWmVObLnANoHi76nt1ki1eX7YUvWO6Faf9PfAfzF2buQ==
X-Received: by 2002:a05:600c:c2:: with SMTP id u2mr2573794wmm.106.1628003006133;
        Tue, 03 Aug 2021 08:03:26 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id l5sm16883641wrc.90.2021.08.03.08.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:03:25 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     paskripkin@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
Subject: [PATCH net 0/2] net: usb: pegasus: better error checking and DRIVER_VERSION removal
Date:   Tue,  3 Aug 2021 18:03:15 +0300
Message-Id: <20210803150317.5325-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>

Add error checking for get_registers() and derivatives.  If the usb transfer
fail then just don't use the buffer where the legal data should have been
returned.

Remove DRIVER_VERSION per Greg KH request.

Petko Manolov (2):
  Check the return value of get_geristers() and friends;
  Remove the changelog and DRIVER_VERSION.

 drivers/net/usb/pegasus.c | 132 +++++++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 60 deletions(-)

-- 
2.30.2

