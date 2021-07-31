Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195BC3DC2FA
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 05:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhGaDkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 23:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbhGaDkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 23:40:01 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7193BC06175F;
        Fri, 30 Jul 2021 20:39:55 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id a20so13402922plm.0;
        Fri, 30 Jul 2021 20:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=p2lpXtsSO03rW6tcWTOmwaCtuMDEqLxg0LUSEGGH3vI=;
        b=JE3SeclbIM3he1tkc9keVUi25AQkxSqk1zYw/znHDZ8usMuV6gWLURbaml/8UEsW+A
         B8HFMv5NQIG4iyODlnJseiGoYiXI10723mumdR7Pk/pL5IvDPYxo7tmLK3U0lx8toGV3
         fSNib14rmAnynvoRlkT6dw2GKrpv/P3Gnqfc3NwKNYXK0uSiuyHcGqoa1FRdPWEJtgxm
         RuZkLFeqyP7BsX+kWtmX/geuxrs3U8s01ZtRsG3dvxOLYJ0xqcI9My5luudQ1hgSKwk1
         WWz9BrxK4FiWLvtDc4R9JYkOAhnWj9Y0B7gvnT5gGklnb76Bdia1IxGzZK4TWnlEgl1+
         Vj3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=p2lpXtsSO03rW6tcWTOmwaCtuMDEqLxg0LUSEGGH3vI=;
        b=j1m8m82A7d6f24Oh5MVbNin7P9inttsTVjNCtFIeuIzLOpZIcmeO8LMrtYX3WY5dM4
         LjRZEm8tvnjhmoh3PRDp08t/7Jb++pgzR9jGr+asUD9AtFeGSoWTXNsi+hlCu/B9fzBL
         SINphf9RRPIKh4gha091lr2c1zn8f7FHHwBsV6tXLCh4b4smP4D+5EtR4iIbbYUmF5kb
         gwo0spY3M78sRLoP89XQSzECKHxQ8Z0ahHMhlOuq/R9GzxJ+uWYmzyC3hWV1B1KK+lOz
         bZx/L+KMSiGrIIYBky0iMTN7WcVm5Zl4MgtDyo8lDxPC/dqMoFWKTkPLGGlyIqCwan4e
         6gtQ==
X-Gm-Message-State: AOAM531HrCPVnaVf/X7X3ziICXK02iBUT941O2CHT5shh8kalDb+KePy
        H4AFQHQsNsbDk5+so6jcC4Sg+UOg/Q296Rrp
X-Google-Smtp-Source: ABdhPJxd77Ef1mfbPQZ8wOiSnmNHKR8W5cnPUcmXDDwNlm9EXArjLXkEKX9EWO0lHYwCm++2YbpmlQ==
X-Received: by 2002:a63:e43:: with SMTP id 3mr1686841pgo.61.1627702795089;
        Fri, 30 Jul 2021 20:39:55 -0700 (PDT)
Received: from [10.106.0.42] ([45.135.186.29])
        by smtp.gmail.com with ESMTPSA id y15sm4555337pga.34.2021.07.30.20.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 20:39:54 -0700 (PDT)
To:     stf_xl@wp.pl, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
From:   Li Tuo <islituo@gmail.com>
Subject: [BUG] iwlegacy: 3945-rs: possible null-pointer dereference in
 il3945_rs_get_rate()
Message-ID: <c9663714-a352-7c5c-1826-c7a1cd6d9abf@gmail.com>
Date:   Sat, 31 Jul 2021 11:39:53 +0800
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
the iwlegacy driver in Linux 5.14.0-rc3:

The variable rs_sta is checked in:
629:    if (rs_sta && !rs_sta->il)

This indicates that rs_sta can be NULL.
If so, some null-pointer dereferences will occur in some statements such as:
643:    idx = min(rs_sta->last_txrate_idx & 0xffff, RATE_COUNT_3945 - 1);
653:    if (rs_sta->start_rate != RATE_INVALID)

I am not quite sure whether this possible null-pointer dereference is 
real and how to fix it if it is real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
