Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BB9621C8D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiKHSzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKHSzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:55:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B87568C77
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:55:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE49BB81C16
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F26C433C1;
        Tue,  8 Nov 2022 18:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667933745;
        bh=hcbY5QhMZtu8UK5c/lErkAa9+DDKO8NUG4RILBoWs1U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jHe4QQN5hqlryFa2UGJ6gYJDEw8sCG28Np8Ulv/QGq+YeJxbv9jw6XlUm63ZbdOPe
         dxdqA2Qsa9HVlL6Qj/XOpWtkbW+BVDi1fhbHdoUZWMLxlBj5hycOfzZthtJMbxgOtH
         q4Vs0urNX+rrv+eKGEunQtCcjZKz1DIrBfOXEmZnB7lhBFfS14hlYqqy7T8SE0COey
         NmazNXnyXQvprHQMZJ9lkVUskruncindrcvSYVhTCIq7OWiL83f3qYoQ3Q+gcSLjlb
         Oj0WfyxSxFC/f8U0Tw1calICLPyLX6nvk+ehG4fQfGpbsipE+z5pADzavNywZg9O2a
         wWMtZq0DFxq1Q==
Date:   Tue, 8 Nov 2022 10:55:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <20221108105544.65e728ad@kernel.org>
In-Reply-To: <Y2odOlWlonu1juWZ@Laptop-X1>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
        <YziJS3gQopAInPXw@pop-os.localdomain>
        <Yzillil1skRfQO+C@t14s.localdomain>
        <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
        <Y1kEtovIpgclICO3@Laptop-X1>
        <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
        <20221102163646.131a3910@kernel.org>
        <Y2odOlWlonu1juWZ@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Nov 2022 17:11:22 +0800 Hangbin Liu wrote:
> On Wed, Nov 02, 2022 at 04:36:46PM -0700, Jakub Kicinski wrote:
> > Eish.
> > 
> > Hangbin, I'm still against this. Please go back to my suggestions /
> > questions. A tracepoint or an attribute should do. Multi-part messages
> > are very hard to map to normal programming constructs, and I don't
> > think there is any precedent for mutli-part notifications.  
> 
> Hi Jakub,
> 
> I checked the doc[1], the NLMSGERR_ATTR_MSG could only be in NLMSG_ERROR and
> NLMSG_DONE messages. But the tfilter_notify() set the nlmsg type to
> RTM_NEWTFILTER. Would you like to help explain what you mean of using
> attribute? Should I send a NLMSG_ERROR/NLMSG_DONE message separately after the
> tfilter_notify()?
> 
> [1] https://www.kernel.org/doc/html//next/userspace-api/netlink/intro.html#ext-ack

My initial thought was to add an attribute type completely independent
of the attribute space defined in enum nlmsgerr_attrs, add it in the
TCA_* space. So for example add a TCA_NTF_WARN_MSG which will carry the
string message.

We can also create a nest to carry the full nlmsgerr_attrs attributes
with their existing types (TCA_NTF_EXT_ACK?). Each nest gets
to choose what attribute set it carries.

That said, most of the ext_ack attributes refer to an input attribute by
specifying the offset within the request. The notification recipient
will not be able to resolve those in any meaningful way. So since only
the string message will be of interest I reckon adding a full nest is
an unnecessary complication?
