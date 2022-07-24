Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D10C57F720
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 23:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiGXVAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 17:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGXVAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 17:00:49 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DD6B1C5;
        Sun, 24 Jul 2022 14:00:47 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id w18so14890lje.1;
        Sun, 24 Jul 2022 14:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0J62l/Q5URIrvVRDydPhg5BQrzftFvW78pkd3tTn9CE=;
        b=DeQgBoi0hrLfeMnY2oOwtNoppn0BqVxKlu3t+fagRWnWIfJgiPIM2i6am0E9jA8Sal
         6C18TesFhuqen6Kz55857aUvA7YivbDSO7d0FK7RLFxbBDSqG2lbl9XuSsf08i6H5G5b
         wRL8vZhoF9+px+/h7eRxAv7WIXgMopwL/8RoxyruD/ky1yz9lucZvVgzffYXTr+g9GS2
         Y1qrOlgvFXLzCFhq008mEBxD4vQmbrz0oXyvBdj9058l2CRR8Q2yzQ7XFUnnZ23rDX92
         4+k0UXLPXjggSWBS355RswLkpED2zJ05CZQnKvTxJOzhbRHs36jP9CmrHj0TtJjg8Bf/
         HRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0J62l/Q5URIrvVRDydPhg5BQrzftFvW78pkd3tTn9CE=;
        b=obrDiELOgUK0NkturudXev4Bk87VkvOEtLq4HmI3ksBF4s/otBsJ6x4uUik7BYmyvn
         yBSqIUncseRs0mpWf3KjZ1pjNoAmyj4Vd0QTcs4Ef4BU5z7l5T4Wn0Or8SxSJ8JUaYVV
         2NhmXiXR3YuuuIvih/FPkGsbYS1xm+3Ztjv6rUHeDj3jLetygKdCrRomgFWYoGB5Pt2O
         UQAfERaHUE10gPiT+uCU9UT+FhZk5KztUdYQmOIFXMgf+00+tEX71SwRdt0MnIuafOWY
         WibGJhN7nIi/iyhN7uPWdA2jVZRfvQDK20PrppOq4hB3Uv9JPk+02KkiBm5Qcv3ayKDL
         AWww==
X-Gm-Message-State: AJIora/QszdvQ69XUKaTKHE7NSxl8C/rxuVQ0zWldLgz0T/j8BIgbYb5
        ef9RN1H18MpQolvIzMCH2+0=
X-Google-Smtp-Source: AGRyM1uyIUokBOFL8+Stj3NfMd19svBCnM67XIwlnWGpGg6bFM+AeaHWOle1XxdJyIK6MbeK/HftfQ==
X-Received: by 2002:a2e:a236:0:b0:25e:767:6521 with SMTP id i22-20020a2ea236000000b0025e07676521mr742830ljm.89.1658696445142;
        Sun, 24 Jul 2022 14:00:45 -0700 (PDT)
Received: from oak.local ([2001:470:28:561:696c:a896:1096:52d])
        by smtp.gmail.com with ESMTPSA id g4-20020a056512118400b00482bdd14fdfsm2364463lfr.32.2022.07.24.14.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 14:00:44 -0700 (PDT)
From:   "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
To:     hdegoede@redhat.com
Cc:     andriy.shevchenko@linux.intel.com, carlo@endlessm.com,
        davem@davemloft.net, hkallweit1@gmail.com, js@sig21.net,
        linux-clk@vger.kernel.org, linux-wireless@vger.kernel.org,
        mturquette@baylibre.com, netdev@vger.kernel.org,
        pierre-louis.bossart@linux.intel.com, sboyd@kernel.org
Subject: [BISECTED] igb initialization failure on Bay Trail
Date:   Mon, 25 Jul 2022 00:00:37 +0300
Message-Id: <20220724210037.3906-1-matwey.kornilov@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20180912093456.23400-4-hdegoede@redhat.com>
References: <20180912093456.23400-4-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I've just found that the following commit

    648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")

breaks the ethernet on my Lex 3I380CW (Atom E3845) motherboard. The board is
equipped with dual Intel I211 based 1Gbps copper ethernet.

Before the commit I see the following:

     igb 0000:01:00.0: added PHC on eth0
     igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
     igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
     igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
     igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
     igb 0000:02:00.0: added PHC on eth1
     igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
     igb 0000:02:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e5
     igb 0000:02:00.0: eth1: PBA No: FFFFFF-0FF
     igb 0000:02:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)

while when the commit is applied I see the following:

     igb 0000:01:00.0: added PHC on eth0
     igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
     igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
     igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
     igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
     igb: probe of 0000:02:00.0 failed with error -2

Please note, that the second ethernet initialization is failed.


See also: http://www.lex.com.tw/products/pdf/3I380A&3I380CW.pdf
