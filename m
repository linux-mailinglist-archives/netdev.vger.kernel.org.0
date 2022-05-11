Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69500524102
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349304AbiEKXZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349228AbiEKXZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:25:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C335210898;
        Wed, 11 May 2022 16:25:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E19461DD1;
        Wed, 11 May 2022 23:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEEDC340EE;
        Wed, 11 May 2022 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652311522;
        bh=Xr/PGgbfybpVEpcSOPJrloL7Oo2fDa2irJaiFzNYSbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DmxBDFhiv2XAlPhLcdRkck7Dt+lIq/JWyu0hPYVLlkUUnopoh5NnERA4sBAq4rcq/
         oXQKL+ke0kCLJspodU4klWRwgnVLdB0cLww6yvGaiGSzBCthft4unMT7JqesiSNlqE
         n82eBQe77u4yHuTvHeUb5wk1fTdB+zHEVzu1Va9cbLqiAI7ZhgbV7IR8g5jxf7tI82
         QoFyHOh/LD6q1qsiy6cQtC3jO49fLwHjallXRWjYxcMKKyqUN82q1P2vJVjNekvM/f
         zpPrQdmNFdKRDRO24gKvdeeq2Do0r+rR725Zuzo9L2k+V4m0MIptL/DdoM83hRCMWj
         3E0+8KrgGfj8A==
Date:   Wed, 11 May 2022 16:25:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC,net-next,x86 0/6] Nontemporal copies in unix socket write
 path
Message-ID: <20220511162520.6174f487@kernel.org>
In-Reply-To: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
References: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022 20:54:21 -0700 Joe Damato wrote:
> Initial benchmarks are extremely encouraging. I wrote a simple C program to
> benchmark this patchset, the program:
>   - Creates a unix socket pair
>   - Forks a child process
>   - The parent process writes to the unix socket using MSG_NTCOPY - or not -
>     depending on the command line flags
>   - The child process uses splice to move the data from the unix socket to
>     a pipe buffer, followed by a second splice call to move the data from
>     the pipe buffer to a file descriptor opened on /dev/null.
>   - taskset is used when launching the benchmark to ensure the parent and
>     child run on appropriate CPUs for various scenarios

Is there a practical use case?

The patches look like a lot of extra indirect calls.
