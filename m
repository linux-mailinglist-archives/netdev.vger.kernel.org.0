Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDF9689E55
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjBCPcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCPca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:32:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ECACC2F
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 07:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675438300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kYJqWP/okG4srcwOVk8SeqXOpf66DBmqAi9vUZpeQMU=;
        b=NkZ+dzlBKmeBLXun/BdH5LfYHLHQ0J87+v/cGgtEkPUBklPu19Ip5mprqLRaxn2r76jjec
        xaX2isRLQaSSC7g1g23hrtS1qGVcnMmKz+t4ySlqyXyzyAKGqFsFZYtZ6s/Ir1vcon0MNB
        5+hh5m1Ab0zgFXQe4diqQeCWFwKd3Tg=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-nfgM3xAzPDaO9_w8fbf8eg-1; Fri, 03 Feb 2023 10:31:39 -0500
X-MC-Unique: nfgM3xAzPDaO9_w8fbf8eg-1
Received: by mail-vk1-f198.google.com with SMTP id t4-20020ac5c904000000b003eab406134cso2350590vkl.0
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 07:31:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kYJqWP/okG4srcwOVk8SeqXOpf66DBmqAi9vUZpeQMU=;
        b=BzNUhc1rtjzmZog0ikPCc4h01fhHQrmUXi/9evBwbiCgZt/L1ySIDX2L/CJHLOnYqk
         3kNkk8xqGQClCxk8PIA5OdO43Irf+QnA1najp8/UrhHmERPuauX2+cGDKtfp90Ewf9Cu
         loo0pD7/Noeh73dyveIom9t/VnknAcu8UDjD8RJSh8OXRCNdOgYanYABklHq4yt+C6SS
         g11svkU00kx+1VywpuWA0ab5SuT/zYclIt+R91pOCFjt/k9fp33+2pf77dEZd6iUZ8g9
         I/nf/8FfNm9cn2yDpZkk8mNovm/4PwMYGEYLZgWMuq9/1cF6c8711dfUuH0R0/YEER8P
         SFiQ==
X-Gm-Message-State: AO0yUKWYlIafPULihiiV/WSDe/9GDmMRU3Cq8DeC21AdWWOFUEVa8Or7
        lWVg52bH8qB8Y2HbXNuRzZLlJJjp17+7jyETBsLo9XfqOB1ap0TT+liyG4Em8dbFL/+g8r5as7l
        ig9+wyq7oOSRALmRw7BKiJ4A2TMjoxC+j
X-Received: by 2002:a05:6102:3443:b0:3fc:3a9e:3203 with SMTP id o3-20020a056102344300b003fc3a9e3203mr1608489vsj.84.1675438297266;
        Fri, 03 Feb 2023 07:31:37 -0800 (PST)
X-Google-Smtp-Source: AK7set+mnBngjFujMOvYCPmv0gDIADIX/M1TpwUZfXT40+77qmfvrcuggqkRyI7dwZU5Vby+3ZRJOKZBgB8w3tEm+Yg=
X-Received: by 2002:a05:6102:3443:b0:3fc:3a9e:3203 with SMTP id
 o3-20020a056102344300b003fc3a9e3203mr1608484vsj.84.1675438296961; Fri, 03 Feb
 2023 07:31:36 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 3 Feb 2023 07:31:36 -0800
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230201161039.20714-1-ozsh@nvidia.com> <20230201161039.20714-3-ozsh@nvidia.com>
 <a32d4a16-90d9-06b5-c56f-aaa4304795e5@mojatatu.com> <cfbbbbbe-0a23-749f-f611-6d2438f797e4@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <cfbbbbbe-0a23-749f-f611-6d2438f797e4@nvidia.com>
