Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BC62B81D2
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgKRQZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKRQZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:25:49 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F1AC0613D6;
        Wed, 18 Nov 2020 08:25:49 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id k2so2835342wrx.2;
        Wed, 18 Nov 2020 08:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9SPOvw1GA45s+4i25r54IMZypxBmzYWD9fOSN2hI59Y=;
        b=qLJc/Gh32BatIpe/UVHKMJ9KLUX0tMNdjB22XW6OJv7ftss4z0ZFE6FzwqGkUYqQw8
         Z1DQ16aLvXLItpj9fB2djiYl9xu+CBlBfReg8aHrY8SoFrW1OPoTY0IregofrrwdDOSQ
         zrz6YSiT6m9oyrMkIOpVhl8dNl4YKVloIGuXCSdEam+qCqIInYDeviQDmrlvsCMOXhOZ
         fVjORAuSJLHIkX7wiJcEYG1zGr8qdmSBbJ5Pp2hU2gU+FyM4TitKRp6usWBqeIF5jvMN
         pfRfuOfOVkpG/d94ddWemZQoH5G+vX5Bs1hLoH2TnNq0YqAFW5WFWggaZ8+W248U2bCb
         6rYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9SPOvw1GA45s+4i25r54IMZypxBmzYWD9fOSN2hI59Y=;
        b=R5jdkfpsT43NjqsxW1LP1fLBC5tgINPTiby9DWC/+eD24rHmpIC3oj6ErhgRbBW7AC
         8+LA9XkbQnsNZJLpfM2JSd5k2JsB7wGajORWn8AQn2YECvhZoYElV/Oeeg6OwEBfb/3d
         sLzmlA/wzXU70oth1gKBvuWYYQSqikyKZppOPChgKugbOOBi8xEUfi8hapko6ked5b+4
         J3zibFJdRQwcrabIqVwHmwH8tX5/qM3ZkRTtyly/oRn8e2KgtGboakxCJgQAS87Mh7Gk
         j0GC59dHkCGV8YjZh0+tcYgEldIcuZGBtkMlGkMLmVAR6NPdlnAbXvZdXAAGUBvi94Ve
         dLvg==
X-Gm-Message-State: AOAM530UcN7YK7ru5U3Z7RF5y2a5OIcTHvZOyTvTicEZo51AFfchwivI
        oUfvyOgrzjCKjUdMShFIaT2usBTuFMU=
X-Google-Smtp-Source: ABdhPJwiMM3V+1uMByMpiTHz9/lOhFkCCfuSXnCRoHAsYeA2Z57iPQANceag6h2TNBbcdDf+nDdlrQ==
X-Received: by 2002:a5d:4e46:: with SMTP id r6mr5524551wrt.218.1605716747928;
        Wed, 18 Nov 2020 08:25:47 -0800 (PST)
Received: from [192.168.8.114] ([37.167.88.152])
        by smtp.gmail.com with ESMTPSA id c17sm4565093wml.14.2020.11.18.08.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 08:25:47 -0800 (PST)
Subject: Re: [RFC PATCH bpf-next 0/8] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5feaafd3-72ca-72da-0fe8-cc4206bc29e6@gmail.com>
Date:   Wed, 18 Nov 2020 17:25:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201117094023.3685-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/20 10:40 AM, Kuniyuki Iwashima wrote:
> The SO_REUSEPORT option allows sockets to listen on the same port and to
> accept connections evenly. However, there is a defect in the current
> implementation. When a SYN packet is received, the connection is tied to a
> listening socket. Accordingly, when the listener is closed, in-flight
> requests during the three-way handshake and child sockets in the accept
> queue are dropped even if other listeners could accept such connections.
> 
> This situation can happen when various server management tools restart
> server (such as nginx) processes. For instance, when we change nginx
> configurations and restart it, it spins up new workers that respect the new
> configuration and closes all listeners on the old workers, resulting in
> in-flight ACK of 3WHS is responded by RST.
> 

I know some programs are simply removing a listener from the group,
so that they no longer handle new SYN packets,
and wait until all timers or 3WHS have completed before closing them.

They pass fd of newly accepted children to more recent programs using af_unix fd passing,
while in this draining mode.

Quite frankly, mixing eBPF in the picture is distracting.

It seems you want some way to transfer request sockets (and/or not yet accepted established ones)
from fd1 to fd2, isn't it something that should be discussed independently ?

