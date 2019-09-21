Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82CF1B9BF9
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 04:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437635AbfIUCPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 22:15:21 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39749 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405181AbfIUCPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 22:15:21 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so10885667qtb.6
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 19:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kyUwyF8pRhJk36eptN8qzG8E9xqBAPETyrMXQXtomu0=;
        b=XTTeNjhWF2EBuize0Uz3Dn8+8lk36gojXal3li9YiFNfvki61jxTyPezZ4LKUDbWpQ
         Az8KFK8Y6a4OSEogxh3uqrkto5JgCSJpStS2Dy4GSsus6VxCZO3E+lfDTkJv2Oqjxxfv
         rMcUMjO890I0D6IVr+eQY5qRs4gcn0+5vrz3KvY/qctIcTBs76OsoxWjwCLHyrp1GqHl
         kAJYKMhZObKr2er2x8tu6MiixGvbOUGjtV+9/9RVY4pJRPLKDY4NWGW4s+a5AYcGCYna
         Xvji/Qk1jS9Gaoyv76Mibys72ItMVlfEqcOwkvzXDJQSHhGIsaF2kELa3EzcF2pmNQxV
         ls5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kyUwyF8pRhJk36eptN8qzG8E9xqBAPETyrMXQXtomu0=;
        b=YNoiwK/F5x953BrH/fNcNA1wZJeFL7LXc+VBq6tBnKrxNhPVtqIYxXLonRHdEnPyrc
         50+xEbHdW6rJdILBFPZoeA41Sjdmiqnw2TCaHGIuAA8ZW2isxp08L0NmzPpkD+xlI2eF
         GTLogx10blTNJLREtUVLEGD37Agc4TtrB+Tg8k3eZaHppWpaUwA/qTm179nkkZu3+a+5
         H6a5CDz5Pi190rSPpRVCsVBKA+RnUzZE4ul/4AQqja0v48gOEHKWQ50mtRWjrzOau5/E
         nN1JH417+KMOF8L2gj410oYgjP/cearHshVT7E3TAFZIhvLmI0SUEkHd2+qPt/hwlI/5
         rruQ==
X-Gm-Message-State: APjAAAWlLai+02iTYujsUwv83hNOVFpQhldhL3ykzIDMvEE1qQniGrWs
        kuvu1wr/Y/H+7qw1CDvCEB3u+O2e8lQ=
X-Google-Smtp-Source: APXvYqxO9/mwpfxV3QbzcpaoejqsVjo8KoPoc/tXWN8FrESSPXRiYUQZoK3XYBojMxkgv5xhYQ870g==
X-Received: by 2002:ac8:3059:: with SMTP id g25mr6612147qte.154.1569032120129;
        Fri, 20 Sep 2019 19:15:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e6sm1725200qtr.25.2019.09.20.19.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 19:15:20 -0700 (PDT)
Date:   Fri, 20 Sep 2019 19:15:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] sch_netem: fix a divide by zero in tabledist()
Message-ID: <20190920191516.073d88b6@cakuba.netronome.com>
In-Reply-To: <20190918150539.135042-1-edumazet@google.com>
References: <20190918150539.135042-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 08:05:39 -0700, Eric Dumazet wrote:
> syzbot managed to crash the kernel in tabledist() loading
> an empty distribution table.
> 
> 	t = dist->table[rnd % dist->size];
> 
> Simply return an error when such load is attempted.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, queued, thank you!
