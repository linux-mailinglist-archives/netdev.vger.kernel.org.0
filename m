Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEBC5344A5
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 22:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbiEYUGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 16:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345361AbiEYUFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 16:05:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D20468319;
        Wed, 25 May 2022 13:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29405B81DDA;
        Wed, 25 May 2022 20:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCD1EC34114;
        Wed, 25 May 2022 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653509151;
        bh=KVzGYD0tGkKI0mBq443u0HhvCvFhFhy9kR+aZCjxq/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lAEhhKPYSuCeZNsCzDTIDXPxU4kGtmtva/8vwaMjGZ4EYRAtAUeokBy2z1PuMWr+y
         FgvIebVAs/bP+40SJXK5X6MgpeKG9Y74E3Zve58+XJsNdIlPafiJOPV+nm9+nEjSBT
         NGzs17l9EHGbJ/pUjljXItrmPI5W6v+9wsGuK0p9ljUKkJ5IwFCRm1YFeeks6UwbNG
         QYjDkumNWDcDrUhBTOvKYQF+QpfNvZhVpzE3aHF528ShruyxFoXBT5ry2L/XyUfprn
         3/hvBK5KRLWYNWeWnmi9HmM22K0Grkh1rSS1lcEpzjX4DL/tSDQWW4MHDbs/QHYrx1
         atEYGjRH4qqDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AEAEBF03943;
        Wed, 25 May 2022 20:05:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5.17 126/158] perf stat: Fix and validate CPU map inputs in
 synthetic PERF_RECORD_STAT events
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165350915170.15505.6185203070051218800.git-patchwork-notify@kernel.org>
Date:   Wed, 25 May 2022 20:05:51 +0000
References: <20220523165851.513336276@linuxfoundation.org>
In-Reply-To: <20220523165851.513336276@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        mpetlan@redhat.com, irogers@google.com,
        alexander.shishkin@linux.intel.com, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, davemarchevsky@fb.com,
        james.clark@arm.com, jolsa@kernel.org, john.fastabend@gmail.com,
        kan.liang@linux.intel.com, kpsingh@kernel.org, lv.ruyi@zte.com.cn,
        mark.rutland@arm.com, kafai@fb.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        quentin@isovalent.com, songliubraving@fb.com, eranian@google.com,
        zhengjun.xing@linux.intel.com, yhs@fb.com, acme@redhat.com,
        sashal@kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Arnaldo Carvalho de Melo <acme@redhat.com>:

On Mon, 23 May 2022 19:04:43 +0200 you wrote:
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit 92d579ea3279aa87392b862df5810f0a7e30fcc6 ]
> 
> Stat events can come from disk and so need a degree of validation. They
> contain a CPU which needs looking up via CPU map to access a counter.
> 
> [...]

Here is the summary with links:
  - [5.17,126/158] perf stat: Fix and validate CPU map inputs in synthetic PERF_RECORD_STAT events
    https://git.kernel.org/netdev/net/c/92d579ea3279

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


