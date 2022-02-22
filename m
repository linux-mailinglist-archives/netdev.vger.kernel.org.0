Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1A64BF03E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbiBVDWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:22:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241027AbiBVDV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:21:58 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5087A14015
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:21:18 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z15so4852612pfe.7
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lhVF4mqP9Cg57S9vHbWaSnNO6MEqW/tFYrFYjWd+QxU=;
        b=MFV0621eha6Ymbg4Yzt7W5eIokMhzLaXCWqGod5/nhb9wAwZ0Ob4bgQZpt0kOMc3m7
         u/kUbaZYs48a9yTWcvdvst1eZ4CE0WQLTPbIdRfDKAy08yNh5v9Ap3twTIB0QChiDe1U
         PBgpvlwtdiBtkfLeUXvOZesCpN65YPHo2I8zJOvY0QxJfpGhgPf27jzmyinWaJXIeu6A
         KKIncDaFftISKmw1CoUt04Csi8/3SJJG2CbYaDAWR7+UZ//IOiuiETZarWdpJM6+xVvL
         ZoGIRQdwZ9kYwzlbtqJuO7GQfv6ddnk/TjZO164T2yUNvpHxlKPREfEIuXZS1icZVOLf
         9kLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lhVF4mqP9Cg57S9vHbWaSnNO6MEqW/tFYrFYjWd+QxU=;
        b=26tywGoJeWoDiE5nZORn7cBqO0ji53AMNUSifhZTVnolAUnrT1ek5iPWaZXAk2DZ+j
         0mwbSoFRDC3J8NVlVGyTaEsJzmZwvBjLV4MFx1MgFpnqK8AyUg70bW/kmNnVghmQzPKA
         lWVu2MXCoYy1qWFQ+3Y+RRKw29MW2gGn+EuGiI4EXapnuE/awl+8yGd3SHqC+JUavLar
         F2/mqHsb63Mh3jdnhD6VxeTAutUCIIs2YyTuyxQiuLeTWIzk2Vglnol/9Vhja/2oDYrN
         vc/TgXVGwKxM5iwv4opWCL61IAQGe4pUmMqTRr8F3E+DVhc0UMeJrzSwO21ghm3dEvXT
         xTrw==
X-Gm-Message-State: AOAM533MXbNurUpiWRKg0TzRn4tT6SaovgqeiFKvfo14DtyZ4Wj9SFJe
        iCzhLxs3plBkbMoXSr9GNLY=
X-Google-Smtp-Source: ABdhPJyg1E2LyP7AbBbCmghbytBhYazupHJwmmPaDg+spj0DrT8J4vX07zZ/jTHNGka0iIEXX6L24A==
X-Received: by 2002:a63:ce51:0:b0:362:c4fd:273b with SMTP id r17-20020a63ce51000000b00362c4fd273bmr18148059pgi.540.1645500077920;
        Mon, 21 Feb 2022 19:21:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f99a:9263:216c:fd72])
        by smtp.gmail.com with ESMTPSA id w198sm14799662pff.96.2022.02.21.19.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 19:21:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Marco Elver <elver@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] tcp: take care of another syzbot issue
Date:   Mon, 21 Feb 2022 19:21:11 -0800
Message-Id: <20220222032113.4005821-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This is a minor issue: It took months for syzbot to find a C repro,
and even with it, I had to spend a lot of time to understand KFENCE
was a prereq. With the default kfence 500ms interval, I had to be
very patient to trigger the kernel warning and perform my analysis.

This series targets net-next tree, because I added a new generic helper
in the first patch, then fixed the issue in the second one.
They can be backported once proven solid.

Eric Dumazet (2):
  net: add skb_set_end_offset() helper
  net: preserve skb_end_offset() in skb_unclone_keeptruesize()

 include/linux/skbuff.h | 30 +++++++++++++++++--------
 net/core/skbuff.c      | 51 ++++++++++++++++++++++++++++++------------
 2 files changed, 58 insertions(+), 23 deletions(-)

-- 
2.35.1.473.g83b2b277ed-goog

