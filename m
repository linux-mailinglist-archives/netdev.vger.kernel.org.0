Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0A540FEC2
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 19:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbhIQRps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 13:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233991AbhIQRpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 13:45:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF7DB61212;
        Fri, 17 Sep 2021 17:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631900662;
        bh=QtoUP5Bx9ASIB8R9v5KDvqYWULYrTkUhG7TY5oFBo3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JzuZQ3CL5uGdHq/lvfqB/1WD/GbuMtgzjT75bBY1hQKH+YrLB8pkYC6gAIelOcTdp
         mA6sxRki/ilzGOdyYA8R4q5vnG3fjf7ftG51FDgGqwgmnieIg3/Sgta8bT8q+AnOBJ
         bRLt1KzgyCOGImMYPYaVgS4baNGN2v1xkxVXPXUfS25AK9dXxADrESzJa/6hxRPJGZ
         166HA4UA2R1NZYaFh2Y3RBrtgNY9BKCHOJMnD9TbWt4eycpJptAfw8bE/oYKEcryIb
         u9Uux3LfRFQZF6ZdPx9PrxfHcKcBd3L0yPb3AfqRtB1NNcGHgGiK6ezrtkn4jaZysk
         gN+byKqsUuOdQ==
Date:   Fri, 17 Sep 2021 10:44:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     pshelar@ovn.org, davem@davemloft.net, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] openvswitch: Fix condition check in
 do_execute_actions() by using nla_ok()
Message-ID: <20210917104420.2d76b847@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1631866034-3869133-1-git-send-email-jiasheng@iscas.ac.cn>
References: <1631866034-3869133-1-git-send-email-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 08:07:14 +0000 Jiasheng Jiang wrote:
> Just using 'rem > 0' might be unsafe, so it's better
> to use the nla_ok() instead.
> Because we can see from the nla_next() that
> '*remaining' might be smaller than 'totlen'. And nla_ok()
> will avoid it happening.
> For example, ovs_dp_process_packet() -> ovs_execute_actions()
> -> do_execute_actions(), and attr comes from OVS_CB(skb)->input_vport,  
> which restores the received packet from the user space.

Right but that's the call trace for where the actions are executed.
Not where they are constructed.

As far as I can tell the action list is constructed in the kernel 
by __ovs_nla_copy_actions(). Since kernel does the formatting, it
can trust the contents are correct. We normally require nla_ok()
when handling input directly from user space, which is not the 
case in do_execute_actions().

And since kernel is sure that the input is correct the extra checking
just adds to the datapath overhead.

Unless you can point out how exactly the input could be invalid 
at this point I'd suggest we leave this code as is. Perhaps add
a comment explaining why input is trusted.

Thanks!

> Fixes: ccb1352e76cff0524e7ccb2074826a092dd13016
> ('net: Add Open vSwitch kernel components.')

FWIW the correct format would have been:

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")

> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
