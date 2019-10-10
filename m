Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F685D1FA3
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbfJJEZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:25:06 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37832 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfJJEZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:25:06 -0400
Received: by mail-pl1-f193.google.com with SMTP id u20so2134714plq.4
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=F2mWN6iONW+mLLRJyrXLX3Mqwxx68njinFB093kEhkw=;
        b=eZn5FosLXe+fiRRmpB6ryaaoYD1tGLkVUMy4O2wDqlMSTpoyb/ivArjB+DV5gr7+Sf
         9zj1ab4evn+7oQJEETVg0tHAr4v+PSKgH/xW2+3kWA8RmvdAnDX+f48hQhhhXZv77+tB
         vRmd4YNclxFP2s+9bLvWEn0wYs1jQzjt/u3IWYqKo5annaJKePlMXFdfGJqwWUSuTgeL
         T40rWhEFQYaXcVdTio+3mcmH7+pc4yq+hiV/jj+gEmfB3N7LVsKMZocFt3kO4ydEC7c2
         YWhGn9507jTzbrpc8qxWa5UXCY8u/Y7U8MjejDrcMISQQ2LjXT8MpR2HtX+tbsGuRXBE
         QKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=F2mWN6iONW+mLLRJyrXLX3Mqwxx68njinFB093kEhkw=;
        b=sfHcrJvJpLkzjA4/U7A2K0Qc7rCGSDsPNK6XjYLL8F0Rxznzs5C6KHMnhKAHNQTim5
         TAg7elE4oZV6rlj8y9oWKeCTAiP4sCXc/LimlFODyxmEdpd3h0i099UVtTGurw7zswBx
         3TAkAbSTs392oXHLdUrxlaq5FZ9NdqwvA5HKz+A/ernV4cuPV9G6oJTMwNgd5IOZW7OK
         foxpaG5hb+aO/JJmnYCgmaiLt0VVfJS5k30bU/dxDMjdBBhYZISZht5i9AhpQnt+G0d4
         7lglKpLr9Dm+wPEt9g+8HwuB55ZzUKPZh+ZcfRioVOondOgAYJhAKgnJT2CnkWgZ21GH
         EZVQ==
X-Gm-Message-State: APjAAAWx0Z1lZ27CisyiOXD7kWJXq+Y/XEHg0HCvlUiJNabj0XOVqg/h
        VD6efXkPSbv7iyhkpHCvRkqvPg==
X-Google-Smtp-Source: APXvYqynM/govpFUXiDmKtrtBuM+YvQonis/gzdNY0zb3g+8xM5GSCV5XpIVAUZNAKVdywvpRG05Eg==
X-Received: by 2002:a17:902:bc4c:: with SMTP id t12mr6816220plz.53.1570681505624;
        Wed, 09 Oct 2019 21:25:05 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id k93sm7601550pjh.3.2019.10.09.21.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:25:05 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:24:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH net] netfilter: conntrack: avoid possible false sharing
Message-ID: <20191009212451.0522979f@cakuba.netronome.com>
In-Reply-To: <20191009161913.18600-1-edumazet@google.com>
References: <20191009161913.18600-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 09:19:13 -0700, Eric Dumazet wrote:
> As hinted by KCSAN, we need at least one READ_ONCE()
> to prevent a compiler optimization.
> 
> More details on :
> https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
> 
> [...]
> 
> Fixes: cc16921351d8 ("netfilter: conntrack: avoid same-timeout update")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>

Applied, thank you. 

Not queuing for stable, please let me know if I should.
