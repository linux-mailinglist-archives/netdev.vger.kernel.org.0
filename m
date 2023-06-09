Return-Path: <netdev+bounces-9500-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B47729731
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0316281932
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6CB6A92C;
	Fri,  9 Jun 2023 10:42:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC003D2FA
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:42:50 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7EB422D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686307346; x=1717843346;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ncc3Frw5jy1newKhE18k3BwtG7xyYraXJTpIpYZ8x/4=;
  b=S58T2HwcGnCUbEsx+uYxGsRVkIC+I8a1ICEzisnP93EJNdZSw0wNqzlO
   j7oatZ6DSoZqN1tIO/2pvdZ93Vwa632UCL5bbO+ywu0uqN/v/mi8Saw+U
   NGgkyuiAuPYM8+Wio/KRreF8akSz4nTxh/yPhu6VYVNZ6OXruAUr8GHnR
   R1Ddu3yLSi7my1zEBTxhdc0aWqVO3JX5q8e33CBIfeU8DbfSIHKVaH5WP
   8kjsxwoVdcxE4hgrxQwXs89OjFtL3e+XDwWXz8l/WmGoTplrFb2FLNb1Y
   pfn0jEc52abokzdgxrv73BYdvIJEgjRXcDDyaie8MRW4wEb0PRSfGOlPh
   A==;
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="219567800"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jun 2023 03:42:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 9 Jun 2023 03:42:25 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 9 Jun 2023 03:42:24 -0700
Date: Fri, 9 Jun 2023 10:42:23 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH iwl-next v3 10/10] ice: update reset path for SRIOV LAG
 support
Message-ID: <20230609104223.5ok45syo7gfrtwev@DEN-LT-70577>
References: <20230608180618.574171-1-david.m.ertman@intel.com>
 <20230608180618.574171-11-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230608180618.574171-11-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Add code to rebuild the LAG resources when rebuilding the state of the
> interface after a reset.
> 
> Also added in a function for building per-queue information into the buffer
> used to configure VF queues for LAG fail-over.  This improves code reuse.
> 
> Due to differences in timing per interface for recovering from a reset, add
> in the ability to retry on non-local dependencies where needed.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

