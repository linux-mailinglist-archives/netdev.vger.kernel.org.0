Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCBB643FDA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbiLFJ34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiLFJ3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:29:54 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DB45F58
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:29:53 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id vv4so4763386ejc.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 01:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjN1hG2Cp71SVpUil5Oz3jZW8dEe3N3cjnowv7yn8rw=;
        b=q/C1vGOVgnZhWvIFLXtfJ76nk2ipqhef41bmUks3C6eezhzxoVEuVWBUqed/gYpHUV
         3KtQ+QbhCC/ENhfvwWwWta4qsw67K+qkUTxegdl8yYW7udqzyNXEGpLgyN7We5cwv3oe
         daAmp2ySbIA9HqlNmQbeVNPSNpbuGOR5RpT3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UjN1hG2Cp71SVpUil5Oz3jZW8dEe3N3cjnowv7yn8rw=;
        b=FtnPQJQDArMG8PK25qOChjHHKiDL1TqnDJmT6B0LW1ogxCcKUbJAoks7rZTyluqwCo
         Iiv9WESzK2gPGuoYaEw4D7eYujVwU0OEYzuWbacXc7S+VKNE9W/gQ2Qu4GTODj2JSgL7
         pSQgC+N06FKm1ZZyyRhD8xS887t1rspxRT1X5YVg7k6cTpWxG5aeYgsfw+6iksHcm/68
         JZWL498hcZrCkHoBGAMGp3QB/AgrwMxpo0fcTb/60IbjPdAELZHZI4sOAMAGv8nBQpSE
         xmKHH8em1kweCwr7UO0HhR/3AshZLiZBpyREsncPMGNmstKiYYDo9CgrCXXpIgFbrRj5
         v5HQ==
X-Gm-Message-State: ANoB5pnRmxcDC62BLgqE2it7C97xc5zaDW2qAH1EyVOWhE9Q0s4pWBho
        S9oR7sgHu0kCPjwU8uqWGbDy/w==
X-Google-Smtp-Source: AA0mqf55XB5GaFMgtjqBGI9rXG5it3M0dDPz7MDm2kSWcdO7Di/dP1DgtzDY1uv4EcixEbCaCLl8Pg==
X-Received: by 2002:a17:906:82cd:b0:7c0:dfb7:62dc with SMTP id a13-20020a17090682cd00b007c0dfb762dcmr9471918ejy.139.1670318992302;
        Tue, 06 Dec 2022 01:29:52 -0800 (PST)
Received: from cloudflare.com (79.184.124.239.ipv4.supernova.orange.pl. [79.184.124.239])
        by smtp.gmail.com with ESMTPSA id n11-20020a170906118b00b007be696512ecsm7057159eja.187.2022.12.06.01.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 01:29:51 -0800 (PST)
References: <Y44xdN3zH4f+BZCD@zwp-5820-Tower>
 <CADVnQykvAWHFOec_=DyU9GMLppK6mpeK-GqUVbktJffj1XA5rQ@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Weiping Zhang <zhangweiping@didiglobal.com>, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        zwp10758@gmail.com
