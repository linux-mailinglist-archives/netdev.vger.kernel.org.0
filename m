Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705772FEB2E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbhAUNKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731649AbhAUNGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 08:06:01 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A50C061575
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 05:05:01 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v15so1673172wrx.4
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 05:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=to:from:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=fi78/iLHBPgQD/i/42gFDpAUqvQKsGxtOq/QZhvVA9c=;
        b=lSyTyIplz1KbkQnJa2GV75BSxmvtLOTGHj6ATvTXgGEWnKgnWojid1mVkWSYYYh8Iq
         IFD6+gCrUgSoWEy8qaO+JyagxTR6xdhnztQw8qzAXHtkbGISqlEAgLwbsdGFsrRAEaW5
         i77+QH5rl3UybqyN5R5GYEqfrBvdc47UXb+Z0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=fi78/iLHBPgQD/i/42gFDpAUqvQKsGxtOq/QZhvVA9c=;
        b=oSKtCXRXyj8uae3YnzSlCxaEkXzqUo1O6VAifxvhc6IkpFa1MBKXK7LqQekYF4ruQB
         JWE+l3tjaDUWnpLBZ3V7Pp4upCSsyGWBRwrFdX5dt22zH+s3K2zyf2CJK3kVMC42nmLz
         5Hz53YDt8UOcDKcTgnyIha8OeuFOVbDPHJEZxHOOCDc7FbfyKjhnoHzjQKVmzLvNqbY2
         m5Mk3pxUFavILPTwXr3K8DWkcvlz73z+n92AHO4BYSWR/7qUhD9f+Anz9g2c18r0+CJK
         l8Ru3W0SWu12Am3gWU/PfeuoO8iqMEZ+SkUVkZd0uPGBxxX2JdyH168zV4a/oUAsOpMd
         HwtQ==
X-Gm-Message-State: AOAM531SUEHPJAdU7uAqE7JzBo2x2wnicSLueJ+dB1OsQiA5go6pOGCo
        FVHm0YxJgNSxJr3bgedBXipOSg==
X-Google-Smtp-Source: ABdhPJxzhJwT9QJwO/sClY2ssWYDDnpqYQdAXmB39CyuMWakcWce0Q8odQhX0rQxVy2tmmUyAq6RCA==
X-Received: by 2002:a05:6000:124e:: with SMTP id j14mr14507770wrx.310.1611234300444;
        Thu, 21 Jan 2021 05:05:00 -0800 (PST)
Received: from [10.2.128.187] (cust97-dsl60.idnet.net. [212.69.60.97])
        by smtp.gmail.com with ESMTPSA id y6sm7936850wrp.6.2021.01.21.05.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 05:04:59 -0800 (PST)
To:     netdev@vger.kernel.org
From:   Mark Pashmfouroush <mpashmfouroush@cloudflare.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        lmb@cloudflare.com
Subject: Observed increased rate of non-linear UDP skb on 5.10 sfc driver
Message-ID: <b418fa92-fa1e-b53c-ce19-8e02b05e68f0@cloudflare.com>
Date:   Thu, 21 Jan 2021 13:04:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

I'm currently conducting an experiment to observe the frequency of
fragmented/non-linear UDP skbs being allocated on the receive path by the sfc
driver. By non-linear I mean that parts of the packet are not contained within
the linear portion of the skb.

I've collected some data on kernel 5.4 with the out-of-tree sfc driver, and now
the mainline sfc driver on kernel 5.10. On kernel 5.4 with the out-of-tree sfc
driver I saw that roughly 10-15% of received UDP skbs were non-linear. On the
in-tree driver I see a significant increase to around 30%. My question is, what
can cause a fragmented/non-linear UDP skb to be allocated by the sfc driver, and
why has this frequency increased since transitioning to the in-tree driver? Is
there a strict size before a UDP packet has an skb with data in the non-linear
buffer? I'm observing this using a tc eBPF program.

While it doesn't seem to cause any issues I'm still curious why there is such a
big difference.

Observed on a Solaflare SFC9120 on multiple different firmware versions with no
difference, currently running version 6.2.7.1001.

Thanks,
Mark


