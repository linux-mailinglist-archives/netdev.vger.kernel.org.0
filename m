Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B264BB08D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiBREMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:12:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiBREMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:12:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAAF3D1E8
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 20:12:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E7B8B82555
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B79C340E9;
        Fri, 18 Feb 2022 04:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645157535;
        bh=edLjz+QzquZgYqiGMKoOgJNc14tR2v3+0lntEcUzpA4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fMMnU3MwxTjtUk9vZ0No+TNqLdT1/rdlBsQfRlOBwELox6MqkHG9fmPXRKWCTnER4
         UeIkaXZzhvBcwvqWBAO4dckxZmbSQSYtnkmgC2Bv/lPX89jluEHx7eLdMpv9gQdZRD
         lw3xl+dmW3s6Y2MVdJu/acUFLE2OhNSK7pC7FkKPY0GnqgXL5m/CL+UOUQFnj772/S
         JJJ2o/NFAGfm2GGXTx83wdmbjVQNO6oVP80q7xCJIti9OMkBqmjRbrSQ5JOXc2j2B+
         HVva2s4mkwSVf8Zv+7LtZPkQb/205lZg97qK9raH++zH801s90AClZhiXS0qGvLqfT
         64pjYzPcV2zmA==
Date:   Thu, 17 Feb 2022 20:12:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH net-next 1/4] ionic: catch transition back to RUNNING
 with fw_generation 0
Message-ID: <20220217201213.3e794f82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217220252.52293-2-snelson@pensando.io>
References: <20220217220252.52293-1-snelson@pensando.io>
        <20220217220252.52293-2-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 14:02:49 -0800 Shannon Nelson wrote:
> In some graceful updates that get initially triggered by the
> RESET event, especially with older firmware, the fw_generation
> bits don't change but the fw_status is seen to go to 0 then back
> to 1.  However, the driver didn't perform the restart, remained
> waiting for fw_generation to change, and got left in limbo.
> 
> This is because the clearing of idev->fw_status_ready to 0
> didn't happen correctly as it was buried in the transition
> trigger: since the transition down was triggered not here
> but in the RESET event handler, the clear to 0 didn't happen,
> so the transition back to 1 wasn't detected.
> 
> Fix this particular case by bringing the setting of
> idev->fw_status_ready back out to where it was before.
> 
> Fixes: 398d1e37f960 ("ionic: add FW_STOPPING state")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

This looks like a fix, and should go separately to net.
Is there a reason behind posting together? The other patches
don't even depend on this one.
