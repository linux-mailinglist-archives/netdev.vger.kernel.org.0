Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20261193E2
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 22:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfEIU6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 16:58:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40856 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfEIU6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 16:58:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED81014DAEDD7;
        Thu,  9 May 2019 13:58:09 -0700 (PDT)
Date:   Thu, 09 May 2019 13:58:09 -0700 (PDT)
Message-Id: <20190509.135809.630741953977432246.davem@davemloft.net>
To:     sunilmut@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, decui@microsoft.com, mikelley@microsoft.com,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hv_sock: Fix data loss upon socket close
From:   David Miller <davem@davemloft.net>
In-Reply-To: <BN6PR21MB0465168DEA6CABA910832A5BC0320@BN6PR21MB0465.namprd21.prod.outlook.com>
References: <BN6PR21MB0465168DEA6CABA910832A5BC0320@BN6PR21MB0465.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 13:58:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>
Date: Wed, 8 May 2019 23:10:35 +0000

> +static inline void hvs_shutdown_lock_held(struct hvsock *hvs, int mode)

Please do not use the inline keyword in foo.c files, let the compiler decide.

Also, longer term thing, I notice that vsock_remove_socket() is very
inefficient locking-wise.  It takes the table lock to do the placement
test, and takes it again to do the removal.  Might even be racy.
