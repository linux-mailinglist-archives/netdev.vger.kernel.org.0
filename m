Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489FD77E7A
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 09:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfG1HqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 03:46:23 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39036 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfG1HqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 03:46:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id u25so40480821wmc.4
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 00:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2/G7IaZ8tiYQkvUjO2OGRQfRiaaHFpZ/Ktl9QzMcAM4=;
        b=Q5h14Lfr1vWRYHjX5e6phEJRFTeh+7dNc+QdnUBBekSIV3CtR0lIVJ3fd6BRZsIQj3
         Hh9/qDIlUUekUyF/zlcHYhwJWJ7c6YHQ1hmMWt7IDtGEyyNNpE/Gu0BRooM3DNGaKkAF
         GQmpZJCrBdT9B8U2g4jYormH1HLmxS58DSCyP4CaFtjxPWSHPwOOulmHdzO+2vOA8qwR
         A0xhEMeBiyXi1+FHnhqJ2Ox0ZGseYzK6n9gL1eEqE+I7VHdoI/XvjCcwItsawXAwnSeW
         kxhoz3SVHnlqAS365oB3V4fplD91va1O5hEAdCc6y3mK8ZSdxVoLHQdwCufe8lhY1ZvN
         fPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2/G7IaZ8tiYQkvUjO2OGRQfRiaaHFpZ/Ktl9QzMcAM4=;
        b=pXd/aCWpyVQa1FsjyQeEBqpmZYdZRoyfuIECCLvGZ7kE7lmmRODL+XFrd/oT9rTwoV
         GNgIYbhVKpt57LD/755f/PRzLyLSYehVL/lD565/qf3Cy/mAXVd2kbXerugSTA2I56gn
         obgJUWllg3Sye8Jl7+HxEdrY8pbnEeC690bUJWwrRAnIkeXl8WDN4O13EcOL7oqTOu9H
         nFAGSa0ix0+j3tsseDFKyb2GuyGCeakhXPjih5qtc7oxSXMHmSn28l6UQgLwJ6/9byXo
         2WwwLucixIYlpng240rAu1oTss0vhB4crdjY05pn2ARP2s7kzZtCZzpFvtkkAKI6F1ei
         zz2w==
X-Gm-Message-State: APjAAAVlP6B7UuzvWN/ThdTh4xySuqWH7VCVY6zHib8V7U7Jq2TyMtcB
        2yJ1CpketoeHGLQ3yejQD2k=
X-Google-Smtp-Source: APXvYqyg9ads4NJultwbj5Ts8UfWbNW/kHbokiWQB83owxZnaZwiVsGhlK22m19FExLQ6sHi8BCEBA==
X-Received: by 2002:a1c:ddc1:: with SMTP id u184mr91017388wmg.158.1564299980967;
        Sun, 28 Jul 2019 00:46:20 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f1sm39579827wml.28.2019.07.28.00.46.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 00:46:20 -0700 (PDT)
Date:   Sun, 28 Jul 2019 09:46:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Colin King <colin.king@canonical.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rocker: fix memory leaks of fib_work on two error return
 paths
Message-ID: <20190728074619.GA2423@nanopsycho.orion>
References: <20190727233726.3121-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190727233726.3121-1-colin.king@canonical.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 28, 2019 at 01:37:26AM CEST, colin.king@canonical.com wrote:
>From: Colin Ian King <colin.king@canonical.com>
>
>Currently there are two error return paths that leak memory allocated
>to fib_work. Fix this by kfree'ing fib_work before returning.
>
>Addresses-Coverity: ("Resource leak")
>Fixes: 19a9d136f198 ("ipv4: Flag fib_info with a fib_nh using IPv6 gateway")
>Fixes: dbcc4fa718ee ("rocker: Fail attempts to use routes with nexthop objects")
>Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
