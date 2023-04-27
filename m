Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2363A6F0BEE
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 20:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244536AbjD0Sal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 14:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244543AbjD0Saf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 14:30:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CE344A3
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 11:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682620186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HusVMQQOSr6I+hFj5oosnsEjzdYh20SMG7G/RgkXZuU=;
        b=Nfxl5oLXVUjSDrDBnHM5qYIvY1B8K6x7e3cH+15DLYqP+2FWEOffv7kebxmr2s67jdXcSn
        2VCzciv8AO0mlPPAnhlDoOVqeiqULIZbMcNc8YCfhaEuh457gLGUHobP7djF1EhZ4wtOtQ
        8sR51phvKCbJ92uKZruWCVpuoYi2bTg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-RmGQgbttMAWyBeEs9s7bFQ-1; Thu, 27 Apr 2023 14:29:44 -0400
X-MC-Unique: RmGQgbttMAWyBeEs9s7bFQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5068e922bcaso8240228a12.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 11:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682620183; x=1685212183;
        h=in-reply-to:references:to:content-language:subject:cc:user-agent
         :mime-version:date:message-id:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HusVMQQOSr6I+hFj5oosnsEjzdYh20SMG7G/RgkXZuU=;
        b=R/PuDMfcdK6LL1bNRVb63Wybo0QNrSZiVbTryVRXTNSaKswLeBaJy/PtdVLVYJtkTn
         876FBxuhJP1Pp1xJC/+JekWxlqrz/1E4xYkvFh855R4OtmXDBN+NqxL9KEHSHiPB/FrK
         /WFIKrA49RaVTgQKnWY9obESL0eNB6Yj+q2pa9sakBEzJ0A+Ux+H/+wGNyxJKjz19xK0
         eGMRIliivJcbKAaIxymIQFYrddeWTx1YF57DFvSN2Ju+mBsgwYUDpaO42Ldd5LllgFsn
         Fcz3rOkkUwFk+LfHccq7QaIZzfY/3JEDATrfeUiIKG7uqxaqOtYHyjxfACD4U0qdxJMl
         lB2A==
X-Gm-Message-State: AC+VfDz/W/CWpSaCKiJ5BXuhvflqQAJrCd6md3eutj/2EGQj1z75Twhr
        d6roYpRbRNwQIybvhVVxG1hCtY9PL7DKACw7oU6AbvW88gNm9NQB7/6PT7vOghaM+ZaaPa9XVZ2
        +hr2Ry1w/AEDsAUj7Ys6zy1Up
X-Received: by 2002:aa7:de93:0:b0:506:b8a2:619f with SMTP id j19-20020aa7de93000000b00506b8a2619fmr1098751edv.41.1682620183104;
        Thu, 27 Apr 2023 11:29:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6NODZmxOrdNS4oGxCkZyp7HBlCf39dhDwV0lvyEMOVwGIo7/3C+AljZQQeVDBV3h3o5XhsDQ==
X-Received: by 2002:aa7:de93:0:b0:506:b8a2:619f with SMTP id j19-20020aa7de93000000b00506b8a2619fmr1098714edv.41.1682620182672;
        Thu, 27 Apr 2023 11:29:42 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id a7-20020aa7d907000000b00506a09795e6sm8157860edr.26.2023.04.27.11.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 11:29:40 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: multipart/mixed; boundary="------------T9z3bw6sCFIuxXHYyhIVle6B"
Message-ID: <733c4402-7aea-07a8-de98-184d88fc17f0@redhat.com>
Date:   Thu, 27 Apr 2023 20:29:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Cc:     brouer@redhat.com, lorenzo@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V1 1/3] page_pool: Remove workqueue in new
 shutdown scheme
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>
References: <168244288038.1741095.1092368365531131826.stgit@firesoul>
 <168244293875.1741095.10502498932946558516.stgit@firesoul>
 <48661b51-1cbb-e3e0-a909-6d0a1532733a@huawei.com>
 <e0bbcd20-77ec-4dc9-ada9-94aaf4ea44bb@redhat.com>
