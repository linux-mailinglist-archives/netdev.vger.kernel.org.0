Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDA7638D9D
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiKYPou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKYPot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:44:49 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A4022BD4
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669391088; x=1700927088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HwacmlHrrFMnQ7z+fyLWh50CXvxu/q9N5ugxCiHs9E4=;
  b=e8B+vDV9gCsVMefePTb4luncu+okM9twURkxgUrvUCJfqPYKHsfumPPR
   mfEBsZnTVR5zaejeAh7j1NmJpkzdHfxwY80BizYWjSrkijP+pyHjE7QSs
   7JaAaComYUSarPVjh9aHb4Ae5V1++3DSMFA7ERMKBUMsQVs23HwNzKXmt
   25znzWc1huvEEgQkQgYaAh+gIqU8UTVBS1IEfdNB61An/lXmMg3obs5nX
   Mht2nbquDf2cPixNbgG2NkB44Hgea3IU9Cs3PTOmIuCu2qx+e9Hqsup61
   1R9QgSjVzr+Y46HUqO/Fw4uigkGZs83Jcl2KOwUB8mhqLh5cebkJ5VCb9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="315660682"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="315660682"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:44:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="636600136"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="636600136"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 25 Nov 2022 07:44:46 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2APFiiHd002647;
        Fri, 25 Nov 2022 15:44:44 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, ecree.xilinx@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [RFCv8 PATCH net-next 00/55] net: extend the type of netdev_features_t to bitmap
Date:   Fri, 25 Nov 2022 16:44:21 +0100
Message-Id: <20221125154421.82829-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>
Date: Sun, 18 Sep 2022 09:42:41 +0000

> For the prototype of netdev_features_t is u64, and the number
> of netdevice feature bits is 64 now. So there is no space to
> introduce new feature bit.
> 
> This patchset try to solve it by change the prototype of
> netdev_features_t from u64 to structure below:
> 	typedef struct {
> 		DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
> 	} netdev_features_t;
> 
> With this change, it's necessary to introduce a set of bitmap
> operation helpers for netdev features. [patch 1]

Hey,

what's the current status, how's going?

[...]

> -- 
> 2.33.0

Thanks,
Olek
