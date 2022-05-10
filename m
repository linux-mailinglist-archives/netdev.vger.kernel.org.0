Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5066C522468
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244624AbiEJSyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbiEJSy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:54:29 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAE312EA0B;
        Tue, 10 May 2022 11:54:29 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id l11so9793524pgt.13;
        Tue, 10 May 2022 11:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Se915aO2vPjgqlRAWsxAyLIac4mNleYAwasmX9ThcTs=;
        b=qtKjfeAFfdWJmrcdiDBx3H9tdAengHKNuMfJ+52+dCHfb2fEN26tHa4yctHK9itWCi
         /S7QNeU9Mg40uShLcIXkEmMQBAcSgSG8JD7arS1Sehk7BvdL17T/fc4ATxuX9eqVVo3M
         5O0f9kenrSlerNMDKS+0efpEqXLaaxeNoAK3sb+ffui7C7i2Sh8tJUX66ZhJOL6H1JWb
         cVEKHijbwtuXVvjBKUXvamEFrR0+KFcejFT4sK0xPlHJRPzLSrEI7qex90z2uxymQT3f
         qY6M3x9dVrSQwXQJ89W7tNLpS467f62pp4xJkrmjfsjuLND+Utd1muiCbeJuVeU4BgDw
         wiug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Se915aO2vPjgqlRAWsxAyLIac4mNleYAwasmX9ThcTs=;
        b=Yjyw7v5N+iUZjL44wJ1lVodEQTyTU7xxIvqq+EZMsZ80kuO6Th9NReVIyQGmbrQfv5
         Q21+VM7mZ51ZjMNGxwFUu45Z25qLE2F22pPTuFeqOGz8PwPvjOh/H0CMY4nUfvbIVe1M
         ESOUrnWBVArz+vZFEIp0TC412qmFLO6zKlDaC88Hi+HtcnGCyE/eftym5GXcaqR61rPR
         bJv6VP00o5hDsdjZl7qHYitQ7WqD4qgJh1GVp695mpT19tB/RXmVA4Nl++79Jy71OUO4
         1bFXL53oBaMzO1760gW039lt3Oj7QRc+zxMHLlONIkkXUB8rk+ssIvAUqx51jJVyneyd
         H+hg==
X-Gm-Message-State: AOAM533SR8R+R28qjmBghAvsYalOD77rEKh1wKqcPBF9bHebZbLHUuGy
        WfWY7P4zWYmRCfrRztB4fio=
X-Google-Smtp-Source: ABdhPJweJ4qdfrx2+kzhEognD0PEYcgHg++Dtst9d97jC8SFSQp0MTMLH8RZ38mnOn0Ip+guLs6JoQ==
X-Received: by 2002:aa7:83c2:0:b0:505:723f:6ace with SMTP id j2-20020aa783c2000000b00505723f6acemr21710594pfn.86.1652208868419;
        Tue, 10 May 2022 11:54:28 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:6c64])
        by smtp.gmail.com with ESMTPSA id r22-20020a170903021600b0015e8d4eb22csm2431432plh.118.2022.05.10.11.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:54:27 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 10 May 2022 08:54:26 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 8/9] bpf: Introduce cgroup iter
Message-ID: <Ynq04gC1l7C2tx6o@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-9-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510001807.4132027-9-yosryahmed@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, May 10, 2022 at 12:18:06AM +0000, Yosry Ahmed wrote:
> From: Hao Luo <haoluo@google.com>
> 
> Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
> iter doesn't iterate a set of kernel objects. Instead, it is supposed to
> be parameterized by a cgroup id and prints only that cgroup. So one
> needs to specify a target cgroup id when attaching this iter. The target
> cgroup's state can be read out via a link of this iter.

Is there a reason why this can't be a proper iterator which supports
lseek64() to locate a specific cgroup?

Thanks.

-- 
tejun
