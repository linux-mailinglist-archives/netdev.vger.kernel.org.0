Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D50509C9E
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 11:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387840AbiDUJtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 05:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387824AbiDUJs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 05:48:59 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE30825C7F;
        Thu, 21 Apr 2022 02:45:57 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nhTNj-00056z-AL; Thu, 21 Apr 2022 11:45:47 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nhTNj-000LG7-0a; Thu, 21 Apr 2022 11:45:47 +0200
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20220419115620.65580586@canb.auug.org.au>
 <20220421103200.2b4e8424@canb.auug.org.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ac093b0a-dba7-b8b8-8a70-fccbed8fee76@iogearbox.net>
Date:   Thu, 21 Apr 2022 11:45:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220421103200.2b4e8424@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26518/Wed Apr 20 10:25:31 2022)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/22 2:32 AM, Stephen Rothwell wrote:
> Hi all,

Maciej, I presume you are already working on a follow-up for the below?

> On Tue, 19 Apr 2022 11:56:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the bpf-next tree, today's linux-next build
>> (x86_64 allmodconfig) failed like this:
>>
>> In file included from include/linux/compiler_types.h:73,
>>                   from <command-line>:
>> drivers/net/ethernet/intel/i40e/i40e_xsk.c: In function 'i40e_run_xdp_zc':
>> include/linux/compiler_attributes.h:222:41: error: attribute 'fallthrough' not preceding a case label or default label [-Werror]
>>    222 | # define fallthrough                    __attribute__((__fallthrough__))
>>        |                                         ^~~~~~~~~~~~~
>> drivers/net/ethernet/intel/i40e/i40e_xsk.c:192:17: note: in expansion of macro 'fallthrough'
>>    192 |                 fallthrough; /* handle aborts by dropping packet */
>>        |                 ^~~~~~~~~~~
>> cc1: all warnings being treated as errors
>> In file included from include/linux/compiler_types.h:73,
>>                   from <command-line>:
>> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c: In function 'ixgbe_run_xdp_zc':
>> include/linux/compiler_attributes.h:222:41: error: attribute 'fallthrough' not preceding a case label or default label [-Werror]
>>    222 | # define fallthrough                    __attribute__((__fallthrough__))
>>        |                                         ^~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c:147:17: note: in expansion of macro 'fallthrough'
>>    147 |                 fallthrough; /* handle aborts by dropping packet */
>>        |                 ^~~~~~~~~~~
>> cc1: all warnings being treated as errors
>>
>> Caused by commits
>>
>>    b8aef650e549 ("i40e, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full")
>>    c7dd09fd4628 ("ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full")
>>
>> I have used the bpf-next tree from next-20220414 for today.
> 
> I am still getting these failures ...
> 

