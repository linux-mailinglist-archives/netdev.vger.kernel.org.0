Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9014DCAD9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbiCQQMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbiCQQMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B480F214F85;
        Thu, 17 Mar 2022 09:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5146660F77;
        Thu, 17 Mar 2022 16:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF3FC340E9;
        Thu, 17 Mar 2022 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647533466;
        bh=DipHHogWaewP/FbS/bJMU0tYn92ipv83Ht+R98R5vt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EXCr8puBCcTF1evc3yydkeMu6vvvojbBLLTdSyKk40ZNklT859Qnq6nnvbc0wipId
         +KnFe28cqBEFqFA+aYb3hLYP6OD7Qqi+LfklWIxbSDNtPgq/hqcWcS5PAPGGLhwF45
         LzHaJutqvOuTh/STuaLX7U8JMymrRm+vaGgfYjLbZkAMcVoCIw51hYF9k+JDxReoZH
         sICvY13gwyuTYYJDutbphlu3+pZuiwu6RP5ChyWquRbez1nTxcsTqLsfh71vT9Lp4r
         H8vUOkC2iXo/IeKX6k7TkaBwb255O/bJwyCw73oyaQOL8r+/KyfIP0ONefwhAg1GZb
         enxP06EGUVvKg==
Date:   Thu, 17 Mar 2022 09:11:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        poros@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] iavf: Fix hang during reboot/shutdown
Message-ID: <20220317091104.1d911864@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220317104524.2802848-1-ivecera@redhat.com>
References: <20220317104524.2802848-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Mar 2022 11:45:24 +0100 Ivan Vecera wrote:
> Recent commit 974578017fc1 ("iavf: Add waiting so the port is
> initialized in remove") adds a wait-loop at the beginning of
> iavf_remove() to ensure that port initialization is finished
> prior unregistering net device. This causes a regression
> in reboot/shutdown scenario because in this case callback
> iavf_shutdown() is called and this callback detaches the device,
> makes it down if it is running and sets its state to __IAVF_REMOVE.
> Later shutdown callback of associated PF driver (e.g. ice_shutdown)
> is called. That callback calls among other things sriov_disable()
> that calls indirectly iavf_remove() (see stack trace below).
> As the adapter state is already __IAVF_REMOVE then the mentioned
> loop is end-less and shutdown process hangs.

Tony, Jesse, looks like the regression is from 5.17-rc6, should 
I take this directly so it makes 5.17 final?
