Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC6F67D9AA
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 00:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjAZXgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 18:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjAZXgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 18:36:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787446E8D;
        Thu, 26 Jan 2023 15:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 041E96195A;
        Thu, 26 Jan 2023 23:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16495C433D2;
        Thu, 26 Jan 2023 23:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674776182;
        bh=cPm84o+nqzhJbSBqPDEbZFcbpmAeNiCQxfVc3mt7rG4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QrjlmhB6v5onaZjVqbMBM45Us0L3cXsqVmsgBoIDhc6a9HlZHJgLJWH48U/hHSzGH
         HgggOzLMH60CHzHFmXpBfTt51FlHEk+Evohw34AKXIg3tgYo9QiEaVA21fbFHzkrkk
         +JMgeXsNneLEhE12xmMhP8KijseB5Hwvw0hrT3WttIXzTXwRNwq2mfUvdRGu6aiOGV
         DYW0N9okYjznn6/QrSZRNYjvGZ1YjwcaqZ2JwzLoc3sbAb/3457LJvcB4Gsy8BDTCU
         Yi3DlRGSv3XTk0urUoNanI4msEkGMhQQ0zFQG8esAhqnFYNWxvyTq8GmwxqBnEjvFa
         KHuiixcUH3xtA==
Date:   Thu, 26 Jan 2023 15:36:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH v2 1/2] selftests: net: Fix missing nat6to4.o when
 running udpgro_frglist.sh
Message-ID: <20230126153621.7503a73e@kernel.org>
In-Reply-To: <Y9JPiA11CHNOMibr@qwirkle>
References: <20230125211350.113855-1-andrei.gherzan@canonical.com>
        <20230125230843.6ea157b1@kernel.org>
        <Y9JPiA11CHNOMibr@qwirkle>
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

On Thu, 26 Jan 2023 10:01:44 +0000 Andrei Gherzan wrote:
> On 23/01/25 11:08PM, Jakub Kicinski wrote:
> > On Wed, 25 Jan 2023 21:13:49 +0000 Andrei Gherzan wrote:  
> > > The udpgro_frglist.sh uses nat6to4.o which is tested for existence in
> > > bpf/nat6to4.o (relative to the script). This is where the object is
> > > compiled. Even so, the script attempts to use it as part of tc with a
> > > different path (../bpf/nat6to4.o). As a consequence, this fails the script:  
> > 
> > Is this a recent regression? Can you add a Fixes tag?  
> 
> This issue seems to be included from the beginning (edae34a3ed92). I can't say
> why this was not seen before upstream but on our side, this test was disabled
> internally due to lack of CC support in BPF programs. This was fixed in the
> meanwhile in 837a3d66d698 (selftests: net: Add cross-compilation support for
> BPF programs) and we found this issue while trying to reenable the test.
> 
> So if you think that is reasonable, I could add a Fixes tag for the initial 
> script commit edae34a3ed92 (selftests net: add UDP GRO fraglist + bpf
> self-tests) and push a v3.

We have queued commit 3c107f36db06 ("selftests/net: mv bpf/nat6to4.c 
to net folder") in net-next, I think that should fix it, too?

> > What tree did you base this patch on? Doesn't seem to apply  
> 
> The patches were done on top of
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git, the master
> branch - 948ef7bb70c4 (Merge tag 'modules-6.2-rc6' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux). There is another
> merge that happened in the meanwhile but the rebase works without issues. I can
> send a rebased v3 if needed.

Could you try linux-next or net-next ?
