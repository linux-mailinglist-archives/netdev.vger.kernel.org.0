Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7DE1E13B5
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbgEYRwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgEYRwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 13:52:54 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A429C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:52:54 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y17so9395822wrn.11
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tfdFv/a+uMiR6L3JhyloRU8+aUg1/bmzQFTApQLPVes=;
        b=QFha/vd1xoP4v8M007AkVTcJ1nBMLaCd8GMy9ZhNKsx1BTz8/b8N8S/7/Vg39Hw3n/
         115r7o9ctPNGs44HWbMyDrcpY4tDkAGDTC5Z+Po20D2rt+1Z9lFkQEIgIMX+1cIFH8Z6
         kFVRsYivOijVK90/tVxAbXHrNLD37MHC33kvi4scU346duFKxNsavIg3Byn8VY+lYsxL
         JOG2NvDt4rj2o/bvAVZc2GD+4e1JaqvKz2JOwIEfC+6mcQln5/so6rXJGVlPjEWJw5AN
         io8xlihLtUuiWhKAOd0gVhc1BHfq/y9p+aOMDKZ8D9j2hjYhoPrJ2MAZ5TmQssj/MniU
         YprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tfdFv/a+uMiR6L3JhyloRU8+aUg1/bmzQFTApQLPVes=;
        b=FAs10xr53Uk8RbH83lE1KpdLPUpD8jLI+6Co+JJXC3DBuieIfpCGQXbLSgig3FFr6o
         /z8am/L3Ee/72ZbQvxS5WldLOl0FYifnlVuf8TzdyRYrVLcxt0B8p8rTs8j4CEkOXLwi
         QTcUkYCp5X04vEn0NXJqR3NEckCdy1Lzk88qtxMseCtfuexKAYJFvpmpbgvM7qPE6RHe
         ftisUvmJ+7hbaP0VTRG+8TlsSCo0oJNUDanzMeXyEzpGXSSUyNfqtjra6fvnUeFg+GHk
         n/d0KSoo3wpEYjyKQhNA318K+Mp0TRPh49TXwKydmtdIQLkziq9hyveQK1O5I4mh8yse
         KDqw==
X-Gm-Message-State: AOAM5327gRwL3iFR0VCShROCD3ObXOj8Gzlw5Azr8jZG0Mv/dg3G2Jzk
        S/WaBLq1MZNFbvBan2GXnsUKak1+
X-Google-Smtp-Source: ABdhPJxUts+AdAD5r8gdszZgi3IkQLXjuy5iS5EOwLZGe5n9S7IJgd4rzOGyv+F8f6VMIb5weq0PSQ==
X-Received: by 2002:a5d:56c6:: with SMTP id m6mr15934429wrw.78.1590429172601;
        Mon, 25 May 2020 10:52:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:fd94:3db4:1774:4731? (p200300ea8f285200fd943db417744731.dip0.t-ipconnect.de. [2003:ea:8f28:5200:fd94:3db4:1774:4731])
        by smtp.googlemail.com with ESMTPSA id 1sm10362786wms.25.2020.05.25.10.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 10:52:52 -0700 (PDT)
Subject: [PATCH net-next 1/4] r8169: sync RTL8168g hw config with vendor
 driver
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
Message-ID: <82c9a91e-8132-2421-ac84-a92da10fe18e@gmail.com>
Date:   Mon, 25 May 2020 19:49:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync hw config for RTL8168g with r8168 vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 79090aefa..d034a57a0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3019,6 +3019,7 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
+	rtl_eri_set_bits(tp, 0x0d4, 0x1f80);
 
 	rtl8168_config_eee_mac(tp);
 
-- 
2.26.2


