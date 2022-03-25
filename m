Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49E4E6E22
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 07:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351777AbiCYGRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 02:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244783AbiCYGRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 02:17:42 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBF6C6837
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 23:16:04 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPsHm0cPbzfZWm;
        Fri, 25 Mar 2022 14:14:28 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Mar 2022 14:16:03 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Fri, 25 Mar
 2022 14:16:02 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: packet stuck in qdisc
To:     Vincent Ray <vray@kalrayinc.com>, <vladimir.oltean@nxp.com>,
        <kuba@kernel.org>, "davem@davemloft.net" <davem@davemloft.net>
CC:     Samuel Jones <sjones@kalrayinc.com>, <netdev@vger.kernel.org>,
        =?UTF-8?B?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>
References: <1862202329.1457162.1643113633513.JavaMail.zimbra@kalray.eu>
 <698739062.1462023.1643115337201.JavaMail.zimbra@kalray.eu>
 <1c53c5c0-4e77-723b-4260-de83e8f8e40c@huawei.com>
Message-ID: <0d6e8178-953a-82c9-329c-241bd311dbf9@huawei.com>
Date:   Fri, 25 Mar 2022 14:16:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1c53c5c0-4e77-723b-4260-de83e8f8e40c@huawei.com>
Content-Type: multipart/mixed;
        boundary="------------3FD93190D76658F87C69830F"
Content-Language: en-US
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------3FD93190D76658F87C69830F
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On 2022/1/28 10:36, Yunsheng Lin wrote:
> On 2022/1/25 20:55, Vincent Ray wrote:
>> Dear kernel maintainers / developers,
>>
>> I work at Kalray where we are developping an NVME-over-TCP target controller board.
>> My setup is as such :
>> - a development workstation running Linux 5.x.y (the host)
>> - sending NVME-TCP traffic to our board, to which it is connected through a Mellanox NIC (Connect-X-5) and a 100G ETH cable
>>
>> While doing performance tests, using simple fio scenarios running over the regular kernel nvme-tcp driver on the host, we noticed important performance variations.
>> After some digging (using tcpdump on the host), we found that there were big "holes" in the tcp traffic sent by the host.
>> The scenario we observed is the following :
>> 1) a TCP segment gets lost (not sent by the host) on a particular TCP connection, leading to a gap in the seq numbers received by the board
>> 2) the board sends dup-acks and/or sacks (if configured) to signal this loss
>> 3) then, sometimes, the host stops emitting on that TCP connection for several seconds (as much as 14s observed)
>> 4) finally the host resumes emission, sending the missing packet
>> 5) then the TCP connection continues correctly with the appropriate throughput
>>
>> Such a scenario can be observed in the attached tcpdump (+ comments).
> 
> Hi,
>     Thanks for reporting the problem.

Hi,
   It seems guoju from alibaba has a similar problem as above.
   And they fixed it by adding a smp_mb() barrier between spin_unlock()
and test_bit() in qdisc_run_end(), please see if it fixes your problem.

> 
>>


--------------3FD93190D76658F87C69830F
Content-Type: text/plain; charset="UTF-8";
	name="0001-net-sched-add-barrier-to-fix-packet-stuck-problem-fo_ali.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename*0="0001-net-sched-add-barrier-to-fix-packet-stuck-problem-fo_al";
	filename*1="i.patch"

