Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D3455F41E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiF2DYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbiF2DYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:24:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0609BC08;
        Tue, 28 Jun 2022 20:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94655B81BAF;
        Wed, 29 Jun 2022 03:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC686C341C6;
        Wed, 29 Jun 2022 03:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656473056;
        bh=hEKpqsCTCBYl6X3gx6o4CGg4SOmuRDZ3EoHxt9IO4QA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IhmRobJSTIP86pLtSRAiaGG98BmiqQqGSXRMjhzDITCuEpkAwp5eCrogCu1DVC4Ih
         e50Vdb4galVkGeIOYFbI/eDIWJ/XXq1dFSQgyj2Gl8ZeRvKdg4kmOS22Y2QsjcQm0g
         UgGPMw7F2ZXVKKY8j16xQvZ6UDXgfrm+9kLh/kgRp2tXl2gbss9tg1MB3RC8A5gN60
         fqQjfkPXY+CIhOvcJcl2OIhwnq2PmJBxqIg8njS7vTeFcyC+OjTQRIPUoxiChWc2PA
         HOM0mvHoXbCDSZYWR9j9n71AS5hGnEjF+whcOpjJX03ScJmD8tMjAbk8C3uOylkekO
         0E5mkTI/KcKKQ==
Date:   Tue, 28 Jun 2022 20:24:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/3] ptp_ocp: implement DPLL ops
Message-ID: <20220628202414.02ac8fd1@kernel.org>
In-Reply-To: <20220628191124.qvto5tyfe63htxxr@bsd-mbp.dhcp.thefacebook.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
        <20220626192444.29321-4-vfedorenko@novek.ru>
        <20220627193436.3wjunjqqtx7dtqm6@bsd-mbp.dhcp.thefacebook.com>
        <7c2fa2e9-6353-5472-75c8-b3ffe403f0f3@novek.ru>
        <20220628191124.qvto5tyfe63htxxr@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 12:11:24 -0700 Jonathan Lemon wrote:
> > > 80-column limit (here and throughout the file)  
> > 
> > I thought this rule was relaxed up to 100-columns?  
> 
> Only in exceptional cases, IIRC.  checkpatch complains too.

Yup, for networking I still prefer 80 chars. 
My field of vision is narrow.

> > > 80 cols, and this should be done before ptp_ocp_complete()
> > > Also, should 'goto out', not return 0 and leak resources.  
> > 
> > I don't think we have to go with error path. Driver itself can work without
> > DPLL device registered, there is no hard dependency. The DPLL device will
> > not be registered and HW could not be configured/monitored via netlink, but
> > could still be usable.  
> 
> Not sure I agree with that - the DPLL device is selected in Kconfig, so
> users would expect to have it present.  I think it makes more sense to
> fail if it cannot be allocated.

+1