Date:   Fri, 3 Feb 2023 07:31:36 -0800
Message-ID: <CALnP8ZZtqkumhUrRtCAqQDHQfEydG0YaszZrafjuXL2CV_oDCw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/9] net/sched: act_pedit, setup offload action
 for action stats query
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBGZWIgMDIsIDIwMjMgYXQgMDk6MjE6MTVBTSArMDIwMCwgT3ogU2hsb21vIHdyb3Rl
Og0KPg0KPiBPbiAwMS8wMi8yMDIzIDIyOjU5LCBQZWRybyBUYW1tZWxhIHdyb3RlOg0KPiA+IE9u
IDAxLzAyLzIwMjMgMTM6MTAsIE96IFNobG9tbyB3cm90ZToNCj4gPiA+IEEgc2luZ2xlIHRjIHBl
ZGl0IGFjdGlvbiBtYXkgYmUgdHJhbnNsYXRlZCB0byBtdWx0aXBsZSBmbG93X29mZmxvYWQNCj4g
PiA+IGFjdGlvbnMuDQo+ID4gPiBPZmZsb2FkIG9ubHkgYWN0aW9ucyB0aGF0IHRyYW5zbGF0ZSB0
byBhIHNpbmdsZSBwZWRpdCBjb21tYW5kIHZhbHVlLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IE96IFNobG9tbyA8b3pzaEBudmlkaWEuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiDCoCBuZXQv
c2NoZWQvYWN0X3BlZGl0LmMgfCAyNCArKysrKysrKysrKysrKysrKysrKysrKy0NCj4gPiA+IMKg
IDEgZmlsZSBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPg0K
PiA+ID4gZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9hY3RfcGVkaXQuYyBiL25ldC9zY2hlZC9hY3Rf
cGVkaXQuYw0KPiA+ID4gaW5kZXggYTAzNzhlOWYwMTIxLi5hYmNlZWY3OTRmMjggMTAwNjQ0DQo+
ID4gPiAtLS0gYS9uZXQvc2NoZWQvYWN0X3BlZGl0LmMNCj4gPiA+ICsrKyBiL25ldC9zY2hlZC9h
Y3RfcGVkaXQuYw0KPiA+ID4gQEAgLTUyMiw3ICs1MjIsMjkgQEAgc3RhdGljIGludCB0Y2ZfcGVk
aXRfb2ZmbG9hZF9hY3Rfc2V0dXAoc3RydWN0DQo+ID4gPiB0Y19hY3Rpb24gKmFjdCwgdm9pZCAq
ZW50cnlfZGF0YSwNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoCB9DQo+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgwqAgKmluZGV4X2luYyA9IGs7DQo+ID4gPiDCoMKgwqDCoMKgIH0gZWxzZSB7DQo+ID4g
PiAtwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiA+ID4gK8KgwqDCoMKgwqDC
oMKgIHN0cnVjdCBmbG93X29mZmxvYWRfYWN0aW9uICpmbF9hY3Rpb24gPSBlbnRyeV9kYXRhOw0K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgIHUzMiBsYXN0X2NtZDsNCj4gPiA+ICvCoMKgwqDCoMKgwqDC
oCBpbnQgazsNCj4gPiA+ICsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCBmb3IgKGsgPSAwOyBrIDwg
dGNmX3BlZGl0X25rZXlzKGFjdCk7IGsrKykgew0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdTMyIGNtZCA9IHRjZl9wZWRpdF9jbWQoYWN0LCBrKTsNCj4gPiA+ICsNCj4gPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGlmIChrICYmIGNtZCAhPSBsYXN0X2NtZCkNCj4gPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiA+DQo+ID4g
SSBiZWxpZXZlIGFuIGV4dGFjayBtZXNzYWdlIGhlcmUgaXMgdmVyeSB2YWx1YWJsZQ0KPiBTdXJl
IHRoaW5nLCBJIHdpbGwgYWRkIG9uZQ0KPiA+DQo+ID4gPiArDQo+ID4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBsYXN0X2NtZCA9IGNtZDsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHN3aXRjaCAoY21kKSB7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjYXNlIFRDQV9Q
RURJVF9LRVlfRVhfQ01EX1NFVDoNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgZmxfYWN0aW9uLT5pZCA9IEZMT1dfQUNUSU9OX01BTkdMRTsNCj4gPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBjYXNlIFRDQV9QRURJVF9LRVlfRVhfQ01EX0FERDoNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgZmxfYWN0aW9uLT5pZCA9IEZMT1dfQUNUSU9OX0FERDsNCj4gPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7DQo+ID4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBkZWZhdWx0Og0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLCAiVW5zdXBwb3J0ZWQgcGVkaXQNCj4gPiA+IGNv
bW1hbmQgb2ZmbG9hZCIpOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gLUVPUE5PVFNVUFA7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9DQo+ID4g
PiArwqDCoMKgwqDCoMKgwqAgfQ0KPiA+DQo+ID4gU2hvdWxkbid0IHRoaXMgc3dpdGNoIGNhc2Ug
YmUgb3V0c2lkZSBvZiB0aGUgZm9yLWxvb3A/DQo+DQo+IFlvdSBhcmUgcmlnaHQsIHRoaXMgY2Fu
IGJlIGRvbmUgb3V0c2lkZSB0aGUgZm9yIGxvb3AuDQoNClRvIGJlZm9yZSB0aGUgZm9yLWxvb3As
IHRoYXQgaXM/DQpCZWNhdXNlIG90aGVyd2lzZSBpdCB3aWxsIHBhcnNlIGFsbCBjb21tYW5kcyBh
bmQgdGhlbiBmYWlsLCB3aGljaCBzZWVtcyBoZWF2aWVyDQp0aGFuIGhvdyBpdCBpcyBoZXJlLg0K
DQotIHZhbGlkYXRlIHRoZSBmaXJzdCBvbmUNCi0gZW5zdXJlIHRoZSByZXN0IGZvbGxvd3MNCg0K
Pg0KPiBJIHdpbGwgcmVmYWN0b3IgdGhlIGNvZGUNCj4NCj4gPg0KPiA+ID4gwqDCoMKgwqDCoCB9
DQo+ID4gPiDCoCDCoMKgwqDCoMKgIHJldHVybiAwOw0KPiA+DQo+DQo=

