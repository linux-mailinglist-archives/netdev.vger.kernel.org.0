Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286B16796B9
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbjAXLdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbjAXLdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:33:51 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597DA29412;
        Tue, 24 Jan 2023 03:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674560023; x=1706096023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tTmTjWwJXmzO49OJW8xcC/9yV2HJVoUxBo+EOvwGkKk=;
  b=QxjbXdaPurtmLBjytmYtkXymycO8yJiEr1ikUxenwmEEMCIdeP4EgW36
   OtlaPgL/vulq2TuWaIkPemAIGygE73THeT852qNyiaokf5SnGDOINQ2qD
   l8AYzTMBFVR0BqsdFS9PF74Y0h8J93r5KY781XJb4oUN7flVjLdHOGpQ2
   N184dbLPxZZbuNdT2SJVrEXgEAJa8cd/7o6oUYbbaDfGCx1nhJCLDzhEw
   ByQXorytV5hkVKqdJMcX2ty2vqVaPFxdDah3Z5KgYmAfibztfXKgy0UAK
   2ib4Q+YjxpYI6c+cULQwDyZsAXkud1ANhrYD4ARDDtNE5a/2ZJs7XucDr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="328364803"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="328364803"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 03:33:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="639554572"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="639554572"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.12.3]) ([10.13.12.3])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 03:33:39 -0800
Message-ID: <7a387e20-68e0-4c08-7ef4-11cb41f79e51@linux.intel.com>
Date:   Tue, 24 Jan 2023 13:33:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH 8/9] igc: Remove redundant
 pci_enable_pcie_error_reporting()
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20230118234612.272916-1-helgaas@kernel.org>
 <20230118234612.272916-9-helgaas@kernel.org>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20230118234612.272916-9-helgaas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/2023 01:46, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> pci_enable_pcie_error_reporting() enables the device to send ERR_*
> Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
> native"), the PCI core does this for all devices during enumeration.
> 
> Remove the redundant pci_enable_pcie_error_reporting() call from the
> driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> from the driver .remove() path.
> 
> Note that this doesn't control interrupt generation by the Root Port; that
> is controlled by the AER Root Error Command register, which is managed by
> the AER service driver.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 5 -----
>   1 file changed, 5 deletions(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
