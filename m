Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF70538980
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 03:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243318AbiEaBPt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 May 2022 21:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiEaBPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 21:15:48 -0400
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B70939B0
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 18:15:46 -0700 (PDT)
Received: (qmail 76677 invoked by uid 89); 31 May 2022 01:15:45 -0000
Received: from unknown (HELO smtpclient.apple) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with ESMTPS (AES256-GCM-SHA384 encrypted); 31 May 2022 01:15:45 -0000
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   Flugsvamp <jlemon@flugsvamp.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH net-next v5 2/2] net: phy: broadcom: Add PTP support for some Broadcom PHYs.
Date:   Mon, 30 May 2022 18:15:44 -0700
Message-Id: <57926B53-BB8B-4A9B-9340-0DFFDA4452BA@flugsvamp.com>
References: <20220530230439.GA22405@hoboy.vegasvil.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
In-Reply-To: <20220530230439.GA22405@hoboy.vegasvil.org>
To:     Richard Cochran <richardcochran@gmail.com>
X-Mailer: iPhone Mail (19E258)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 30, 2022, at 4:04 PM, Richard Cochran <richardcochran@gmail.com> wrote:
> 
> ﻿On Mon, May 30, 2022 at 10:07:44AM -0700, Jonathan Lemon wrote:
>>> On Sat, May 28, 2022 at 05:34:47PM -0700, Richard Cochran wrote:
>>>> On Wed, May 18, 2022 at 03:39:35PM -0700, Jonathan Lemon wrote:
>>> 
>>>> +static int bcm_ptp_adjtime_locked(struct bcm_ptp_private *priv,
>>>> +                  s64 delta_ns)
>>>> +{
>>>> +    struct timespec64 ts;
>>>> +    int err;
>>>> +
>>>> +    err = bcm_ptp_gettime_locked(priv, &ts, NULL);
>>>> +    if (!err) {
>>>> +        set_normalized_timespec64(&ts, ts.tv_sec,
>>>> +                      ts.tv_nsec + delta_ns);
>>> 
>>> This also takes a LONG time when delta is large...
>> 
>> Didn't we just go through this?  What constitutes a "large" offset here?
>> The current version seems acceptable to me:
> 
> When the PHY boots, it starts from time zero.
> 
> Then as a client it needs to adjust to today, something like:
> 
> 1653951762.413809006 or Mon May 30 16:02:42 2022
> 
> (that means adding 1,653,951,762,413,809,006 nanoseconds)
> 
> Try that and see how long it takes to apply the adjustment.

That’s certainly a big adjustment. I was expecting something along the lines of a settime() call, followed up by adjtime().

Will fix. Seems like there should be a better call sequence for this, though. 

Sent from my iPhone
