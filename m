Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D964C4A0D
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242570AbiBYQE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237102AbiBYQE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:04:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4861A1C7E
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:04:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32DAE61AE3
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 16:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB0FC340F0;
        Fri, 25 Feb 2022 16:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645805063;
        bh=rKQl9JJOocK/8eSbFcZRij5fb1ky9WqTUIB/hLWvQMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E4hklcDVD8ivVbYHHu6Yyk6JgGMw881oYaW1XwkM7T/mQhsHqM4O6uY+moOOeLR6j
         9Rtzg9uBCepl7cBp/H8USlrqVGglXSz+Ku9eWKAtIsvD8j23BuQ6fE8U7mVYyWsflI
         C1a12eAncX6apKz9+kdrZvnlh1U8psYKWoEdbuR6+LjcdX3Qi/QEk4fX60cjKBKnBN
         kP5SZrLAwYAZu8uezk6n+FIORwfwP4ioR6j8tOL7Tpmzyw6NWGSnV83OU53WXigrJe
         PF8kUE+EL3Hpy2JDtAKVcEtnSu+z3kiizYarT/laloJ9FPBoAVPzkY4XbpQXeJqMfW
         8U+HyGbCn+Jzg==
Date:   Fri, 25 Feb 2022 08:04:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <jiri@nvidia.com>, <razor@blackwall.org>,
        <roopa@nvidia.com>, <dsahern@gmail.com>, <andrew@lunn.ch>,
        <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 03/14] net: rtnetlink: RTM_GETSTATS: Allow
 filtering inside nests
Message-ID: <20220225080422.7551b855@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <87a6effiup.fsf@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
        <20220224133335.599529-4-idosch@nvidia.com>
        <20220224221447.6c7fa95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87a6effiup.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022 09:22:19 +0100 Petr Machata wrote:
> > Why use bitfield if we only use the .value, a u32 would do?  
> 
> The bitfield validates the mask as well, thereby making sure that
> userspace and the kernel are in sync WRT which bits are meaningful.
> 
> Specifically in case of filtering, all meaningful bits are always going
> to be the set ones. So it should be OK to just handroll the check that
> value doesn't include any bits that we don't know about, and we don't
> really need the mask.

Nothing that NLA_POLICY_MASK() can't do, right? Or do you mean that 
we can when user space requests _not_ to have a group reported?
 
> So I can redo this as u32 if you prefer.

I think that'd be better, simplest tool for the job.
