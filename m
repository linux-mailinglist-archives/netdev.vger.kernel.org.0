Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA55D1FAD
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfJJEcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:32:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35691 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJJEcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:32:24 -0400
Received: by mail-pl1-f193.google.com with SMTP id c3so2149032plo.2
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FfyfyhhrxNQpmlLeDJUqAmuGWBMXq0FoF/j7heYS/FY=;
        b=mXFhCCP6e88CNASIwkycE6kEZA74uk68zunh1DoeHi6uIpE4QPzq41wSomiEWMVC9J
         36mqh9eSjoYDWDtOMs3H2MYjRqh61rs9yX5WBZm6Og5kt0DgaRpFKXtjdqKJ5Rn2t0Vm
         2kgZE+XW4rUm/pJm/MctscAJ8xmf5JOvroXqZKbbyZm+NgIkJskHaJEN03x1QmtAbcA+
         GcA5CLjRIk237JcVBphc9ItTHWj8k1wL5h0QlH5WsSVAbig3mG1pIZfkDk1O0UVgdX+D
         pP/Le78wcvdkzxuoXPTezCo8f77XihXQOSlv0yWEB0OnS4BeKyiBFsGmKuMAtJqy0jNU
         x6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FfyfyhhrxNQpmlLeDJUqAmuGWBMXq0FoF/j7heYS/FY=;
        b=VCXKOBNxbyN9MoocAbITNH6qZaNcAJ/rc8JtPj9CKXyrbJrHUr4XaZhJDdQWBbS5y6
         li4dOmj8sfnUMceqHf2M6DAbf+e0qmsyz+9LIKYy9tnH6YWrvGsEpg9vkPvsKDG0qDDG
         2SdQv7ZsyHHe/f2vZq7J8tkc8+rr+zE5CCFQj5RwXr5vusBgpc/WUh6f1ss5WWV7u/oJ
         pMwRqRHvLUMhEQRX+W24UE1oQPjTtt6gzJWJd8w3cmyQ2O2a60EA4IER5+UtAWVfHuL3
         3GTTZy0SL8rkzlgPAYneKtb2mARJIbcxcSuFoDli5Loc5T0Zhx0hIextHtYqJ5kSLhN0
         f4jg==
X-Gm-Message-State: APjAAAUvU11zejbsTcoeFKCWoX0VT9zdByg+vYbJbkXK+4NY+9ndqIE2
        vj+ZUjF+b9udSRuCgjeigpNOlA==
X-Google-Smtp-Source: APXvYqyehcd9rpgwEMXh1xexse6xkjADgbM+7IxBoZWU66P3aiksY5532Ydq+/bAZUyC0EOPmz9eKQ==
X-Received: by 2002:a17:902:a987:: with SMTP id bh7mr6911757plb.181.1570681943217;
        Wed, 09 Oct 2019 21:32:23 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id k15sm4016542pfa.65.2019.10.09.21.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:32:22 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:32:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net] net: avoid possible false sharing in
 sk_leave_memory_pressure()
Message-ID: <20191009213209.6c07bf0c@cakuba.netronome.com>
In-Reply-To: <20191009195553.154443-1-edumazet@google.com>
References: <20191009195553.154443-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 12:55:53 -0700, Eric Dumazet wrote:
> As mentioned in https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
> a C compiler can legally transform :
> 
> if (memory_pressure && *memory_pressure)
>         *memory_pressure = 0;
> 
> to :
> 
> if (memory_pressure)
>         *memory_pressure = 0;
> 
> Fixes: 0604475119de ("tcp: add TCPMemoryPressuresChrono counter")
> Fixes: 180d8cd942ce ("foundations of per-cgroup memory pressure controlling.")
> Fixes: 3ab224be6d69 ("[NET] CORE: Introducing new memory accounting interface.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
