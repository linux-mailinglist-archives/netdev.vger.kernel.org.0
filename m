Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60C7353034
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 22:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhDBUWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 16:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhDBUWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 16:22:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CB0C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 13:22:04 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso3036144pjh.2
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 13:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nVqsmwMPkzC42KyAwGO+gYq2EHIzl8y3FoVHaXaAwNk=;
        b=BrHqgOxPo6gajZsdlCYqhbMzWVYMvrTeYOajQBC7c/3zhi3McG7SQnR4Tv1Oad8gjm
         I9HJzz7OdQMRD9XQz34iMgdGrKyF8WZZPB0GApnBxw5erTVcohwvZcFT28gwSj3WY8fY
         LBeGtd+E1FlY9XO6+91Q2dGExO2FKzTMQf+Qq6vaiVQVzL/zwk0/qZSt9tMKMoUHo2+C
         ORKL3azvlm3leTpyi2+BKTEWfelui1nr+Cm+uelRjimoh0iRPtRPPKOujudlfDxFl8Bk
         /oM8DvKO1OU2GieDIgG/JI4NWEcqOMbDAMDsnmngH+dtyA95xfwpVp5OSqAXwtCVwG5C
         z3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nVqsmwMPkzC42KyAwGO+gYq2EHIzl8y3FoVHaXaAwNk=;
        b=C76PKb5EvZtyoMQDuvxfNLY3ijVYIFV47/SF/kg8s18MtKVbvPsOcchem3QkncyxdN
         HOQB4t+e8we6VyiU9ufUN6AT/5LfK4rMzj2n1+9LmRu6T0JFxF4bOqbupaofnkl2S5S7
         Cw0lbB0UIWaz0iYWaqLlZ0LSs5RxPe/KQuIxphfQk7qnnSoaEtLhDVRAuT7jEtIqWNrd
         fhGFXKBnaAbTkc5fbjSUfzTyDp2QnOpZkO63MmumKpIZ36F0sdhcz2Oak9fOjCKY03oS
         TWx4HgAn8TSJF0ivu/hlck1uspcKSKoLTsXo7j/xql/6Nu4GIrTOM8BG1rgQzoU85ZSj
         tOUw==
X-Gm-Message-State: AOAM531l+rS/HW/a/xIY6IrTKae4eonc0bPyLJW2i5cJRouJ6yWAYWxP
        OWNVaIVe/vPZws3X/IJylgzGzw==
X-Google-Smtp-Source: ABdhPJwzCIM6OZHQNyn4Qm+ZQvJbXm43WxQCfld3OizqI4Hu3mEZVBeA9TCz556q3Q5qBwNN0Vwj6A==
X-Received: by 2002:a17:90a:a403:: with SMTP id y3mr15316933pjp.227.1617394924285;
        Fri, 02 Apr 2021 13:22:04 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id j21sm8048377pfc.114.2021.04.02.13.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 13:22:03 -0700 (PDT)
Date:   Fri, 2 Apr 2021 13:21:55 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] tcp: reorder tcp_congestion_ops for better
 cache locality
Message-ID: <20210402132155.5cb367e4@hermes.local>
In-Reply-To: <20210402181037.19736-1-eric.dumazet@gmail.com>
References: <20210402181037.19736-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Apr 2021 11:10:37 -0700
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> From: Eric Dumazet <edumazet@google.com>
> 
> Group all the often used fields in the first cache line,
> to reduce cache line misses.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Makes sense.
Acked-by: Stephen Hemminger <stephen@networkplumber.org>

