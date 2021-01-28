Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D8330686B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhA1AMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhA1ALj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:11:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D41A764DD6;
        Thu, 28 Jan 2021 00:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611792619;
        bh=pg8FEOGF1w41Q4s3Rc66aRDXuknOxLXlsy0Wg43bVCo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mRDiUgt8SVu2OzraAsr3tDOCqB5fA0jF0vgUNNleXGRODZNj5swAWrnpm0jXfiBs8
         mwTJtNrss9Pdo4va6BvKfm2Aofm2j8lj//lJ+/FgPwhMhynnZaTJyAQTgCPCzvy8pG
         cspnoufnJLW1CFVPXDl/iYHgtHTImTyPtLmmk07G5i84k3tohMN+aBRMrlgyHqYB78
         a4Q3PmKFeKRrDleEzd7v8oqhuS0Fh3XBFzl6fgIVVnv+zWh0Lny/5sGVHpW79DjWyx
         H3MHk7T8dWfZqJZbhpgVJPhHCm+k4+U6gy1SqtnG7ZTZ0y22JLewXrZObo6PAYav/8
         BCRaRkPf4E86A==
Date:   Wed, 27 Jan 2021 16:10:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     <netdev@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 net-next] vmxnet3: Remove buf_info from device
 accessible structures
Message-ID: <20210127161017.2d9adf4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126190640.26942-1-doshir@vmware.com>
References: <20210126190640.26942-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 11:06:40 -0800 Ronak Doshi wrote:
> buf_info structures in RX & TX queues are private driver data that
> do not need to be visible to the device.  Although there is physical
> address and length in the queue descriptor that points to these
> structures, their layout is not standardized, and device never looks
> at them.
> 
> So lets allocate these structures in non-DMA-able memory, and fill
> physical address as all-ones and length as zero in the queue
> descriptor.
> 
> That should alleviate worries brought by Martin Radev in
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210104/022829.html
> that malicious vmxnet3 device could subvert SVM/TDX guarantees.
> 
> Signed-off-by: Petr Vandrovec <petr@vmware.com>
> Signed-off-by: Ronak Doshi <doshir@vmware.com>

Checkpatch says:

WARNING: kfree(NULL) is safe and this check is probably not required
#39: FILE: drivers/net/vmxnet3/vmxnet3_drv.c:455:
 	if (tq->buf_info) {
+		kfree(tq->buf_info);

WARNING: kfree(NULL) is safe and this check is probably not required
#73: FILE: drivers/net/vmxnet3/vmxnet3_drv.c:1737:
 	if (rq->buf_info[0]) {
+		kfree(rq->buf_info[0]);


You can remove those ifs as well.
