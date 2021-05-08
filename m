Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C9D3773A3
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhEHSdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhEHSdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 14:33:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37086C061574;
        Sat,  8 May 2021 11:32:12 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so6591511wmb.3;
        Sat, 08 May 2021 11:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gqc1OTa3jTNr84LwnR1jjanBc77WFyrSL7toBAzIDi8=;
        b=r7V8AZznhiaJIoAbsfTEKDBwLXkCJ+gEdQC7lFhrNsW6Lf/Fo+kIuzDh49xZ95QU9v
         jjgpmAT3DZdcXTEuLl/aIiFsIyQMuv5j2HTf/S0Za/gQliyq/COXFqTqePqXX0RrRq4B
         I4zqLNEKP5RWPQiSlFXpRWlECezYSeRWwEAORKliBgwid+sufgUY0oeaxplG1pZtBSOF
         9ENoTHxUZPrdJGbSy6EGQlhFEK+SHYq/PVh7lCWnwmqDx41GqA25xkeYar75X3yqRIgA
         caFdvcGUDcx542gDXBdSRKLiEUz0+Vs7xYQbobUMZXqk+bMNcQH7vL9DdAMVbyolqy9m
         xdhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gqc1OTa3jTNr84LwnR1jjanBc77WFyrSL7toBAzIDi8=;
        b=nE0YfG8f5wbNGOuYDUs7E0BkeQ145WueLfFB+PEBoy4zkhBJFTVpx/5k6sjoUS1gqK
         GKUvhmB74PZC/Juku8x9BfdEsQy8VGj8lj0b5mbf/nOvaEckcQFIdj9sUcHGfumJWoNI
         ELPhDSpHlYQJc2+aQOreqWHmANPlnmnQXLICiedk4zqZvmAjKLOwXzaf5GHmB0UIMu8O
         Zp7dQTJ4xS2wTVVaEekVGE+81GDBHwqB67rvomBKzIdWxQAoFrP+tD5j0+b+co5MHvwg
         OxDkrk9mtTiCGUBEsSjEgcuymsUq7SpuBqFBjBt0+fviHVaH5LqNnBd5aSeabkBBw0A3
         cCUg==
X-Gm-Message-State: AOAM530nT82WmMEPqRlU7IivUnJdbt34WPQLbT4DJ7xgKZRIxIXzVPMT
        2joC+0x/SyUFfUf1IQcB97P/nVq38rs=
X-Google-Smtp-Source: ABdhPJzOFpOzmzMIpcc6HNw3yMiN6UXVQTbWdmlsKmMBKqPQSTAA8mkr9pyZJJjk8vBtxHjDplbg7g==
X-Received: by 2002:a05:600c:47d7:: with SMTP id l23mr27924579wmo.95.1620498730765;
        Sat, 08 May 2021 11:32:10 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id s10sm14153516wru.55.2021.05.08.11.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 11:32:10 -0700 (PDT)
Date:   Sat, 8 May 2021 21:32:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix a crash if ->get_sset_count() fails
Message-ID: <20210508183208.fhsjngggjdel6ma6@skbuf>
References: <YJaSe3RPgn7gKxZv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJaSe3RPgn7gKxZv@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 04:30:35PM +0300, Dan Carpenter wrote:
> If ds->ops->get_sset_count() fails then it "count" is a negative error
> code such as -EOPNOTSUPP.  Because "i" is an unsigned int, the negative
> error code is type promoted to a very high value and the loop will
> corrupt memory until the system crashes.
> 
> Fix this by checking for error codes and changing the type of "i" to
> just int.
> 
> Fixes: badf3ada60ab ("net: dsa: Provide CPU port statistics to master netdev")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
