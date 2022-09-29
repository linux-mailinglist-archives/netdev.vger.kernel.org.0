Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111C95EF899
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbiI2PXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiI2PXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:23:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BB91514D0
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:23:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5094461484
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 15:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B2CC433C1;
        Thu, 29 Sep 2022 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664465008;
        bh=YTe9P14YqLojcsFy0//pbq/oilNL4/PiTLUABmITT5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dKHScsEP9kA+srQPwLyWwY4qEkixRmiljWfWMcVQXtqIj483h+/LKx2b+cDCMzuHk
         rEKjuAf5TFwRKzyV00WRHtcr7b+YYaLs8PIcCOQuWD7qDU/3YNzPHElyPyvxgMlS6G
         yqRYsA0Jskxz53CwLoQeag48dsOhxk+pkyLgBaTfSGTqoCxHMbSlAapnE3JcYoaEly
         kztBxS8D4ScpirEnIewOVOxxQIgYd1tWPJCWhx7SnVR+nBjxnX36FQGkrOREZcHBw1
         W7s4kHESUFgVs+cn8o6PABkSpHFLOPpkEKuQgk9FiiDa9qU8nyivSUjW/aeWO01vWo
         NyrwNKlNunesA==
Date:   Thu, 29 Sep 2022 08:23:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP
 packets
Message-ID: <20220929082327.209d6227@kernel.org>
In-Reply-To: <6f6f4487-1c5d-de4e-0c79-452128deae0c@nvidia.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
        <20220927170919.3a1dbcc3@kernel.org>
        <SJ1PR11MB6180CAE122C465AB7CB58B1BB8579@SJ1PR11MB6180.namprd11.prod.outlook.com>
        <20220929065615.0a717655@kernel.org>
        <6f6f4487-1c5d-de4e-0c79-452128deae0c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 17:46:04 +0300 Gal Pressman wrote:
> What exactly do you mean by DMA stamps?
> 
> Our NIC supports two modes of operation (both TX/RX):
> - CQE timestamp (I think that's what you call DMA timestamp), where the
> timestamp is written when the completion is being written/generated.
> - Port timestamp (MAC timestamp), where the timstamp is written when the
> packet is being sent to the wire, or received from the wire. This
> doesn't account for the time the packet spent inside the NIC pipeline.
> 
> So I believe the answer to your question is yes :).

Thanks! I think we should provide the config API for both Tx and Rx,
then.
