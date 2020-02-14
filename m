Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C693015FA46
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgBNXVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:21:22 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37807 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbgBNXVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:21:22 -0500
Received: by mail-pl1-f194.google.com with SMTP id c23so4275322plz.4
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 15:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZsLaZgqvs23GU4BSnehdWbbYJMF5R0Qy/9x8Xj5bn6s=;
        b=JPI7sKzFHaxt/NJEY6HulU02hXYqbqvGomRKpO+zgL710yd/1A8dB6GKnL052LiN8k
         xTrBRKuzQFu3I8j1tSxtOo2uhapU+dySkVaB2Y9myMNDxSIdF49QHIhxjqkXY+kn85aC
         dwdVH1zrCPpe0WGsQfl6jdACqi4NbHwLpyArVeInQ5/lTu2DU4+CmKRu7hEoLWMjiNiM
         hBnb5OzSTcLrqljOwGAPyvEJWiaBrUvdewwPJB/awZVWlbX689evZt8cdawUF6Hbio0D
         sScqL0N8c0gBh4gjyLpcY/tujtERshIVXoBJsqBC/gndzerV5vVrU95lnYkxnE/5dg7R
         ox0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZsLaZgqvs23GU4BSnehdWbbYJMF5R0Qy/9x8Xj5bn6s=;
        b=iqhlJEC/Jh8c0ia3y9fdFw6RcNesyPkzilg1Plk3V1O0Irgpfx1LdcfJxB9lsolXZQ
         r549ZgqPCkr3ymgHEz2GKfV/op99qpPc3MHsQhqg1idzUNqwaG4FsIRkmFu/wO1UxbJJ
         J+uB2+teoz2ub0mDIHH9MIca4SLxIcIKYmndtuHYq9tOqzmsxY9FgOp9LN6DRicYT9ch
         AdYIrL3nNVZttLP5O7V5lR6FK6GqbIboNqac4o015YugJ5Ahnjvt0c9S+obroxnA20Ba
         QGweWyQmo96FqR/NUO4WMU3ah7+N21wqK5KF4hZaxAQJHvsZZthdPG5J63u+mkNMnzd+
         b06g==
X-Gm-Message-State: APjAAAX/6F2admzZTh/EjkzpW5Pv1Jk5H+YluEfmT3eGPaHtYfvd5udN
        XWyJa3EtxVZd/AcY5xvRObQ=
X-Google-Smtp-Source: APXvYqw7q5QRmMd0SxzRMIxvGNlCwGsgB/fZOZUNFpLLJ8RDzQZtQgeFEtAAM1o7O0DMS28g1dMs/g==
X-Received: by 2002:a17:902:7591:: with SMTP id j17mr5486399pll.163.1581722480333;
        Fri, 14 Feb 2020 15:21:20 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id r198sm8574738pfr.54.2020.02.14.15.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 15:21:19 -0800 (PST)
Subject: Re: [PATCH v3 net 3/4] wireguard: send: account for mtu=0 devices
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>
References: <20200214225723.63646-1-Jason@zx2c4.com>
 <20200214225723.63646-4-Jason@zx2c4.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <93b32ed6-4660-47ad-922f-b3b618ece8ea@gmail.com>
Date:   Fri, 14 Feb 2020 15:21:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214225723.63646-4-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/20 2:57 PM, Jason A. Donenfeld wrote:
> It turns out there's an easy way to get packets queued up while still
> having an MTU of zero, and that's via persistent keep alive. This commit
> makes sure that in whatever condition, we don't wind up dividing by
> zero. Note that an MTU of zero for a wireguard interface is something
> quasi-valid, so I don't think the correct fix is to limit it via
> min_mtu. This can be reproduced easily with:
> 
> ip link add wg0 type wireguard
> ip link add wg1 type wireguard
> ip link set wg0 up mtu 0
> ip link set wg1 up
> wg set wg0 private-key <(wg genkey)
> wg set wg1 listen-port 1 private-key <(wg genkey) peer $(wg show wg0 public-key)
> wg set wg0 peer $(wg show wg1 public-key) persistent-keepalive 1 endpoint 127.0.0.1:1
> 
> However, while min_mtu=0 seems fine, it makes sense to restrict the
> max_mtu. This commit also restricts the maximum MTU to the greatest
> number for which rounding up to the padding multiple won't overflow a
> signed integer. Packets this large were always rejected anyway
> eventually, due to checks deeper in, but it seems more sound not to even
> let the administrator configure something that won't work anyway.
> 
> We use this opportunity to clean up this function a bit so that it's
> clear which paths we're expecting.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

