Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D224DA775
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 02:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352827AbiCPBqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 21:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245032AbiCPBqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 21:46:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1673E5E6
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 18:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5C5961614
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA121C340E8;
        Wed, 16 Mar 2022 01:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647395128;
        bh=J390HQz5xp6EP8GvCthPXxoQZAiK3X3s3buuRk8fSeg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JWZGOEFVao2oWkJ0Ta1W6F8W88USN7ae4W0Swq29n5UTzEJgucVck2DNKDDxD8j7o
         9OHKsBj4OEz7738ZwIH0DfL+JW/d3s1loN8zpJI+uMsIeKpa2YC4av2PGp9cbEhqLp
         q9jZIJBgmLux15vNbfGMjSeSGi48Z7I0MzNbtXflhIdd4DnjoX3xYMQ/s+7P0tyGW3
         TF8f6OHh02OUouObtPGef6QAmqCaqSBj5mAka6t1BrfzAGhIE8Z3Y/Uf5FOOnkpL4H
         lOG105rY51ZR8ybaFKsk6VyDWq/wEPR9o75AJoX951++cmBfz67jut0UX1BZ2P0Yfe
         ZXx05pp+XymLA==
Date:   Tue, 15 Mar 2022 18:45:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jie Wang <wangjie125@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, huangguangbin2@huawei.com,
        lipeng321@huawei.com, shenjian15@huawei.com, moyufeng@huawei.com,
        linyunsheng@huawei.com, tanhuazhong@huawei.com,
        salil.mehta@huawei.com, chenhao288@hisilicon.com
Subject: Re: [RFC net-next 1/2] net: ethtool: add ethtool ability to set/get
 fresh device features
Message-ID: <20220315184526.3e15e3ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315195606.ggc3eea6itdiu6y7@lion.mk-sys.cz>
References: <20220315032108.57228-1-wangjie125@huawei.com>
        <20220315032108.57228-2-wangjie125@huawei.com>
        <20220315121529.45f0a9d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220315195606.ggc3eea6itdiu6y7@lion.mk-sys.cz>
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

On Tue, 15 Mar 2022 20:56:06 +0100 Michal Kubecek wrote:
> On Tue, Mar 15, 2022 at 12:15:29PM -0700, Jakub Kicinski wrote:
> > On Tue, 15 Mar 2022 11:21:07 +0800 Jie Wang wrote: =20
> > > As tx push is a standard feature for NICs, but netdev_feature which is
> > > controlled by ethtool -K has reached the maximum specification.
> > >=20
> > > so this patch adds a pair of new ethtool messages=EF=BC=9A'ETHTOOL_GD=
EVFEAT' and
> > > 'ETHTOOL_SDEVFEAT' to be used to set/get features contained entirely =
to
> > > drivers. The message processing functions and function hooks in struct
> > > ethtool_ops are also added.
> > >=20
> > > set-devfeatures/show-devfeatures option(s) are designed to provide set
> > > and get function.
> > > set cmd:
> > > root@wj: ethtool --set-devfeatures eth4 tx-push [on | off]
> > > get cmd:
> > > root@wj: ethtool --show-devfeatures eth4 =20
> >=20
> > I'd be curious to hear more opinions on whether we want to create a new
> > command or use another method for setting this bit, and on the concept
> > of "devfeatures" in general. =20
>=20
> IMHO it depends a lot on what exactly "belong entirely to the driver"
> means. If it means driver specific features, using a private flag would
> seem more appropriate for this particular feature and then we can
> discuss if we want some generalization of private flags for other types
> of driver/device specific parameters (integers etc.). Personally, I'm
> afraid that it would encourage driver developers to go this easier way
> instead of trying to come with universal and future proof interfaces.

The "belong entirely to the driver" meant that the stack does not need
to be aware of it. That's the justification for not putting it in
netdev features, which the stack also peeks at, at times.

> If this is supposed to gather universal features supported by multiple
> drivers and devices, I suggest grouping it with existing parameters
> handled as tunables in ioctl API. Or perhaps we could keep using the
> name "tunables" and just handle them like any other command parameters
> encoded as netlink attributes in the API.

Let's throw tunables into the hell fire where they belong, lest they
spawn a monster in the image of devlink params.

How about we put it in SET_RINGS? It's a ring param after all=20
(the feature controls use of a fast path descriptor push which=20
skips the usual in-memory ring).
