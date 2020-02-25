Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6EA16E9C2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbgBYPPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:15:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33522 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbgBYPPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 10:15:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=235GHztb3ZNOQxme0xDo0Q30x3nKhI4zYzStHwg/A0A=; b=dD5grdHzj3m/hBmempTfmNNKXn
        lHAdbbhkzvC2w6FP7AcGck4A/wXgg26Tvm5PkT/JVsIxYJo4/u8VKODphVo5O53q6i+wxg+UdpMbG
        kuWi7j1L8dti7QD4IdSN/rsroOmS+x8kMxI60iMwzWfDmkzw9vqjXAl4qAA30geKSTFc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6bvd-0007r0-Aq; Tue, 25 Feb 2020 16:15:21 +0100
Date:   Tue, 25 Feb 2020 16:15:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Alex Elder <elder@linaro.org>, m.chetan.kumar@intel.com,
        Dan Williams <dcbw@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] wwan: add a new WWAN subsystem
Message-ID: <20200225151521.GA7663@lunn.ch>
References: <20200225100053.16385-1-johannes@sipsolutions.net>
 <20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> One issue in comining up with the notion of a "WWAN device" is that
> a typical WWAN device (especially USB ones) is not composed of just
> a single function, but may have one or multiple network functions,
> some TTYs for control, etc. These are actually not even seen by a
> single driver in Linux, but various. An additional wrinkle is that
> each of those drivers will not be aware of the others, and also be
> a driver for a generic network or TTY device (for example), so by
> itself it cannot even know it's dealing with a unified WWAN device.
> 
> To still achieve a unified model, we allow each WWAN device to be
> composed of "component devices". Each component device can offer a
> certain subset of the overall functionality (which is shown in the
> struct wwan_component_device_ops). This isn't implemented right now,
> but ultimately it will allow us to have a "tentative" state, where
> a number component drivers register their component, but the full
> WWAN device is only formed if any one of them says that it indeed
> knows for sure that it's a piece of a WWAN device, or perhaps by
> some other heuristic.

Hi Johannes

Looking at it bottom up, is the WWAN device itself made up of multiple
devices? Are the TTYs separate drivers to the packet moving engines?
They have there own USB end points, and could just be standard CDC
ACM?

driver/base/component.c could be useful for bringing together these
individual devices to form the whole WWAN device. This is often used
for graphics drivers, where there can be i2c devices, display pipeline
devices, acceleration drivers etc, which each probe separately, but
need to be brought together to form a gpu driver as a whole.

Plus you need to avoid confusion by not adding another "component
framework" which means something totally different to the existing
component framework.

	   Andrew
