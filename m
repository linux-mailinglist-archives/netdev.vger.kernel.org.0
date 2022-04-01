Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438C84EF8DB
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 19:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349873AbiDARY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 13:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349922AbiDARYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 13:24:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EC7208C3C
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 10:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FB88B82576
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 17:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EB3C2BBE4;
        Fri,  1 Apr 2022 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648833751;
        bh=mTHMuWAj205cl8+NNwYr+ykZTytkBayxLRN6XLi8p4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TSECY3/Ylt3UsOo7ei3U78n/JbGKGTto0bG5paWrBAuqhSarx2T615zv6Bt9CEYQI
         orHgtDE4/lLQQczVwtmlBkaexfiATOYaYdnpe02wX8OSWqYitENT4Zn7dCKSPsAvkA
         QviuAHq1HBNURuhut4zOUIXSpva28DcNo9M2nsfIjAi6cffUtnCpT5gCJbHGUPgU7M
         vLXgP7uMPUEIyRVTe15JvxY01Bqzrb24uhvPW1i3x4ewVPOSlnTRCqoTGUGNtxyNFB
         0xrLIcg7MfIBXygXbLRhXW53jTt/iw0DJDRjHT8r+Q5/PTQIznwucRrPi4CfJvw/hb
         m22r5iOZmvwlA==
Date:   Fri, 1 Apr 2022 10:22:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?= 
        <niklas.soderlund@corigine.com>,
        Danie du Toit <danie.dutoit@corigine.com>
Subject: Re: [PATCH net] nfp: do not use driver_data to index device info
Message-ID: <20220401102230.2caab128@kernel.org>
In-Reply-To: <20220401111936.92777-1-simon.horman@corigine.com>
References: <20220401111936.92777-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Apr 2022 13:19:36 +0200 Simon Horman wrote:
> From: Niklas S=C3=B6derlund <niklas.soderlund@corigine.com>
>=20
> When adding support for multiple chips the struct pci_device_id
> driver_data field was used to hold a index to lookup chip device
> specific information from a table. This works but creates a regressions
> for users who uses /sys/bus/pci/drivers/nfp_netvf/new_id.
>=20
> For example, before the change writing "19ee 6003" to new_id was
> sufficient=20

Can you explain the use case? I think this worked somewhat
coincidentally. If we had entries that matched subvendor =3D 0
subdevice =3D 0 it'd fail with EEXIST.

> but after one needs to write enough fields to be able to also
> match on the driver_data field, "19ee 6003 19ee ffffffff ffffffff 0 1".
>=20
> The usage of driver_data field was only a convenience and in the belief
> the driver_data field was private to the driver and not exposed in
> anyway to users. Changing the device info lookup to a function that
> translates from struct pci_device_id device field instead works just as
> well and removes the user facing regression.

I think you're trading a coincidental "feature" while breaking what
new_id is actually supposed to be used for. Which is adding IDs.
nfp_get_dev_info() you add only recognizes existing IDs.

> As a bonus the enum and table with lookup information can be moved out
> from a shared header file to the only file where it's used.
>=20
> Reported-by: Danie du Toit <danie.dutoit@corigine.com>
> Fixes: e900db704c8512bc ("nfp: parametrize QCP offset/size using dev_info=
")
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund@corigine.com>
