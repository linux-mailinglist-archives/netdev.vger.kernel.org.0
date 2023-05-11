Return-Path: <netdev+bounces-1938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB5A06FFAF2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B475E1C20EE0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC10947B;
	Thu, 11 May 2023 20:00:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10D3206B0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:00:15 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3705276;
	Thu, 11 May 2023 13:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683835214; x=1715371214;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Q5gZor7ZoJyjEgavshxpohrnJsBgB2CTzJ8PmHxBTpI=;
  b=gVQFL4M66TYyV3Ur9HGnmk+sCZMy6uI/RFLKmB3VD0hGu/6v3bSTeBjc
   7NdKsEL0+PXLl4gXrO0/fiw+MrgkdoKvziYQCpmSVubfM9/uC6NV8Q3Sw
   MFbrbmUn7PXc5a7v5jYdeePD9XRaWEkUivmEp0gFTJx2dx3fzvR/mUW9f
   ie9zdM3HSelOHtlMDu9Ef+S9xaKFy+RDBpEPPf8uFPH1Uu2myOpSpq4WJ
   RsCPqdACM19ziQO6vtEfXAoVfcOGIF6dO4Ww6EPFVICTHxx/wMl73zGHQ
   NWyKw+N97CfYjbsWyzNW/F51ZmLeHEV0xOwfT13enP/x4Zj1ciAlwk7Yd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="378751728"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="378751728"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 13:00:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="702873995"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="702873995"
Received: from jsanche3-mobl1.ger.corp.intel.com ([10.252.39.112])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 13:00:05 -0700
Date: Thu, 11 May 2023 23:00:02 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
cc: linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>, 
    Rob Herring <robh@kernel.org>, 
    Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, 
    =?ISO-8859-2?Q?Krzysztof_Wilczy=F1ski?= <kw@linux.com>, 
    Lukas Wunner <lukas@wunner.de>, nic_swsd@realtek.com, 
    "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>, 
    LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/17] r8169: Use pcie_lnkctl_clear_and_set() for changing
 LNKCTL
In-Reply-To: <98b3b70a-86c0-78c0-b734-0764bb5a21fc@gmail.com>
Message-ID: <985b617-c5d7-dce3-318b-f2f8412beed3@linux.intel.com>
References: <20230511131441.45704-1-ilpo.jarvinen@linux.intel.com> <20230511131441.45704-15-ilpo.jarvinen@linux.intel.com> <98b3b70a-86c0-78c0-b734-0764bb5a21fc@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-2047432099-1683835210=:1900"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2047432099-1683835210=:1900
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 11 May 2023, Heiner Kallweit wrote:

> On 11.05.2023 15:14, Ilpo Järvinen wrote:
> > Don't assume that only the driver would be accessing LNKCTL. ASPM
> > policy changes can trigger write to LNKCTL outside of driver's control.
> > 
> > Use pcie_lnkctl_clear_and_set() which does proper locking to avoid
> > losing concurrent updates to the register value.
> > 
> 
> Wouldn't it be more appropriate to add proper locking to the
> underlying pcie_capability_clear_and_set_word()?

As per discussion for the other patch, that's where this series is now 
aiming to in v2.

-- 
 i.

--8323329-2047432099-1683835210=:1900--

