Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784BA6CF91E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 04:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjC3C1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 22:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3C1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 22:27:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974984C2D
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 421A3B82583
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A712C433D2;
        Thu, 30 Mar 2023 02:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680143254;
        bh=ZsDWsVt11/2IHfBwYZ9LW7kROO2uoVu9ogqnpHpawVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GP8Uw23HJL4hDn9JQ920QdCxrxc526K7ryAK6KEE8oRJV5n7tkJYhWFyaHT/LyYLb
         QkMk7v0o3YjRA0No9OedTTLQHhcjsssiYFiY59xHmTgwdVpNH7h1I+XBuDo9ijM4am
         0WkiU1dNYxaPTyKDNpgMas7P/heQ35Clwd3oS1SYc5lQPednrqIeLLKuDmDpDrGca9
         U5rv1STRhu9RnMKLP4ZiySPTXatvOtbvGH4c0bVJ+Hn4lbVnhco4jDm8rOYK9KNGG9
         har/VNSnL2hAhY/Xr2GxY5biSQQGiGr/fBV0kWLkyBH4QINSj53YdFUakVSWWMiPNS
         yWIUsIkm/L8Yw==
Date:   Wed, 29 Mar 2023 19:27:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Message-ID: <20230329192733.7473953c@kernel.org>
In-Reply-To: <45c28c76-688c-5f49-4a30-f6cb6eab0dce@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
        <20230324190243.27722-2-shannon.nelson@amd.com>
        <20230325163952.0eb18d3b@kernel.org>
        <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
        <20230327174347.0246ff3d@kernel.org>
        <822ec781-ce1e-35ef-d448-a3078f68c04f@amd.com>
        <20230328151700.526ea042@kernel.org>
        <45c28c76-688c-5f49-4a30-f6cb6eab0dce@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 13:53:23 -0700 Shannon Nelson wrote:
> The devlink alloc and registration are obviously a part of the probe and=
=20
> thus device control setup, so I=E2=80=99m not sure why this is an issue.
>=20
> As is suggested in coding style, the smaller functions make for easier=20
> reading, and keeps the related locking in a nice little package.  Having=
=20
> the devlink registration code gathered in one place in the devlink.c=20
> file seems to follow most conventions, which then allows the helper=20
> functions to be static to that file.  This seems to be what about half=20
> the drivers that use devlink have chosen to do.

It is precisely the painful experience of dealing with those drivers
when refactoring devlink code which makes me ask you to do it right.

> Sure, I could move that function into main.c and make the helper=20
> functions more public if that is what you=E2=80=99re looking for.  This s=
eems to=20
> be the choice for a few of the other drivers.
>=20
> Or are you looking to have all of the devlink.c code get rolled into main=
.c?

Not all of the code, but don't wrap parts of probe/remove into
out-of-sight helpers. It will lead to other devlink code collecting
in the same functions regardless of whether it's the right stage of=20
initialization. Having devlink.c as an entry point for the ops is=20
perfectly fine, OTOH.
