Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADD811F06F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 06:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfLNFp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 00:45:27 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34372 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfLNFp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 00:45:26 -0500
Received: by mail-pg1-f196.google.com with SMTP id r11so572863pgf.1
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 21:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/6yM6mz0cKHxsNjuJZjpRkGJnNfe09Jvx6IRE/+uomA=;
        b=0AOoZeSM55J87VI7EX7QlxOIruywusFbFFD3KWbiT+Md/0rIBJB2uAGoizxgtwNUhd
         ugDDmV6OfMkfaAft5R8arRhHCgIMVQJdKFaI1Wgi2uEuW57ynNPEM9p4blNs69Pei58P
         CEeyZ+kTLQnc/qSFDJpEVT+2WTFLOENeSFryQjFxOeryJqUgTKv5S/X97DfOawKtl9Jb
         Qgx8BR1Ndy/GCBi7TCZjaHB+R4U2sxtL3o65wpuXG5NVbtjSrqYrS9UsDIULhF44xU12
         ac84RB0adgo7w/H94Xc3g3drBwIGOdiJm0Lz1lMGDv+g6seLgl5sj0PWvzsbbKNPS8aQ
         6Xuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/6yM6mz0cKHxsNjuJZjpRkGJnNfe09Jvx6IRE/+uomA=;
        b=fEI7n3iIj3Z8RnWdo8LzqzXkaymflu3x0bZRQyI/dcQlEGpiBdfcvOb/kiH1Tldg/d
         XXgowzTTEhMXsjjVG4Zd3qLcVvzejwOyjvVZe+73FX3uFewYMZk4gsonjFj7WDMlB1Uf
         GIvZhdy46ER+nT5GrflD6E5ElfBi1zHBlWsVFoiT851aFFsb3bkIdzeDYO25koeF8CY6
         +OCwaL0knEC7n3pIeP1Dk8/f/ZW3FDwdbFFlvJnOA7qzHdfZuZO3p+6wupLZx7NrUJWL
         8Nq4a3zTi7sLl9liqPki61KcVfi77hG/Ti4DRwZz/LVgUuzoLyJBEaaAyAB2z2ggAS8A
         Hazw==
X-Gm-Message-State: APjAAAUIUkR9/WkPCeVxI10rjvXWM5jPeVp6Tt2va7TshLnfga2AtI+5
        yOZIggLz3LORYJt4eqLqsmnwtg==
X-Google-Smtp-Source: APXvYqw66xpd+tfGTncUaGZh0fAMPqvE1vf6m4K6jAv1pXJ7d8wgXURBW3guNODgGXdc5rIfE5Ww0w==
X-Received: by 2002:a62:cd83:: with SMTP id o125mr3681968pfg.248.1576302326074;
        Fri, 13 Dec 2019 21:45:26 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id t5sm11475407pje.6.2019.12.13.21.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 21:45:25 -0800 (PST)
Date:   Fri, 13 Dec 2019 21:45:22 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Firo Yang <firo.yang@suse.com>
Subject: Re: [PATCH net v2] tcp/dccp: fix possible race
 __inet_lookup_established()
Message-ID: <20191213214522.6b48065a@cakuba.netronome.com>
In-Reply-To: <20191214022041.75340-1-edumazet@google.com>
References: <20191214022041.75340-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 18:20:41 -0800, Eric Dumazet wrote:
> Michal Kubecek and Firo Yang did a very nice analysis of crashes
> happening in __inet_lookup_established().
> 
> Since a TCP socket can go from TCP_ESTABLISH to TCP_LISTEN
> (via a close()/socket()/listen() cycle) without a RCU grace period,
> I should not have changed listeners linkage in their hash table.
> 
> They must use the nulls protocol (Documentation/RCU/rculist_nulls.txt),
> so that a lookup can detect a socket in a hash list was moved in
> another one.
> 
> Since we added code in commit d296ba60d8e2 ("soreuseport: Resolve
> merge conflict for v4/v6 ordering fix"), we have to add
> hlist_nulls_add_tail_rcu() helper.
> 
> Fixes: 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt under synflood")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> Reported-by: Firo Yang <firo.yang@suse.com>
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> Link: https://lore.kernel.org/netdev/20191120083919.GH27852@unicorn.suse.cz/

Applied, and queued for stable, thank you!