In-Reply-To: <e0bbcd20-77ec-4dc9-ada9-94aaf4ea44bb@redhat.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------T9z3bw6sCFIuxXHYyhIVle6B
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 27/04/2023 12.47, Jesper Dangaard Brouer wrote:
> 
> On 27/04/2023 02.57, Yunsheng Lin wrote:
>> On 2023/4/26 1:15, Jesper Dangaard Brouer wrote:
>>> @@ -609,6 +609,8 @@ void page_pool_put_defragged_page(struct 
>>> page_pool *pool, struct page *page,
>>>           recycle_stat_inc(pool, ring_full);
>>>           page_pool_return_page(pool, page);
>>>       }
>>> +    if (pool->p.flags & PP_FLAG_SHUTDOWN)
>>> +        page_pool_shutdown_attempt(pool);
>>
>> It seems we have allowed page_pool_shutdown_attempt() to be called
>> concurrently here, isn't there a time window between 
>> atomic_inc_return_relaxed()
>> and page_pool_inflight() for pool->pages_state_release_cnt, which may 
>> cause
>> double calling of page_pool_free()?
>>
> 
> Yes, I think that is correct.
> I actually woke up this morning thinking of this case of double freeing,
> and this time window.  Thanks for spotting and confirming this issue.
> 
> Basically: Two concurrent CPUs executing page_pool_shutdown_attempt() 
> can both end-up seeing inflight equal zero, resulting in both of them 
> kfreeing the memory (in page_pool_free()) as they both think they are 
> the last user of PP instance.
> 
> I've been thinking how to address this.
> This is my current idea:
> 
> (1) Atomic variable inc and test (or cmpxchg) that resolves last user race.
> (2) Defer free to call_rcu callback to let other CPUs finish.
> (3) Might need rcu_read_lock() in page_pool_shutdown_attempt().
> 

I think I found a more simply approach (adjustment patch attached).
That avoids races and any call_rcu callbacks.

Will post a V2.

--Jesper
--------------T9z3bw6sCFIuxXHYyhIVle6B
Content-Type: text/plain; charset=UTF-8; name="02-fix-race"
Content-Disposition: attachment; filename="02-fix-race"
Content-Transfer-Encoding: base64

