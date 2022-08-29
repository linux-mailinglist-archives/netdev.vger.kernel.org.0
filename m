Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5545A43C2
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiH2H15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2H1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:27:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1894DF01;
        Mon, 29 Aug 2022 00:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F72ECE0E62;
        Mon, 29 Aug 2022 07:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951C0C433D7;
        Mon, 29 Aug 2022 07:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661758068;
        bh=QBKOCoTZ6XZgyyunpEAs68DUjO/2pOPpwNeRHbtxvMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJSIQ1Lb0E3HGCPjCT7ITuT8fzC+A8MCwrjZcRnWMOD+YktvB5KCIL8TykwxdnzH/
         eQWB73STnszdOdUhX4Ms1V+BX/Bfv3bcAx8CJIKy7t50xRUVMlCSKX+vW1kiaZr8Ff
         VyCY5IIh/V7Qjsaoz+tR5LWuWcuWNTt982UTYJ7r2WA+P8AVuPT0kBnNuavGCL5Zpn
         5vUvTPNLUdXSN2jL2grMBfMqxR+/a2SRYxOciy148qfBNdAyUMFpU9p6wXJ6Cvhn3n
         IQ3sDiffpSGTrX3SxDpuNBPJIXOzvd+gaiqwJbaMN3mm25zVWyyo24gJuSw+7i5WRq
         Sst1GXxFliyQQ==
Date:   Mon, 29 Aug 2022 09:27:41 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Gabriel Ryan <gabe@cs.columbia.edu>,
        Abhishek Shah <abhishek.shah@columbia.edu>,
        linux-kernel@vger.kernel.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net,
        hannes@cmpxchg.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: Re: data-race in cgroup_get_tree / proc_cgroup_show
Message-ID: <20220829072741.tsxfgjp75lywzlgn@wittgenstein>
References: <CAEHB249jcoG=sMGLUgqw3Yf+SjZ7ZkUfF_M+WcyQGCAe77o2kA@mail.gmail.com>
 <20220819072256.fn7ctciefy4fc4cu@wittgenstein>
 <CALbthtdFY+GHTzGH9OujzqpOtWZAqsU3MAsjv5OpwZUW6gVa7A@mail.gmail.com>
 <YwuySgH4j6h2CGvk@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwuySgH4j6h2CGvk@slm.duckdns.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 28, 2022 at 08:22:02AM -1000, Tejun Heo wrote:
> On Mon, Aug 22, 2022 at 01:04:58PM -0400, Gabriel Ryan wrote:
> > Hi Christian,
> > 
> > We ran a quick test and confirm your suggestion would eliminate the
> > data race alert we observed. If the data race is benign (and it
> > appears to be), using WRITE_ONCE(cgrp_dfl_visible, true) instead of
> > cmpxchg in cgroup_get_tree() would probably also be ok.
> 
> I don't see how the data race can lead to anything but would the following
> work?

Yep. You can take my,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
when you turn it into a patch.
