Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B2F59309A
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242962AbiHOOUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242985AbiHOOUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:20:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3382232
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 07:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660573242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sEuTlIc9D6exXishpGuOUy0Zpyin7rcQK73GQnhVdPw=;
        b=Oh1uTyvG+KyAnAQY3aEGi9+qYocSMiUcCEQJkgyIGwbUkzaiZQWQ6WYUcYwIDmMXqpUQg2
        fIHZNPe9dGkPPgQEcBOupJrreEEVmgrRTepPXsC4h//MCLLLfGSwrHTRHN5wVZh/pCAdc1
        1GdoCRolE+zIz8b/JynbN7Qa+wly2w0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-364-bnZfUnPbN7y-6-eD6r_KCA-1; Mon, 15 Aug 2022 10:20:41 -0400
X-MC-Unique: bnZfUnPbN7y-6-eD6r_KCA-1
Received: by mail-wm1-f72.google.com with SMTP id f21-20020a1cc915000000b003a3551598a1so1501007wmb.0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 07:20:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=sEuTlIc9D6exXishpGuOUy0Zpyin7rcQK73GQnhVdPw=;
        b=0CjEye53jlqxIOYQH2ZsadL1ianVuKDl0KCLUloqv0t9m3T5Bor38DUqjfe/he3Usu
         83DMpMSmVmKKSOnQ9p6CynLu6u/RhUCV+bEreu9NTPJXBds2Ho6hlKpIs7DMpqgtmgH5
         +TEeWKhK8n9R0usWyYs9cV0WFvc0SwZn+RAb76GSDlypwBDN8nkXb8H7x49CHe/elRsZ
         U4upBxTX/UVyFwfjIpDQA80NkpblsJPB3qWBTiO+3rIOATR0VQI1AQgTHEUywVyMULmu
         s/NSOjuBaLUNsKOQaCdZ0zj1I0GFZU+PXQC/FY8ze7BIqrbIgaetL7nVHEYKOcs5Gs+i
         fIyw==
X-Gm-Message-State: ACgBeo1LU25QZ1valphsSgKKwzhTfuIRI5f9bFzkvFYbLCHeASntUY8R
        IlvJDt6GcWjDnAK3SsTuyNfxa/3/9I+WxCg4pez0BVpXNDq7x/SphXxiGlk+wpZMD1MDkdlopJ+
        Xed012ghDyhCq+ERz
X-Received: by 2002:a7b:c851:0:b0:3a5:f211:45cd with SMTP id c17-20020a7bc851000000b003a5f21145cdmr3809008wml.156.1660573240049;
        Mon, 15 Aug 2022 07:20:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5K+0BJFIv+aYiFq6fh9I9DjGQJGMk6v7lj9XQKf0lJDnlYFtrvurp8nf2kDJ76lAMQRk7Ndw==
X-Received: by 2002:a7b:c851:0:b0:3a5:f211:45cd with SMTP id c17-20020a7bc851000000b003a5f21145cdmr3809000wml.156.1660573239855;
        Mon, 15 Aug 2022 07:20:39 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id d15-20020a05600c048f00b003a601a1c2f7sm879909wme.19.2022.08.15.07.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 07:20:39 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 1/2] sched/topology: Introduce sched_numa_hop_mask()
In-Reply-To: <6a2dae6d-cbac-84ba-8852-dadd183fb77d@gmail.com>
References: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
 <20220810105119.2684079-1-vschneid@redhat.com>
 <db20e6fe-4368-15ec-65c5-ead28fc7981b@gmail.com>
 <03aaf512-3ac5-fdfe-da2d-3fecd24591e2@gmail.com>
 <xhsmhmtcac0up.mognet@vschneid.remote.csb>
 <6a2dae6d-cbac-84ba-8852-dadd183fb77d@gmail.com>
Date:   Mon, 15 Aug 2022 15:20:38 +0100
Message-ID: <xhsmhfshxbnbd.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/08/22 11:19, Tariq Toukan wrote:
> The API is indeed easy to use, the driver part looks straight forward.
>
> I appreciate the tricks you used to make it work!
> However, the implementation is relatively complicated, not easy to read
> or understand, and touches several files. I do understand what you did
> here, but I guess not all respective maintainers will like it. Let's see.
>

Dumping it all into a single diff also doesn't help :-) I think the changes to
get a for_each_cpu_andnot() are straightforward enough, the one eyesore is
the macro but I consider it a necessary evil to get an allocation-free
interface.

> One alternative to consider, that will simplify things up, is switching
> back to returning an array of cpus, ordered by their distance, up to a
> provided argument 'npus'.
> This way, you will iterate over sched_numa_hop_mask() internally, easily
> maintaining the cpumask diffs between two hops, without the need of
> making it on-the-fly as part an an exposed for-loop macro.
>

That requires extra storage however: at the very least the array, and a
temp cpumask to remember already-visited CPUs (the alternative being
scanning the array every CPU iteration to figure out if it's been added
already).

I'm going to submit the cpumask / sched changes, hopefully I get to
something by the time you're back from PTO.

