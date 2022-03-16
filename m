Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9AF4DB917
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 20:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345055AbiCPUBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244611AbiCPUA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:00:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAD56A04F
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 12:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529AD60FED
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 19:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B6EC340E9;
        Wed, 16 Mar 2022 19:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647460782;
        bh=ultL9CAuMrYi6naQcd/u8pT8X8fnpin6JUaqG9z1DCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uOX0vdneF+Kdmsa20/4qLB0KAkOPkJgTzNr5wZ7G815r67uG/PndKnmFT9fZfbO5v
         mpVTc2a/fW/Ifn3GkK/a0xdOJfysKI9oPkaX8P07UmaH/Ewb/6BpH7eupnM+ScMaRu
         iBIjVjjyTpQ1+YyYMst/bxV9QE73/8Kq7VATkX/VpaTdoDaju1cFisqMMmhFnfTx5n
         l9Mvl1DC1kgOY2ihh+3QZVICiS0cv0I9hrdEgxyCvPyn/6eO7nFSbpNABt+KslYvw6
         ZtFdV7LvHCV8pi07G1Wt5kCxojRpL87K0p/AQGGNl6BvIUT2tePBLYw4C/E/U20+LP
         MxQka+BqHIEHQ==
Date:   Wed, 16 Mar 2022 12:59:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Vaishnavi Bhat <vaish123@in.ibm.com>
Subject: Re: [PATCH net 1/1] ibmvnic: fix race between xmit and reset
Message-ID: <20220316125941.2a11d68e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316012315.1880265-1-sukadev@linux.ibm.com>
References: <20220316012315.1880265-1-sukadev@linux.ibm.com>
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

On Tue, 15 Mar 2022 18:23:15 -0700 Sukadev Bhattiprolu wrote:
> Subject: [PATCH net 1/1] ibmvnic: fix race between xmit and reset
> 
> There is a race between reset and the transmit paths that can lead to
> ibmvnic_xmit() accessing an scrq after it has been freed in the reset
> path. It can result in a crash like:

This one does not apply cleanly on net.
