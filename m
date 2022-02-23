Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8744C0AC3
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiBWD7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiBWD7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:59:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9758F59A65
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 19:59:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F6F1B81C1F
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B041EC340E7;
        Wed, 23 Feb 2022 03:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645588755;
        bh=4HuVuXakTIeHVIRBqrxok+jDLeLJod81Ni1LrIiuLl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T9ePnNNGGa0IOyfBTVQD1P+T2aOl5eLVppnq1eRrdbuWn1OWvcynPrEF83wO2hirl
         Vu8qjFSJltTJ4wqRdy9rYPLVN3HMP0JFODIGbUg+8awlXrQIW1ue2+50boMEAZCWnw
         PQqDwMHO7lR4+pOqn6M4F8/ujOmOPk8FIenedeP9Ov+Vo8g2byDX7EVuOzZeBMySgG
         aPQTPkegKVbshERrTFKCUU9OnbwPARpFgclzn0nXe9XHCClJj2C1yBIP6G2zT3oxK6
         ygmsTXfUwLQyXfvxVTaHYsnk0WVsgfSrpfPjZ7J6k5g6QzGki5ImdpcI6kONGGP+Pt
         7uLE9y+GgeJig==
Date:   Tue, 22 Feb 2022 19:59:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     Matt Johnston <matt@codeconstruct.com.au>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 1/2] mctp: make __mctp_dev_get() take a
 refcount hold
Message-ID: <20220222195914.6f001f66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222041739.511255-2-matt@codeconstruct.com.au>
References: <20220222041739.511255-1-matt@codeconstruct.com.au>
        <20220222041739.511255-2-matt@codeconstruct.com.au>
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

On Tue, 22 Feb 2022 12:17:38 +0800 Matt Johnston wrote:
> Previously there was a race that could allow the mctp_dev refcount
> to hit zero:
> 
> rcu_read_lock();
> mdev = __mctp_dev_get(dev);
> // mctp_unregister() happens here, mdev->refs hits zero
> mctp_dev_hold(dev);
> rcu_read_unlock();
> 
> Now we make __mctp_dev_get() take the hold itself. It is safe to test
> against the zero refcount because __mctp_dev_get() is called holding
> rcu_read_lock and mctp_dev uses kfree_rcu().

Jeremy, did you have any specific semantics or naming scheme in mind
here? PTAL. Is it better to make __mctp_dev_get() "safe" or create
mctp_dev_get()? etc
