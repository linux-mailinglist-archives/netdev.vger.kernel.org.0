Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F971386D0
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 15:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbgALOp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 09:45:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733016AbgALOp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 09:45:26 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587432084D;
        Sun, 12 Jan 2020 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578840326;
        bh=kO/EcNMbjXvZbEdH+pcBpXJygmTN31CqOB3nA1PemSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IVAnXlYGjXeINoEEJdg09/XhuB8ecx750MaJBau+JH3JZ77LuYHvLbSCQdILd5fGI
         yhNWnrmWuzsW5/qql5cFvnQSbePlpGjPTqu0qN3JwZtQKZU9qNymoOVAKHkM0DhkWx
         fBMfQGLgkoYBwIeXJd4UY95yiEVSPWXxgMwTba9w=
Date:   Sun, 12 Jan 2020 06:45:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 3/5] netdevsim: avoid debugfs warning message when
 module is remove
Message-ID: <20200112064110.43245268@cakuba>
In-Reply-To: <20200111163723.4260-1-ap420073@gmail.com>
References: <20200111163723.4260-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jan 2020 16:37:23 +0000, Taehee Yoo wrote:
> When module is being removed, it couldn't be held by try_module_get().
> debugfs's open function internally tries to hold file_operation->owner
> if .owner is set.
> If holding owner operation is failed, it prints a warning message.

> [  412.227709][ T1720] debugfs file owner did not clean up at exit: ipsec

> In order to avoid the warning message, this patch makes netdevsim module
> does not set .owner. Unsetting .owner is safe because these are protected
> by inode_lock().

So inode_lock will protect from the code getting unloaded/disappearing?
At a quick glance at debugs code it doesn't seem that inode_lock would
do that. Could you explain a little more to a non-fs developer like
myself? :)

Alternatively should we perhaps hold a module reference for each device
created and force user space to clean up the devices? That may require
some fixes to the test which use netdevsim.

> Fixes: 7699353da875 ("netdevsim: add ipsec offload testing")
> Fixes: 31d3ad832948 ("netdevsim: add bpf offload support")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
