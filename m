Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFBF6E60A5
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjDRMIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDRMH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:07:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7CDCC15
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681819133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ic+G8JxkY030ztDDxrSVr0gIWS+MILOdZNy5BfZjtHQ=;
        b=GRokVicCAK5z3JYvEz1SaiJmczut8JZ4kCvrVdQz46bWtN3LyCV0MvTo/UL8QPWaWl2/mS
        olStiqtLIENXN96jgEO0eOILmEWJ7y5O1LyhGKxyDiWvl0NW1aQheQYjMl1SWksJeewSpc
        0u87/uSfQlvOJaTwTjhwtbH11RodILM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-B3JB6x_-PbWhGm-cky0iUA-1; Tue, 18 Apr 2023 07:58:52 -0400
X-MC-Unique: B3JB6x_-PbWhGm-cky0iUA-1
Received: by mail-wm1-f71.google.com with SMTP id bd16-20020a05600c1f1000b003f172e02edbso3429336wmb.4
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681819131; x=1684411131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ic+G8JxkY030ztDDxrSVr0gIWS+MILOdZNy5BfZjtHQ=;
        b=lIxP1LjcfnQKWh6FAg0BPq0OPZp0V28ppYJTcDt3/X+fNlxDSJZ76TAjCPS8F8vfQ8
         21EchtBusD87JSZBlHzJ+TnEz5T3r1evulag3T8WsHjmIALKWsFTohgfdwaFCWT2RVrY
         /2S67yYUbIchbxYifCo+k+e93xHzRKqWE+TrGH/2VdkJoyM+7w3ZLoyg+tyTGpJAUtue
         ehhG3Yf6bJysCc+lprO+LC7QNxzSuROY02NhrkQktuW33ZEYE5hli2q0W4e60nojpDdT
         MBmfequH8meIhlgVJAYwjorkdD6W1qDCE+WyT7uM72OXw48DvWwJiQ8DxsvaTH6Rtyfn
         2Z0g==
X-Gm-Message-State: AAQBX9eY60eIA4xI6FOSlZZp091kjUUeJyaQRftGH1rT1adsaWIQQqOy
        nHul6XdhbvyO5msUANAsQ8DAPRLSA78lHAAAc576BVbPmvVfj7iS/l6cCGaXlsLjgIqEndrqenv
        fYmNRjAf+igUFwv7P
X-Received: by 2002:a7b:cb07:0:b0:3f0:5519:9049 with SMTP id u7-20020a7bcb07000000b003f055199049mr13710169wmj.8.1681819131389;
        Tue, 18 Apr 2023 04:58:51 -0700 (PDT)
X-Google-Smtp-Source: AKy350YYPfT3gB+38KJa3OuGZh4qKj+97YG3AusxGQ1ufp+BlxDKePtvpPOBSG270xYpIPQ/XjAu0Q==
X-Received: by 2002:a7b:cb07:0:b0:3f0:5519:9049 with SMTP id u7-20020a7bcb07000000b003f055199049mr13710144wmj.8.1681819131056;
        Tue, 18 Apr 2023 04:58:51 -0700 (PDT)
Received: from localhost ([37.160.130.245])
        by smtp.gmail.com with ESMTPSA id m4-20020a05600c4f4400b003f0ae957fcesm12903095wmq.42.2023.04.18.04.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 04:58:50 -0700 (PDT)
Date:   Tue, 18 Apr 2023 13:58:46 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Abhijeet Rastogi <abhijeet.1989@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: change ip_vs_conn_tab_bits range to [8,31]
Message-ID: <ZD6F9l2yE0i42YE5@renaissance-vector>
References: <20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com>
 <d2519ce3-e49b-a544-b79d-42905f4a2a9a@ssi.bg>
 <CACXxYfxLU0jWmq0W7YxX=44XFCGvgMX2HwTFUUHCUMjO28g5BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXxYfxLU0jWmq0W7YxX=44XFCGvgMX2HwTFUUHCUMjO28g5BA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 06:58:06PM -0700, Abhijeet Rastogi wrote:
> Hi Simon, Andrea and Julian,
> 
> I really appreciate you taking the time to respond to my patch. Some follow up
> questions that I'll appreciate a response for.
> 
> @Simon Horman
> >In any case, I think this patch is an improvement on the current situation.
> 
> +1 to this. I wanted to add that, we're not changing the defaults
> here, the default still stays at 2^12. If a kernel user changes the
> default, they probably already know what the limitations are, so I
> personally don't think it is a big concern.
> 
> @Andrea Claudi
> >for the record, RHEL ships with CONFIG_IP_VS_TAB_BITS set to 12 as
> default.
> 
> Sorry, I should have been clearer. RHEL ships with the same default,
> yes, but it doesn't have the range check, at least, on the version I'm
> using right now (3.10.0-1160.62.1.el7.x86_64).
> 
> On this version, I'm able to load with bit size 30, 31 gives me error
> regarding allocating memory (64GB host) and anything beyond 31 is
> mysteriously switched to a lower number. The following dmesg on my
> host confirms that the bitsize 30 worked, which is not possible
> without a patch on the current kernel version.
> 
> "[Fri Apr 14 01:14:51 2023] IPVS: Connection hash table configured (size=1073741
> 824, memory=16777216Kbytes)"

I see. This makes sense to me as RHEL 7 does not include the range
check, while RHEL 8 and RHEL 9 both includes it.

The reason why any number beyond 31 results in a lower number is to be
searched in gcc implementation. IIRC shifting an int by more than 31 or
less than 0 results in an undefined behaviour, according to the C
standard.

> 
> @Julian Anastasov,
> >This is not a limit of number of connections. I prefer
> not to allow value above 24 without adding checks for the
> available memory,
> 
> Interesting that you brought up that number 24, that is exactly what
> we use in production today. One IPVS node is able to handle spikes of
> 10M active connections without issues. This patch idea originated as
> my company is migrating from the ancient RHEL version to a somewhat
> newer CentOS (5.* kernel) and noticed that we were unable to load the
> ip_vs kernel module with anything greater than 20 bits. Another
> motivation for kernel upgrade is utilizing maglev to reduce table size
> but that's out of context in this discussion.
> 
> My request is, can we increase the range from 20 to something larger?
> If 31 seems a bit excessive, maybe, we can settle for something like
> [8,30] or even lower. With conn_tab_bits=30, it allocates 16GB at
> initialization time, it is not entirely absurd by today's standards.
> 
> I can revise my patch to a lower range as you guys see fit.
> 
> --
> Cheers,
> Abhijeet (https://abhi.host)
> 

