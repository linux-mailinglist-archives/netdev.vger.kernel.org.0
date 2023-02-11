Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05687692DEE
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBKDeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBKDeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:34:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3129B3A095
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:33:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0E3961E2D
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7ADAC433D2;
        Sat, 11 Feb 2023 03:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676086432;
        bh=HUoVZ/gWBoNCMEc2+cfuIjpX/EtREl1kdASDrNtqPhA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bLx0spRpeZ3sD919EAYxrW2eNOduSdimiy/LsSzYk4xwYPyAsCIc7jhtlfXhQPckZ
         r7M9Wnsp52O/uZNPvFnMKZ+q25qm1NJ9WRyQ/F00MAiQBzTQy8rnG/eB5QedpWr+E5
         q7THgwaaUlXhM1hAA5eaVd7tfSR327HypJCdcoMf7NaDIq9E48+COtEzZQg068SOk+
         JMLP4egNLWfJ/sklY9T8RxRuo69DJMhoQFVUTy822t8FT3mL2XpAsgc/7LVjuUDcVz
         aTAg27/4r0yvpTRM/BvjllTU0rpyQ61X9oCffM0f67xVjmWAhp7/ettelhldK0/A16
         LkaFrR/7Y8eog==
Date:   Fri, 10 Feb 2023 19:33:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>,
        Maksym Yaremchuk <maksymy@nvidia.com>
Subject: Re: [PATCH net] mlxsw: spectrum: Fix incorrect parsing depth after
 reload
Message-ID: <20230210193350.239f707f@kernel.org>
In-Reply-To: <6abc3c92f72af737cb3bba18e610adaa897ced21.1675942338.git.petrm@nvidia.com>
References: <6abc3c92f72af737cb3bba18e610adaa897ced21.1675942338.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Feb 2023 12:40:24 +0100 Petr Machata wrote:
> Spectrum ASICs have a configurable limit on how deep into the packet
> they parse. By default, the limit is 96 bytes.
> 
> There are several cases where this parsing depth is not enough and there
> is a need to increase it. For example, timestamping of PTP packets and a
> FIB multipath hash policy that requires hashing on inner fields. The
> driver therefore maintains a reference count that reflects the number of
> consumers that require an increased parsing depth.
> 
> During reload_down() the parsing depth reference count does not
> necessarily drop to zero, but the parsing depth itself is restored to
> the default during reload_up() when the firmware is reset. It is
> therefore possible to end up in situations where the driver thinks that
> the parsing depth was increased (reference count is non-zero), when it
> is not.

Sounds quite odd TBH, something doesn't get de-registered during _down()
but is registered again during _up()?
