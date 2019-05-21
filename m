Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADEC258A4
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfEUULN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:11:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44630 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEUULM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:11:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0490D14C7D96E;
        Tue, 21 May 2019 13:11:11 -0700 (PDT)
Date:   Tue, 21 May 2019 13:11:11 -0700 (PDT)
Message-Id: <20190521.131111.2280404979625075472.davem@davemloft.net>
To:     3erndeckstein@gmail.com
Cc:     linux@roeck-us.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        corsac@corsac.net, Oliver.Zweigle@faro.com,
        3ernd.Eckstein@gmail.com
Subject: Re: [PATCH] usbnet: ipheth: fix racing condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558366269-17787-1-git-send-email-3ernd.Eckstein@gmail.com>
References: <1558366269-17787-1-git-send-email-3ernd.Eckstein@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 May 2019 13:11:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bernd Eckstein <3erndeckstein@gmail.com>
Date: Mon, 20 May 2019 17:31:09 +0200

> Fix a racing condition in ipheth.c that can lead to slow performance.
> 
> Bug: In ipheth_tx(), netif_wake_queue() may be called on the callback
> ipheth_sndbulk_callback(), _before_ netif_stop_queue() is called.
> When this happens, the queue is stopped longer than it needs to be,
> thus reducing network performance.
> 
> Fix: Move netif_stop_queue() in front of usb_submit_urb(). Now the order
> is always correct. In case, usb_submit_urb() fails, the queue is woken up
> again as callback will not fire.
> 
> Testing: This racing condition is usually not noticeable, as it has to
> occur very frequently to slowdown the network. The callback from the USB
> is usually triggered slow enough, so the situation does not appear.
> However, on a Ubuntu Linux on VMWare Workstation, running on Windows 10,
> the we loose the race quite often and the following speedup can be noticed:
> 
> Without this patch: Download:  4.10 Mbit/s, Upload:  4.01 Mbit/s
> With this patch:    Download: 36.23 Mbit/s, Upload: 17.61 Mbit/s
> 
> Signed-off-by: Oliver Zweigle <Oliver.Zweigle@faro.com>
> Signed-off-by: Bernd Eckstein <3ernd.Eckstein@gmail.com>

Applied.
