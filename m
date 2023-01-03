Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E68865C728
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 20:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238929AbjACTPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 14:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbjACTOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 14:14:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30561580F;
        Tue,  3 Jan 2023 11:13:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63A8C614E2;
        Tue,  3 Jan 2023 19:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83932C433EF;
        Tue,  3 Jan 2023 19:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672773204;
        bh=tSDPzU+5kzmh6ydrbMl2dVR41MTdLf+q1kWvPUFZiMQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=GXdurLDeCh4toqDsgsNdnN0cas4HphRoxVFcL2Ador31DDslwyfyYYpWlYjJ1Ikoy
         sLOkGN5PxQbrECiOYSTQxSpM1DQeQwn02nTrC5bPgHVkWhLpVaLRo/XLOaorozlqiU
         ibVxkw03ELSmdIdt5Rk/JLMiAQ1paw5pPbExims1JifDMGoZ1u1CpMXanE2Ujektyj
         7moyyLaPT0trnYAi526orDa0pke8u9j9cpi7RPKCmcI+NT3Snyv0BPEGSqtzSih9y9
         rfR3naI3KI9yqltuz/rTjS73lC3FNmy2JXvBbTTKLO4KMoy8BUZG3BOAftg5bpaP8z
         FFoxr144M11Ow==
Date:   Tue, 3 Jan 2023 13:13:23 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Khandelwal, Rajat" <rajat.khandelwal@intel.com>
Cc:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Rajat Khandelwal <rajat.khandelwal@linux.intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "naamax.meir" <naamax.meir@linux.intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Mushayev, Nikolay" <nikolay.mushayev@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Efrati, Nir" <nir.efrati@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
Message-ID: <20230103191323.GA1011840@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB483539867F2BABC92F586F8696F49@CO1PR11MB4835.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 06:58:36AM +0000, Khandelwal, Rajat wrote:
> ...
> The reason I masked inherently is I witnessed a function
> netxen_mask_aer_correctable() inside
> net/ethernet/qlogic/netxen/netxen_nic_main.c, which masks the
> correctable errors in the corresponding PCIe device.

In my opinion, netxen_mask_aer_correctable() should not exist.  The
PCI core should own the PCI_ERR_COR_MASK register.

netxen_mask_aer_correctable() was added by dce87b960cf4 ("netxen: mask
correctable error") with the note that it is a "HW workaround."  Maybe
it covers up some hardware defect in the device, although it doesn't
include any evidence of this.

But if we do actually need it, I would rather have the driver set a
quirk bit that the PCI core can use to mask correctable errors so the
AER configuration is all in one place.

Bjorn