Zml4IHJhY2UKCkZyb206IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGJyb3VlckByZWRoYXQu
Y29tPgoKU2lnbmVkLW9mZi1ieTogSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJl
ZGhhdC5jb20+Ci0tLQogbmV0L2NvcmUvcGFnZV9wb29sLmMgfCAgIDQ4ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDM0IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL25ldC9j
b3JlL3BhZ2VfcG9vbC5jIGIvbmV0L2NvcmUvcGFnZV9wb29sLmMKaW5kZXggY2U3ZThkZGE2
NDAzLi4yNTEzOWIxNjI2NzQgMTAwNjQ0Ci0tLSBhL25ldC9jb3JlL3BhZ2VfcG9vbC5jCisr
KyBiL25ldC9jb3JlL3BhZ2VfcG9vbC5jCkBAIC00NTEsOSArNDUxLDggQEAgRVhQT1JUX1NZ
TUJPTChwYWdlX3Bvb2xfYWxsb2NfcGFnZXMpOwogICovCiAjZGVmaW5lIF9kaXN0YW5jZShh
LCBiKQkoczMyKSgoYSkgLSAoYikpCiAKLXN0YXRpYyBzMzIgcGFnZV9wb29sX2luZmxpZ2h0
KHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wpCitzdGF0aWMgczMyIF9fcGFnZV9wb29sX2luZmxp
Z2h0KHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wsIHUzMiByZWxlYXNlX2NudCkKIHsKLQl1MzIg
cmVsZWFzZV9jbnQgPSBhdG9taWNfcmVhZCgmcG9vbC0+cGFnZXNfc3RhdGVfcmVsZWFzZV9j
bnQpOwogCXUzMiBob2xkX2NudCA9IFJFQURfT05DRShwb29sLT5wYWdlc19zdGF0ZV9ob2xk
X2NudCk7CiAJczMyIGluZmxpZ2h0OwogCkBAIC00NjUsNiArNDY0LDE0IEBAIHN0YXRpYyBz
MzIgcGFnZV9wb29sX2luZmxpZ2h0KHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wpCiAJcmV0dXJu
IGluZmxpZ2h0OwogfQogCitzdGF0aWMgczMyIHBhZ2VfcG9vbF9pbmZsaWdodChzdHJ1Y3Qg
cGFnZV9wb29sICpwb29sKQoreworCXUzMiByZWxlYXNlX2NudCA9IGF0b21pY19yZWFkKCZw
b29sLT5wYWdlc19zdGF0ZV9yZWxlYXNlX2NudCk7CisJcmV0dXJuIF9fcGFnZV9wb29sX2lu
ZmxpZ2h0KHBvb2wsIHJlbGVhc2VfY250KTsKK30KKworc3RhdGljIGludCBwYWdlX3Bvb2xf
ZnJlZV9hdHRlbXB0KHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wsIHUzMiByZWxlYXNlX2NudCk7
CisKIC8qIERpc2Nvbm5lY3RzIGEgcGFnZSAoZnJvbSBhIHBhZ2VfcG9vbCkuICBBUEkgdXNl
cnMgY2FuIGhhdmUgYSBuZWVkCiAgKiB0byBkaXNjb25uZWN0IGEgcGFnZSAoZnJvbSBhIHBh
Z2VfcG9vbCksIHRvIGFsbG93IGl0IHRvIGJlIHVzZWQgYXMKICAqIGEgcmVndWxhciBwYWdl
ICh0aGF0IHdpbGwgZXZlbnR1YWxseSBiZSByZXR1cm5lZCB0byB0aGUgbm9ybWFsCkBAIC00
NzMsNyArNDgwLDcgQEAgc3RhdGljIHMzMiBwYWdlX3Bvb2xfaW5mbGlnaHQoc3RydWN0IHBh
Z2VfcG9vbCAqcG9vbCkKIHZvaWQgcGFnZV9wb29sX3JlbGVhc2VfcGFnZShzdHJ1Y3QgcGFn
ZV9wb29sICpwb29sLCBzdHJ1Y3QgcGFnZSAqcGFnZSkKIHsKIAlkbWFfYWRkcl90IGRtYTsK
LQlpbnQgY291bnQ7CisJdTMyIGNvdW50OwogCiAJaWYgKCEocG9vbC0+cC5mbGFncyAmIFBQ
X0ZMQUdfRE1BX01BUCkpCiAJCS8qIEFsd2F5cyBhY2NvdW50IGZvciBpbmZsaWdodCBwYWdl
cywgZXZlbiBpZiB3ZSBkaWRuJ3QKQEAgLTQ5MCw4ICs0OTcsMTIgQEAgdm9pZCBwYWdlX3Bv
b2xfcmVsZWFzZV9wYWdlKHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wsIHN0cnVjdCBwYWdlICpw
YWdlKQogCXBhZ2VfcG9vbF9zZXRfZG1hX2FkZHIocGFnZSwgMCk7CiBza2lwX2RtYV91bm1h
cDoKIAlwYWdlX3Bvb2xfY2xlYXJfcHBfaW5mbyhwYWdlKTsKLQljb3VudCA9IGF0b21pY19p
bmNfcmV0dXJuX3JlbGF4ZWQoJnBvb2wtPnBhZ2VzX3N0YXRlX3JlbGVhc2VfY250KTsKKwlj
b3VudCA9IGF0b21pY19pbmNfcmV0dXJuKCZwb29sLT5wYWdlc19zdGF0ZV9yZWxlYXNlX2Nu
dCk7CiAJdHJhY2VfcGFnZV9wb29sX3N0YXRlX3JlbGVhc2UocG9vbCwgcGFnZSwgY291bnQp
OworCisJLyogSW4gc2h1dGRvd24gcGhhc2UsIGxhc3QgcGFnZSB3aWxsIGZyZWUgcG9vbCBp
bnN0YW5jZSAqLworCWlmIChwb29sLT5wLmZsYWdzICYgUFBfRkxBR19TSFVURE9XTikKKwkJ
cGFnZV9wb29sX2ZyZWVfYXR0ZW1wdChwb29sLCBjb3VudCk7CiB9CiBFWFBPUlRfU1lNQk9M
KHBhZ2VfcG9vbF9yZWxlYXNlX3BhZ2UpOwogCkBAIC01NDMsNyArNTU0LDcgQEAgc3RhdGlj
IGJvb2wgcGFnZV9wb29sX3JlY3ljbGVfaW5fY2FjaGUoc3RydWN0IHBhZ2UgKnBhZ2UsCiAJ
cmV0dXJuIHRydWU7CiB9CiAKLXN0YXRpYyB2b2lkIHBhZ2VfcG9vbF9zaHV0ZG93bl9hdHRl
bXB0KHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wpOworc3RhdGljIHZvaWQgcGFnZV9wb29sX2Vt
cHR5X3Jpbmcoc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCk7CiAKIC8qIElmIHRoZSBwYWdlIHJl
ZmNudCA9PSAxLCB0aGlzIHdpbGwgdHJ5IHRvIHJlY3ljbGUgdGhlIHBhZ2UuCiAgKiBpZiBQ
UF9GTEFHX0RNQV9TWU5DX0RFViBpcyBzZXQsIHdlJ2xsIHRyeSB0byBzeW5jIHRoZSBETUEg
YXJlYSBmb3IKQEAgLTYxMCw3ICs2MjEsNyBAQCB2b2lkIHBhZ2VfcG9vbF9wdXRfZGVmcmFn
Z2VkX3BhZ2Uoc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCwgc3RydWN0IHBhZ2UgKnBhZ2UsCiAJ
CXBhZ2VfcG9vbF9yZXR1cm5fcGFnZShwb29sLCBwYWdlKTsKIAl9CiAJaWYgKHBvb2wtPnAu
ZmxhZ3MgJiBQUF9GTEFHX1NIVVRET1dOKQotCQlwYWdlX3Bvb2xfc2h1dGRvd25fYXR0ZW1w
dChwb29sKTsKKwkJcGFnZV9wb29sX2VtcHR5X3JpbmcocG9vbCk7CiB9CiBFWFBPUlRfU1lN
Qk9MKHBhZ2VfcG9vbF9wdXRfZGVmcmFnZ2VkX3BhZ2UpOwogCkBAIC02NjAsNyArNjcxLDcg
QEAgdm9pZCBwYWdlX3Bvb2xfcHV0X3BhZ2VfYnVsayhzdHJ1Y3QgcGFnZV9wb29sICpwb29s
LCB2b2lkICoqZGF0YSwKIAogb3V0OgogCWlmIChwb29sLT5wLmZsYWdzICYgUFBfRkxBR19T
SFVURE9XTikKLQkJcGFnZV9wb29sX3NodXRkb3duX2F0dGVtcHQocG9vbCk7CisJCXBhZ2Vf
cG9vbF9lbXB0eV9yaW5nKHBvb2wpOwogfQogRVhQT1JUX1NZTUJPTChwYWdlX3Bvb2xfcHV0
X3BhZ2VfYnVsayk7CiAKQEAgLTc0Myw2ICs3NTQsNyBAQCBzdHJ1Y3QgcGFnZSAqcGFnZV9w
b29sX2FsbG9jX2ZyYWcoc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCwKIH0KIEVYUE9SVF9TWU1C
T0wocGFnZV9wb29sX2FsbG9jX2ZyYWcpOwogCitub2lubGluZQogc3RhdGljIHZvaWQgcGFn
ZV9wb29sX2VtcHR5X3Jpbmcoc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCkKIHsKIAlzdHJ1Y3Qg
cGFnZSAqcGFnZTsKQEAgLTgwMiwyMiArODE0LDI4IEBAIHN0YXRpYyB2b2lkIHBhZ2VfcG9v
bF9zY3J1YihzdHJ1Y3QgcGFnZV9wb29sICpwb29sKQogCXBhZ2VfcG9vbF9lbXB0eV9yaW5n
KHBvb2wpOwogfQogCi1zdGF0aWMgaW50IHBhZ2VfcG9vbF9yZWxlYXNlKHN0cnVjdCBwYWdl
X3Bvb2wgKnBvb2wpCitub2lubGluZQorc3RhdGljIGludCBwYWdlX3Bvb2xfZnJlZV9hdHRl
bXB0KHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wsIHUzMiByZWxlYXNlX2NudCkKIHsKIAlpbnQg
aW5mbGlnaHQ7CiAKLQlwYWdlX3Bvb2xfc2NydWIocG9vbCk7Ci0JaW5mbGlnaHQgPSBwYWdl
X3Bvb2xfaW5mbGlnaHQocG9vbCk7CisJaW5mbGlnaHQgPSBfX3BhZ2VfcG9vbF9pbmZsaWdo
dChwb29sLCByZWxlYXNlX2NudCk7CiAJaWYgKCFpbmZsaWdodCkKIAkJcGFnZV9wb29sX2Zy
ZWUocG9vbCk7CiAKIAlyZXR1cm4gaW5mbGlnaHQ7CiB9CiAKLW5vaW5saW5lCi1zdGF0aWMg
dm9pZCBwYWdlX3Bvb2xfc2h1dGRvd25fYXR0ZW1wdChzdHJ1Y3QgcGFnZV9wb29sICpwb29s
KQorc3RhdGljIGludCBwYWdlX3Bvb2xfcmVsZWFzZShzdHJ1Y3QgcGFnZV9wb29sICpwb29s
KQogewotCXBhZ2VfcG9vbF9yZWxlYXNlKHBvb2wpOworCWludCBpbmZsaWdodDsKKworCXBh
Z2VfcG9vbF9zY3J1Yihwb29sKTsKKwlpbmZsaWdodCA9IHBhZ2VfcG9vbF9pbmZsaWdodChw
b29sKTsKKwlpZiAoIWluZmxpZ2h0KQorCQlwYWdlX3Bvb2xfZnJlZShwb29sKTsKKworCXJl
dHVybiBpbmZsaWdodDsKIH0KIAogdm9pZCBwYWdlX3Bvb2xfdXNlX3hkcF9tZW0oc3RydWN0
IHBhZ2VfcG9vbCAqcG9vbCwgdm9pZCAoKmRpc2Nvbm5lY3QpKHZvaWQgKiksCkBAIC04NjEs
NyArODc5LDkgQEAgdm9pZCBwYWdlX3Bvb2xfZGVzdHJveShzdHJ1Y3QgcGFnZV9wb29sICpw
b29sKQogCSAqIEVudGVyIGludG8gc2h1dGRvd24gcGhhc2UsIGFuZCByZXRyeSByZWxlYXNl
IHRvIGhhbmRsZSByYWNlcy4KIAkgKi8KIAlwb29sLT5wLmZsYWdzIHw9IFBQX0ZMQUdfU0hV
VERPV047Ci0JcGFnZV9wb29sX3NodXRkb3duX2F0dGVtcHQocG9vbCk7CisKKwkvKiBDb25j
dXJyZW50IENQVXMgY291bGQgaGF2ZSByZXR1cm5lZCBsYXN0IHBhZ2VzIGludG8gcHRyX3Jp
bmcgKi8KKwlwYWdlX3Bvb2xfZW1wdHlfcmluZyhwb29sKTsKIH0KIEVYUE9SVF9TWU1CT0wo
cGFnZV9wb29sX2Rlc3Ryb3kpOwogCg==

--------------T9z3bw6sCFIuxXHYyhIVle6B--

