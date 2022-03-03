Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568CD4CCA38
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 00:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237294AbiCCXpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 18:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiCCXpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 18:45:45 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D71F13DE16;
        Thu,  3 Mar 2022 15:44:58 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nPv7p-0007pg-Ju; Fri, 04 Mar 2022 00:44:49 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nPv7p-000O97-5z; Fri, 04 Mar 2022 00:44:49 +0100
Subject: Re: [PATCH v3 sysctl-next] bpf: move bpf sysctls from kernel/sysctl.c
 to bpf module
To:     Luis Chamberlain <mcgrof@kernel.org>, Yan Zhu <zhuyan34@huawei.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, keescook@chromium.org,
        kpsingh@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, liucheng32@huawei.com,
        netdev@vger.kernel.org, nixiaoming@huawei.com,
        songliubraving@fb.com, xiechengliang1@huawei.com, yhs@fb.com,
        yzaikin@google.com, zengweilin@huawei.com
References: <Yh1dtBTeRtjD0eGp@bombadil.infradead.org>
 <20220302020412.128772-1-zhuyan34@huawei.com>
 <Yh/V5QN1OhN9IKsI@bombadil.infradead.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d8843ebe-b8df-8aa0-a930-c0742af98157@iogearbox.net>
Date:   Fri, 4 Mar 2022 00:44:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <Yh/V5QN1OhN9IKsI@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26470/Thu Mar  3 10:49:16 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/22 9:39 PM, Luis Chamberlain wrote:
> On Wed, Mar 02, 2022 at 10:04:12AM +0800, Yan Zhu wrote:
>> We're moving sysctls out of kernel/sysctl.c as its a mess. We
>> already moved all filesystem sysctls out. And with time the goal is
>> to move all sysctls out to their own susbsystem/actual user.
>>
>> kernel/sysctl.c has grown to an insane mess and its easy to run
>> into conflicts with it. The effort to move them out is part of this.
>>
>> Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
> 
> Daniel, let me know if this makes more sense now, and if so I can
> offer take it through sysctl-next to avoid conflicts more sysctl knobs
> get moved out from kernel/sysctl.c.

If this is a whole ongoing effort rather than drive-by patch, then it's
fine with me. Btw, the patch itself should also drop the linux/bpf.h
include from kernel/sysctl.c since nothing else is using it after the
patch.

Btw, related to cleanups.. historically, we have a bunch of other knobs
for BPF under net (in net_core_table), that is:

   /proc/sys/net/core/bpf_jit_enable
   /proc/sys/net/core/bpf_jit_harden
   /proc/sys/net/core/bpf_jit_kallsyms
   /proc/sys/net/core/bpf_jit_limit

Would be nice to consolidate all under e.g. /proc/sys/kernel/bpf_* for
future going forward, and technically, they should be usable also w/o
net configured into kernel. Is there infra to point the sysctl knobs
e.g. under net/core/ to kernel/, or best way would be to have single
struct ctl_table and register for both?

Cheers,
Daniel
