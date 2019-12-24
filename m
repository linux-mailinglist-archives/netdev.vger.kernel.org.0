Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE46012A16E
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 13:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfLXMtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 07:49:06 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:37355 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfLXMtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 07:49:06 -0500
Received: by mail-il1-f193.google.com with SMTP id t8so16531666iln.4
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 04:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+Vj6P90fRubqhoKEZxiE3E77OyLHisnwi189PPakAB0=;
        b=mo9Ln5YmIbFT+vfC2T38yLz9C9DUUJtEKGuCjej8SQ3SDHlIyedFp05ZEqlGbTUD+B
         BTdQsbJzBN5awiKodx89pOv4JyHwNE9acb2coiAENuDys+NUz5rQ7LBPZ+1joXaQpojI
         u6hk2Xtk+FZJ0VPChBRcpKs61fpiUXoT0SLRRNbxTwOShsbG+ONWfMSk+6EaFC+KLsa0
         WDBDCqGOKkFdsEEffxhg838eh7zgb5zkhGvMssC3mc1PXeVuErv8aB+8+2NQgk7G6QnO
         uGyxGLvuKzGn+EKA15lbIibhvp8g/HfesTaWoirXFOpTQ8A8TOWfUJMWnBII+LzcPKRP
         1PxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Vj6P90fRubqhoKEZxiE3E77OyLHisnwi189PPakAB0=;
        b=ZPonexVZeLuKH2+m8J5eDo5arGrYXMmUjMaYHPcJEAvJae9XcAl4FlUy2QlQFW4Qf+
         vg1EIq/nAdmrstEkYeH8YOpK68ZJI+jSLYcoJjj/NdnBF66+s+N8tK1Wn0Uou+XmmN8B
         veHd6WIiu3X8pfBkV5mkbqh1sIxmfhJ3fGl3XMr+TWjswGI9yZOP6uMPjCdlqWXTLvkn
         yxSjrYjBjEsg8vhagDoeVwNTXNvWW8x5MUawQ5NOmA5gUNg92NNIugFetyYxAuUFXrE7
         YdqUoNZHHz2hWMrA7rl0F9UvffX65cXTTNFFGHnlqVCXuGyKTTCWSbtdYMpJRsiRSLe9
         clBw==
X-Gm-Message-State: APjAAAWGwiuACwQNR25eeHCOpIlX7dMFAu+1fv5fVSf+MDtP4XxrJvAj
        61QO55j+tauxOVGSwNwwkRvaWw==
X-Google-Smtp-Source: APXvYqx9j+Gh9bndOQ1AgIzNivprADngGcXr84GvfALIXIaEAMRzDs8N/aowSeIEQjEOdjcj3Ks9jQ==
X-Received: by 2002:a92:88d0:: with SMTP id m77mr31485141ilh.9.1577191745392;
        Tue, 24 Dec 2019 04:49:05 -0800 (PST)
Received: from [192.168.0.101] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id 75sm10057274ila.61.2019.12.24.04.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 04:49:04 -0800 (PST)
Subject: Re: [PATCH net 0/2] net/sched: avoid walk() while deleting filters
 that still use rtnl_lock
To:     Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@mellanox.com>
References: <cover.1577179314.git.dcaratti@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7579353e-4e8c-062b-0db2-9d04774b8bf3@mojatatu.com>
Date:   Tue, 24 Dec 2019 07:49:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <cover.1577179314.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Davide,
Thanks for the effort. Looks good to me - will wait for you to
address Vlad's comments then run a couple of tests...

cheers,
jamal

On 2019-12-24 4:30 a.m., Davide Caratti wrote:
> we don't need to use walk() on deletion of TC filters, at least for those
> implementations that don't have TCF_PROTO_OPS_DOIT_UNLOCKED.
> 
> - patch 1/2 restores walk() semantic in cls_u32, that was recently
>    changed to fix semi-configured filters in the error path of u32_change().
> - patch 2/2 moves the delete_empty() logic to cls_flower, the only filter
>    that currently needs to guard against concurrent insert/delete.
>    For flower, the current delete_empty() still [ab,]uses walk(), to
>    preserve the bugfixes introduced by [1] and [2]: a follow-up commit
>    in the future can implement a proper delete_empty() that avoids calls
>    to fl_walk().
> 
> (tested with tdc "concurrency", "matchall", "basic" and "u32")
> 
> [1] 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp is empty")
> [2] 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
> 
> Davide Caratti (2):
>    Revert "net/sched: cls_u32: fix refcount leak in the error path of
>      u32_change()"
>    net/sched: add delete_empty() to filters and use it in cls_flower
> 
>   include/net/sch_generic.h |  2 ++
>   net/sched/cls_api.c       | 29 ++++-------------------------
>   net/sched/cls_flower.c    | 23 +++++++++++++++++++++++
>   net/sched/cls_u32.c       | 25 -------------------------
>   4 files changed, 29 insertions(+), 50 deletions(-)
> 

