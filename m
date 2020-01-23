Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A238E146551
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAWKDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:03:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgAWKDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:03:48 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7444E153D60A2;
        Thu, 23 Jan 2020 02:03:41 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:03:34 +0100 (CET)
Message-Id: <20200123.110334.575852757631951738.davem@davemloft.net>
To:     mpe@ellerman.id.au
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        security@kernel.org, ivansprundel@ioactive.com
Subject: Re: [PATCH 1/2] airo: Fix possible info leak in
 AIROOLDIOCTL/SIOCDEVPRIVATE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122040728.8437-1-mpe@ellerman.id.au>
References: <20200122040728.8437-1-mpe@ellerman.id.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 02:03:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>
Date: Wed, 22 Jan 2020 15:07:27 +1100

> The driver for Cisco Aironet 4500 and 4800 series cards (airo.c),
> implements AIROOLDIOCTL/SIOCDEVPRIVATE in airo_ioctl().
> 
> The ioctl handler copies an aironet_ioctl struct from userspace, which
> includes a command and a length. Some of the commands are handled in
> readrids(), which kmalloc()'s a buffer of RIDSIZE (2048) bytes.
> 
> That buffer is then passed to PC4500_readrid(), which has two cases.
> The else case does some setup and then reads up to RIDSIZE bytes from
> the hardware into the kmalloc()'ed buffer.
> 
> Here len == RIDSIZE, pBuf is the kmalloc()'ed buffer:
> 
> 	// read the rid length field
> 	bap_read(ai, pBuf, 2, BAP1);
> 	// length for remaining part of rid
> 	len = min(len, (int)le16_to_cpu(*(__le16*)pBuf)) - 2;
> 	...
> 	// read remainder of the rid
> 	rc = bap_read(ai, ((__le16*)pBuf)+1, len, BAP1);
> 
> PC4500_readrid() then returns to readrids() which does:
> 
> 	len = comp->len;
> 	if (copy_to_user(comp->data, iobuf, min(len, (int)RIDSIZE))) {
> 
> Where comp->len is the user controlled length field.
> 
> So if the "rid length field" returned by the hardware is < 2048, and
> the user requests 2048 bytes in comp->len, we will leak the previous
> contents of the kmalloc()'ed buffer to userspace.
> 
> Fix it by kzalloc()'ing the buffer.
> 
> Found by Ilja by code inspection, not tested as I don't have the
> required hardware.
> 
> Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Applied and queued up for -stable.
