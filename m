Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF12F0BC4
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbfKFBtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:49:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFBtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:49:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF28D150FC2F2;
        Tue,  5 Nov 2019 17:49:09 -0800 (PST)
Date:   Tue, 05 Nov 2019 17:49:09 -0800 (PST)
Message-Id: <20191105.174909.256611580863902520.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, vladbu@mellanox.com, jiri@mellanox.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        louis.peens@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net 1/1] net: sched: prevent duplicate flower rules
 from tcf_proto destroy race
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572704267-29705-1-git-send-email-john.hurley@netronome.com>
References: <1572704267-29705-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 17:49:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Sat,  2 Nov 2019 14:17:47 +0000

> When a new filter is added to cls_api, the function
> tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
> determine if the tcf_proto is duplicated in the chain's hashtable. It then
> creates a new entry or continues with an existing one. In cls_flower, this
> allows the function fl_ht_insert_unque to determine if a filter is a
> duplicate and reject appropriately, meaning that the duplicate will not be
> passed to drivers via the offload hooks. However, when a tcf_proto is
> destroyed it is removed from its chain before a hardware remove hook is
> hit. This can lead to a race whereby the driver has not received the
> remove message but duplicate flows can be accepted. This, in turn, can
> lead to the offload driver receiving incorrect duplicate flows and out of
> order add/delete messages.
> 
> Prevent duplicates by utilising an approach suggested by Vlad Buslov. A
> hash table per block stores each unique chain/protocol/prio being
> destroyed. This entry is only removed when the full destroy (and hardware
> offload) has completed. If a new flow is being added with the same
> identiers as a tc_proto being detroyed, then the add request is replayed
> until the destroy is complete.
> 
> Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> Reported-by: Louis Peens <louis.peens@netronome.com>

Applied and queued up for -stable, thanks John.
