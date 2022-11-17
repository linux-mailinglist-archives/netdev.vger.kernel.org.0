Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C75362D0E7
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 03:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiKQCAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 21:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKQCAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 21:00:30 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41E8663ED;
        Wed, 16 Nov 2022 18:00:29 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCNQh5nHYzHvsT;
        Thu, 17 Nov 2022 09:59:56 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 10:00:27 +0800
Message-ID: <e348e36b-2a8b-7c76-4b6f-ac07407597bb@huawei.com>
Date:   Thu, 17 Nov 2022 10:00:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2 1/2] selftests/net: fix missing xdp_dummy
To:     Saeed Mahameed <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <andrii@kernel.org>,
        <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <martin.lau@linux.dev>,
        =?UTF-8?Q?Daniel_M=c3=bcller?= <deso@posteo.net>
References: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
 <1668507800-45450-2-git-send-email-wangyufen@huawei.com>
 <Y3VcyRoZ3OQvv309@x130.lan>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <Y3VcyRoZ3OQvv309@x130.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/11/17 5:57, Saeed Mahameed 写道:
> On 15 Nov 18:23, Wang Yufen wrote:
>> After commit afef88e65554 ("selftests/bpf: Store BPF object files with
>> .bpf.o extension"), we should use xdp_dummy.bpf.o instade of xdp_dummy.o.
>>
>> In addition, use the BPF_FILE variable to save the BPF object file name,
>> which can be better identified and modified.
>>
>> Fixes: afef88e65554 ("selftests/bpf: Store BPF object files with 
>> .bpf.o extension")
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> Cc: Daniel Müller <deso@posteo.net>
>> ---
>> tools/testing/selftests/net/udpgro.sh         | 6 ++++--
>> tools/testing/selftests/net/udpgro_bench.sh   | 6 ++++--
>> tools/testing/selftests/net/udpgro_frglist.sh | 6 ++++--
>> tools/testing/selftests/net/udpgro_fwd.sh     | 3 ++-
>> tools/testing/selftests/net/veth.sh           | 9 +++++----
>> 5 files changed, 19 insertions(+), 11 deletions(-)
>>
>> diff --git a/tools/testing/selftests/net/udpgro.sh 
>> b/tools/testing/selftests/net/udpgro.sh
>> index 6a443ca..a66d62e 100755
>> --- a/tools/testing/selftests/net/udpgro.sh
>> +++ b/tools/testing/selftests/net/udpgro.sh
>> @@ -5,6 +5,8 @@
>>
>> readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
>>
>> +BPF_FILE="../bpf/xdp_dummy.bpf.o"
>> +
>> # set global exit status, but never reset nonzero one.
>> check_err()
>> {
>> @@ -34,7 +36,7 @@ cfg_veth() {
>>     ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
>>     ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
>>     ip -netns "${PEER_NS}" link set dev veth1 up
>> -    ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o 
>> section xdp
>> +    ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
>> }
>>
>> run_one() {
>> @@ -195,7 +197,7 @@ run_all() {
>>     return $ret
>> }
>>
>> -if [ ! -f ../bpf/xdp_dummy.o ]; then
>> +if [ ! -f ${BPF_FILE} ]; then
>>     echo "Missing xdp_dummy helper. Build bpf selftest first"
> 
> nit: I would improve the error message here to print  ${BPF_FILE}.
> There are 3 more spots in the rest of this patch.
got it, thanks!
