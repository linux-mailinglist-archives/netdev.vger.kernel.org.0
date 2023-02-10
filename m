Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD738692578
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbjBJSiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjBJSiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:38:04 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64A77A7DC;
        Fri, 10 Feb 2023 10:38:01 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pQYHP-00077w-RR; Fri, 10 Feb 2023 19:37:51 +0100
Message-ID: <a17e64e1-845f-e8d5-02ed-a59587cbf5b5@leemhuis.info>
Date:   Fri, 10 Feb 2023 19:37:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Bug report: UDP ~20% degradation
Content-Language: en-US, de-DE
To:     Tariq Toukan <tariqt@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Chen <david.chen@nutanix.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Network Development <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>, Malek Imam <mimam@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>
References: <113e81f6-b349-97c0-4cec-d90087e7e13b@nvidia.com>
From:   "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <113e81f6-b349-97c0-4cec-d90087e7e13b@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1676054281;94fb6658;
X-HE-SMSGID: 1pQYHP-00077w-RR
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 08.02.23 12:08, Tariq Toukan wrote:
> 
> Our performance verification team spotted a degradation of up to ~20% in
> UDP performance, for a specific combination of parameters.
> 
> Our matrix covers several parameters values, like:
> IP version: 4/6
> MTU: 1500/9000
> Msg size: 64/1452/8952 (only when applicable while avoiding ip
> fragmentation).
> Num of streams: 1/8/16/24.
> Num of directions: unidir/bidir.
> 
> Surprisingly, the issue exists only with this specific combination:
> 8 streams,
> MTU 9000,
> Msg size 8952,
> both ipv4/6,
> bidir.
> (in unidir it repros only with ipv4)
> 
> The reproduction is consistent on all the different setups we tested with.
> 
> Bisect [2] was done between these two points, v5.19 (Good), and v6.0-rc1
> (Bad), with ConnectX-6DX NIC.
> 
> c82a69629c53eda5233f13fc11c3c01585ef48a2 is the first bad commit [1].
> 
> We couldn't come up with a good explanation how this patch causes this
> issue. We also looked for related changes in the networking/UDP stack,
> but nothing looked suspicious.
> 
> Maybe someone here can help with this.
> We can provide more details or do further tests/experiments to progress
> with the debug.

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced c82a69629c53eda5233f13fc11c3c01585ef48a
#regzbot title sched/fair: UDP ~20% degradation
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

> [1]
> commit c82a69629c53eda5233f13fc11c3c01585ef48a2
> Author: Vincent Guittot <vincent.guittot@linaro.org>
> Date:   Fri Jul 8 17:44:01 2022 +0200
> 
>     sched/fair: fix case with reduced capacity CPU
> 
>     The capacity of the CPU available for CFS tasks can be reduced
> because of
>     other activities running on the latter. In such case, it's worth
> trying to
>     move CFS tasks on a CPU with more available capacity.
> 
> 
> 
> 
>     The rework of the load balance has filtered the case when the CPU is
> 
>     classified to be fully busy but its capacity is reduced.
> 
> 
> 
> 
> 
> 
>     Check if CPU's capacity is reduced while gathering load balance
> statistic
> 
>     and classify it group_misfit_task instead of group_fully_busy so we can
> 
>     try to move the load on another CPU.
> 
> 
> 
> 
> 
> 
>     Reported-by: David Chen <david.chen@nutanix.com>
> 
> 
>     Reported-by: Zhang Qiao <zhangqiao22@huawei.com>
> 
> 
>     Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> 
> 
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> 
>     Tested-by: David Chen <david.chen@nutanix.com>
> 
> 
>     Tested-by: Zhang Qiao <zhangqiao22@huawei.com>
> 
> 
>     Link:
> https://lkml.kernel.org/r/20220708154401.21411-1-vincent.guittot@linaro.org
> 
> 
> 
> [2]
> 
> Detailed bisec steps:
> 
> +--------------+--------+-----------+-----------+
> | Commit       | Status | BW (Gbps) | BW (Gbps) |
> |              |        | run1      | run2      |
> +--------------+--------+-----------+-----------+
> | 526942b8134c | Bad    | ---       | ---       |
> +--------------+--------+-----------+-----------+
> | 2e7a95156d64 | Bad    | ---       | ---       |
> +--------------+--------+-----------+-----------+
> | 26c350fe7ae0 | Good   | 279.8     | 281.9     |
> +--------------+--------+-----------+-----------+
> | 9de1f9c8ca51 | Bad    | 257.243   | ---       |
> +--------------+--------+-----------+-----------+
> | 892f7237b3ff | Good   | 285       | 300.7     |
> +--------------+--------+-----------+-----------+
> | 0dd1cabe8a4a | Good   | 305.599   | 290.3     |
> +--------------+--------+-----------+-----------+
> | dfea84827f7e | Bad    | 250.2     | 258.899   |
> +--------------+--------+-----------+-----------+
> | 22a39c3d8693 | Bad    | 236.8     | 245.399   |
> +--------------+--------+-----------+-----------+
> | e2f3e35f1f5a | Good   | 277.599   | 287       |
> +--------------+--------+-----------+-----------+
> | 401e4963bf45 | Bad    | 250.149   | 248.899   |
> +--------------+--------+-----------+-----------+
> | 3e8c6c9aac42 | Good   | 299.09    | 294.9     |
> +--------------+--------+-----------+-----------+
> | 1fcf54deb767 | Good   | 292.719   | 301.299   |
> +--------------+--------+-----------+-----------+
> | c82a69629c53 | Bad    | 254.7     | 246.1     |
> +--------------+--------+-----------+-----------+
> | c02d5546ea34 | Good   | 276.4     | 294       |
> +--------------+--------+-----------+-----------+
