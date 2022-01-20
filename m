Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD34494CE9
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbiATL2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:28:24 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:35853 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiATL2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:28:18 -0500
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JfgGT6z4Czccfy;
        Thu, 20 Jan 2022 19:27:29 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 20 Jan 2022 19:28:15 +0800
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
To:     Oliver Hartkopp <socketcan@hartkopp.net>, <mkl@pengutronix.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220117120102.2395157-1-william.xuanziyang@huawei.com>
 <53279d6d-298c-5a85-4c16-887c95447825@hartkopp.net>
 <280e10c1-d1f4-f39e-fa90-debd56f1746d@huawei.com>
 <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
 <890d8209-f400-a3b0-df9c-3e198e3834d6@huawei.com>
 <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <2aba02d4-0597-1d55-8b3e-2c67386f68cf@huawei.com>
Date:   Thu, 20 Jan 2022 19:28:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
Content-Type: multipart/mixed;
        boundary="------------7DE5E435FA50CA8998BDA82F"
Content-Language: en-US
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------7DE5E435FA50CA8998BDA82F
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

> 
> On 20.01.22 07:24, Ziyang Xuan (William) wrote:
> 
>> I have reproduced the syz problem with Marc's commit, the commit can not fix the panic problem.
>> So I tried to find the root cause for panic and gave my solution.
>>
>> Marc's commit just fix the condition that packet size bigger than INT_MAX which trigger
>> tpcon::{idx,len} integer overflow, but the packet size is 4096 in the syz problem.
>>
>> so->rx.len is 0 after the following logic in isotp_rcv_ff():
>>
>> /* get the FF_DL */
>> so->rx.len = (cf->data[ae] & 0x0F) << 8;
>> so->rx.len += cf->data[ae + 1];
>>
>> so->rx.len is 4096 after the following logic in isotp_rcv_ff():
>>
>> /* FF_DL = 0 => get real length from next 4 bytes */
>> so->rx.len = cf->data[ae + 2] << 24;
>> so->rx.len += cf->data[ae + 3] << 16;
>> so->rx.len += cf->data[ae + 4] << 8;
>> so->rx.len += cf->data[ae + 5];
>>
> 
> In these cases the values 0 could be the minimum value in so->rx.len - but e.g. the value 0 can not show up in isotp_rcv_cf() as this function requires so->rx.state to be ISOTP_WAIT_DATA.

Consider the scenario that isotp_rcv_cf() and isotp_rcv_cf() are concurrent for the same isotp_sock as following sequence:

isotp_rcv_cf()
if (so->rx.state != ISOTP_WAIT_DATA) [false]
						isotp_rcv_ff()
						so->rx.state = ISOTP_IDLE
						/* get the FF_DL */ [so->rx.len == 0]
alloc_skb() [so->rx.len == 0]
						/* FF_DL = 0 => get real length from next 4 bytes */ [so->rx.len == 4096]
skb_put(nskb, so->rx.len) [so->rx.len == 4096]
skb_over_panic()

> 
> And when so->rx.len is 0 in isotp_rcv_ff() this check
> 
> if (so->rx.len + ae + off + ff_pci_sz < so->rx.ll_dl)
>         return 1;
> 
> will return from isotp_rcv_ff() before ISOTP_WAIT_DATA is set at the end. So after that above check we are still in ISOTP_IDLE state.
> 
> Or did I miss something here?
> 
>> so->rx.len is 0 before alloc_skb() and is 4096 after alloc_skb() in isotp_rcv_cf(). The following
>> skb_put() will trigger panic.
>>
>> The following log is my reproducing log with Marc's commit and my debug modification in isotp_rcv_cf().
>>
>> [  150.605776][    C6] isotp_rcv_cf: before alloc_skb so->rc.len: 0, after alloc_skb so->rx.len: 4096
> 
> 
> But so->rx_len is not a value that is modified by alloc_skb():
> 
>                 nskb = alloc_skb(so->rx.len, gfp_any());
>                 if (!nskb)
>                         return 1;
> 
>                 memcpy(skb_put(nskb, so->rx.len), so->rx.buf,
>                        so->rx.len);
> 
> 
> Can you send your debug modification changes please?

My reproducing debug as attachment and following:

diff --git a/net/can/isotp.c b/net/can/isotp.c
index df6968b28bf4..8b12d63b4d59 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -119,8 +119,8 @@ enum {
 };

 struct tpcon {
-       int idx;
-       int len;
+       unsigned int idx;
+       unsigned int len;
        u32 state;
        u8 bs;
        u8 sn;
@@ -505,6 +505,7 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
        struct isotp_sock *so = isotp_sk(sk);
        struct sk_buff *nskb;
        int i;
+       bool unexpection = false;

        if (so->rx.state != ISOTP_WAIT_DATA)
                return 0;
@@ -562,11 +563,13 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
                                sk_error_report(sk);
                        return 1;
                }
-
+               if (so->rx.len == 0)
+                       unexpection = true;
                nskb = alloc_skb(so->rx.len, gfp_any());
                if (!nskb)
                        return 1;
