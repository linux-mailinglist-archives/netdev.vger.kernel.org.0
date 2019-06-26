Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F6756EDE
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFZQdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:33:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36529 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZQdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:33:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id u8so2769297wmm.1
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 09:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=bpOxFXXLoWMDrveyWIq85kNuVHOabyt0+wMBFm2oCRQ=;
        b=Ni2I0m1uc6sEZFX/FBD1ZeKu4mdE+r+3ZMxJVU4R4tWUJ6KK2n+Bai/JhlkJsFLPRh
         Aoqfo7lSHQh2bzabiN4otACRQeVZdA4d1jeqn/lNZar8tWLrFtiDBrIXXnUYu1NPWTzv
         qwc5VrdghdQqZsbEyOiAh+jZk0InivOsEIglw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=bpOxFXXLoWMDrveyWIq85kNuVHOabyt0+wMBFm2oCRQ=;
        b=AoYX7yTsQVvQ1rw72vDg/Qdxh3Rk9/9fjgVwpIpiMoDAk2UyklpWkPksNMQVgEj/KM
         0FmQ7p+uppoVk24TFQtvr0V9+irI6HYRCWBnOs86Z6MV5Xn0tPc3HW3tFlJjAQ41+5BI
         vkHYJnPWOiwfrACiQV/NhFCQ6iT1J69hKCDNn2CiahWPOcZ8HQCnGaxJM26dhcuPg9vT
         PIvL4SjR9y9AEBN9nnsknyEOvKr8u7hPz5sG94cfPMWyfmZ7nKDUbtkMcRrpxCXyizDo
         tiYfuI1jWuLTRSBmD8aXGo0oKyoWiSwEGD5wpL/klkqCTf9Udp9x9LgTK2PC0L9Pz1Ki
         HF7A==
X-Gm-Message-State: APjAAAXP8l7xsqdBIhjxJc4IHKPaFScKCMgxc/zwsqKWszMazU+A0qoL
        AjuO5pfBF94f97eGOrwxJEqtwg==
X-Google-Smtp-Source: APXvYqzE5Fh2dEZWq4uALpb7AmDi19kjcjl5wunh15vJxa7bzPSuY7dsGNNiIhKj3hg5gMeahFsYUw==
X-Received: by 2002:a7b:c84c:: with SMTP id c12mr3269417wml.70.1561566833101;
        Wed, 26 Jun 2019 09:33:53 -0700 (PDT)
Received: from localhost ([149.62.204.238])
        by smtp.gmail.com with ESMTPSA id g17sm15229742wrm.7.2019.06.26.09.33.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 09:33:52 -0700 (PDT)
Date:   Wed, 26 Jun 2019 19:33:48 +0300
In-Reply-To: <20190626191835.1e306147@eyal-ubuntu>
References: <20190626155615.16639-1-nikolay@cumulusnetworks.com> <20190626155615.16639-4-nikolay@cumulusnetworks.com> <20190626191835.1e306147@eyal-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next v2 3/4] net: sched: em_ipt: keep the user-specified nfproto and use it
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, jhs@mojatatu.com
From:   nikolay@cumulusnetworks.com
Message-ID: <92B812B3-C5FB-452B-809A-1367349DB29A@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 June 2019 19:18:35 EEST, Eyal Birger <eyal=2Ebirger@gmail=2Ecom> wrot=
e:
>Hi Nik,
>
>On Wed, 26 Jun 2019 18:56:14 +0300
>Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom> wrote:
>
>> For NFPROTO_UNSPEC xt_matches there's no way to restrict the matching
>> to a specific family, in order to do so we record the user-specified
>> family and later enforce it while doing the match=2E
>>=20
>> v2: adjust changes to missing patch, was patch 04 in v1
>>=20
>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom>
>> ---
>>  net/sched/em_ipt=2Ec | 17 +++++++++++++++--
>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>=20
>=2E=2Esnip=2E=2E
>> @@ -182,8 +195,8 @@ static int em_ipt_match(struct sk_buff *skb,
>> struct tcf_ematch *em, const struct em_ipt_match *im =3D (const void
>> *)em->data; struct xt_action_param acpar =3D {};
>>  	struct net_device *indev =3D NULL;
>> -	u8 nfproto =3D im->match->family;
>>  	struct nf_hook_state state;
>> +	u8 nfproto =3D im->nfproto;
>
>Maybe I'm missing something now - but it's not really clear to me now
>why keeping im->nfproto would be useful:
>
>If NFPROTO_UNSPEC was provided by userspace then the actual nfproto
>used
>will be taken from the packet, and if NFPROTO_IPV4/IPV6 was specified
>from userspace then it will equal im->match->family=2E
>
>Is there any case where the resulting nfproto would differ as a result
>of this patch?
>
>Otherwise the patchset looks excellent to me=2E
>
>Thanks!
>Eyal=2E

Hi,
It's needed to limit the match only to the user-specified family
for unspec xt matches=2E The problem is otherwise im->match->family
stays at nfproto_unspec regardless of the user choice=2E

Thanks for reviewing the set=2E=20

Cheers,
  Nik
