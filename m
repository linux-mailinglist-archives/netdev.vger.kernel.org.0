Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A066ACCBC
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjCFSeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjCFSds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:33:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6767464AA1;
        Mon,  6 Mar 2023 10:33:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03791610D5;
        Mon,  6 Mar 2023 18:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0952C433D2;
        Mon,  6 Mar 2023 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678127598;
        bh=FTivFyV4DbisKRHK/tybw6xlcvILxRKLCGqnjHgbTFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EPpjOD9C+AL+8IvdGSre8j5m0IJV9tqOLI+JZ1YzfOYgiggokbCt7VQlhsd8riimp
         Vw7bmibzRyFT52vlaBrcAMkdWOeturZvaR/eKKZMGKqVfJ7SAT4J8nL9Wd1wag/7or
         y0JNtMcGg0L6M5SaShwqxFZc8qupOGihX4MVaFYAMYBYUn28DjcMH7I/9Rb4YrOgku
         RdT/WF891pv1UQ4qD0Fd86KYR44xR2yltu4rrSqMHnxqNoRUMGHnsny2ibw8xuNp1M
         zZBJdp50kOSKgR7T5g7unrJWT2/Xoak2RW5aGMY2TKeA5UPBZS0BTN5hjKia51/ozb
         pcVMMR2Jx8HWA==
Date:   Mon, 6 Mar 2023 10:33:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, idosch@mellanox.com,
        danieller@mellanox.com, petrm@mellanox.com, shuah@kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net
Subject: Re: [PATCH] selftests: net: devlink_port_split.py: skip test if no
 suitable device available
Message-ID: <20230306103316.3224383e@kernel.org>
In-Reply-To: <20230306111959.429680-1-po-hsu.lin@canonical.com>
References: <20230306111959.429680-1-po-hsu.lin@canonical.com>
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

On Mon,  6 Mar 2023 19:19:59 +0800 Po-Hsu Lin wrote:
> The `devlink -j dev show` command output may not contain the "flavour"
> key, for example:
>   $ devlink -j dev show
>   {"dev":{"pci/0001:00:00.0":{},"pci/0002:00:00.0":{}}}

It's not dev that's supposed to have the flavor, it's port.

  devlink -j port show

Are you running with old kernel or old user space?
Flavor is not an optional attribute.

> This will cause a KeyError exception. Fix this by checking the key
> existence first.
> 
> Also, if max lanes is 0 the port splitting won't be tested at all.
> but the script will end normally and thus causing a false-negative
> test result.
> 
> Use a test_ran flag to determine if these tests were skipped and
> return KSFT_SKIP accordingly.
> 
> Link: https://bugs.launchpad.net/bugs/1937133
> Fixes: f3348a82e727 ("selftests: net: Add port split test")
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Could you factor out the existing skipping logic from main()
(the code under "if not dev:") and add the test for flavors
to the same function? It'll be a bit more code but cleaner
result IMHO.
