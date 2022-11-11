Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D814B625F32
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 17:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbiKKQNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 11:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKKQNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 11:13:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC48623B7
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:13:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC6B6204E
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFFEC433D7;
        Fri, 11 Nov 2022 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668183199;
        bh=eqga4GU1EX8a8OMybCvuwS3fJqBGWzJ2p8xlMYLE46U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aFVLjo49cGqh93HgMU7hKfjmlnwqNa1PceCYAtVKs2bv3LnzZ3vrYTqBnttbt3ENK
         Nb93QcLRZd6gF9AFrhCbTBJpDGULmmVp2mWuh7Q3udL07X6ajOa8WB1ZJ378x9XhdE
         35RoslTDfOmEWGQWSNF/T8WEvABp+rVGPjtEkzdtYBkAao4g5WBh646k7bQHrgeLwA
         p4RIzXQlDZvHAHTZwMb123ybmSiLh4mtoASTfgIhvATzor4MdSCP/DbBH6Ui2HrxLk
         T51hLDnL/hiD4yc1J2AC/MY95DG4ZMuTBYl6is3qDe3KTnrjf1+U9KpiZ7uIy0HVq0
         TkUm3o3PlCvBg==
Date:   Fri, 11 Nov 2022 18:13:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
Message-ID: <Y250mkqG20F5cpT8@unreal>
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
 <Y2vozcC2ahbhAvhM@unreal>
 <20221109122641.781b30d9@kernel.org>
 <CAMZ6Rq+K6oD9auaNzt1kJAW0nz9Hs=ODDvOiEaiKi2_1KVNA8g@mail.gmail.com>
 <Y2zASloeKjMMCgyw@unreal>
 <20221110090127.0d729f05@kernel.org>
 <CAMZ6RqKVrRufmUsJ3XuzGhc3Ea=dEjChu3rd7Xw8LZ-SBrsSUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMZ6RqKVrRufmUsJ3XuzGhc3Ea=dEjChu3rd7Xw8LZ-SBrsSUw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 03:43:36PM +0900, Vincent MAILHOL wrote:
> On Fri. 11 Nov. 2022 à 02:01, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 10 Nov 2022 11:11:38 +0200 Leon Romanovsky wrote:
> > > I will be happy to see such patch and will review it, but can't add sign-off
> > > as I'm not netdev maintainer.
> >
> > Did we finish the version removal work? :S
> >
> > Personally I'd rather direct any effort towards writing a checkpatch /
> > cocci / python check that catches new cases than cleaning up the pile
> > of drivers we have. A lot of which are not actively used..
> 
> Agree, but I will not work on that (because of other personal
> priorities). If someone else wants to do it, go ahead :)

It's ok, Jakub referred to me. I sent a lot of patches like this.
https://lore.kernel.org/netdev/5d76f3116ee795071ec044eabb815d6c2bdc7dbd.1649922731.git.leonro@nvidia.com/

> 
> What I can do is update the documentation:
> https://lore.kernel.org/netdev/20221111064054.371965-1-mailhol.vincent@wanadoo.fr/
> 
> 
> Yours sincerely,
> Vincent Mailhol
