Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143ED537869
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbiE3JzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbiE3JzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:55:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813AC4C7A2;
        Mon, 30 May 2022 02:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653904510; x=1685440510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2+hk4ostrY+MgPjlK3LLl5aBonfXPFHwp7H2wGkBm0A=;
  b=l2WflFQLF2yT+A3ZswKmNutlIVWnZhi2sEpaVzFBgVyXDo3+XenWIerB
   rTQR8vXy+/PbZaotYbDl9xtNG3UnZd/+QPruXQStiSEnvTaYXet8GHArs
   QZO0qPn5HYRTSnX39HfvYlszt7MfPyFM63Wxur7iInHfbi9tbF+Ed3b+y
   /J7Ifg52diiw4OpS9D1P7tokENsrr5wrdyoeQ4pIorAJod4/G22BIYZLm
   eBj+/mYklUcEB8qOkidQIXl0ccJz9vCj6QHCjrPDGtWZDUzR+CMOHgUZt
   P5x6S4sp4sbG/wPoiKXsDUdzITCikkxS/y/CX5h92M2Wi+NU2JXh39pkj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10362"; a="272527404"
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="272527404"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 02:55:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="666452045"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 30 May 2022 02:55:07 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 24U9t6o1022718;
        Mon, 30 May 2022 10:55:06 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: fix invalid structure access
Date:   Mon, 30 May 2022 11:53:53 +0200
Message-Id: <20220530095353.1237458-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527222905.chagmk4wfresegfg@sx1>
References: <20220527110132.102192-1-alexandr.lobakin@intel.com> <20220527222905.chagmk4wfresegfg@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Fri, 27 May 2022 15:29:05 -0700

> On 27 May 13:01, Alexander Lobakin wrote:
> >After pulling latest bpf-next, I started catching the following:

[...]

> We have a similar patch that is being reviewed internally.
> I don't like comparing strings to match devices. Also this could cause mlx5
> unwanted aux devices to be matched, e.g mlx5e, mlx5_ib, mlx5v, etc .., since
> they all share the same prefix ? yes, no ? 
> 
> We also have another patch/approach that is comparing drivers:
> 
> 	if (dev->driver != curr->device->driver)
> 		return NULL;
> 
> But also this is under discussion.

Ok, I spotted that implementation in your repo at korg, hope it will
hit mainline trees soon.

> 
> I think the whole design of this function is wrong, it's being used to match
> devices of type mlx5_core_dev which are pci devices, but it is using aux class
> to lookup! It works since we always have some aux devices hanging on top of
> mlx5_core pci devs and since all of them share the same wrapper structure
> "mlx5_adev" we find the corresponding mdev "mlx5_core_dev" sort of correctly.

[...]

> >-- 
> >2.36.1

Thanks,
Al
