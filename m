Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133C8249B4E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHSLBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgHSLBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 07:01:09 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6436DC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 04:01:05 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id v22so17733235edy.0
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 04:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=P0A2Xb0BW5alB149oxZ3EesEFZvw7ER05pmvkEUl0tM=;
        b=bp9abS3yhHYNu6IfHsGqzN4h8aubiwQgLNroV/wOhEV0eM4R1P/k34lUFYWRPH2VZK
         zQiFtx5hBc7tn2AKByOs1Ec8rwb/ri9VrLQdo1VNYK0iVFkDQ3OLo1BKp2S9q+HuIdxX
         8KyzEcUW2cR0SpFK6SvoGrCoQgK0V9q5e30Waq7vjOMf+5Fn8hwwjFF7sWEx4hMqiU0a
         OdqhSDwav3iwodvwlxa+fmauhdDBjBVZ8uZ6nFXRNk7csrAjRkKi1sDBtTr4FGLInGv9
         whSR8u3ZRVbxtR1OKwTqckVh5EdNZqg93LcKztu0q9ALW5vGCE7Jym60NGF+u74b9d7k
         NE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=P0A2Xb0BW5alB149oxZ3EesEFZvw7ER05pmvkEUl0tM=;
        b=q/4CEGSipNYUK82N5ImVlLcu38LBAvf3WeM6Vp00E3UabscdRHGufeuGwjLLSFEvxC
         FvHtGxWVFytbOVid9TJo33l9bItgxhK+ZilstpUqlP6cf9e+a2QsgnuyfTBsXwgVYHJD
         seE0wDuJWSu4g11D1yAKetAcLq1huAkiC37x+4ptDwNhhlmNcr5xGWCGetGzh0FT/hMQ
         jxRulUuxjdFn3DBDGMmO4vywIsa5dFNs94+5VqDsyWpIvWu5h6RhRHo3P8JHwdBll3k8
         Mhb6gk3SyBNKPROaLUIVIcwC0YBSLviAkAB8YrsW1L+7nz7ukwXrEA4/0n5Kmu5xwmj/
         XrMw==
X-Gm-Message-State: AOAM531zf6qbCO3SzU7lI5j8iejeXOo6Dj+wvNE1jgiiMGQp5R4i2DBi
        1mBClmU9eUm+qkhxfy6UYk1gDyhnaDfxvg==
X-Google-Smtp-Source: ABdhPJyVO5uIY6FxQud6EK9i76A6NyijWqFRyjMdKHB/vNEomipY0hh9uQMoETnG1+WT5YI8swc1LA==
X-Received: by 2002:aa7:d70a:: with SMTP id t10mr23587263edq.68.1597834862844;
        Wed, 19 Aug 2020 04:01:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8106:4619:9f30:5ac7? (p200300ea8f235700810646199f305ac7.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8106:4619:9f30:5ac7])
        by smtp.googlemail.com with ESMTPSA id l24sm18521036eji.115.2020.08.19.04.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 04:01:02 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] r8169: use napi_complete_done return value
Message-ID: <18f0fcd2-919e-3580-979d-d0270c81a9ad@gmail.com>
Date:   Wed, 19 Aug 2020 13:00:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consider the return value of napi_complete_done(), this allows users to
use the gro_flush_timeout sysfs attribute as an alternative to classic
interrupt coalescing.

Heiner Kallweit (2):
  r8169: use napi_complete_done return value
  r8169: remove member irq_enabled from struct rtl8169_private

 drivers/net/ethernet/realtek/r8169_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

-- 
2.28.0

