Return-Path: <netdev+bounces-8757-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC7597258B7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24EF4281275
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936AB8C16;
	Wed,  7 Jun 2023 08:55:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890028C09
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:55:06 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A493C1994
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686128075; x=1717664075;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HQz4rwTqsDysvbrLsgRUKg34cXOPwy+EIaHfg0BVeu4=;
  b=fV+JUhiQHACBYrXBnF4QSem57GsZ7giB79somZQ62zH5aNeFBFRH7Fjt
   wQQwpajDTI4VqM687dQ9SUjyMytf1SLLF9bEObqGOsTMQALFsX0yu/JPe
   n0gBSoh5h5ttVjOBdohnzySr73jbqFfxmzV2juv1kA/b3KGdMpGy1w+ep
   fdlfQ2KpJR9pWBwJ1KKOwkOrPjjh3MA/zpRucBo51YyHth4xRvErfeTd3
   FwGm8SeXGjCvbsdI6hFYUkic/BkieTaj2AmpJiLWR0K2vFoVbvalPTYwv
   4uUyeL71hNJdPBSelOL4PVmTXToO86uufB0w/zt0Sw2PIX6sfGhpYaAnq
   A==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="219220402"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2023 01:54:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 7 Jun 2023 01:54:05 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 7 Jun 2023 01:54:04 -0700
Date: Wed, 7 Jun 2023 08:54:03 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 08/10] ice: enforce interface eligibility and add
 messaging for SRIOV LAG
Message-ID: <20230607085403.vm34kbnw2bajglse@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-9-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605182258.557933-9-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Implement checks on what interfaces are eligible for supporting SRIOV VFs
> when a member of an aggregate interface.
> 
> Implement unwind path for interfaces that become ineligible.
> 
> checks for the SRIOV LAG feature bit wrap most of the functional code for
> manipulating resources that apply to this feature.  Utilize this bit
> to track compliant aggregates.  Also flag any new entries into the
> aggregate as not supporting SRIOV LAG for the time they are in the
> non-compliant aggregate.
> 
> Once an aggregate has been flagged as non-compliant, only unpopulating the
> aggregate and re-populating it will return SRIOV LAG functionality.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>


