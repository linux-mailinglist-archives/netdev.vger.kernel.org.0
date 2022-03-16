Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2884DA76A
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 02:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243988AbiCPBlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 21:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240895AbiCPBlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 21:41:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D8454BD7
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 18:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 077A76157F
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED9EC340E8;
        Wed, 16 Mar 2022 01:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647394815;
        bh=FljtnJm4oqbVatLSCslW03iL+AP0Lixtcb/AeXhm3mA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uf5lQ3Qo+aZY3nwoFL3mTOo4LKtwevvePfOXLmtvxUkNeAc/WQnOIR8KV4TsPB6Ol
         OAWe1REVYFQAGPNGwA75wOHNTq7obm9p9FQC4qkzz58K73GQYN3iLfd8mL+EusS105
         FaDXE67NEsYWjUcR4cRYZS/5rBdno1DYAY/s2KUWw8chRgD2OKPgH9soCcRiTvirZa
         HO9JtvgTv3ncO+UfJEPRVGx008ZEeJplZEUaV9MAcQ2cICwVFVg84zhZoBfgcMxLdI
         WVSQvyY9wCUPjJWhz//T2lGOPnWXjN0vw/jI6o+lL6lw/gItmGqSMjLHh5UdhrGv4U
         iVkpggpASehGg==
Date:   Tue, 15 Mar 2022 18:40:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Jie Wang <wangjie125@huawei.com>, mkubecek@suse.cz,
        davem@davemloft.net, netdev@vger.kernel.org,
        huangguangbin2@huawei.com, lipeng321@huawei.com,
        shenjian15@huawei.com, moyufeng@huawei.com, linyunsheng@huawei.com,
        tanhuazhong@huawei.com, salil.mehta@huawei.com,
        chenhao288@hisilicon.com
Subject: Re: [RFC net-next 1/2] net: ethtool: add ethtool ability to set/get
 fresh device features
Message-ID: <20220315184013.0b5970c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <59620a57-f465-917f-1773-65fcf594d3aa@nvidia.com>
References: <20220315032108.57228-1-wangjie125@huawei.com>
        <20220315032108.57228-2-wangjie125@huawei.com>
        <20220315121529.45f0a9d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <59620a57-f465-917f-1773-65fcf594d3aa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 13:03:00 -0700 Roopa Prabhu wrote:
> > I'd be curious to hear more opinions on whether we want to create a new
> > command or use another method for setting this bit, and on the concept
> > of "devfeatures" in general.
> >
> > One immediate feedback is that we're not adding any more commands to
> > the ioctl API. You'll need to implement it in the netlink version of
> > the ethtool API. =20
>=20
> +1,=C2=A0 it would have been nice if we did not have to expose the change=
 in=20
> api for features via=C2=A0 a new option.
>=20
> harder for user to track which features need new option.
>=20
> ie, if possible, it would be better to internally transition new=20
> features to new api.
>=20
> (i have not looked yet if moving to netlink will make the above point moo=
t)

The slight wrinkle on the usual feature API is that it's out of bits
and the work on moving it to bitmap has stalled :S
