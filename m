Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115E63A0E9
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 19:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfFHRlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 13:41:44 -0400
Received: from first.geanix.com ([116.203.34.67]:34424 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbfFHRlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 13:41:44 -0400
Received: from [192.168.100.94] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 3050513BA;
        Sat,  8 Jun 2019 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1560015573; bh=8Mcsy1AXfsPvxQCimsGZ/Qj+10qocdvKPo/j08b3ztY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=CBb6Ncn92z5m60XbXq6N/MR/6T+MNLw3b9Xrdd1/Gz9TDsNW/mHm33UFzgLShAjNK
         PygcPL6tOczba5WYb1D2AQjH17svVdtAniAmbi5POAempcoXs9r9lrL/UA2v8xNGnT
         Qk+DDHOGtuAkS633cIeTJCccCa9JtH5JhZWn51glo8AxUcH6jDWGiLfJmomlCP26vZ
         Q73VfVsyP2BAcfxZlvOOFg55+ixBhAc3GUyFjmWDou5+iI4hP6GM9yS8Ahlr+t0+gv
         0gbx7WnfpoKEQqbjF4RpxzKRhSkeuLPOUNfGZpbdW7JnWHbpv+X1iuNBQALgX79nv2
         8usdrfH2ozifg==
Subject: Re: [PATCH] can: flexcan: fix deadlock when using self wakeup
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190517023652.19285-1-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <fbbe474f-bdf7-a97a-543d-da17dfd2a114@geanix.com>
Date:   Sat, 8 Jun 2019 19:41:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190517023652.19285-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 796779db2bec
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/05/2019 04.39, Joakim Zhang wrote:
> As reproted by Sean Nyekjaer bellow:
> When suspending, when there is still can traffic on the
> interfaces the flexcan immediately wakes the platform again.
> As it should :-)
> But it throws this error msg:
> [ 3169.378661] PM: noirq suspend of devices failed
> 
> On the way down to suspend the interface that throws the error
> message does call flexcan_suspend but fails to call
> flexcan_noirq_suspend.
> That means the flexcan_enter_stop_mode is called, but on the way
> out of suspend the driver only calls flexcan_resume and skips
> flexcan_noirq_resume, thus it doesn't call flexcan_exit_stop_mode.
> This leaves the flexcan in stop mode, and with the current driver
> it can't recover from this even with a soft reboot, it requires a
> hard reboot.
> 
> Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
> 
> This patch intends to fix the issue, and also add comment to explain the
> wakeup flow.
> Reported-by: Sean Nyekjaer <sean@geanix.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

How is it going with the updated patch?

/Sean
