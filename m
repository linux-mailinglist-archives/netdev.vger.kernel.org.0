Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D555667F0F
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbjALT1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbjALT0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:26:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273A965A7
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:20:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2F36B81FF6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 19:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD56C433EF;
        Thu, 12 Jan 2023 19:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551222;
        bh=CoaPy7eX8iA2Gtt8hwFizNzWitdwiIbIQH3fQKRb7H0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=onZae/FIbJpuznTnRakbTt3GZ4r1E0hRtynfdqpbJ10/eGIG8+fpHqT6OzddOd+8x
         YhqNdmqkx/U9ba10EP5WYYDknI5Tst9+2l60/OyZA/8pMdSTgwUirZt8lmIwIaiyyP
         Y7ZF0URZV2u0Vhg2hyuZB2d8wtmrN17cdZYmEnkb1Fdwfbz0bTefE7eqNb0RsA0H6S
         yNR8Rur4Vc5cjHIuSphWmv9gRlSulxnv14jhUZgHcfI08mlz/GkhBV+d1W1rbIwNS1
         49cO1NKsuTPDrIc/XFC3UdOAJEZ5EQ7rsLaMnQvos0NZwz/qkExCMPMoyUcf5i65/i
         TdplcqiqJyOzw==
Date:   Thu, 12 Jan 2023 11:20:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters
 after the instance
Message-ID: <20230112112021.0ff88cdb@kernel.org>
In-Reply-To: <Y7+xv6gKaU+Horrk@unreal>
References: <20230106063402.485336-1-kuba@kernel.org>
        <20230106063402.485336-8-kuba@kernel.org>
        <Y7gaWTGHTwL5PIWn@nanopsycho>
        <20230106132251.29565214@kernel.org>
        <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
        <Y72T11cDw7oNwHnQ@nanopsycho>
        <20230110122222.57b0b70e@kernel.org>
        <Y76CHc18xSlcXdWJ@nanopsycho>
        <20230111084549.258b32fb@kernel.org>
        <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
        <Y7+xv6gKaU+Horrk@unreal>
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

On Thu, 12 Jan 2023 09:07:43 +0200 Leon Romanovsky wrote:
> As a user, I don't want to see any late dynamic object addition which is
> not triggered by me explicitly. As it doesn't make any sense to add
> various delays per-vendor/kernel in configuration scripts just because
> not everything is ready. Users need predictability, lazy addition of
> objects adds chaos instead.
> 
> Agree with Jakub, it is anti-pattern.

To be clear my preference would be to always construct the three from
the root. Register the main instance, then sub-objects. I mean - you
tried forcing the opposite order and it only succeeded in 90-something
percent of cases. There's always special cases.

I don't understand your concern about user experience here. We have
notifications for each sub-object. Plus I think drivers should hold 
the instance lock throughout the probe routine. I don't see a scenario
in which registering the main instance first would lead to retry/sleep
hacks in user space, do you? I'm talking about devlink and the subobjs
we have specifically.
