Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456F82A5FDC
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 09:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgKDIug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 03:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgKDIug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 03:50:36 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44360C0613D3;
        Wed,  4 Nov 2020 00:50:34 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id p1so1975778wrf.12;
        Wed, 04 Nov 2020 00:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rb5+9Uu5Pextlzz28MhD13qyqn/S8yH6ObfjNiHXu9M=;
        b=OsMZKWk6API99ut4fdwjboNr+6mH122uBWsHSEeLEzBJ2/JHKBZMheoHwcEmiaCJ+a
         6zgXIKL5hWM/tTnynAFcCrYAShQ/EV11D+LvWEGbBCKmiTx1zMRI1eIfyBEtnztem5MZ
         KeZ1qR3O4HRdg7PPkdSMUuxhlCukI711ZtwwGEnvOSyawakesItvR57naIzLJ7IWSSZQ
         7rUQ3l61niHRazUr0u93egm8VpkEtNsvTRmos4TzPDIFWr2OQxXSUOThBqUoBNV3qVmH
         M33dtj14JicyN31dudzygBMkchcX2rGnt3KVma9k5e6G4EN89c04Xi3SxWLi2Mh+3Lh5
         I05A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rb5+9Uu5Pextlzz28MhD13qyqn/S8yH6ObfjNiHXu9M=;
        b=cdKu5MT273Ud3SBTt+532OphaQNdQ9Fe5+rgQZinZieHran+5bBS9eKwEZBE9V8Ja1
         sulrssdcYSA9n+S89z45jpSXmttB8TGzaH3L0sxIg2zoSbLngrXTk/VzUeuU1vtYTuud
         4lrYL7sluAlpzU6L9bozYHmGmyBRQHL5nEC/oLQp51WyuEzV/tZKRHZjVuAhkyUyTH9E
         zilftptPLTzc555PNqRkT4lSZmMVb8yzQ/ECxmWefhY4buwPtysJuzrFYKuxpjf+ys5O
         HCH1LQp/v7+XwN6Uwl36DSQetUFgz4jGIkb5zzpifRrngFx2x/AN1pyvO6zbsxldTGQ/
         8gIw==
X-Gm-Message-State: AOAM533dV3unCW0CfPujazcn5X/yZiuzmt6aQkqW0O0l3DU/eKkPwOg4
        Cwku99RQnUFkxdBot6pw7Yw=
X-Google-Smtp-Source: ABdhPJwIaJwaDd5dlm6XkBJ424PxxvIm7rtGoOuLm192Wv1qUSuLJ3vrfQjzeQLqxYUXNvHGOAC9FA==
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr29596142wrn.427.1604479833095;
        Wed, 04 Nov 2020 00:50:33 -0800 (PST)
Received: from [192.168.212.98] (104.160.185.81.rev.sfr.net. [81.185.160.104])
        by smtp.gmail.com with ESMTPSA id k18sm1608302wrx.96.2020.11.04.00.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 00:50:32 -0800 (PST)
Subject: Re: [PATCH 1/1] mm: avoid re-using pfmemalloc page in
 page_frag_alloc()
To:     Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        venkat.x.venkatsubra@oracle.com, manjunath.b.patil@oracle.com,
        joe.jin@oracle.com, srinivas.eeda@oracle.com
References: <20201103193239.1807-1-dongli.zhang@oracle.com>
 <20201103203500.GG27442@casper.infradead.org>
 <7141038d-af06-70b2-9f50-bf9fdf252e22@oracle.com>
 <20201103211541.GH27442@casper.infradead.org>
 <20201104011640.GE2445@rnichana-ThinkPad-T480>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2bce996a-0a62-9d14-4310-a4c5cb1ddeae@gmail.com>
Date:   Wed, 4 Nov 2020 09:50:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201104011640.GE2445@rnichana-ThinkPad-T480>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/20 2:16 AM, Rama Nichanamatlu wrote:
>> Thanks for providing the numbers.  Do you think that dropping (up to)
>> 7 packets is acceptable?
> 
> net.ipv4.tcp_syn_retries = 6
> 
> tcp clients wouldn't even get that far leading to connect establish issues.

This does not really matter. If host was under memory pressure,
dropping a few packets is really not an issue.

Please do not add expensive checks in fast path, just to "not drop a packet"
even if the world is collapsing.

Also consider that NIC typically have thousands of pre-allocated page/frags
for their RX ring buffers, they might all have pfmemalloc set, so we are speaking
of thousands of packet drops before the RX-ring can be refilled with normal (non pfmemalloc) page/frags.

If we want to solve this issue more generically, we would have to try
to copy data into a non pfmemalloc frag instead of dropping skb that
had frags allocated minutes ago under memory pressure.

This copy could happen in core networking stack, but this seems adding
more pressure to mm layer under pressure.

