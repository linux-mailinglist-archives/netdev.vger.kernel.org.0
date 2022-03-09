Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212BD4D25B6
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiCIBCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiCIBCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:02:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989A326B5A3;
        Tue,  8 Mar 2022 16:40:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED47612F0;
        Wed,  9 Mar 2022 00:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFB9C340EB;
        Wed,  9 Mar 2022 00:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646786426;
        bh=td/REnltt/bdfkFO3iQ1pNa5fzMHBJX93HnYjIUNMU0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ts0iiMK/LYgr5rc7RY5U3A8NnMAovEaaS73DZr34O+wVOTcSdSKsR1X3z649tFqLE
         6/FNGf8SK9ISttNNHTCR+nvmP+Jt+viPEfHxxvZgskWyAfutOVHhKAQw7O76sQjhNW
         ygtEoBhIRsxADOtxPEig3LBtt9Uj8D1a4jik129qzlOj6B+u0KvptshvxHj4rHkshD
         p95uuimevOO+c39T+i99lUTK83ssNIIAB2eKedUAv20+5jLMjhEB1vVZnW4zfA/5Ce
         ybW2vwLAG+lk1w9lIGk7vQhhqtaSdh8CEVdyRVvt7wpqoBM/AAgGtm7fDlxEL/4XSP
         hKwMlyNnQ+mTA==
Date:   Tue, 8 Mar 2022 16:40:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <20220308164024.5f65b426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
        <YifMSUA/uZoPnpf1@lunn.ch>
        <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
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

On Tue, 8 Mar 2022 23:30:00 +0100 Horatiu Vultur wrote:
> > >  static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
> > >  {
> > > -     u32 val;
> > > +     unsigned long time = jiffies + usecs_to_jiffies(READL_TIMEOUT_US);
> > > +     int ret = 0;
> > >
> > > -     return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
> > > -                                      QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
> > > -                                      READL_SLEEP_US, READL_TIMEOUT_US);
> > > +     while (!(lan_rd(lan966x, QS_INJ_STATUS) &
> > > +              QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
> > > +             if (time_after(jiffies, time)) {
> > > +                     ret = -ETIMEDOUT;
> > > +                     break;
> > > +             }  
> > 
> > Did you try setting READL_SLEEP_US to 0? readx_poll_timeout_atomic()
> > explicitly supports that.  
> 
> I have tried but it didn't improve. It was the same as before.

Huh, is ktime_get() super expensive on that platform?
jiffies vs ktime seems to be the main difference?
