Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B02416ED74
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 19:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgBYSG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 13:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728367AbgBYSG3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 13:06:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F20522176D;
        Tue, 25 Feb 2020 18:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582653987;
        bh=bGA+JaV7Z1hLSbO2MDlRKCgPocAM/WHwCt6R5f4QfPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b2SAxAmrWiRQTw2/ZMJMGIPTzhfmqN1TH3efUFP5X60raJNdpyKsFym1fbXvs8an6
         aGE1vK8NVS2lJ/lZTeFuhBxe4WtjucEALBPvoAjFZIk0wUWijx06wyHFGeT+AVrDQ3
         mznB7Ux7AwgBsOnOp7w6MS1r94mF9W81sC041zDU=
Date:   Tue, 25 Feb 2020 10:06:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, mlxsw@mellanox.com,
        Marian Pritsak <marianp@mellanox.com>
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW
 stats type
Message-ID: <20200225100625.01887735@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200225162203.GE17869@nanopsycho>
References: <20200221095643.6642-1-jiri@resnulli.us>
        <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
        <20200222063829.GB2228@nanopsycho>
        <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
        <20200224131101.GC16270@nanopsycho>
        <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
        <20200224162521.GE16270@nanopsycho>
        <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
        <20200225162203.GE17869@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Feb 2020 17:22:03 +0100 Jiri Pirko wrote:
> >> You can reuse this index in multiple counter action instances.  
> >
> >That is great because it maps to tc semantics. When you create
> >an action of the same type, you can specify the index and it
> >is re-used. Example:
> >
> >sudo tc filter add dev lo parent ffff: protocol ip prio 8 u32 \
> >match ip dst 127.0.0.8/32 flowid 1:8 \
> >action vlan push id 8 protocol 802.1q index 8\
> >action mirred egress mirror dev eth0 index 111
> >
> >sudo tc filter add dev lo parent ffff: protocol ip prio 8 u32 \
> >match ip dst 127.0.0.15/32 flowid 1:10 \
> >action vlan push id 15 protocol 802.1q index 15 \
> >action mirred egress mirror index 111 \
> >action drop index 111
> >
> >So for the shared mirror action the counter is shared
> >by virtue of specifying index 111.
> >
> >What tc _doesnt allow_ is to re-use the same
> >counter index across different types of actions (example
> >mirror index 111 is not the same instance as drop 111).
> >Thats why i was asking if you are exposing the hw index.  
> 
> User does not care about any "hw index". That should be abstracted out
> by the driver.

+1

> >> and we report stats from action_counter for all the_actual_actionX.  
> >
> >This may not be accurate if you are branching - for example
> >a policer or quota enforcer which either accepts or drops or sends next
> >to a marker action etc .
> >IMO, this was fine in the old days when you had one action per match.
> >Best is to leave it to whoever creates the policy to decide what to
> >count. IOW, I think modelling it as a pipe or ok or drop or continue
> >and be placed anywhere in the policy graph instead of the begining.  
> 
> Eh, that is not that simple. The existing users are used to the fact
> that the actions are providing counters by themselves. Having and
> explicit counter action like this would break that expectation.
> Also, I think it should be up to the driver implementation. Some HW
> might only support stats per rule, not the actions. Driver should fit
> into the existing abstraction, I think it is fine.

+1
