Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6ADFD25F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKOBYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:24:44 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33959 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfKOBYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:24:44 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so5519906pff.1
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 17:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=vQl889CN5y2lhB7wQ6ztDPXBLh/TC9puTuFstOMw+l0=;
        b=tLtW9Df66yptv8LsOzfXJQ7EPj8Me/bXdfsqRaNGzfGnNU5hUFR3lsSLhRMDdMIjDG
         uu+7pXTviCHZNZrk638M29ad3q6dh04R3SLSedYnfMbBDN+YDJQxL4qCzYhRGtNUD4rG
         6lS/zKbHkB5l3wtRYEq2sjB6K1GscKqIZrrPW7WvTh42gDcoOg3L4Jg+5zzD+LLwuzeF
         CPDHsuuX9giUuH2SERVo8kOLTZFkeMg5s93ZOgcCxrYLZ6sigh2qYhCMdQVXn5/pLmGZ
         eEZbd984p3LrhOhKAKsj0GeQ3mJsyw7gsMtl4OGeI/tqgtWhio4uXVMOa9jEtuFez6gk
         yasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=vQl889CN5y2lhB7wQ6ztDPXBLh/TC9puTuFstOMw+l0=;
        b=Y8ixLHjH2N/FSwFdmEeyavPPzWjgIRMmOs2WE8BoT8Cja8K42pH4AJnVk+xRPOcZ8T
         VU8OKEpvUczcGmLXuNF6NT/zr1KkEMj+RXJ0Qjmplo77lrcgC6GoWBXhnRjXfWg6INvo
         kF0wv2kMQaQ8ue8J/PQ7S9L/9x2+8GLN3TTECXlwxDEDDuyEdvUza1ZdXS48qAwhMCIo
         OoemxSTHVJY9U1PqnYOxdnfnOETNt0mWs0vPGXIE73MWSfhzcrG/oMy/0jX89CVabeqM
         SCLnNHJAqakTIDcZyl6FLVVGrYDswv/KB3dEkk4VkeIYlDAhRCk/bf6jzz7r/tScWNBJ
         5fzA==
X-Gm-Message-State: APjAAAXKmw+VPv3FPlPjyOKZPD8H/VlX9bbzdytNGny16z40bnkxJ1xF
        ESBG1CPqBQ2Drw7HreXw1Nq0sfJU
X-Google-Smtp-Source: APXvYqxbAl2kU6xt96G1Q1Sc9TOM/I/01e/wTMVzM/b+jijV/Wewc0UP7GJy6C7z0Z22IjX69chqfA==
X-Received: by 2002:a63:4819:: with SMTP id v25mr13264347pga.165.1573781083825;
        Thu, 14 Nov 2019 17:24:43 -0800 (PST)
Received: from [172.20.189.1] ([2620:10d:c090:180::34be])
        by smtp.gmail.com with ESMTPSA id x3sm6638835pjq.10.2019.11.14.17.24.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 17:24:43 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, kernel-team@fb.com
Subject: Re: [net-next PATCH v3 1/1] page_pool: do not release pool until
 inflight == 0.
Date:   Thu, 14 Nov 2019 17:24:42 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <F7B3F26C-A697-4E47-897B-582444962A53@gmail.com>
In-Reply-To: <20191114231737.29b46690@carbon>
References: <20191114221300.1002982-1-jonathan.lemon@gmail.com>
 <20191114221300.1002982-2-jonathan.lemon@gmail.com>
 <20191114231737.29b46690@carbon>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 2019, at 14:17, Jesper Dangaard Brouer wrote:

> On Thu, 14 Nov 2019 14:13:00 -0800
> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>> The page pool keeps track of the number of pages in flight, and
>> it isn't safe to remove the pool until all pages are returned.
>>
>> Disallow removing the pool until all pages are back, so the pool
>> is always available for page producers.
>>
>> Make the page pool responsible for its own delayed destruction
>> instead of relying on XDP, so the page pool can be used without
>> the xdp memory model.
>>
>> When all pages are returned, free the pool and notify xdp if the
>> pool is registered with the xdp memory system.  Have the callback
>> perform a table walk since some drivers (cpsw) may share the pool
>> among multiple xdp_rxq_info.
>>
>> Note that the increment of pages_state_release_cnt may result in
>> inflight == 0, resulting in the pool being released.
>>
>> Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic 
>> warning")
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks, Jesper!
-- 
Jonathan
