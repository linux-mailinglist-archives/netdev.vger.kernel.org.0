Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112FD6C4140
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjCVDqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCVDqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:46:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7D82E805
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1CD961D84
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA14C433EF;
        Wed, 22 Mar 2023 03:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679456793;
        bh=QlaQrbPGFcgBRKYgeExjpzuNuTb6iYFH6Rfp+gPt07g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GisENaYm1EdLImli57xBrBMH+RpI6BUIin4045+aJUVzC/qF0cnx5porygFAGbJk+
         hUYAWRQX8y0bxhk4+ancdwX1rQcqEFfWB0gyauWRtj4Rid39QRpvdArk5umWEIEeqx
         yDojc3GzaMTIFR9eZC7quZRH5/H4p0rG5+lGeykzk7fsHwkc86fMxIUanKSm/sQTBj
         Iu5lc9DMFLO3zTZMYRbK5iDlH00RoUlriKvOCxUu+k+nL8EROJaRymSNapkWa3OmJt
         0YjtB3PUko527LWV4ld5S1cZt5Vj98Hk6ZsfVm+qc9xn4hpamz4KmyvQrDlok7IZMG
         PPi5sreGziY4A==
Date:   Tue, 21 Mar 2023 20:46:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: Re: [net-next 03/14] lib: cpu_rmap: Add irq_cpu_rmap_remove to
 complement irq_cpu_rmap_add
Message-ID: <20230321204631.0f8bc64e@kernel.org>
In-Reply-To: <20230320175144.153187-4-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
        <20230320175144.153187-4-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 10:51:33 -0700 Saeed Mahameed wrote:
> From: Eli Cohen <elic@nvidia.com>
> 
> Add a function to complement irq_cpu_rmap_add(). It removes the irq from
> the reverse mapping by setting the notifier to NULL.

Poor commit message. You should mention that glue is released and
cleared via the kref.

BTW who can hold the kref? What are the chances that user will call:

	irq_cpu_rmap_remove()
	irq_cpu_rmap_add()

and the latter will fail because glue was held?

> diff --git a/include/linux/cpu_rmap.h b/include/linux/cpu_rmap.h
> index 0ec745e6cd36..58284f1f3a58 100644
> --- a/include/linux/cpu_rmap.h
> +++ b/include/linux/cpu_rmap.h
> @@ -60,6 +60,8 @@ static inline struct cpu_rmap *alloc_irq_cpu_rmap(unsigned int size)
>  }
>  extern void free_irq_cpu_rmap(struct cpu_rmap *rmap);
>  
> +extern int irq_cpu_rmap_remove(struct cpu_rmap *rmap, int irq);
>  extern int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq);
>  
> +

use checkpatch, please :(
