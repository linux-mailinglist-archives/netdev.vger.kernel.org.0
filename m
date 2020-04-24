Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03231B6EF2
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgDXH1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgDXH1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:27:02 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D013EC09B045
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 00:27:00 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id k28so6840607lfe.10
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 00:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YOpc3bZiRWRriDSOObFG3Qsaf8uxGUEggNP5IeWWlyc=;
        b=Uq9i3WyVrsQvzUcGGl60mesNcqH8kUSz9cfz0yx+jCZu+S946JMHJL7esS8It0Etnm
         H1alD/laSVyanfu+OLGlYwuz8hgJVQCCScKBzrJhJB+qRmcQxvtw0uT7ay87Dgy3GCim
         qrx26IZ9MiZa5KQh4Q3QCgBAEshKCOyJDXlyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YOpc3bZiRWRriDSOObFG3Qsaf8uxGUEggNP5IeWWlyc=;
        b=c8Ons3EMsfPM6eo9h2MtywAFPYANnStKdkUjWRj1ziQWD/4go3s0bgf2DcD63f2M15
         IluFDWqTDcG1IDZgciKfKS+NvVz13Mbj+k2glHNqgvlrl1eH5CQ8Lj9bmCyMzRZ1fw48
         1TtH+ijJ4evW49Q+Q79+7i59e1xw6fzS4eiZPOek14n/LuQIpyv0mB8qjgPX0svbkQMJ
         F/H3vZNdwLSntop1rKd7B9XocvFiiecKucohTQFtm5nJ++H4C/gjsA3ogZ3yrGcLBclZ
         tnhwJX15lk1I2L4rF+PND0C4wOob3pqJbX5Dm9fKh1l7ebuoLU/X5BRcNuaT9UJXpAXV
         irnQ==
X-Gm-Message-State: AGi0PuYJDhpZn7lrMQkRABjBdLlFx/8HjeYofrGhr0daNEJO3Lpbjq/o
        DjdzxwqlcGiEKq/zOp/orJITNha+dwt7tg==
X-Google-Smtp-Source: APiQypL57MdwPcz6SQqNih12slm2YU3XiyTUoy6A/+GUwGfBkGiI9RJaSEMMsfSToqoUJhDTX3TpbA==
X-Received: by 2002:a19:224e:: with SMTP id i75mr5249872lfi.22.1587713219328;
        Fri, 24 Apr 2020 00:26:59 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y22sm3755051lfg.92.2020.04.24.00.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 00:26:58 -0700 (PDT)
Subject: Re: [PATCH net v3] net: bridge: fix vlan stats use-after-free on
 destruction
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        syzkaller-bugs@googlegroups.com
References: <20181114172703.5795-1-nikolay@cumulusnetworks.com>
 <20181116165001.30896-1-nikolay@cumulusnetworks.com>
 <20200423170521.65a3bc59@hermes.lan>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <137746b0-1655-3704-a6f1-54274615d605@cumulusnetworks.com>
Date:   Fri, 24 Apr 2020 10:26:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423170521.65a3bc59@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/04/2020 03:05, Stephen Hemminger wrote:
> On Fri, 16 Nov 2018 18:50:01 +0200
> Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> 
>> Syzbot reported a use-after-free of the global vlan context on port vlan
>> destruction. When I added per-port vlan stats I missed the fact that the
>> global vlan context can be freed before the per-port vlan rcu callback.
>> There're a few different ways to deal with this, I've chosen to add a
>> new private flag that is set only when per-port stats are allocated so
>> we can directly check it on destruction without dereferencing the global
>> context at all. The new field in net_bridge_vlan uses a hole.
>>
>> v2: cosmetic change, move the check to br_process_vlan_info where the
>>     other checks are done
>> v3: add change log in the patch, add private (in-kernel only) flags in a
>>     hole in net_bridge_vlan struct and use that instead of mixing
>>     user-space flags with private flags
>>
>> Fixes: 9163a0fc1f0c ("net: bridge: add support for per-port vlan stats")
>> Reported-by: syzbot+04681da557a0e49a52e5@syzkaller.appspotmail.com
>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> 
> Why not just use v->stats itself as the flag.
> Since free of NULL is a nop it would be cleaner?
> 

v->stats is *always* set while the vlan is published/visible, that's a guarantee
I don't want to break because I'll have to add null checks in the fast-path.

By the way this is a thread from 2018. :-)

Cheers,
 Nik