-
+               if (unexpection)
+                       printk("%s: before alloc_skb so->rc.len: 0, after alloc_skb so->rx.len: %u\n", __func__, so->rx.len);
                memcpy(skb_put(nskb, so->rx.len), so->rx.buf,
                       so->rx.len);


> 
> Best regards,
> Oliver
> 
>> [  150.611477][    C6] skbuff: skb_over_panic: text:ffffffff881ff7be len:4096 put:4096 head:ffff88807f93a800 data:ffff88807f93a800 tail:0x1000 end:0xc0 dev:<NULL>
>> [  150.615837][    C6] ------------[ cut here ]------------
>> [  150.617238][    C6] kernel BUG at net/core/skbuff.c:113!
>>
> 
> .

--------------7DE5E435FA50CA8998BDA82F
Content-Type: text/plain; charset="UTF-8";
	name="0001-can-isotp-debug-for-reproducing-isotp_rcv-panic.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="0001-can-isotp-debug-for-reproducing-isotp_rcv-panic.patch"

RnJvbSAxNmM5NGU1YWVlMjU4YjFkODU2ZTI5NDkzNzQ2ZGI5YWZjZTg5NjNhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBaaXlhbmcgWHVhbiA8d2lsbGlhbS54dWFueml5YW5n
QGh1YXdlaS5jb20+CkRhdGU6IFRodSwgMjAgSmFuIDIwMjIgMTU6MTc6NTQgKzA4MDAKU3Vi
amVjdDogW1BBVENIXSBjYW46IGlzb3RwOiBkZWJ1ZyBmb3IgcmVwcm9kdWNpbmcgaXNvdHBf
cmN2IHBhbmljCgpTaWduZWQtb2ZmLWJ5OiBaaXlhbmcgWHVhbiA8d2lsbGlhbS54dWFueml5
YW5nQGh1YXdlaS5jb20+Ci0tLQogbmV0L2Nhbi9pc290cC5jIHwgMTEgKysrKysrKy0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvbmV0L2Nhbi9pc290cC5jIGIvbmV0L2Nhbi9pc290cC5jCmluZGV4IGRmNjk2
OGIyOGJmNC4uOGIxMmQ2M2I0ZDU5IDEwMDY0NAotLS0gYS9uZXQvY2FuL2lzb3RwLmMKKysr
IGIvbmV0L2Nhbi9pc290cC5jCkBAIC0xMTksOCArMTE5LDggQEAgZW51bSB7CiB9OwogCiBz
dHJ1Y3QgdHBjb24gewotCWludCBpZHg7Ci0JaW50IGxlbjsKKwl1bnNpZ25lZCBpbnQgaWR4
OworCXVuc2lnbmVkIGludCBsZW47CiAJdTMyIHN0YXRlOwogCXU4IGJzOwogCXU4IHNuOwpA
QCAtNTA1LDYgKzUwNSw3IEBAIHN0YXRpYyBpbnQgaXNvdHBfcmN2X2NmKHN0cnVjdCBzb2Nr
ICpzaywgc3RydWN0IGNhbmZkX2ZyYW1lICpjZiwgaW50IGFlLAogCXN0cnVjdCBpc290cF9z
b2NrICpzbyA9IGlzb3RwX3NrKHNrKTsKIAlzdHJ1Y3Qgc2tfYnVmZiAqbnNrYjsKIAlpbnQg
aTsKKwlib29sIHVuZXhwZWN0aW9uID0gZmFsc2U7CiAKIAlpZiAoc28tPnJ4LnN0YXRlICE9
IElTT1RQX1dBSVRfREFUQSkKIAkJcmV0dXJuIDA7CkBAIC01NjIsMTEgKzU2MywxMyBAQCBz
dGF0aWMgaW50IGlzb3RwX3Jjdl9jZihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBjYW5mZF9m
cmFtZSAqY2YsIGludCBhZSwKIAkJCQlza19lcnJvcl9yZXBvcnQoc2spOwogCQkJcmV0dXJu
IDE7CiAJCX0KLQorCQlpZiAoc28tPnJ4LmxlbiA9PSAwKQorCQkJdW5leHBlY3Rpb24gPSB0
cnVlOwogCQluc2tiID0gYWxsb2Nfc2tiKHNvLT5yeC5sZW4sIGdmcF9hbnkoKSk7CiAJCWlm
ICghbnNrYikKIAkJCXJldHVybiAxOwotCisJCWlmICh1bmV4cGVjdGlvbikKKwkJCXByaW50
aygiJXM6IGJlZm9yZSBhbGxvY19za2Igc28tPnJjLmxlbjogMCwgYWZ0ZXIgYWxsb2Nfc2ti
IHNvLT5yeC5sZW46ICV1XG4iLCBfX2Z1bmNfXywgc28tPnJ4Lmxlbik7CiAJCW1lbWNweShz
a2JfcHV0KG5za2IsIHNvLT5yeC5sZW4pLCBzby0+cnguYnVmLAogCQkgICAgICAgc28tPnJ4
Lmxlbik7CiAKLS0gCjIuMjUuMQoK
--------------7DE5E435FA50CA8998BDA82F--
