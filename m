Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE336813ED
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbjA3O6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237908AbjA3O6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:58:15 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5269A10409
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:58:14 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ml19so8949897ejb.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HiGrD1dyHCsxNZSafiiQouritp32iJwUHx6VOOxAvoU=;
        b=6TyF+8emNxzziWsWUGWqM4UZYfylE0d3H0jPQQo9Ldg+ZbpryIRFo9jTjTrSyX2A9c
         eXwx+jB+Z2Ytwg4EvHwJD66FjOVkG04QYF/AmsuuoXcwHa3yQThODcqd11Ga2xMyJGgz
         xsPwN2A4qKINz5jWIdfqUfauE+mjjMVHejGYpVXXf905/B92aW5qo1w6fz5nk+YawpEN
         KbkvniIuSjt3o+HNjxabCsZrdoc9/0kyj2EDLvqsvix61rTMQ6BaFSuIulHF7ORRNjDI
         TRb8j20IoT7NIlnwSw2hhdkY7PyGFzpREQvSnoBMNJXhSDqRjbIvsu7yqvlAJU7qe+lq
         g5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HiGrD1dyHCsxNZSafiiQouritp32iJwUHx6VOOxAvoU=;
        b=KX6WzXU4qEnTUdaJC6Csh4r9XnRgi+LFDPfoEWnFHN49xZdiLGoFke1J8sNDW8CXhz
         +VtmZIOL7RP+/c02mgwMKoMomSLdj/9Nsb8D5+WQTWGy47sPMBAbvQrpXnguKXVnfniw
         TNfV43DSUh14rfGZflBupa3Ona2c4H1dZjvpAr/w0N5EiOV1STS5ayh5Zoib4k6Y8Imt
         ltijtNEJauOU0ONjS/56+qJoAQqQkzidUcGUJATX7hAM5jfjdYqzFAPSj6LgInoISwCG
         4z7ZR/676qRWcNunrmR8/hM2kws4GizzLIm87MQZvn5ZxDHXDTX1QgevIv1aXPZ8nq+c
         Bg7g==
X-Gm-Message-State: AO0yUKXBKZrS/nsYx7n68foMuDQJ0QXTN5CG7KmFjO6YCK9YrYqpX6js
        cGFjwtV5iNEG1n12GVw2lqCeENwUlDIdPD00ddU=
X-Google-Smtp-Source: AK7set9jWVEhwPAGmMP1q6mxH37JVc79+diom5D7Nq0GQOgWQNwmTt77Z+rZGJCp4VHPL8QeLHwHZg==
X-Received: by 2002:a17:906:4999:b0:87d:f1f9:a2fb with SMTP id p25-20020a170906499900b0087df1f9a2fbmr11258498eju.29.1675090692825;
        Mon, 30 Jan 2023 06:58:12 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id rh16-20020a17090720f000b0084c7029b24dsm7036658ejb.151.2023.01.30.06.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 06:58:11 -0800 (PST)
Date:   Mon, 30 Jan 2023 15:58:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     John Hickey <jjh@daedalian.us>
Cc:     anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] ixgbe: Panic during XDP_TX with > 64 CPUs
Message-ID: <Y9fbAqR+BDhlPb6I@nanopsycho>
References: <20230128011213.150171-1-jjh@daedalian.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128011213.150171-1-jjh@daedalian.us>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jan 28, 2023 at 02:12:12AM CET, jjh@daedalian.us wrote:
>In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
>(4fe815850bdc8d4cc94e06fe1de069424a895826), support was added to allow
>XDP programs to run on systems with more than 64 CPUs by locking the
>XDP TX rings and indexing them using cpu % 64 (IXGBE_MAX_XDP_QS).
>
>Upon trying this out patch via the Intel 5.18.6 out of tree driver
>on a system with more than 64 cores, the kernel paniced with an
>array-index-out-of-bounds at the return in ixgbe_determine_xdp_ring in
>ixgbe.h, which means ixgbe_determine_xdp_q_idx was just returning the
>cpu instead of cpu % IXGBE_MAX_XDP_QS.
>
>I think this is how it happens:
>
>Upon loading the first XDP program on a system with more than 64 CPUs,
>ixgbe_xdp_locking_key is incremented in ixgbe_xdp_setup.  However,
>immediately after this, the rings are reconfigured by ixgbe_setup_tc.
>ixgbe_setup_tc calls ixgbe_clear_interrupt_scheme which calls
>ixgbe_free_q_vectors which calls ixgbe_free_q_vector in a loop.
>ixgbe_free_q_vector decrements ixgbe_xdp_locking_key once per call if
>it is non-zero.  Commenting out the decrement in ixgbe_free_q_vector
>stopped my system from panicing.
>
>I suspect to make the original patch work, I would need to load an XDP
>program and then replace it in order to get ixgbe_xdp_locking_key back
>above 0 since ixgbe_setup_tc is only called when transitioning between
>XDP and non-XDP ring configurations, while ixgbe_xdp_locking_key is
>incremented every time ixgbe_xdp_setup is called.
>
>Also, ixgbe_setup_tc can be called via ethtool --set-channels, so this
>becomes another path to decrement ixgbe_xdp_locking_key to 0 on systems
>with greater than 64 CPUs.
>
>For this patch, I have changed static_branch_inc to static_branch_enable
>in ixgbe_setup_xdp.  We aren't counting references and I don't see any
>reason to turn it off, since all the locking appears to be in the XDP_TX
>path, which isn't run if a XDP program isn't loaded.
>
>Signed-off-by: John Hickey <jjh@daedalian.us>

This is missing "Fixes" tag and "net" keyword in "[patch]" subject
section.


>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 3 ---
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
> 2 files changed, 1 insertion(+), 4 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
>index f8156fe4b1dc..0ee943db3dc9 100644
>--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
>+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
>@@ -1035,9 +1035,6 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
> 	adapter->q_vector[v_idx] = NULL;
> 	__netif_napi_del(&q_vector->napi);
> 
>-	if (static_key_enabled(&ixgbe_xdp_locking_key))
>-		static_branch_dec(&ixgbe_xdp_locking_key);
>-
> 	/*
> 	 * after a call to __netif_napi_del() napi may still be used and
> 	 * ixgbe_get_stats64() might access the rings on this vector,
>diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>index ab8370c413f3..cd2fb72c67be 100644
>--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>@@ -10283,7 +10283,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
> 	if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
> 		return -ENOMEM;
> 	else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
>-		static_branch_inc(&ixgbe_xdp_locking_key);
>+		static_branch_enable(&ixgbe_xdp_locking_key);
> 
> 	old_prog = xchg(&adapter->xdp_prog, prog);
> 	need_reset = (!!prog != !!old_prog);
>-- 
>2.37.2
>
