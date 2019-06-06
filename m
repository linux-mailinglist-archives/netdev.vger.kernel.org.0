Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B876368AB
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFFAQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:16:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43144 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFFAQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:16:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DC1B13AEF259;
        Wed,  5 Jun 2019 17:16:09 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:16:08 -0700 (PDT)
Message-Id: <20190605.171608.657801050353966463.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, linville@redhat.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net v2] ethtool: fix potential userspace buffer overflow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603205713.28121-1-vivien.didelot@gmail.com>
References: <20190603205713.28121-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:16:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Mon,  3 Jun 2019 16:57:13 -0400

> ethtool_get_regs() allocates a buffer of size ops->get_regs_len(),
> and pass it to the kernel driver via ops->get_regs() for filling.
> 
> There is no restriction about what the kernel drivers can or cannot do
> with the open ethtool_regs structure. They usually set regs->version
> and ignore regs->len or set it to the same size as ops->get_regs_len().
> 
> But if userspace allocates a smaller buffer for the registers dump,
> we would cause a userspace buffer overflow in the final copy_to_user()
> call, which uses the regs.len value potentially reset by the driver.
> 
> To fix this, make this case obvious and store regs.len before calling
> ops->get_regs(), to only copy as much data as requested by userspace,
> up to the value returned by ops->get_regs_len().
> 
> While at it, remove the redundant check for non-null regbuf.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied and queued up for -stable, thanks.
