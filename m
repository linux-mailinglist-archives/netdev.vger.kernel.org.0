Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA7A18027F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCJPyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:54:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32864 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgCJPyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:54:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id n7so6679576pfn.0;
        Tue, 10 Mar 2020 08:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hyrZhGrQSEDWXCf6l1K0WVVemgS8j81vIr9KuEMeNkw=;
        b=Fnr9nH/1FiSHsgd5I4mASsBjBOAmLtnO9KW8gGJGjtqZ0Ies0iCUFa54FNxkQwMVH8
         9vozAHc88+mmTFfl0t8MJbh6NYELuNIstZCIwR9xp2lvT0U4DIVD5U27Y45Zt/3JjwLp
         i/18FPdI/yaUtIiZixGoY4EEBOXox38OvshHlJjNP4TwhQ9IIG0YaTz1gix2tUH36g1P
         xWot2m6eSJJfsRB6nnLF9GibDnWJba71embpqUTI+7dT02Sn8uD3GrKVmiJPgqcVFssa
         veqYq0kbeFu/nR8R5BxDg/vflmaADT6Bu4YfAKLhdKQ2e4nuvhxraukxO+555BkJCzpB
         MpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hyrZhGrQSEDWXCf6l1K0WVVemgS8j81vIr9KuEMeNkw=;
        b=VW055u7mpMrVnyvy3pcO/XLWYg4W6n1SVa52KnW5CzToW2siIvtNuGf7fjgEq3vC7k
         U70YWN5nHimDkzLPTxZ1Wo7mS1MkKcbVtpaJsEmMbvl+ymyLfwKf0W7BEKUBpwfUnVV1
         f3xq58TBFbq9XrtGdGIJJcdNezk/VZkOM0jwPffC9Elc8jnmtVOg5JmW//KGHEKmx0gc
         yJBf/gH0KrGztuE6mNfn/fZ/9qIKWWikruOH6Whj7HPL7aOJf++w4ep9tEWrXRqrTLy1
         8DUEvk5b+3wLYNmdL2oH+GtsJ2NQVTguyXVknbeH/fWRANlvy6wswzSx/DzIWChdtkJ7
         0+xQ==
X-Gm-Message-State: ANhLgQ2DsXUD/1WtDHvLC0yZBxGWu5ZJEkmYyEU3CdSYWZPEJyAM3XBx
        bxsF2SwlwOy7WpPzTByfE19ued3b
X-Google-Smtp-Source: ADFU+vsR8/enDWMRGI9zYCByh8vYrAJV/k0ZVXaSFoQmagS/wnBOwBl7rNs8nV0VXWjtxaN1jPTAdQ==
X-Received: by 2002:a63:7783:: with SMTP id s125mr21230881pgc.214.1583855639885;
        Tue, 10 Mar 2020 08:53:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z17sm36944540pfk.110.2020.03.10.08.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 08:53:58 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] net: memcg: late association of sock to memcg
To:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Roman Gushchin <guro@fb.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200310051606.33121-1-shakeelb@google.com>
 <20200310051606.33121-2-shakeelb@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <652106b3-975d-b8bc-ca27-682c0c8d8aa3@gmail.com>
Date:   Tue, 10 Mar 2020 08:53:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310051606.33121-2-shakeelb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/20 10:16 PM, Shakeel Butt wrote:
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by such sockets will
> not be accounted by the memcg.
> 
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
> 
> To fix the issue, just do the association of the sockets at the accept()
> time in the process context and then force charge the memory buffer
> already used and reserved by the socket.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

