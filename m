Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CED5ED2A5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 03:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiI1B3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 21:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbiI1B3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 21:29:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1829012757
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 18:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50825B81E83
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96695C433D6;
        Wed, 28 Sep 2022 01:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664328574;
        bh=+ASddU7/J6rYDjBNj8P5NKAvmkMXqg59oNQ1ho7jFp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=boK5CRnGFqmwG5KWpjeLP8pk/waoUPXUYjWzMLxLJkn1+Nz5abVSGjfqSmRk14IXA
         rmX5Xpiv2oCKRXU4Jc7HfzonQVPzRXYtpVdlqnojJfJze7g3UAkKJJw+CegFKtgtd3
         smrHnM5B2J6P25i5r6OLrjo7BhK/TDh+TICrA0XphaT5bCZ2cebB3sP+gejbmHWKAk
         0oOTfobxTNdd6BNROo1TUcnWWq2qih5DnolVKeE6IBd4t2ZPnHL+N8JCdZv4Pn81ht
         3y7G/EBp01dcHPLlBe1KiCswC1HbJoZo3vzMetqiBMqoJSvtnTw8HeOVypD1ktVUEE
         cie59s0nR2MFQ==
Date:   Tue, 27 Sep 2022 18:29:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Michal Jaron <michalx.jaron@intel.com>, netdev@vger.kernel.org,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
Message-ID: <20220927182933.30d691d2@kernel.org>
In-Reply-To: <20220926203214.3678419-3-anthony.l.nguyen@intel.com>
References: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
        <20220926203214.3678419-3-anthony.l.nguyen@intel.com>
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

On Mon, 26 Sep 2022 13:32:13 -0700 Tony Nguyen wrote:
> During tx rings configuration default XPS queue config is set and
> __I40E_TX_XPS_INIT_DONE is locked. XPS CPUs maps are cleared in
> every reset by netdev_set_num_tc() call regardless it was set by
> user or driver. If reset with reinit occurs __I40E_TX_XPS_INIT_DONE
> flag is removed and XPS mapping is set to default again but after
> reset without reinit this flag is still set and XPS CPUs to queues
> mapping stays cleared.
> 
> Add code to preserve xps_cpus mapping as cpumask for every queue
> and restore those mapping at the end of reset.

Not sure this is a fix, are there other drivers in the tree which do
this? In the drivers I work with IRQ mapping and XPS are just seemingly
randomly reset on reconfiguration changes. User space needs to rerun its
affinitization script after all changes it makes.

Apart from the fact that I don't think this is a fix, if we were to
solve it we should shoot for a more generic solution and not sprinkle
all drivers with #ifdef CONFIG_XPS blocks :S
