Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80631930CD
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgCYTEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:04:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgCYTEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:04:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A58415A06D62;
        Wed, 25 Mar 2020 12:04:13 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:04:12 -0700 (PDT)
Message-Id: <20200325.120412.734295569199099804.davem@davemloft.net>
To:     gpiccoli@canonical.com
Cc:     netanel@amazon.com, akiyano@amazon.com, netdev@vger.kernel.org,
        gtzalik@amazon.com, saeedb@amazon.com, zorik@amazon.com,
        kernel@gpiccoli.net, gshan@redhat.com, gavin.guo@canonical.com,
        jay.vosburgh@canonical.com, pedro.principeza@canonical.com
Subject: Re: [PATCH] net: ena: Add PCI shutdown handler to allow safe kexec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320125534.28966-1-gpiccoli@canonical.com>
References: <20200320125534.28966-1-gpiccoli@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 12:04:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Date: Fri, 20 Mar 2020 09:55:34 -0300

> Currently ENA only provides the PCI remove() handler, used during rmmod
> for example. This is not called on shutdown/kexec path; we are potentially
> creating a failure scenario on kexec:
> 
> (a) Kexec is triggered, no shutdown() / remove() handler is called for ENA;
> instead pci_device_shutdown() clears the master bit of the PCI device,
> stopping all DMA transactions;
> 
> (b) Kexec reboot happens and the device gets enabled again, likely having
> its FW with that DMA transaction buffered; then it may trigger the (now
> invalid) memory operation in the new kernel, corrupting kernel memory area.
> 
> This patch aims to prevent this, by implementing a shutdown() handler
> quite similar to the remove() one - the difference being the handling
> of the netdev, which is unregistered on remove(), but following the
> convention observed in other drivers, it's only detached on shutdown().
> 
> This prevents an odd issue in AWS Nitro instances, in which after the 2nd
> kexec the next one will fail with an initrd corruption, caused by a wild
> DMA write to invalid kernel memory. The lspci output for the adapter
> present in my instance is:
> 
> 00:05.0 Ethernet controller [0200]: Amazon.com, Inc. Elastic Network
> Adapter (ENA) [1d0f:ec20]
> 
> Suggested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>

Applied and queued up for -stable, thank you.
