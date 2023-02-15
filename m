Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22E4698430
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBOTK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjBOTK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:10:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE022A6F7;
        Wed, 15 Feb 2023 11:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB17761D2D;
        Wed, 15 Feb 2023 19:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D95C433EF;
        Wed, 15 Feb 2023 19:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676488222;
        bh=aRpikr0zsyyqLLytek0o654D7o3kNoTfCOtRIn/lAIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AU6Kqdu0qJNMmg5XdZnTRngJGdkSGECgLNlTocJLz37k9CmvHiuT4RZJeEdSyFdVi
         qNKlEBLVo7sHRExul5yrmEBVeSvK1j2TdPvm24Z+PyCoE/4ZaSEYEpQMq1nl7Fj+JC
         bGTlwyfynUGn1XoI+cuvw27kXcGbVrQ2chHrrEtKGKcv0AoU06Z67J+SgZjZJwzBio
         ygsDRBKgLcIgUKgVgySJpaWoNzHs9q+joP2QwQ0CAW6UV83M2WSoY94kXOjKI1BChi
         znBl3+4qjIawnCiWTuVay1jgFhBta+Z2I942GWbYBu/Dp4b3vBj2+qtA1wUfuBrNxl
         yPRT2XSWl0v5w==
Date:   Wed, 15 Feb 2023 11:10:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH net-next v2 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230215111020.0c843384@kernel.org>
In-Reply-To: <Y+0Wjrc9shLkH+Gg@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
        <20230214210811.448b5ec4@kernel.org>
        <Y+0Wjrc9shLkH+Gg@hog>
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

On Wed, 15 Feb 2023 18:29:50 +0100 Sabrina Dubroca wrote:
> > And how will we handle re-keying in offload?  
> 
> Sorry for the stupid question... do you mean that I need to solve that
> problem before this series can progress, or that the cover letter
> should summarize the state of the discussion?

I maintain that 1.3 offload is much more important than rekeying.
Offloads being available for 1.2 may be stalling adoption of 1.3
(just a guess, I run across this article mentioning 1.2 being used
in Oracle cloud for instance:
https://blogs.oracle.com/cloudsecurity/post/how-oci-helps-you-protect-data-with-default-encryption
could be because MITM requirements, or maybe they have HW which
can only do 1.2? Dunno).

But I'm willing to compromise, we just need a solid plan of how to
handle the inevitable. I'm worried that how this will pay out is:
 - you don't care about offload and add rekey
 - vendors don't care about rekey and add 1.3
  ... time passes ...
 - both you and the vendors have moved on
 - users run into issues, waste their time debugging and
   eventually report the problem upstream
 - it's on me to fix?

:(
