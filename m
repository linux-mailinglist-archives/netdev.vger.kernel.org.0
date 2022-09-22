Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D535E62C2
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiIVMuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiIVMup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:50:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8E9E11C1
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 05:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EE54B83635
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E72C433C1;
        Thu, 22 Sep 2022 12:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663851042;
        bh=m/FwU2dcL90ZC3pn99kQWbwdnuMYzMVQjWLPINwONbY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DtyAyvidO9xcwUgnqAY1igUeBEx5dJowYRTFhdyb2tddEGgOH0Ocbgn7MeDRj2LbC
         H9YT8UYhejPPRBf1sqFHt/rD9lJ3SiIyzH9sv0h9R+E+rGzPqnXgHAUtKRLsAJdQxg
         QZGm9wmB1jun3Yj0L9auK07o804aS5QC4Juv+CdhTCUHR/vPtNPw9cWY1MT7cIjJCz
         8b+1d1N0XMuyPKrqnLV9NE6AgIlW0w3VXnXDplW4tyyPI2rxzHOJ9P9k18UjZU9Z7T
         0F51aZzbQThLgfn7lHPfz8HFIZONsB5LKMrPeFc7oHsiMPIWlcxUUsK4jGHoXGF8Mu
         ydXSvpkLHqxug==
Date:   Thu, 22 Sep 2022 05:50:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <20220922055040.7c869e9c@kernel.org>
In-Reply-To: <477ea14d-118a-759f-e847-3ba93ae96ea8@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
        <20220915134239.1935604-3-michal.wilczynski@intel.com>
        <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
        <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
        <20220921163354.47ca3c64@kernel.org>
        <477ea14d-118a-759f-e847-3ba93ae96ea8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 13:44:14 +0200 Wilczynski, Michal wrote:
> Below I'll paste the output of how initially the topology looks like for =
our
> hardware.
> If the devlink_port objects are present (as in switchdev mode), there
> should also be vport nodes represented. It is NOT a requirement for
> a queue to have a vport as it's ancestor.

Thanks! How did you know that my preferred method of reading=20
hierarchies is looking at a linear output!? =F0=9F=98=95

Anyway. My gut feeling is that this is cutting a corner. Seems=20
most natural for the VF/PF level to be controlled by the admin
and the queue level by whoever owns the queue. The hypervisor
driver/FW should reconcile the two and compile the full hierarchy.
