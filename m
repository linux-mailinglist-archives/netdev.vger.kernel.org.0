Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBAB5732B0
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbiGMJbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiGMJau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:30:50 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B48EF510B;
        Wed, 13 Jul 2022 02:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=kLBQYCUDgt/w+rK5ClHja0x3VM6zWl/k45w0S9fdM/Y=; b=RGHFMcif0AxOj2Oc9IXRTmEqOc
        AGEtCvzK176Z5vs1TghjkopX7I1YOze1rFn820J1lfXKZBwjLbBxQoSlRjGVgCnJqZNPUdGLarNen
        T//Wzu0O+1ZbwetmqqInZye5G3UTrNk6ibJyRf3FcQRy9TvCISO2V48l0StXjcczwA5xoz8gn2xRF
        dGqMHk8ou9cuEqXt7bJDaiNN3N03upBDjT7OdTJ1Vk3byWCTUFCvXDrC0HD7V4hhWOiNUyUazLzcg
        bOAgaaKM8aB8f3MzsjHCyRTjGVktIxJAro3FPaZuPEnXNwnU9IucgzrA+mjAulQt7dsHW7uCw/c74
        TXZsxmIUSWT0PwsNHLB8Qu5PIaY7qxi3GaLO7dDmErr1cmlVBa5WC2fZpb5+drrYeLhNd9Qv2yv3o
        d2r2IGHTofvH4vloBx2pVng59d9p7nL++5IEflvUQLq9dL6nkBh+mvkenXYKH12mrEukhHAQ4456O
        6DChGhBJAq0cpPc2uWT450SOfEZPNQ2pbsBJ5pi+Y7NByACTwM2OKaoOxrxMxuEN5FCHA4WJzr9JL
        ploE38tZsS698LkNEnjDy/XwpMJ9W6795ErJ+kx3sRFmWHNFNEIOfydWhFXNaluomeIs1tUWeOoM7
        dll19TD9TQDw01htaeFCRyX1PbIZ/pNeabwvlVkl0=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [V9fs-developer] [PATCH v5 11/11] net/9p: allocate appropriate reduced
 message buffers
Date:   Wed, 13 Jul 2022 11:29:13 +0200
Message-ID: <1998718.eTOXZt5M9a@silver>
In-Reply-To: <4284956.GYXQZuIPEp@silver>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <Ys3jjg52EIyITPua@codewreck.org> <4284956.GYXQZuIPEp@silver>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mittwoch, 13. Juli 2022 11:19:48 CEST Christian Schoenebeck wrote:
> On Dienstag, 12. Juli 2022 23:11:42 CEST Dominique Martinet wrote:
> > Dominique Martinet wrote on Wed, Jul 13, 2022 at 04:33:35AM +0900:
> > > Christian Schoenebeck wrote on Tue, Jul 12, 2022 at 04:31:36PM +0200:
> > > > So far 'msize' was simply used for all 9p message types, which is far
> > > > too much and slowed down performance tremendously with large values
> > > > for user configurable 'msize' option.
> > > > 
> > > > Let's stop this waste by using the new p9_msg_buf_size() function for
> > > > allocating more appropriate, smaller buffers according to what is
> > > > actually sent over the wire.
> > > > 
> > > > Only exception: RDMA transport is currently excluded from this, as
> > > > it would not cope with it. [1]
> > 
> > Thinking back on RDMA:
> > - vs. one or two buffers as discussed in another thread, rdma will still
> > require two buffers, we post the receive buffer before sending as we
> > could otherwise be raced (reply from server during the time it'd take to
> > recycle the send buffer)
> > In practice the recv buffers should act liks a fifo and we might be able
> > to post the buffer we're about to send for recv before sending it and it
> > shouldn't be overwritten until it's sent, but that doesn't look quite
> > good.
> > 
> > - for this particular patch, we can still allocate smaller short buffers
> > for requests, so we should probably keep tsize to 0.
> > rsize there really isn't much we can do without a protocol change
> > though...
> 
> Good to know! I don't have any RDMA setup here to test, so I rely on what
> you say and adjust this in v6 accordingly, along with the strcmp -> flag
> change of course.
> 
> As this flag is going to be very RDMA-transport specific, I'm still
> scratching my head for a good name though.

Or, instead of inventing some exotic flag name, maybe introducing an enum for 
the individual 9p transport types?
 
Best regards,
Christian Schoenebeck



