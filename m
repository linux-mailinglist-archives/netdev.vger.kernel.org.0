Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776B23E88D2
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 05:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhHKDaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 23:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbhHKDaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 23:30:14 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BF9C061765;
        Tue, 10 Aug 2021 20:29:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso4683932pjb.1;
        Tue, 10 Aug 2021 20:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=jkh8MdBd+5xRfDGap7m8dlGwadMn0qsFS4+s/qO2eG4=;
        b=rhiUyBRmbmOzo52u0m963KeCQ/FWF9Tl38u5WFbzQ6IfCDO2yNpJIdIShEBZHTfzI+
         R3A47nKzPNlNIiuMachh5u4bm0wKjqnjYVClShici5GXbySc3x+/C14X9CZm15d+isG3
         PA5KsoHTHy2LTVK8hIqbP4lP13x4K8rpTnMOwEuyLdCBLwQYRTJwuGXois6rqtiePbW0
         OMDetOvW80BYMd5IGHzcDS6lVIhk73L7Kz/wU1FG09sL1h8EmOF5qlwAJX7voyvQF3je
         cyKuYmFaYWdCUaNMoa7fqzHs+0x5gfa4ktWFna7uATFxVJwEwiN+SPUWhgfe7GRS54bp
         ysBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=jkh8MdBd+5xRfDGap7m8dlGwadMn0qsFS4+s/qO2eG4=;
        b=Ng1U+D5jsiqRyJcrBVQBi0476aqzwOjtXPGQsKVj8OutGRwJxM1M8fdUtsCntN3fjB
         AZaenfa+EMG+o2u2S2vCybCh3pUPgA4Cul//d+9ZiWHAyJyF+zvgyjk4cwfG4Juev/QJ
         fBJu2zbvXYj0KYG0WekbA3Dmx1rQIPUVsIZ5xB1Qr5XCodRIy1WglSWpebnLkXt7Jqie
         EuGYI+D0XJSRmI6KhUGDQgJ6Aiazy7f5DmB/tfp14VFHfAkD+iVhxNb/8rDez+GTOh0n
         q41pBVnVnbpTJzZDyB57iwDq62WFRI61XEU/jnaWTITnw8cylRq8CbVhwmgpje0+Ex6v
         W1Ng==
X-Gm-Message-State: AOAM531jln1cDG7zcg0rdOx48ctrKc7f5gvQ3HdDSwOW+2JeklBYG99l
        H+EtxLFFU7ZprW/SPdRJ2SKf9ltE4iEszCI4FxY=
X-Google-Smtp-Source: ABdhPJxcHLx2WGY5X793Y1A3LBXlruDQHcT7/hg1RaF3/2EAafKiAJS3+kC9dDldlCvChUhMC0DGCQ==
X-Received: by 2002:a17:90a:1b2e:: with SMTP id q43mr11056326pjq.217.1628652590918;
        Tue, 10 Aug 2021 20:29:50 -0700 (PDT)
Received: from [10.178.0.78] ([85.203.23.37])
        by smtp.gmail.com with ESMTPSA id t8sm4689152pja.41.2021.08.10.20.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 20:29:50 -0700 (PDT)
To:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "baijiaju1990@gmail.com" <baijiaju1990@gmail.com>
From:   Tuo Li <islituo@gmail.com>
Subject: [BUG] net: qed: possible null-pointer dereference in
 qed_rdma_create_qp()
Message-ID: <36bc2872-5b1f-ca1f-86c3-1a13cadcad2c@gmail.com>
Date:   Wed, 11 Aug 2021 11:29:47 +0800
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

Our static analysis tool finds a possible null-pointer dereference in 
qed_rdma.c in Linux 5.14.0-rc3:

The variable rdma_cxt is assigned to p_hwfn, and rdma_cxt is checked in:
1286:    if (!rdma_cxt || !in_params || !out_params || 
!p_hwfn->p_rdma_info->active)

This indicates that both rdma_cxt and p_hwfn can be NULL. If so, a 
null-pointer dereference will occur:
1288:    DP_ERR(p_hwfn->cdev, ...);

I am not quite sure whether this possible null-pointer dereference is 
real and how to fix it if it is real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
