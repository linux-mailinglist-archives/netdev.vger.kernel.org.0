Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7757021A761
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGIS5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgGIS5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 14:57:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A941420774;
        Thu,  9 Jul 2020 18:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594321042;
        bh=QyLYktjnNd9/FkmcnpURY2O8rFyOTw3Fkut2coF5viI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1RmEnt+muvngIaqPPcqDjUjYsJwuxJghqrbEHp4cPIOi6qIJV/W0HCJFvhep/e0Nc
         l7aZJ6lYdN2+Dym+AJW5yOl5A3bvc4IdrvVRDr71eWK1ZT+5sVdhojckboesDuyfqT
         yGyXhVXVJU/QIImefvrKij6UrJ3DbpSan/vPICB8=
Date:   Thu, 9 Jul 2020 11:57:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: fix genlmsg_put() failure handling in
 ethnl_default_dumpit()
Message-ID: <20200709115721.492dcf76@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709101150.65DBB60567@lion.mk-sys.cz>
References: <20200709101150.65DBB60567@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 12:11:50 +0200 (CEST) Michal Kubecek wrote:
> If the genlmsg_put() call in ethnl_default_dumpit() fails, we bail out
> without checking if we already have some messages in current skb like we do
> with ethnl_default_dump_one() failure later. Therefore if existing messages
> almost fill up the buffer so that there is not enough space even for
> netlink and genetlink header, we lose all prepared messages and return and
> error.
> 
> Rather than duplicating the skb->len check, move the genlmsg_put(),
> genlmsg_cancel() and genlmsg_end() calls into ethnl_default_dump_one().
> This is also more logical as all message composition will be in
> ethnl_default_dump_one() and only iteration logic will be left in
> ethnl_default_dumpit().
> 
> Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
