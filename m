Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806214D289F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 06:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiCIF7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 00:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiCIF7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 00:59:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14036EB2A;
        Tue,  8 Mar 2022 21:58:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EEDEB81F3A;
        Wed,  9 Mar 2022 05:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F20C340E8;
        Wed,  9 Mar 2022 05:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646805532;
        bh=nBdw0PFUgI9rHcAMdSksgHJv8MFwbw+evuLD7B1lrrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H9SDN6dCekoDWiMzcWpMmr4TZ8DLnTG/mH9dAhFGw43kPtWr4qQGHrJAYky+XfRln
         NqXlDqTboGbeJ4pc7/ZPZA/tjHWOIJEV4FPMIJ9D0BrVRIRy727pcHFV4LlevSr4iQ
         MLvMQiKV5Rxuiu3AfyhFBB5HHHSUEfRlTJxYE38FWDb0vYHWnq6zIHr6+6p0Yejctz
         +bdAaDZfmW4gQPhPAEXDm2vL1PDuxd+4ZgB0sYsiKKwdpWc4YfAVCIkWjhfoaM4q5v
         uvv0XKxVNm2sIBoTUxgszLf4KsfA86zqkXFA0PbusMPYBvIVWYUqNIXw8czQRE5E8R
         tKnEC/XC4+oDw==
Date:   Tue, 8 Mar 2022 21:58:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kleber Sacilotto de Souza <kleber.souza@canonical.com>
Cc:     davem@davemloft.net, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] net: netdevsim: fix byte order on ipsec debugfs file
Message-ID: <20220308215851.397817bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220308135106.890270-1-kleber.souza@canonical.com>
References: <20220308135106.890270-1-kleber.souza@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Mar 2022 14:51:06 +0100 Kleber Sacilotto de Souza wrote:
> When adding a new xfrm state, the data provided via struct xfrm_state
> is stored in network byte order. This needs to be taken into
> consideration when exporting the SAs data to userspace via debugfs,
> otherwise the content will depend on the system endianness. Fix this by
> converting all multi-byte fields from network to host order.
> 
> Also fix the selftest script which was expecting the data as exported by
> a little-endian system, which was inverted.
> 
> Fixes: 7699353da875 ("netdevsim: add ipsec offload testing")
> Fixes: 2766a11161cc ("selftests: rtnetlink: add ipsec offload API test")
> Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>

Then the struct members need to have the correct types, 
as is this patch adds sparse warnings (build with C=1).
