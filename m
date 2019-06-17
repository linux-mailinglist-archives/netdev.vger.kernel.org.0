Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A1C4850A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfFQOOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:14:31 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41340 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbfFQOO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 10:14:29 -0400
Received: by mail-io1-f65.google.com with SMTP id w25so21410540ioc.8;
        Mon, 17 Jun 2019 07:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IfMMacDCEm5DrweDwYWF788XFS0vnRBrlp52D5AlxZY=;
        b=cvDCotR4yV8JD1WStg2ykTBlVb4D2EG+aZ2eHDNyE16zkhSPlS2rll6A433QvIP+d4
         bOOvG5/lQk7Nmm8XPRstaeQaKmAZQpQ3aOtqCYm5QMpmnB4CibSiIs8shiNUR+PaayL8
         XLaZgRgffRrooFzRlk1rwZjsuWQ29sGtlX9Xt97KVc4KQfulmtO7QP1bBy1IVXaHVH7Q
         m1Sd3enQWqzrYyV6ukMmH8BM3PljZUidJXSCWguBo2b43klrYzfWDenXLJh+mIJ1HtuW
         AP9R2FaDWaT1PzKSxKn7/Qr7nq+k24gVBYiH/GiBuxZzT3NXZJ87zpOpFmoTNY8MuBHU
         DO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IfMMacDCEm5DrweDwYWF788XFS0vnRBrlp52D5AlxZY=;
        b=c6J7ORjsIKnrm1TGhhpQYNPUmQFBH8Ngr2zpSCCWZ/QCAL+wCqfOqg6nbkmOT+Ia7h
         j2ufpY7fW9eE6l/KABQWUJtlKk7X+DtryQJS2IgFbe2Gl7oL2ToLdTTlPptVt7Htf3o7
         Yo0ca8Rx0Vkkxk8OxMDhgTOJsww5ncxF8QQo/PekHxJ/6tuHnJiszJfZ1YarX2Hxb/RD
         aphO+pjCpn6MiPsqiSEDtpuuKEwvGnO+vN1lMP5Rhnrg1Cx/yK2VYMO5ltwbftJkpJUN
         US3epsDZ1iqLoCyngsaiRxFKVsfONN/LjhGw0gtnjyGOpkGuDZN8ofX5D3qOTCBMLxBI
         nQ4Q==
X-Gm-Message-State: APjAAAUh0xOq5ORtVc3rUVcRXB7I6114ptqjWJ6GWfVBFMVCii/o4EQt
        ETYRA6ZSC4vWoITy2BxIxmYTCidD
X-Google-Smtp-Source: APXvYqywv7Qg7K8EwUy9WHIF+e+y9mecZODBz68uw3BKpbhaVJihQPyccQ1HKXKUJqa9r6c0yOI4JQ==
X-Received: by 2002:a05:6602:2253:: with SMTP id o19mr30456906ioo.297.1560780868559;
        Mon, 17 Jun 2019 07:14:28 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id a2sm8888533iod.57.2019.06.17.07.14.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 07:14:27 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: fix the check that forwarding is enabled in
 bpf_ipv6_fib_lookup
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190615225348.2539-1-a.s.protopopov@gmail.com>
 <877e9ka2aj.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <df5297c5-87c5-5f2f-e22b-d35d6448d82c@gmail.com>
Date:   Mon, 17 Jun 2019 08:14:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <877e9ka2aj.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 5:17 AM, Toke Høiland-Jørgensen wrote:
> Anton Protopopov <a.s.protopopov@gmail.com> writes:
> 
>> The bpf_ipv6_fib_lookup function should return BPF_FIB_LKUP_RET_FWD_DISABLED
>> when forwarding is disabled for the input device.  However instead of checking
>> if forwarding is enabled on the input device, it checked the global
>> net->ipv6.devconf_all->forwarding flag.  Change it to behave as expected.
>>
>> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> 
> Thanks!
> 
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 

Fixes: 87f5fc7e48dd ("bpf: Provide helper to do forwarding lookups in
kernel FIB table")

Reviewed-by: David Ahern <dsahern@gmail.com>
