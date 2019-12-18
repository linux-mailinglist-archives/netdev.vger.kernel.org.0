Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554C212496D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfLROYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:24:01 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:39697 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfLROYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:24:01 -0500
Received: by mail-il1-f196.google.com with SMTP id x5so1838424ila.6
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 06:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I8xsC4KqqdJv76nf3R8l7PTNtZop40ZjK9SGrrFfcfI=;
        b=hT96SFHY4+cbtTjfGc1eVxWOLr+B4nCbFllPZywLqbB257CAnxu80Fv0XuchXmrsVI
         fXxGcpqcfPY3ipb+JoYnXGPx9vzw2zNGrUIxDOlkPJdgadi4ZZUdjnL5B9k70/b2czld
         XJEwZErQPFygMvDYG273w6ySCGUGP3wRt14/ACEXIsnTapO/x2TyxIZjhuTIXFB6AmzA
         5DP0e/EPGgeHQjiFgjJAV2jYJCIPyjBWXr42ZpAcnH6JWMtAC0qcjiUu31D82Kn/oSuF
         Fih/qy063rgCP7XZWWsmaDY2a5bxAsOykTkKuWrrTcmD+XRkaz5tKgXLsrBHWyBHlAuE
         A3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I8xsC4KqqdJv76nf3R8l7PTNtZop40ZjK9SGrrFfcfI=;
        b=P+S1orQN/ZEgGQq/PJ55lM7eOAaSoxlGRYNFqQMAjbbYjV9RrFxPKcbFb1O0rcYeiR
         89ULaQsJZQzesS60WpMsBWZWfFFycmHm5F3OsoWDdp7bMvpOWw84QNwZWXKqY6hrjP0t
         zS1PPIlaqD/MoaZfEm8i8m3DMFrqrBvFa/xlvaPQCh10tevKVdKvlnN1MtrdcDYL+0L0
         mRB9WUz6wkzxbQfZfGGwqPTzOwvDdyKfL4dUJpAsx3vK2dekgJpb97lgNL9tj9Kp++n7
         IKHiS9W2GFAnlJ2NdXqUpoPG8Wo2SpnqBC34U9sVXIoFKHnE209CSjy62IVltOpU3mih
         Rv8A==
X-Gm-Message-State: APjAAAVAo0mGlEnNJGld2pDPZRY3AXHel03hV/dpx53uwbqo1pYez6Rp
        rReELtaXVK06MX4xxEyGpCmmCA==
X-Google-Smtp-Source: APXvYqyHrmoiRbpO5lsIRi97ddPyTbvvUrXfFAvymqG7nQBfaHrweh+chsdJFuT01oFi7B66kWw0Mg==
X-Received: by 2002:a92:3a58:: with SMTP id h85mr2046413ila.245.1576679040199;
        Wed, 18 Dec 2019 06:24:00 -0800 (PST)
Received: from [192.168.0.101] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id b1sm698706ilc.33.2019.12.18.06.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 06:23:59 -0800 (PST)
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
To:     Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Roman Mashak <mrv@mojatatu.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
Date:   Wed, 18 Dec 2019 09:23:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019-12-17 6:00 p.m., Davide Caratti wrote:
> when users replace cls_u32 filters with new ones having wrong parameters,
> so that u32_change() fails to validate them, the kernel doesn't roll-back
> correctly, and leaves semi-configured rules.
> 
> Fix this in u32_walk(), avoiding a call to the walker function on filters
> that don't have a match rule connected. The side effect is, these "empty"
> filters are not even dumped when present; but that shouldn't be a problem
> as long as we are restoring the original behaviour, where semi-configured
> filters were not even added in the error path of u32_change().
> 
> Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp is empty")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Hi Davide,

Great catch (and good test case addition),
but I am not sure about the fix.

Unless I am  misunderstanding the flow is:
You enter bad rules, validation fails, partial state had already been
created (in this case root hts) before validation failure, you then
leave the partial state in the kernel but when someone dumps you hide
these bad tables?

It sounds like the root cause is there is a missing destroy()
invocation somewhere during the create/validation failure - which is
what needs fixing... Those dangling tables should not have been
inserted; maybe somewhere along the code path for tc_new_tfilter().
Note "replace" is essentially "create if it doesnt
exist" semantic therefore NLM_F_CREATE will be set.

Since this is a core cls issue - I would check all other classifiers
with similar aggrevation - make some attribute fail in the middle or
end.
Very likely only u32 is the victim.

cheers,
jamal

