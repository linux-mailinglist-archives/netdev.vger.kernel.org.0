Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3511C3DC408
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 08:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbhGaGeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 02:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGaGeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 02:34:20 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B600C06175F;
        Fri, 30 Jul 2021 23:34:13 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so23904361pja.5;
        Fri, 30 Jul 2021 23:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=nwHZHKPyHdulVpG6nZp/fHzmawIMoWKSVKxMeN3+CoI=;
        b=nZszvoxugr7/mJ4QS2quqa6R7rKRH8itdwlZUuyWTz3JIkRr3p9w0c7NFQWw9drwky
         3E6zUdRt0BWtpzvO1h/hQnwcIqmr0AYTnl3FPR1RhQnCbCEPIZTBwOOj0J8Z6SM6/4G1
         zhd6B/NXeZTO3YffD7B3W6EXVAWhctXcRzh/WqpsUTVZ8ZI66Cql7frjRn4I9fqyj7Ny
         Igl2h9K1NW+PxESbMKhNqRnc0hdC/GLLmnfWdSMjb5XtNan7OsIOWWgoSPF+TmwddUwV
         EZzWX1jrT9iLmvcLQa7+xw7P/pBr7FOuSUbYu/S1vW2yoXv2tkdtaj7y2+ncZD/8q7gz
         sqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=nwHZHKPyHdulVpG6nZp/fHzmawIMoWKSVKxMeN3+CoI=;
        b=URnQJ5z/4jgjHDGtxjA5Y8LRZwK0x+WW86iHY9J9eZ8qdXzDXdAxKKCenbXcRkVtZi
         t6vmAWX0U2eSTPH54tOdm5DYRupW2mjZwMuc3fld45sWRbtDAujMEsFoGbmIJJErwIR9
         8bWBp9WbEsiB/S5b0a9K0vLshym+lhhrcOSgwyDfa+1H7bYz6Yf980IjQVkCAljEJDcs
         gNM3K+jXblYrDlKaK36vHPiMH4/omQYJ52RaUfzjzqhryTx5g7MKSvOp0XXKXKI58f69
         0NBbCSFVX6fIForrjZXqnijUsMT3KYGUNxeYE80Fe/TSjgUdKX1VjGSvf0Apk1Uswj09
         Agrg==
X-Gm-Message-State: AOAM531KDDuXd8R2aWJjkjtKWY//t0SDZu1IpYZ8GsymvnDXVKrYPkCV
        D0Srtkb3WG5e6i7u7bfIzhg=
X-Google-Smtp-Source: ABdhPJw5aaSdBOA/B22KmWjK7ZemAJJrWlxSuRwt1dUh6nh9ejaJZSIA/kWgMbDU7K6686nV3CqBFg==
X-Received: by 2002:a65:6a52:: with SMTP id o18mr2433953pgu.414.1627713253034;
        Fri, 30 Jul 2021 23:34:13 -0700 (PDT)
Received: from [10.106.0.50] ([45.135.186.29])
        by smtp.gmail.com with ESMTPSA id n17sm5276730pgj.93.2021.07.30.23.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 23:34:12 -0700 (PDT)
To:     vz@mleia.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
From:   Li Tuo <islituo@gmail.com>
Subject: [BUG] net: ethernet: lpc_eth: possible uninitialized-variable access
 in lpc_eth_drv_probe()
Message-ID: <e431a6ad-d06c-2913-55ec-303707386029@gmail.com>
Date:   Sat, 31 Jul 2021 14:34:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Our static analysis tool finds a possible uninitialized-variable access 
in the nxp driver in Linux 5.14.0-rc3:

At the beginning of the function lpc_eth_drv_probe(), the variable 
dma_handle is not initialized.
If the following conditions are false, it remains uninitialized.
1304:    if (use_iram_for_net(dev))
1314:    if (pldat->dma_buff_base_v == NULL)

However, it is accessed through:
1333:    pldat->dma_buff_base_p = dma_handle;;

I am not quite sure whether this possible uninitialized-variable access 
is real and how to fix it if it is real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
