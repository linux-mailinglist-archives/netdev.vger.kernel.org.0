Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB8A5FB33B
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJKNUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 09:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiJKNUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 09:20:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A7E97D65
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 06:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665494340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TDCMSGvi/kRX/Ot4OPzT6z0p0kG2Pn06Pcb3KApka90=;
        b=eGM/hE11Hcrz0SkbfhF9VgZVGmlmUL+EigWSCtybuJe4GtNg0Vq/BGRRuU5ce9raHG7AAq
        RXXMflHd+IOIw6Ceqb5iMsEmjUOieaQ0EjZr+NkNYcF8YrrL+jvM/X8KNUZkty+uaZu+kg
        PVpJEFIp/8oyoWbZCoLT5fy29ufNuEw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-115-Gin4huCPOJe5YyKpk8MkcQ-1; Tue, 11 Oct 2022 09:18:59 -0400
X-MC-Unique: Gin4huCPOJe5YyKpk8MkcQ-1
Received: by mail-qv1-f71.google.com with SMTP id q20-20020ad44354000000b004afb5a0d33cso7889500qvs.12
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 06:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TDCMSGvi/kRX/Ot4OPzT6z0p0kG2Pn06Pcb3KApka90=;
        b=0uEWa0KaJ3BowLoIWAmR3I8fpHBu9RAdidxGYBF3xKKtC7EwCrEhI6DFKA+vUM0moq
         tYpTfEW42MZQ2YeykCFtVpA895HPa9pRVy54lpbyRX1HRzofY4KSBD90AgCIyM9T5zfQ
         ZekB1izBV39Xjdyx+0iuVIaMoBo1rzgB+juSEzpFCQTGw57zHgA62Dc6TPMjYRQqcqkl
         vMcLlW4HEqJ5LPnUB0K/VURbpfHkmZr9hNdu3oilnsWoHCWRht4jcECDDAzC3+g52sT5
         k8nzVp3JJxrlvneWbklytZs3JhMVHpykah5Il+Oi9FYoQb3+BCyXO7jW7c6jADe2mjrr
         W2Jw==
X-Gm-Message-State: ACrzQf2lJBUZ0BvrjWM7e0UKWpEHicBYmZVko1O89WViIggtIbinE0Sh
        bCPpwSzlYcYIhCNv1oPXCg5wN26jdg+lr3ZyikdIrpretAmHnpulld9eHd0cGixJ3TWAV1ychTq
        KKnpo6rwzQQboSYJN
X-Received: by 2002:a37:b041:0:b0:6eb:cc8c:e9a9 with SMTP id z62-20020a37b041000000b006ebcc8ce9a9mr10117336qke.573.1665494338813;
        Tue, 11 Oct 2022 06:18:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7dIYhwlas6OZtmsmZiLfYVI7d5Nj1cy6lD86qqfVYrx394tNkaNREnLpBJxr4GzDttBy7txg==
X-Received: by 2002:a37:b041:0:b0:6eb:cc8c:e9a9 with SMTP id z62-20020a37b041000000b006ebcc8ce9a9mr10117317qke.573.1665494338566;
        Tue, 11 Oct 2022 06:18:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id q4-20020a05620a2a4400b006ee74cc976esm3069348qkp.70.2022.10.11.06.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 06:18:58 -0700 (PDT)
Message-ID: <126bda05a809cb53090675725a6c5ad51d439918.camel@redhat.com>
Subject: Re: [PATCH net-next v5 0/4] Implement devlink-rate API and extend it
From:   Paolo Abeni <pabeni@redhat.com>
To:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Date:   Tue, 11 Oct 2022 15:18:54 +0200
In-Reply-To: <20221011090113.445485-1-michal.wilczynski@intel.com>
References: <20221011090113.445485-1-michal.wilczynski@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-10-11 at 11:01 +0200, Michal Wilczynski wrote:
> This is a follow up on:
> https://lore.kernel.org/netdev/20220915134239.1935604-1-michal.wilczynski@intel.com/
> 
> This patch series implements devlink-rate for ice driver. Unfortunately
> current API isn't flexible enough for our use case, so there is a need to
> extend it.  Some functions have been introduced to enable the driver to
> export current Tx scheduling configuration.
> 
> In the previous submission I've made a mistake and didn't remove
> internal review comments. To avoid confusion I don't go backwards
> in my versioning and submit it as a v5.
> 
> V5:
> - removed queue support per community request
> - fix division of 64bit variable with 32bit divisor by using div_u64()
> - remove RDMA, ADQ exlusion as it's not necessary anymore
> - changed how driver exports configuration, as queues are not supported
>   anymore
> - changed IDA to Xarray for unique node identification
> 
> 
> V4:
> - changed static variable counter to per port IDA to
>   uniquely identify nodes
> 
> V3:
> - removed shift macros, since FIELD_PREP is used
> - added static_assert for struct
> - removed unnecessary functions
> - used tab instead of space in define
> 
> V2:
> - fixed Alexandr comments
> - refactored code to fix checkpatch issues
> - added mutual exclusion for RDMA, DCB
> 
> 
> 
> Michal Wilczynski (4):
>   devlink: Extend devlink-rate api with export functions and new params
>   ice: Introduce new parameters in ice_sched_node
>   ice: Implement devlink-rate API
>   ice: Prevent DCB coexistence with Custom Tx scheduler
> 
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   4 +-
>  drivers/net/ethernet/intel/ice/ice_common.c   |   3 +
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   4 +
>  drivers/net/ethernet/intel/ice/ice_devlink.c  | 467 ++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
>  drivers/net/ethernet/intel/ice/ice_idc.c      |   5 +
>  drivers/net/ethernet/intel/ice/ice_repr.c     |  13 +
>  drivers/net/ethernet/intel/ice/ice_sched.c    |  79 ++-
>  drivers/net/ethernet/intel/ice/ice_sched.h    |  25 +
>  drivers/net/ethernet/intel/ice/ice_type.h     |   8 +
>  .../mellanox/mlx5/core/esw/devlink_port.c     |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/esw/qos.c |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/esw/qos.h |   2 +-
>  drivers/net/netdevsim/dev.c                   |  10 +-
>  include/net/devlink.h                         |  21 +-
>  include/uapi/linux/devlink.h                  |   3 +
>  net/core/devlink.c                            | 145 +++++-
>  17 files changed, 767 insertions(+), 32 deletions(-)
> 
net-next is currently CLOSED,

Please repost when net-next reopens after 6.1-rc1 is cut.

Thanks,

Paolo

