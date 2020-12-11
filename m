Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168EB2D710A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 08:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436782AbgLKHpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 02:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388543AbgLKHpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 02:45:14 -0500
Date:   Fri, 11 Dec 2020 08:44:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607672673;
        bh=PZae96WnzP1vFvimEKQ4F1bK4K9OLoigPkcKSSQwLH4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=kq6RNr9KfH8w+TGmzkcsVjLHeySDeronzNAmnz9KZS70WZK4wfwZGOs1JfC61Ad/8
         ImdBkVj15V08R3zgPk0LoCpvA5Q3nLMg3/lUMKZ4pnYh7QkhqFvw1nszhqscE8aiyJ
         gq4VRhmB0iBvuGzk7SF9AdsrNFM8anu9KPmjIOes=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v17 3/3] bus: mhi: Add userspace client interface driver
Message-ID: <X9MjXWABgdJIpyIw@kroah.com>
References: <1607670251-31733-1-git-send-email-hemantk@codeaurora.org>
 <1607670251-31733-4-git-send-email-hemantk@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607670251-31733-4-git-send-email-hemantk@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 11:04:11PM -0800, Hemant Kumar wrote:
> This MHI client driver allows userspace clients to transfer
> raw data between MHI device and host using standard file operations.
> Driver instantiates UCI device object which is associated to device
> file node. UCI device object instantiates UCI channel object when device
> file node is opened. UCI channel object is used to manage MHI channels
> by calling MHI core APIs for read and write operations. MHI channels
> are started as part of device open(). MHI channels remain in start
> state until last release() is called on UCI device file node. Device
> file node is created with format
> 
> /dev/<mhi_device_name>
> 
> Currently it supports QMI channel. libqmi is userspace MHI client which
> communicates to a QMI service using QMI channel. libqmi is a glib-based
> library for talking to WWAN modems and devices which speaks QMI protocol.
> For more information about libqmi please refer
> https://www.freedesktop.org/wiki/Software/libqmi/

This says _what_ this is doing, but not _why_.

Why do you want to circumvent the normal user/kernel apis for this type
of device and move the normal network handling logic out to userspace?
What does that help with?  What does the current in-kernel api lack that
this userspace interface is going to solve, and why can't the in-kernel
api solve it instead?

You are pushing a common user/kernel api out of the kernel here, to
become very device-specific, with no apparent justification as to why
this is happening.

Also, because you are going around the existing network api, I will need
the networking maintainers to ack this type of patch.

thanks,

greg k-h
