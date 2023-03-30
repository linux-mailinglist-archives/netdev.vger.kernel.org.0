Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C501D6D0B99
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjC3Qqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbjC3Qqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:46:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDB6D52C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA2D6620F8
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E01C433D2;
        Thu, 30 Mar 2023 16:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680194792;
        bh=XWHy4AoisTQg/N8frKwR0FIisi5JoMsno3W9QkI/CKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QcmkHlFU1ori4JqqdOE1QxREUc5NyRnApA+UFlMqlhwhdhRZfVm7Ugdzy9E/qYNaL
         DxPud2PiDkI5Q97O3foRC9n1uMMLZKXKHfPb4yBYV0JTZE1laWz1ZTP9Sienns1otb
         53ltC5KctCkVgHu+WZVPzote7ecJxZPFY8XWs3ueBiKBhhlDc67pRvx0lUbbhIjZ8c
         CfDGnO/UnB+mj+M3P+JHTfOrAxezkV91Y1xqVm9OZ7Vpy4/PgkunybLG6Gz4wLGrZT
         3qBqAYLe4CnzLgGDlwVgZ6BmAqWovNtXhJmu9svO4JaHzJEgWVzFlJUq3BuF/w9l8u
         qsrGBbDkve53A==
Date:   Thu, 30 Mar 2023 09:46:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Message-ID: <20230330094630.3ba04654@kernel.org>
In-Reply-To: <90284b4a-0e81-441b-5d28-547992dab274@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
        <20230324190243.27722-2-shannon.nelson@amd.com>
        <20230325163952.0eb18d3b@kernel.org>
        <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
        <20230327174347.0246ff3d@kernel.org>
        <822ec781-ce1e-35ef-d448-a3078f68c04f@amd.com>
        <20230328151700.526ea042@kernel.org>
        <45c28c76-688c-5f49-4a30-f6cb6eab0dce@amd.com>
        <20230329192733.7473953c@kernel.org>
        <90284b4a-0e81-441b-5d28-547992dab274@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 00:43:56 -0700 Shannon Nelson wrote:
> On 3/29/23 7:27 PM, Jakub Kicinski wrote:
> > On Wed, 29 Mar 2023 13:53:23 -0700 Shannon Nelson wrote: =20
> >> The devlink alloc and registration are obviously a part of the probe a=
nd
> >> thus device control setup, so I=E2=80=99m not sure why this is an issu=
e.
> >>
> >> As is suggested in coding style, the smaller functions make for easier
> >> reading, and keeps the related locking in a nice little package.  Havi=
ng
> >> the devlink registration code gathered in one place in the devlink.c
> >> file seems to follow most conventions, which then allows the helper
> >> functions to be static to that file.  This seems to be what about half
> >> the drivers that use devlink have chosen to do. =20
> >=20
> > It is precisely the painful experience of dealing with those drivers
> > when refactoring devlink code which makes me ask you to do it right. =20
>=20
> Is there a useful place where such guidance can be put to help future=20
> folks from falling into the same traps?

Putting it mildly we have a reasonable expectation that any large
company will have at least one person reading the mailing list :(
Who's going to write the documentation you're asking about?
This is an open source project, let's be realistic..