RnJvbSAyN2VhY2I5ZDcyNjc5ZDU5MDI3MWIyZDNlOWRhMmE3N2U0ZjYwMzE3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBHdW9qdSBGYW5nIDxndW9qdS5mZ2pAYWxpYmFiYS1p
bmMuY29tPgpEYXRlOiBGcmksIDE4IEZlYiAyMDIyIDExOjE4OjQ1ICswODAwClN1YmplY3Q6
IFtQQVRDSF0gbmV0OiBzY2hlZDogYWRkIGJhcnJpZXIgdG8gZml4IHBhY2tldCBzdHVjayBw
cm9ibGVtIGZvcgogbG9ja2xlc3MgcWRpc2MKClRoZSBjb21taXQgYTkwYzU3ZjJjZWRkICgi
bmV0OiBzY2hlZDogZml4IHBhY2tldCBzdHVjayBwcm9ibGVtIGZvcgpsb2NrbGVzcyBxZGlz
YyIpIGFuZCBjb21taXQgODk4MzdlYjRiMjQ2ICgibmV0OiBzY2hlZDogYWRkIGJhcnJpZXIg
dG8KZW5zdXJlIGNvcnJlY3Qgb3JkZXJpbmcgZm9yIGxvY2tsZXNzIHFkaXNjIikgZml4IGEg
cGFja2V0IHN0dWNrIHByb2JsZW0KZm9yIGxvY2tsZXNzIHFkaXNjIGFuZCBkZXNjcmliZSB0
aGUgcmFjZSBjb25kaXRpb24uIEJ1dCBhZnRlciB0aGUgdHdvCmNvbW1pdHMgd2Ugc3RpbGwg
Y2FuIHJlcHJvZHVjZSBhIHNpbWlsYXIgcHJvYmxlbSwgYW5kIG9uZSBtb3JlIGJhcnJpZXIK
aXMgbmVlZGVkIHRvIGZpeCBpdC4KCk5vdyB0aGUgY29uY3VycmVudCBvcGVyYXRpb25zIGNh
biBiZSBkZXNjcmliZWQgYXMgYmVsb3csCiAgICAgICBDUFUwICAgICAgICAgICAgfCAgICAg
ICAgIENQVTEKICAgcWRpc2NfcnVuX2VuZCgpICAgICB8ICAgcWRpc2NfcnVuX2JlZ2luKCkK
ICAgICAgICAuICAgICAgICAgICAgICB8ICAgICAgICAgIC4KICAgICAgIHNwaW5fdW5sb2Nr
KCkgICB8ICAgICAgIHNldF9iaXQoKQogICAgICAgIC4gICAgICAgICAgICAgIHwgICAgICAg
c21wX21iX19hZnRlcl9hdG9taWMoKQogICAgICAgdGVzdF9iaXQoKSAgICAgIHwgICAgICAg
c3Bpbl90cnlsb2NrKCkKICAgICAgICAuICAgICAgICAgICAgICB8ICAgICAgICAgIC4KCklu
IHFkaXNjX3J1bl9lbmQoKSwgdGhlIHNwaW5fdW5sb2NrKCkgb25seSBoYXMgc3RvcmUtcmVs
ZWFzZSBzZW1hbnRpYywKd2hpY2ggZ3VhcmFudGVlcyBhbGwgZWFybGllciBtZW1vcnkgYWNj
ZXNzIGFyZSB2aXNpYmxlIGJlZm9yZSB0aGUKc3Bpbl91bmxvY2soKSwgYnV0IHRoZSBzdWJz
ZXF1ZW50IHRlc3RfYml0KCkgbWF5IGJlIHJlb3JkZXJlZCB0byBwcmVjZWRlCnRoZSBpdC4g
U28gb25lIGV4cGxpY2l0IGJhcnJpZXIgaXMgbmVlZGVkIGJldHdlZW4gc3Bpbl91bmxvY2so
KSBhbmQKdGVzdF9iaXQoKSB0byBlbnN1cmUgdGhlIGNvcnJlY3Qgb3JkZXIuCgpTaWduZWQt
b2ZmLWJ5OiBHdW9qdSBGYW5nIDxndW9qdS5mZ2pAYWxpYmFiYS1pbmMuY29tPgotLS0KIGlu
Y2x1ZGUvbmV0L3NjaF9nZW5lcmljLmggfCAzICsrKwogMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmggYi9p
bmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5oCmluZGV4IDQ3Mjg0M2VlZGJhZS4uZmY4NDNlMmE0
NTQ0IDEwMDY0NAotLS0gYS9pbmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5oCisrKyBiL2luY2x1
ZGUvbmV0L3NjaF9nZW5lcmljLmgKQEAgLTIyOSw2ICsyMjksOSBAQCBzdGF0aWMgaW5saW5l
IHZvaWQgcWRpc2NfcnVuX2VuZChzdHJ1Y3QgUWRpc2MgKnFkaXNjKQogCWlmIChxZGlzYy0+
ZmxhZ3MgJiBUQ1FfRl9OT0xPQ0spIHsKIAkJc3Bpbl91bmxvY2soJnFkaXNjLT5zZXFsb2Nr
KTsKIAorCQkvKiBzdG9yZS1sb2FkIGJhcnJpZXIgKi8KKwkJc21wX21iKCk7CisKIAkJaWYg
KHVubGlrZWx5KHRlc3RfYml0KF9fUURJU0NfU1RBVEVfTUlTU0VELAogCQkJCSAgICAgICZx
ZGlzYy0+c3RhdGUpKSkKIAkJCV9fbmV0aWZfc2NoZWR1bGUocWRpc2MpOwotLSAKMi4zMi4w
LjMuZzAxMTk1Y2Y5ZgoK
--------------3FD93190D76658F87C69830F--
