Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB504AD6C1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357027AbiBHL31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbiBHLNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 06:13:19 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECB3C03FEC0;
        Tue,  8 Feb 2022 03:13:18 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id z13so640698pfa.3;
        Tue, 08 Feb 2022 03:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=jT1cKosXcRAQ3QgcohgO2Lw1KpFQbKWn6saHhs1RKHA=;
        b=lj/XmEGsyYOviX8Ubzy8vnxlCH4B3X5gXp8BQ4iYG8FxHjtJqU29xFPQUBNV3uTr8q
         FyEWO6FAoRy9hFENyGTMdp2oo49IlOk9TmOHenmQXdaKZ4yy3nVgIOtPxUb1B+UJ10f4
         cdkr1AWz0VfCm9xRKPL7htfXKHMtaCxYkDHzulU21jFlEkmbttO0PDakAsaGqwZHaVpc
         lClPrf0p4eBUilZdeaJEnhDrtxxWUJxNR/ZS70y8Y0WmBkZj3mZoWDhuUTOwV4jOKiRA
         ZxX08P7jH8pGt8ccDZR1eg7eBIXleA0IbJH2lmFZIGS5Zy3XG/RX1nfVhdZ5WfMlPbmh
         eMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=jT1cKosXcRAQ3QgcohgO2Lw1KpFQbKWn6saHhs1RKHA=;
        b=z07O4ULcxNTPTCg9t7BKokYFCrqqNdrMhHTltqUDUQwXSRAzyOosVn2QZmxwhOAwnE
         eiNYQ1LlWSzubHT+5cvSQnR0gPlFF3h2A878XyVSDaxmBYfAYlXNKD9hJ48wwJ6VJ7U7
         lVbA8eWL1UIl3j/bAOzPgUOOV74moAAhxfi2EQRGwZuatqB/Hjx4PLTNhTyiOmmoAijs
         /koOOSOZUgjA14gvB0BPSpfB5Up6DJgcYwvhlN8blH8XHjIH6XJCEGw8fOZ7JhIFADdk
         PMLyLbPqOpIg4RpOmLgzCX/KsapmaYACK78Dm5TXrj8XWNsEiCYPCBxhsJP+m8Zzi63H
         Z1vQ==
X-Gm-Message-State: AOAM5318s//PoN6UrvDJ8w3INSugOm5toD3EOT7O5jyY04Nhe/ClUWSJ
        GcY/8wCIG9ej4p5N/EukfIV/ZJYzY8s=
X-Google-Smtp-Source: ABdhPJzdPftreTii6GmmT++vd2facGVqjUbf4A6ncaTkAs98QhKLW+qK8LqOjFuc4VSa+LQe0eyH7Q==
X-Received: by 2002:a63:ad44:: with SMTP id y4mr3097759pgo.160.1644318797989;
        Tue, 08 Feb 2022 03:13:17 -0800 (PST)
Received: from [192.168.1.100] ([166.111.139.99])
        by smtp.gmail.com with ESMTPSA id rj1sm2581464pjb.49.2022.02.08.03.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 03:13:17 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pontus.fuchs@gmail.com, Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [BUG] ar5523: possible deadlocks involving locking and waiting
 operations
Message-ID: <7c9bb278-5042-3bdc-9598-95a10e42f78d@gmail.com>
Date:   Tue, 8 Feb 2022 19:13:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My static analysis tool reports two possible deadlocks in the ar5523 
driver in Linux 5.16:

#BUG 1
ar5523_hwconfig()
   mutex_lock(&ar->mutex); --> Line 1135 (Lock A)
   ar5523_flush_tx()
     wait_event_timeout(ar->tx_flush_waitq, ...) --> Line 926 (Wait X)

ar5523_tx_work()
   mutex_lock(&ar->mutex); --> Line 888 (Lock A)
   ar5523_tx_work_locked()
     ar5523_data_tx_pkt_put()
       wake_up(&ar->tx_flush_waitq); --> Line 727 (Wake X)

#BUG 2
ar5523_configure_filter()
   mutex_lock(&ar->mutex); --> Line 1331 (Lock A)
   ar5523_flush_tx()
     wait_event_timeout(ar->tx_flush_waitq, ...) --> Line 926 (Wait X)

ar5523_tx_work()
   mutex_lock(&ar->mutex); --> Line 888 (Lock A)
   ar5523_tx_work_locked()
     ar5523_data_tx_pkt_put()
       wake_up(&ar->tx_flush_waitq); --> Line 727 (Wake X)

When ar5523_hwconfig()/ar5523_configure_filter() is executed, "Wait X" 
is performed by holding "Lock A". If ar5523_tx_work() is executed at 
this time, "Wake X" cannot be performed to wake up "Wait X", because 
"Lock A" has been already held, causing possible deadlock.
I find that "Wait X" is performed with a timeout, to relieve the 
possible deadlocks; but I think this timeout can cause inefficient 
execution.

I am not quite sure whether these possible problems are real.
Any feedback would be appreciated, thanks :)


Best wishes,
Jia-Ju Bai
