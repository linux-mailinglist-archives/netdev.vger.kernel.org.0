Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7406C76AE
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 05:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjCXEuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 00:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCXEuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 00:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5CE7A80
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 21:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C819FB822DA
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CACDC433EF;
        Fri, 24 Mar 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679633419;
        bh=V/vqCeb3RbgmvX2bnF4HvOb2pb2BDpG+AfkyZn/6l7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cNsWgxR+BBstW9b8fk8feGehNBcKgdbFPE+8xS1SSm55McwsBBlCp40fw28lwqpFP
         mCu60LPUxdoEipLnoJOw4p6gGmz4NocHya1NFQwiO0InG6gaGdze7sJ7XtMohe7cc+
         r+PpxsjcN/5UfFJtwevCUi0hLJ0kCwwKzDgsDEF+x4F9zQk8I0P4PqYLtaTo1MLrgZ
         CddJ8EuwgQVopVv6RdHzsEp4qCidkg73YgDXKmdTogV3P3RxX6n30K8R6Sm9FyMV4k
         0B4LQm/I6Yde5VE+XYegdXLEQZBxEUBCVVPtahwpS3AfvFnmcx1nUk8dhQj2mdBDAk
         m5jc7C+2ouLXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58EACE21ED4;
        Fri, 24 Mar 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] ynl: allow to encode u8 attr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167963341934.15621.1845708945689435953.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 04:50:19 +0000
References: <20230322154242.1739136-1-jiri@resnulli.us>
In-Reply-To: <20230322154242.1739136-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, sdf@google.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Mar 2023 16:42:42 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Playing with dpll netlink, I came across following issue:
> $ sudo ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do pin-set --json '{"id": 0, "pin-idx": 1, "pin-state": 1}'
> Traceback (most recent call last):
>   File "tools/net/ynl/cli.py", line 52, in <module>
>     main()
>   File "tools/net/ynl/cli.py", line 40, in main
>     reply = ynl.do(args.do, attrs)
>   File "tools/net/ynl/lib/ynl.py", line 520, in do
>     return self._op(method, vals)
>   File "tools/net/ynl/lib/ynl.py", line 476, in _op
>     msg += self._add_attr(op.attr_set.name, name, value)
>   File "tools/net/ynl/lib/ynl.py", line 344, in _add_attr
>     raise Exception(f'Unknown type at {space} {name} {value} {attr["type"]}')
> Exception: Unknown type at dpll pin-state 1 u8
> 
> [...]

Here is the summary with links:
  - [net-next] ynl: allow to encode u8 attr
    https://git.kernel.org/netdev/net-next/c/8da3a5598f75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


