Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5911CFE656
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKOUVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:21:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40612 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfKOUVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:21:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76FFC14E0F40E;
        Fri, 15 Nov 2019 12:21:20 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:21:19 -0800 (PST)
Message-Id: <20191115.122119.1151591656300969166.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: Re: [PATCH] net-sysfs: Fix memory leak in register_queue_kobjects
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114111325.2027-1-jouni.hogander@unikie.com>
References: <20191114111325.2027-1-jouni.hogander@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:21:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com
Date: Thu, 14 Nov 2019 13:13:25 +0200

> +err_sysfs_create:
> +	kobject_put(kobj);
> +err_init_and_add:
> +	kfree_const(kobj->name);

If you put the object, then you cannot access kobj->name afterwards as kobj
may be released at this point.

Both of your fixes add this bug.
