Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C01F4EE127
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbiCaS4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiCaS4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:56:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE57192357;
        Thu, 31 Mar 2022 11:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81F00B81FB5;
        Thu, 31 Mar 2022 18:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7280C340EE;
        Thu, 31 Mar 2022 18:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648752852;
        bh=cE2VdA/h/XTdqDk0/6qzfoxKeN6uZi8s1gUGZrTEgf4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DMEpuMjMJQrp7Zv+ba0Yh8YR7Ub4MnWh1JQ1UQaJyix7H9fbyfTWKMqfLrQ/jewFP
         gvRiPEpJIvIN9bEPXDF7Z9umnkeFbsS/lf9Vanr7ZGqOnN/RdDhBOIX3JdsaZDWmnV
         Af27XJf05A/Hxm4s5o6dOANmevvUCw4mkzUkx/0e37HpkzIiR9XMVKL5LM5Rm35zQG
         I8AdGNyCNMGbmu8ki5EPke5LgMkSm65GdZKwgG+tMX891FCx6WV4HHezyJOP2f9KFL
         oaXJWhc4n6Ebife53yyfj2gm2azedZ9jJXjq8zyBmf+d+L200TYJ3aIsl4wJYcEgW7
         xdO823slHisnw==
Date:   Thu, 31 Mar 2022 11:54:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK <linux-kselftest@vger.kernel.org>, 
        open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
        Netdev" <netdev@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: kselftest: net: tls: hangs
Message-ID: <20220331115410.34156bb9@kernel.org>
In-Reply-To: <CA+G9fYsX=NfUoSXHGEqo_pPqrZ7dxt8+iiQMiAm4dEemNtwq1g@mail.gmail.com>
References: <CA+G9fYsntwPrwk39VfsAjRwoSNnb3nX8kCEUa=Gxit7_pfD6bg@mail.gmail.com>
        <8c81e8ad-6741-b5ed-cf0a-5a302d51d40a@linuxfoundation.org>
        <20220325161203.7000698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <08c5c6f3-e340-eaee-b725-9ec1a4988b84@linuxfoundation.org>
        <CA+G9fYsjP2+20YLbKTFU-4_v+VLq6MfaagjERL9PWETs+sX8Zg@mail.gmail.com>
        <20220329102649.507bbf2a@kernel.org>
        <CA+G9fYsX=NfUoSXHGEqo_pPqrZ7dxt8+iiQMiAm4dEemNtwq1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 13:18:56 +0530 Naresh Kamboju wrote:
> Hi Jakub,
> 
> > Can you check where the process is stuck and it's state?
> > /proc/$pid/stack and run that thru scripts/decode_stacktrace
> >  
> 
> Steps to reproduce:
>           - cd /opt/kselftests/default-in-kernel/net
>           - ./tls &
>           - tests_pid=$!
>           - echo $tests_pid
>           - sleep 90
>           - cat /proc/$tests_pid/stack | tee tests_pid_stack.log
>           - cat tests_pid_stack.log
> 
> [<0>] do_wait+0x191/0x3a0
> [<0>] kernel_wait4+0xaf/0x160
> [<0>] __do_sys_wait4+0x85/0x90
> [<0>] __x64_sys_wait4+0x1c/0x20
> [<0>] do_syscall_64+0x5c/0x80
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

The kernel test harness runs the tests in a separate process,
this is the stack trace for the main process. We'll need a stack trace
for the child, so:

	main_pid=$!
	tests_pid=$(pgrep -P $main_pid)

Also since each test runs in a separate child, we can try to catch the
one that got stuck for longer than 30 sec:

	pp=$(pgrep -P $main_pid)
	while true; do 
		sleep 30
		p=$(pgrep -P $main_pid)
		if [ $p != $pp ]; then
			pp=$p
			echo "New PID $p, continue waiting..."
			continue
		fi

		echo "PID $p is stuck!"
		cat /proc/$p/stack
	done

> Detail test log can be found here in this link [1]
> 
> I do not see any output from
> ./scripts/decode_stacktrace.sh  stack-dump.txt
> 
> 
> - Naresh
> 
> [1] https://lkft.validation.linaro.org/scheduler/job/4812800#L2256

