Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC849547199
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 05:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349970AbiFKDZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 23:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346923AbiFKDZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 23:25:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752B69AE40;
        Fri, 10 Jun 2022 20:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654917908; x=1686453908;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UsYYyX+/SHIT1MvBl8yridNdLkGTwE+InRQzJyWqVk8=;
  b=AVX8ED7s85qa5f4tvTzCQ+T0FxbcvD3W9XM8qIprcoZazns8it69WeGm
   vJyU80oPagd3K/RioSrZKRMONCNEsK+lzR26S016Zw+PFBtXzkJAH/vwh
   kLNw4qahVFxo4u512Bqb1CH3ohQMw1ecHO2UxiG45h2bo5NupPJwbRxBs
   qJ7NyL/WEO9n/04YxmLzyl2qZYbQ9f7F2MRte43dWvesSc6PO31KZHlsO
   blCJBIa3kWA1rMMZhxwByxFky7Hgn7+M4ctBFTbGkFCjeCmn9fUKerc0v
   9KguYzpNj4VdheGLFk7ppfx/yw/lO4n/+/bKZ6C+AhLIzZkQTC8DQ60Me
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="364144661"
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="364144661"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 20:25:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="638503297"
Received: from jiaqingz-mobl.ccr.corp.intel.com (HELO [10.255.31.17]) ([10.255.31.17])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 20:25:06 -0700
Message-ID: <3c9fa928-f416-3526-be23-12644d18db3b@linux.intel.com>
Date:   Sat, 11 Jun 2022 11:25:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 0/6] Configurable VLAN mode for NCSI driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
 <20220610130903.0386c0d9@kernel.org>
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
In-Reply-To: <20220610130903.0386c0d9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-11 04:09, Jakub Kicinski wrote:
> On Sat, 11 Jun 2022 00:59:34 +0800 Jiaqing Zhao wrote:
>> Currently kernel NCSI driver only supports the "VLAN + non-VLAN" mode
>> (Mode #2), but this mode is an optional mode [1] defined in NCSI spec
>> and some NCSI devices like Intel E810 Network Adapter [2] does not
>> support that mode. This patchset adds a new "ncsi,vlan-mode" device
>> tree property for configuring the VLAN mode of NCSI device.
>>
>> [1] Table 58 - VLAN Enable Modes
>>     https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.0.0.pdf
>> [2] 12.6.5.4.3 VLAN
>>     https://cdrdv2.intel.com/v1/dl/getContent/613875
> 
> Please don't post the same patches more than once a day. You posted the
> same patches 3 times within 15 minutes with no major difference :/

Got it, sorry for misusing the mailing list. 

> Why is "ncsi,vlan-mode" set via the device tree? Looks like something
> that can be configured at runtime. 

Actually this cannot be configured at runtime, the NCSI spec defines no
command or register to determine which mode is supported by the device.
If kernel want to enable VLAN on the NCSI device, either "Filtered tagged
+ Untagged" (current default) or "Any tagged + untagged" mode should be
enabled, but unfortunately both of these two modes are documented to be
optionally supported in the spec. And in real cases, there are devices
that only supports one of them, or neither of them. So I added the device
tree property to configure which mode to use.
