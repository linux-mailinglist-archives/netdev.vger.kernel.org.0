Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AED04D2FBF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiCINMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbiCINMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:12:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26495128DCC;
        Wed,  9 Mar 2022 05:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QsyLvqtN/yV+ncyNzH22OgydtJL5VdIrk4utNTTIsnc=; b=qaQeA88+jr7QiC7JRb/KSCRxRp
        znTQn30epe+AV9TZClGAZrw2TcIgkEa1QYrQw92co4deoE+NQVFmJ+ip6DjFa+7AHNdbUWSTVhRhD
        pTZwTwcme9UU2YizvwLEQaTy27bk4BPHsX/bXsmwhIXchddn4Yd8hiiKedHcVhHG37hw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRw6a-009xq0-62; Wed, 09 Mar 2022 14:11:52 +0100
Date:   Wed, 9 Mar 2022 14:11:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <YiinmN+VBWRxN5l4@lunn.ch>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
 <YifMSUA/uZoPnpf1@lunn.ch>
 <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 11:30:00PM +0100, Horatiu Vultur wrote:
> The 03/08/2022 22:36, Andrew Lunn wrote:
> > 
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

The reason i recommend ipoll.h is that your implementation has the
usual bug, which iopoll does not have. Since you are using _atomic()
it is less of an issue, but it still exists.

     while (!(lan_rd(lan966x, QS_INJ_STATUS) &
              QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {

Say you take an interrupt here

             if (time_after(jiffies, time)) {
                     ret = -ETIMEDOUT;
                     break;
             }


The interrupt takes a while, so that by the time you get to
time_after(), you have reached your timeout. So -ETIMEDOUT is
returned. But in fact, the hardware has done its thing, and if you
where to read the status the bit would be set, and you should actually
return O.K, not an error.

iopoll does another check of the status before deciding to return
-ETIMEDOUT or O.K.

If you decide to simply check the status directly after the write, i
suggest you then use readx_poll_timeout_atomic() if you do need to
poll.

	Andrew
