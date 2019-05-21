Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE1525966
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbfEUUrF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 16:47:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbfEUUrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:47:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B282E14CEC900;
        Tue, 21 May 2019 13:47:04 -0700 (PDT)
Date:   Tue, 21 May 2019 13:47:04 -0700 (PDT)
Message-Id: <20190521.134704.1456978856134153782.davem@davemloft.net>
To:     Jan.Kloetzke@preh.de
Cc:     oneukum@suse.com, jan@kloetzke.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3] usbnet: fix kernel crash after disconnect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190521131826.30475-1-Jan.Kloetzke@preh.de>
References: <1558438944.12672.13.camel@suse.com>
        <20190521131826.30475-1-Jan.Kloetzke@preh.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 May 2019 13:47:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kloetzke Jan <Jan.Kloetzke@preh.de>
Date: Tue, 21 May 2019 13:18:40 +0000

> When disconnecting cdc_ncm the kernel sporadically crashes shortly
> after the disconnect:
 ...
> The crash happens roughly 125..130ms after the disconnect. This
> correlates with the 'delay' timer that is started on certain USB tx/rx
> errors in the URB completion handler.
> 
> The problem is a race of usbnet_stop() with usbnet_start_xmit(). In
> usbnet_stop() we call usbnet_terminate_urbs() to cancel all URBs in
> flight. This only makes sense if no new URBs are submitted
> concurrently, though. But the usbnet_start_xmit() can run at the same
> time on another CPU which almost unconditionally submits an URB. The
> error callback of the new URB will then schedule the timer after it was
> already stopped.
> 
> The fix adds a check if the tx queue is stopped after the tx list lock
> has been taken. This should reliably prevent the submission of new URBs
> while usbnet_terminate_urbs() does its job. The same thing is done on
> the rx side even though it might be safe due to other flags that are
> checked there.
> 
> Signed-off-by: Jan Klötzke <Jan.Kloetzke@preh.de>

Applied.
