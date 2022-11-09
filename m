Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46154623249
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiKISUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKISUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:20:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F7324F17;
        Wed,  9 Nov 2022 10:20:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CCF961C28;
        Wed,  9 Nov 2022 18:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF291C433C1;
        Wed,  9 Nov 2022 18:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668018036;
        bh=lHGIXa/gzMZc3tKmxe07xLxCc5ENdiRStUxmf+RJ76E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aDq7gFkVLaBFz3piUo2ROtjM7vxyTK0VgBb5MXkNJgRAbmWlBmTQAiI41f+1Fq2qu
         hkBF5vneS+6G0CgV0oggBnfm/bAMNfaMfflzjPZ8cCLyMC+11/bbC0LaTWC8z9KShf
         KEvyGPmr1uvvOjajknE8coL4wgOAepw9wtS7ip9S9Ed8mf7iJ/Z8fkvVZbYim3DyHw
         /CjzIqaQe8NMx0OCe2GRwOsKL4SZ42DEtNbTPZSJ03z7K5ixHbjnvnlvVElMzKTUAE
         hQKRXQgFBEbHSRD6K2dYHJ/IssE5VQhMrtpOw/7P2lXAzoDqsuMLK67aCu4bO3UtAn
         f/7fnsVKFTauA==
Date:   Wed, 9 Nov 2022 20:20:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, sassmann@redhat.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] iavf: Do not restart Tx queues after reset task
 failure
Message-ID: <Y2vvbwkvAIOdtZaA@unreal>
References: <20221108102502.2147389-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108102502.2147389-1-ivecera@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:25:02AM +0100, Ivan Vecera wrote:
> After commit aa626da947e9 ("iavf: Detach device during reset task")
> the device is detached during reset task and re-attached at its end.
> The problem occurs when reset task fails because Tx queues are
> restarted during device re-attach and this leads later to a crash.

<...>

> +	if (netif_running(netdev)) {
> +		/* Close device to ensure that Tx queues will not be started
> +		 * during netif_device_attach() at the end of the reset task.
> +		 */
> +		rtnl_lock();
> +		dev_close(netdev);
> +		rtnl_unlock();
> +	}

Sorry for my naive question, I see this pattern a lot (including RDMA), 
so curious. Everyone checks netif_running() outside of rtnl_lock, while
dev_close() changes state bit __LINK_STATE_START. Shouldn't rtnl_lock()
placed before netif_running()?

Thanks

> +
>  	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
>  reset_finish:
>  	rtnl_lock();
> -- 
> 2.37.4
> 
