Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32616A9957
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 15:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjCCOW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 09:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCCOW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 09:22:57 -0500
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D31B2D6F;
        Fri,  3 Mar 2023 06:22:56 -0800 (PST)
Received: by mail-qt1-f172.google.com with SMTP id c19so2890168qtn.13;
        Fri, 03 Mar 2023 06:22:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677853375;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S1G8ayTi+GmNzm1jKyUjsHCaHNlVaFWS5yZRA/20YVw=;
        b=Bn2VSsCojpJZr/eWFLrlOmrS8ik6iJsFVqaIOCEqcgr3BeQ2gdHaExIDvJTSys4L3N
         SgHMDgs0fyL0gTwaiBW6GCMfvoGPmuYOz5zzD07z9eoDjIQt9a4D4bjoD2LXTGtVmK55
         eiRXVYl9/bZ2sti88ucEw6ffviu70k01htJ4b1Oi9T0Q9DGCGBk0L8EvC+7dnd1+jG9d
         OwIsLNYs/8uxeI2imOcfS7Lg2tVlNCrlHuFogJP52dJ+XdqA29Ohb/FgtsqSuYi5a7QK
         pE9mBk/Vh2TcmVih9pHduVMZwlKES3I1U6J7XUYEMWxvV43qRiVL/D9bNbU350vHneHc
         SNFQ==
X-Gm-Message-State: AO0yUKURmoRV3TH2dPYOkxxy6mZu9cUO+03GmqsHa40D7eSQn5LYAR0k
        y6KVRfu5ASBwDxgnCBPucIV7HAJD/fpw7ftH
X-Google-Smtp-Source: AK7set9h5W3ZfcpGPKVN9QXbnC0/olejL8EkIISjLqIJC8Tcd3hSURsvUEZXlGZNcwHZVg+4as8PfA==
X-Received: by 2002:ac8:5a49:0:b0:3b2:4309:99e with SMTP id o9-20020ac85a49000000b003b24309099emr3617727qta.54.1677853375358;
        Fri, 03 Mar 2023 06:22:55 -0800 (PST)
Received: from maniforge ([24.1.27.177])
        by smtp.gmail.com with ESMTPSA id i188-20020a37b8c5000000b0073b45004754sm1830523qkf.34.2023.03.03.06.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 06:22:54 -0800 (PST)
Date:   Fri, 3 Mar 2023 08:22:52 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v5 bpf-next 6/6] bpf: Refactor RCU enforcement in the
 verifier.
Message-ID: <ZAICvFGmh2ykz9Bi@maniforge>
References: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
 <20230303041446.3630-7-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303041446.3630-7-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 08:14:46PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> bpf_rcu_read_lock/unlock() are only available in clang compiled kernels. Lack
> of such key mechanism makes it impossible for sleepable bpf programs to use RCU
> pointers.
> 
> Allow bpf_rcu_read_lock/unlock() in GCC compiled kernels (though GCC doesn't
> support btf_type_tag yet) and allowlist certain field dereferences in important
> data structures like tast_struct, cgroup, socket that are used by sleepable
> programs either as RCU pointer or full trusted pointer (which is valid outside
> of RCU CS). Use BTF_TYPE_SAFE_RCU and BTF_TYPE_SAFE_TRUSTED macros for such
> tagging. They will be removed once GCC supports btf_type_tag.
> 
> With that refactor check_ptr_to_btf_access(). Make it strict in enforcing
> PTR_TRUSTED and PTR_UNTRUSTED while deprecating old PTR_TO_BTF_ID without
> modifier flags. There is a chance that this strict enforcement might break
> existing programs (especially on GCC compiled kernels), but this cleanup has to
> start sooner than later. Note PTR_TO_CTX access still yields old deprecated
> PTR_TO_BTF_ID. Once it's converted to strict PTR_TRUSTED or PTR_UNTRUSTED the
> kfuncs and helpers will be able to default to KF_TRUSTED_ARGS. KF_RCU will
> remain as a weaker version of KF_TRUSTED_ARGS where obj refcnt could be 0.
> 
> Adjust rcu_read_lock selftest to run on gcc and clang compiled kernels.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: David Vernet <void@manifault.com>
