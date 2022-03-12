Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8D44D6B69
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 01:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiCLAVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 19:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiCLAVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 19:21:45 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4B238A;
        Fri, 11 Mar 2022 16:20:40 -0800 (PST)
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nSpUi-00061u-3o; Sat, 12 Mar 2022 01:20:28 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nSpUh-000Xff-QL; Sat, 12 Mar 2022 01:20:27 +0100
Subject: Re: [PATCH bpf-next 2/4] bpf: Introduce bpf_int_jit_abort()
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220309123321.2400262-1-houtao1@huawei.com>
 <20220309123321.2400262-3-houtao1@huawei.com>
 <f4bbf729-b960-de37-8a17-de41bc5559e6@iogearbox.net>
Message-ID: <f7e0b3fd-6ae1-caa0-bd05-93e4aaf51e11@iogearbox.net>
Date:   Sat, 12 Mar 2022 01:20:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <f4bbf729-b960-de37-8a17-de41bc5559e6@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26478/Fri Mar 11 10:27:25 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/22 12:54 AM, Daniel Borkmann wrote:
[...]
> Don't quite follow this one. For example, if we'd fail in the second pass, the
> goto out_addrs from jit would free and clear the prog->aux->jit_data. If we'd succeed
> but different prog is returned, prog->aux->jit_data is released and later the goto
> out_free in here would clear the jited prog via bpf_jit_free(). Which code path leaves
> prog->aux->jit_data as non-NULL such that extra bpf_int_jit_abort() is needed?

Nevermind, it's for those that haven't been jited second time yet..
