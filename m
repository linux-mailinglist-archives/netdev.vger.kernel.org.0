Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CEC3D37CB
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhGWIzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhGWIze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:55:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8289C061575;
        Fri, 23 Jul 2021 02:36:07 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id hg12-20020a17090b300cb02901736d9d2218so3004080pjb.1;
        Fri, 23 Jul 2021 02:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ZTe2QhZNvjeunOdwndEKdmKEetZXSNLWlRKdUTF8nEA=;
        b=noix7vBVUY0miC7zY6X47bnNSgos9y1DtT1DWKJwZfTTL96A3vHc2zzH9oNyR+Ymlo
         4EwOUM1d91Tz4WtVSCASMVAkOfG2GXxWrpq72WKIsR+nE2PZlDsQbJ+Au/W/ICuZroZx
         SLjVlomLADXPZmHCSoa2grT/cZArhJ8aa+6utp8LGeFnSUi8uIvscpmk1qrREtyNDnRI
         BA9mG3NMJ16FrQ7Hdj97cCjb5Apx98W1Vq0omPxd0U8pI3fgeoF9V7vJ+w8SSJI3J4pB
         LhvV/rVHaAIC9A8bSz6cqgwHrvCB0K4vvEX1928Eu4TCWUsgUzQ9OCMbuHxUgadmoTeN
         1SWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ZTe2QhZNvjeunOdwndEKdmKEetZXSNLWlRKdUTF8nEA=;
        b=YebfRpgcV2FOWFjwInvtDvOdej+bki3kFkJdkYwXJd7DvxKebI8l3WGOOie8ZUkOuD
         gZMXzv4hf2ZPQXfof4oawNo1jxXrAQyYWd59V/ZpdvuP9Q5A2FB+jgXuRUyRfq0im4zQ
         Q58ffSkwAG3m8UPe1X/ecSqBWScYDIKjr89EPe77b9R2kA9KTUn//L/vmvnY91/ElhWX
         fePsqmPzTPTvYbFgW3qr8nAgb2thLmJGoqnW/RmeqTT8Dcnm6yABeDocQnVixnLfntnv
         Zjb5i2ZgOHzr4pE3ipWXEghHiFFYvjR0lar5Ofi0A5uiXq2SHcboexUhGJyf/a8CvjVS
         4I/A==
X-Gm-Message-State: AOAM533L8RNqPO5RJZ6fft0wrZC1mc51aS/MdxZ7/a9ibBQQ7dLysE92
        XXGDC+quDZc3GGO4hxAJ8rxlgZlYjCvLyeBNXZU=
X-Google-Smtp-Source: ABdhPJx+9QoaAOcl/XoijfUaFdofNEePpqRuK0qvS5sdRzbvrBU3oIu8OFMTpje/RJ0CaWK4OC/zLQ==
X-Received: by 2002:a62:8c52:0:b029:335:a9bc:47e1 with SMTP id m79-20020a628c520000b0290335a9bc47e1mr3630701pfd.11.1627032966912;
        Fri, 23 Jul 2021 02:36:06 -0700 (PDT)
Received: from [10.12.169.24] (5e.8a.38a9.ip4.static.sl-reverse.com. [169.56.138.94])
        by smtp.gmail.com with ESMTPSA id s36sm22703766pgl.8.2021.07.23.02.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 02:36:06 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: free the object allocated in
 wiphy_apply_custom_regulatory
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
 <6fa2aecc-ab64-894d-77c2-0a19b524cc03@gmail.com>
 <CAD-N9QXO4bX6SzMNir0fin0wVAZYhsS8-triiWPjY+Rz2WCy1w@mail.gmail.com>
From:   xiaoqiang zhao <zhaoxiaoqiang007@gmail.com>
Message-ID: <2e9e6fa7-a405-088d-3b4c-da62b85f3fc6@gmail.com>
Date:   Fri, 23 Jul 2021 17:36:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAD-N9QXO4bX6SzMNir0fin0wVAZYhsS8-triiWPjY+Rz2WCy1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/7/23 17:25, Dongliang Mu 写道:
> Can you point out the concrete code releasing regd? Maybe the link to elixir.
> 
>>>       ieee80211_unregister_hw(data->hw);
>>>       device_release_driver(data->dev);
>>>       device_unregister(data->dev);
>>>

call graph seems like this:

ieee80211_unregister_hw
(https://elixir.bootlin.com/linux/v5.14-rc2/source/net/mac80211/main.c#L1368)
	wiphy_unregister
(https://elixir.bootlin.com/linux/v5.14-rc2/source/net/wireless/core.c#L1011)
		wiphy_regulatory_deregister
(https://elixir.bootlin.com/linux/v5.14-rc2/source/net/wireless/reg.c#L4057)
			rcu_free_regdom