Subject: Re: [RFC PATCH] tcp: correct srtt and mdev_us calculation
Date:   Tue, 06 Dec 2022 10:11:11 +0100
In-reply-to: <CADVnQykvAWHFOec_=DyU9GMLppK6mpeK-GqUVbktJffj1XA5rQ@mail.gmail.com>
Message-ID: <87mt805181.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 02:15 PM -05, Neal Cardwell wrote:
> On Mon, Dec 5, 2022 at 1:02 PM Weiping Zhang
> <zhangweiping@didiglobal.com> wrote:
>>
>> From the comments we can see that, rtt =3D 7/8 rtt + 1/8 new,
>> but there is an mistake,
>>
>> m -=3D (srtt >> 3);
>> srtt +=3D m;
>>
>> explain:
>> m -=3D (srtt >> 3); //use t stands for new m
>> t =3D m - srtt/8;
>>
>> srtt =3D srtt + t
>> =3D srtt + m - srtt/8
>> =3D srtt 7/8 + m
>>
>> Test code:
>>
>>  #include<stdio.h>
>>
>>  #define u32 unsigned int
>>
>> static void test_old(u32 srtt, long mrtt_us)
>> {
>>         long m =3D mrtt_us;
>>         u32 old =3D srtt;
>>
>>         m -=3D (srtt >> 3);
>>         srtt +=3D m;
>>
>>         printf("%s old_srtt: %u mrtt_us: %ld new_srtt: %u\n", __func__, =
 old, mrtt_us, srtt);
>> }
>>
>> static void test_new(u32 srtt, long mrtt_us)
>> {
>>         long m =3D mrtt_us;
>>         u32 old =3D srtt;
>>
>>         m =3D ((m - srtt) >> 3);
>>         srtt +=3D m;
>>
>>         printf("%s old_srtt: %u mrtt_us: %ld new_srtt: %u\n", __func__, =
 old, mrtt_us, srtt);
>> }
>>
>> int main(int argc, char **argv)
>> {
>>         u32 srtt =3D 100;
>>         long mrtt_us =3D 90;
>>
>>         test_old(srtt, mrtt_us);
>>         test_new(srtt, mrtt_us);
>>
>>         return 0;
>> }
>>
>> ./a.out
>> test_old old_srtt: 100 mrtt_us: 90 new_srtt: 178
>> test_new old_srtt: 100 mrtt_us: 90 new_srtt: 98
>>
>> Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
>
> Please note that this analysis and this test program do not take
> account of the fact that srtt in the Linux kernel is maintained in a
> form where it is shifted left by 3 bits, to maintain a 3-bit
> fractional part. That is why at first glance it would seem there is a
> missing multiplication of the new sample by 1/8. By not shifting the
> new sample when it is added to srtt, the new sample is *implicitly*
> multiplied by 1/8.

Nifty. And it's documented.

struct tcp_sock {
        =E2=80=A6
	u32	srtt_us;	/* smoothed round trip time << 3 in usecs */

Thanks for the hint.

>>  net/ipv4/tcp_input.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index 0640453fce54..0242bb31e1ce 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -848,7 +848,7 @@ static void tcp_rtt_estimator(struct sock *sk, long =
mrtt_us)
>>          * that VJ failed to avoid. 8)
>>          */
>>         if (srtt !=3D 0) {
>> -               m -=3D (srtt >> 3);       /* m is now error in rtt est */
>> +               m =3D (m - srtt >> 3);    /* m is now error in rtt est */
>>                 srtt +=3D m;              /* rtt =3D 7/8 rtt + 1/8 new */
>>                 if (m < 0) {
>>                         m =3D -m;         /* m is now abs(error) */
>> @@ -864,7 +864,7 @@ static void tcp_rtt_estimator(struct sock *sk, long =
mrtt_us)
>>                         if (m > 0)
>>                                 m >>=3D 3;
>>                 } else {
>> -                       m -=3D (tp->mdev_us >> 2);   /* similar update o=
n mdev */
>> +                       m =3D (m - tp->mdev_us >> 2);   /* similar updat=
e on mdev */
>>                 }
>>                 tp->mdev_us +=3D m;               /* mdev =3D 3/4 mdev +=
 1/4 new */
>>                 if (tp->mdev_us > tp->mdev_max_us) {
>> --
>> 2.34.1
>
> AFAICT this proposed patch does not change the behavior of the code
> but merely expresses the same operations with slightly different
> syntax. Am I missing something?  :-)

I've been wondering about that too. There's a change hiding behind
operator precedence. Would be better expressed with explicitly placed
parenthesis:

        m =3D (m - srtt) >> 3;    /* m is now error in rtt est */
