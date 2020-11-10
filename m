Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5872C2ADD8E
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgKJR6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730504AbgKJR6S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 12:58:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C770F20781;
        Tue, 10 Nov 2020 17:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605031097;
        bh=RIQtxy/Q98sCLVqwPHTqyM87zYGU1ecCP3Nkry/4KJE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qWbeDanDQ8LTacruEGA8MseDR7iXxqZAsBx00l+C3CFBxnBrM8oMkwL5NS+Jaytom
         CELhIfkUkCHybYESX8bvfAsuraJ31VxvKZ7qYfQ25HYnV63ji4eoSk+N2r6ARt1qxQ
         5hpOt3DIMPY0I8rXOeghBkcE358WN5gOnUWUzBGI=
Date:   Tue, 10 Nov 2020 09:58:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     ralf@linux-mips.org, davem@davemloft.net, saeed@kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH v3 net] rose: Fix Null pointer
 dereference in rose_send_frame()
Message-ID: <20201110095815.41577920@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107191835.5541-1-anmol.karan123@gmail.com>
References: <20201107082041.GA2675@Thinkpad>
        <20201107191835.5541-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  8 Nov 2020 00:48:35 +0530 Anmol Karn wrote:
> +			dev = rose_dev_get(dest);

this calls dev_hold internally, you never release that reference in
case ..neigh->dev is NULL

> +			if (rose_loopback_neigh->dev && dev) {
