Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4B76172EC
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 00:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiKBXlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 19:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiKBXkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 19:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3985B13FBC
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 16:36:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C17AF61CBE
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 23:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7477C433C1;
        Wed,  2 Nov 2022 23:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667432208;
        bh=jCVBKb7Cflgm9xHyZURLH1okS5p6H5KxV/IvZJot/h0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tBDfIxPwjq6uOSbDatmx1D5CywoCnLWOY580E9TniIpkVJHKamwrlmuK9c9nsT2YR
         KStnMyNiDMYUKiUUDHJ+zGidOWTQtiKP5Cl7u7+H6zi+IMJyPzpg3M6B9mZwNwrjwU
         FXCG9ElLvnXLtihKpE+0ykMTortEPh2InPIzuSAP5bjctxPk8rX8QLkSgapac27zab
         fjPMOwKV+qh3DBdr26cVM/nxezeO75ab3tvOjUMGjRaRlOr3Skq7pUYkgVlPHuFh96
         7s3gEtDNl9VzJXRy4AjiwCw7y28rOrOzf7r1kfWctlZGZ1EVChgQ2Q2ADSXXNjIXld
         hvcXFoehmdy1w==
Date:   Wed, 2 Nov 2022 16:36:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <20221102163646.131a3910@kernel.org>
In-Reply-To: <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
        <YziJS3gQopAInPXw@pop-os.localdomain>
        <Yzillil1skRfQO+C@t14s.localdomain>
        <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
        <Y1kEtovIpgclICO3@Laptop-X1>
        <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 11:33:18 -0400 Jamal Hadi Salim wrote:
> > Sorry for the late response. I just came back form vacation. For this issue,
> > I saw netlink_dump_done() also put NLMSGERR_ATTR_MSG in NLMSG_DONE.
> > So why can't we do the same here?
> >
> > In https://www.kernel.org/doc/html//next/userspace-api/netlink/intro.html,
> > The "optionally extended ACK" in NLMSG_DONE is OK.
> 
> Ok.
> [That seemd to  be a nice doc - need to find time to look at it]

Thanks.

> > > Also - i guess it will depend on the underlying driver?
> > > This seems very related to a specific driver:
> > > "Warning: mlx5_core: matching on ct_state +new isn't supported."
> > > Debuggability is always great but so is backwards compat.
> > > What happens when you run old userspace tc? There are tons
> > > of punting systems that process these events out there and
> > > depend on the current event messages as is.  
> >
> > I think old tc should just ignore this NLMSGERR_ATTR_MSG?  
> 
> Yes.
> So looks good to me then.
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Eish.

Hangbin, I'm still against this. Please go back to my suggestions /
questions. A tracepoint or an attribute should do. Multi-part messages
are very hard to map to normal programming constructs, and I don't
think there is any precedent for mutli-part notifications.
