Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD8658446D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiG1Qxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiG1Qxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:53:46 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608487436B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:53:44 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id m16so1833624qka.12
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xGVPmZSPrbx+eKc83ja2PpqsvLm/DDS+QFGGJ9xOY4g=;
        b=Q6NVBueFd1MERNeCHWlZriu8t3DSS4Vh5eg8xjAwp+mj77zvsaROKzSgr5ponhokAm
         hQ1DRpdJ0f0KwgNA4laYrazBJ8TXkUJliDtljK8/n+ZXTdPi9ElJsmaKxUNvBbDYutzE
         BlWWjW30PpEqtWNA0GY5AZPUXsVuRqQkXyVnrJnWBNOrbZO2wbtqSsSCAdr8HH8jUsgr
         Qzd1081JdtoeNc6KW8DwjeOnmfOZ/BBalk1zjyGR1wbxguXVFgeT2C3Qp9cxlyWgg/G0
         mdUTCbD3USjmp3BFvPTNPMVrufp2v22xn9SrllvRj/rWgowPyxjVyUacMtPeXjSEE37W
         P4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xGVPmZSPrbx+eKc83ja2PpqsvLm/DDS+QFGGJ9xOY4g=;
        b=F41UtOE4L3i+vfN2GI42LzVVEmGaObu0jncpYsP0WNh8QJ7fwravvSon0t+PqNUgdL
         GvpX7I0P+aBVnb0Kuljcp2kLL7Z0jc3wOxLE631ErdYnDzFnFlZSEDC4ZQTWqaiB2fnE
         4nAoKqsZ9WzYaDcr2dqgxCVMUPxLjLusvNHxuXdEfPFRuA3TJ5929CiRkiMYo8lQbNS9
         YBwVi/UGZ95ldufLJykh3yUEzos9CBsfwu60qYTb1Nz35IzOkj0pOKGTNpGlosMmZs5l
         ZDlvPYhqbvfVpW8bKk+Pp14lPZcqybEzEPDTuroS2lJTLVSHGpZRSpJK/jxKLUjEcsxc
         BDzg==
X-Gm-Message-State: AJIora+84nXnapDn5/n00YrgapC5HTp4njLFIqvzdZcg0TREHWhkWfAP
        j6i17/Pwr5ORCXi93kXI1M1Yew==
X-Google-Smtp-Source: AGRyM1vTkbqOAk/zj3B6akQKXO1r+tl0s/E1AShNSvjVsV09iOkh2TMcmnz+vWyiVYdnwXH0Z+Q6hA==
X-Received: by 2002:ae9:f704:0:b0:6b2:42da:3ad with SMTP id s4-20020ae9f704000000b006b242da03admr20741386qkg.439.1659027223429;
        Thu, 28 Jul 2022 09:53:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id ay43-20020a05620a17ab00b006b66d9dd916sm809067qkb.32.2022.07.28.09.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 09:53:42 -0700 (PDT)
From:   Jason Gunthorpe <jgg@ziepe.ca>
X-Google-Original-From: Jason Gunthorpe <jgg@nvidia.com>
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oH6lZ-001DFn-FG;
        Thu, 28 Jul 2022 13:53:41 -0300
Date:   Wed, 27 Jul 2022 15:17:55 -0300
To:     Michael Guralnik <michaelgur@nvidia.com>
Cc:     leonro@nvidia.com, maorg@nvidia.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com
Subject: Re: [PATCH rdma-next v1 0/5] MR cache cleanup
Message-ID: <YuGBU4QqOVJRUM77@nvidia.com>
References: <20220726071911.122765-1-michaelgur@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726071911.122765-1-michaelgur@nvidia.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 10:19:06AM +0300, Michael Guralnik wrote:
> Hi,
> 
> In this series, Aharon continues to clean mlx5 MR cache logic.
> 
> Thanks
> 
> v1: Change push_mkey to eliminate locking on mail flow
> v0: http://lore.kernel.org/all/cover.1654601897.git.leonro@nvidia.com/
> 
> Aharon Landau (5):
>   RDMA/mlx5: Replace ent->lock with xa_lock
>   RDMA/mlx5: Replace cache list with Xarray
>   RDMA/mlx5: Store the number of in_use cache mkeys instead of total_mrs
>   RDMA/mlx5: Store in the cache mkeys instead of mrs
>   RDMA/mlx5: Rename the mkey cache variables and functions

Applied to for-next, thanks

Jason
