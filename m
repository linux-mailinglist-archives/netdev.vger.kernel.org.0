Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6735FD305
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJMBwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiJMBwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:52:01 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26BB1146;
        Wed, 12 Oct 2022 18:52:00 -0700 (PDT)
Message-ID: <469d28c0-8156-37ad-d0d9-c11608ca7e07@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665625918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hdgnqq1ARkg6g154LJ5+p1ignceb1z/i3AWqnB/XZ+g=;
        b=P+oVc9Cu0CtgdYsrUtq9NLcCVK9oxxLF+GNIcSA64k6NuIGitdlqAtI+o/Uk0qqK4G0e8G
        Aog2QcqylGq6+eLNFEmLNLIL7LIx7xuJvmCa1+yoYayXnQNKuuhrXew6CLi7lQUdTsNSPC
        RAGvQKEBjODEKFJWlwQ1dbTV7z4eh2c=
Date:   Wed, 12 Oct 2022 18:51:55 -0700
MIME-Version: 1.0
Subject: Re: [net 1/2] selftests/net: fix opening object file failed
To:     Wang Yufen <wangyufen@huawei.com>,
        Lina Wang <lina.wang@mediatek.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lina.wang@mediatek.com,
        deso@posteo.net, netdev@vger.kernel.org
References: <1665482267-30706-1-git-send-email-wangyufen@huawei.com>
 <1665482267-30706-2-git-send-email-wangyufen@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <1665482267-30706-2-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/22 2:57 AM, Wang Yufen wrote:
> The program file used in the udpgro_frglist testcase is "../bpf/nat6to4.o",
> but the actual nat6to4.o file is in "bpf/" not "../bpf".
> The following error occurs:
>    Error opening object ../bpf/nat6to4.o: No such file or directory

hmm... so it sounds like the test never works...

The test seems like mostly exercising the tc-bpf?  It makes sense to move it to 
the selftests/bpf. or staying in net is also fine for now and only need to fix 
up the path here.

However, if moving to selftests/bpf, I don't think it is a good idea to only 
move the bpf prog but not moving the actual test program (the script here) such 
that the bpf CI can continuously testing it.  Otherwise, it will just drift and 
rot slowly like patch 2.

Also, if you prefer to move it to selftests/bpf, the bpf prog cannot be moved in 
the current form.  eg. There is some convention on the SEC name in the 
selftests/bpf/progs.  Also, the testing script needs to be adapted to the 
selftests/bpf/test_progs infra.

