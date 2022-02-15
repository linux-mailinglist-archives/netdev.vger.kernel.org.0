Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F3B4B70D9
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbiBOP6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:58:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238710AbiBOP63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:58:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ED3BD2F9;
        Tue, 15 Feb 2022 07:58:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1DCD6173A;
        Tue, 15 Feb 2022 15:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB07C340EB;
        Tue, 15 Feb 2022 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644940698;
        bh=METPB92CtNbr6/d2L9GqXB2/kwPevXX1yNucGxSNXmE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dEdeMFUxg/2iUjXJZUkI26sBeNbtJZ1nmzy6ny2Wfjd4WPddAoev9Refn+mdZssgi
         5Iy1xJuuz14QDQDZO3L6YwsWpIiVnG3xavGMamRBOibB6ThAH5fD1+EJMcISjuxgSf
         63CPivcTBMEB22svZ0rdC13VHAiq4nb9esFm3em2GzP12n+hNqbYwkllvFjaH8Vk1l
         zUbqSZqsBRldRQPABcnCTybfLWY134UdEhFTCn3PHXPJq4uhbjSiUOlWBy4s6k3Cf4
         HUkPc6t/rQvwS+RlP+vlpPNlfikaNR942cFpPmbTLWZNGvMT+96v1vmm/Bj/OrtYOl
         EbDDfs202xImQ==
Date:   Tue, 15 Feb 2022 07:58:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     Wolfram Sang <wsa@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Subject: Re: [PATCH net-next v5 2/2] mctp i2c: MCTP I2C binding driver
Message-ID: <20220215075816.4188df1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e891478fbb4c3a5a5b44d13c5ce3557a884d10f5.camel@codeconstruct.com.au>
References: <20220210063651.798007-1-matt@codeconstruct.com.au>
        <20220210063651.798007-3-matt@codeconstruct.com.au>
        <20220211143815.55fb29e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b857c3087443f86746d81c1d686eaf5044db98a7.camel@codeconstruct.com.au>
        <20220214210410.2d49e55f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e891478fbb4c3a5a5b44d13c5ce3557a884d10f5.camel@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 18:01:25 +0800 Matt Johnston wrote:
> Thanks. I'll just make sure to kthread_stop() prior to calling unregister. It
> looks like the kthread needs to keep running when the interface is down to
> handle MCTP release timeouts which unlock the i2c bus, so can't use ndo_stop.
> 
> Similarly for the RX path, can I safely call netif_rx(skb) after unregister?
> It looks like in that case it should be OK, since enqueue_to_backlog() tests
> for netif_running() and just drops the packet. (It's running from the I2C
> slave irq so can't just use a mutex).

I wouldn't do it, using an object after it's unregistered is asking for
trouble. RPS seems to happily dereference skb->dev. It may or may not
work.
