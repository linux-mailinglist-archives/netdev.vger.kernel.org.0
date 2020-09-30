Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C417B27EDFC
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgI3P4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3P4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:56:00 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA93DC061755;
        Wed, 30 Sep 2020 08:55:58 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q9so32899wmj.2;
        Wed, 30 Sep 2020 08:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=whq8WAXRjk7ec2QJ8+8MtHlF+DITSdGmvR0TsIALGuU=;
        b=VHOonPRjYSEulblKeiMXnBs8ZvfVVNV/P4klarccoXAxPafcmRGcTNoICV79F9XrUR
         HB1BYIAHLu641bx+bY1+7/WIRaZUvGSzDKdUb6yfU/Z4Gt91K2H088058QM7uXUd/4ls
         E9M0xFGujQo55ayyNbQXHketTOzUmSAVYIScEy1XvsubxYCAs1ulZB1j8adW78j5a12O
         vZp0VBR9SG/Aks1icANIeNBX3FtlmLBocPo8jhFX3FzDAJwSGAF/G3Bv/oOl+EZJ2TaC
         fJ3WfALSF1TntHW8+VkOT1MqccwRO1BoEmILWUS8+EbbI/IW6NPBwqu/9tVskF/gBJ1l
         Dcfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=whq8WAXRjk7ec2QJ8+8MtHlF+DITSdGmvR0TsIALGuU=;
        b=P3aMT6mfnqJLfbUHUM/lnfCz6zema4QA98EIHX9p8RJGymc9wVgyBf2vGvRDwPIR1Q
         3QJebQrDS+p/mOwlLzb0d5n7D97JgdCVRrx7XYB1B0UQa9OCbk+zcQbij9KVxaclD6EK
         43e9qkThI69ME/KJqtGGsGktmIUFWvFyH7K4D64WUoixhYx2ljxQzn25TYNh1ZpPQlhA
         xUZ5KeTJR8sZVReZLbM5uuXYrSl+lCVRZrCoMHe//cUP2IrSPF7HMFb3ZWHLaRF/2DiO
         0Zi2A3LkRfYoeVfKXTGeS49PWDEEaXZ0ZndQjNgb/IhinI97e5AwWmtShynJ4IYMOmO8
         nTZw==
X-Gm-Message-State: AOAM533eXDtb31xLr/YHbpowGvX9fo3tg55UAr+T8NnnYRAmc2dIvrrt
        ZnCaOI/Shd0mFgRmRN+HPPD5qjLxoYs=
X-Google-Smtp-Source: ABdhPJxT7UdKtA5yQFeCtiFZQBFbedgCCZnxNOxAZoo3vBoJjUa/xQPdhMNR6kMKsAyZtstbDKD9pA==
X-Received: by 2002:a05:600c:221a:: with SMTP id z26mr3956645wml.131.1601481357632;
        Wed, 30 Sep 2020 08:55:57 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.161.238])
        by smtp.gmail.com with ESMTPSA id o15sm3422075wmh.29.2020.09.30.08.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 08:55:57 -0700 (PDT)
Subject: Re: [PATCH bpf-next v4 2/6] bpf, net: rework cookie generator as
 per-cpu one
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org
Cc:     john.fastabend@gmail.com, kafai@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
References: <cover.1601477936.git.daniel@iogearbox.net>
 <8a80b8d27d3c49f9a14e1d5213c19d8be87d1dc8.1601477936.git.daniel@iogearbox.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c42aac64-d78c-7f3b-9e07-5da7d46aa582@gmail.com>
Date:   Wed, 30 Sep 2020 17:55:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <8a80b8d27d3c49f9a14e1d5213c19d8be87d1dc8.1601477936.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/20 5:18 PM, Daniel Borkmann wrote:
> With its use in BPF, the cookie generator can be called very frequently
> in particular when used out of cgroup v2 hooks (e.g. connect / sendmsg)
> and attached to the root cgroup, for example, when used in v1/v2 mixed
> environments. In particular, when there's a high churn on sockets in the
> system there can be many parallel requests to the bpf_get_socket_cookie()
> and bpf_get_netns_cookie() helpers which then cause contention on the
> atomic counter.
> 
> As similarly done in f991bd2e1421 ("fs: introduce a per-cpu last_ino
> allocator"), add a small helper library that both can use for the 64 bit
> counters. Given this can be called from different contexts, we also need
> to deal with potential nested calls even though in practice they are
> considered extremely rare. One idea as suggested by Eric Dumazet was
> to use a reverse counter for this situation since we don't expect 64 bit
> overflows anyways; that way, we can avoid bigger gaps in the 64 bit
> counter space compared to just batch-wise increase. Even on machines
> with small number of cores (e.g. 4) the cookie generation shrinks from
> min/max/med/avg (ns) of 22/50/40/38.9 down to 10/35/14/17.3 when run
> in parallel from multiple CPUs.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.

