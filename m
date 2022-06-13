Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C624548E1E
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346303AbiFMKzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 06:55:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55278 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346494AbiFMKvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 06:51:08 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 2DBC183EA40E;
        Mon, 13 Jun 2022 03:51:04 -0700 (PDT)
Date:   Mon, 13 Jun 2022 11:50:58 +0100 (BST)
Message-Id: <20220613.115058.818063822562949798.davem@davemloft.net>
To:     longli@microsoft.com, longli@linuxonhyperv.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, kuba@kernel.org,
        pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
        edumazet@google.com, shiraz.saleem@intel.com,
        sharmaajay@microsoft.com, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [Patch v3 03/12] net: mana: Handle vport sharing between
 devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1655068494-16440-4-git-send-email-longli@linuxonhyperv.com>
References: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
        <1655068494-16440-4-git-send-email-longli@linuxonhyperv.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 13 Jun 2022 03:51:08 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: longli@linuxonhyperv.com
Date: Sun, 12 Jun 2022 14:14:45 -0700

> +int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
> +		   u32 doorbell_pg_id)
>  {
> +	/* Ethernet driver and IB driver can't take the port at the same time */
> +	refcount_inc(&apc->port_use_count);
> +	if (refcount_read(&apc->port_use_count) > 2) {

This is a racy test, the count could change after the test against
'2'.  It would be nice if there was a primitive to do the increment
and test atomically, but I fail to see one that matches this scenerio
currently.

Thank you.

