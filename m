Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBEB31E188
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhBQVhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBQVhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 16:37:33 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA95BC061574;
        Wed, 17 Feb 2021 13:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:
        Mime-Version:From:Content-Transfer-Encoding:Content-Type:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/uZNGi666T9AmszXFdp2hSTIV5QmDVisC5kGWzPltv4=; b=gyGiYZP/VYLjWaMcd2rusQ1bHU
        Ou2nATawQkD3aWr0LhiAqrPr7zvLO9/sXQR6u6ygILHvcHtk0+FEf9FQChPrTvHhjwWGjd+OaUySk
        rzvcJqt7bElclKYtK2NM2KTYyafrGXgJrTCFeIA93X2QFx4Eg+Smxlf52ziXgpvIaPnk=;
Received: from [2a01:598:b105:cab0:200c:a5c2:fc75:64e4]
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lCUUm-0002xn-5w; Wed, 17 Feb 2021 22:36:28 +0100
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Felix Fietkau <nbd@nbd.name>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/2] ath9k: fix ath_tx_process_buffer() potential null ptr dereference
Date:   Wed, 17 Feb 2021 22:36:27 +0100
Message-Id: <0B055508-7269-4D12-B355-586C8EEE26DD@nbd.name>
References: <5d70b0ab-0627-74a1-3602-98a7c71b871a@linuxfoundation.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, davem@davemloft.net,
        kuba@kernel.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <5d70b0ab-0627-74a1-3602-98a7c71b871a@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
X-Mailer: iPhone Mail (17F75)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 17. Feb 2021, at 21:28, Shuah Khan <skhan@linuxfoundation.org> wrote:
>=20
> =EF=BB=BFOn 2/17/21 7:56 AM, Shuah Khan wrote:
>>> On 2/17/21 12:30 AM, Kalle Valo wrote:
>>> Shuah Khan <skhan@linuxfoundation.org> writes:
>>>=20
>>>> On 2/16/21 12:53 AM, Felix Fietkau wrote:
>>>>>=20
>>>>> On 2021-02-16 08:03, Kalle Valo wrote:
>>>>>> Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>>>>=20
>>>>>>> ath_tx_process_buffer() references ieee80211_find_sta_by_ifaddr()
>>>>>>> return pointer (sta) outside null check. Fix it by moving the code
>>>>>>> block under the null check.
>>>>>>>=20
>>>>>>> This problem was found while reviewing code to debug RCU warn from
>>>>>>> ath10k_wmi_tlv_parse_peer_stats_info() and a subsequent manual audit=

>>>>>>> of other callers of ieee80211_find_sta_by_ifaddr() that don't hold
>>>>>>> RCU read lock.
>>>>>>>=20
>>>>>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>>>>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>>>>>=20
>>>>>> Patch applied to ath-next branch of ath.git, thanks.
>>>>>>=20
>>>>>> a56c14bb21b2 ath9k: fix ath_tx_process_buffer() potential null ptr de=
reference
>>>>> I just took another look at this patch, and it is completely bogus.
>>>>> Not only does the stated reason not make any sense (sta is simply pass=
ed
>>>>> to other functions, not dereferenced without checks), but this also
>>>>> introduces a horrible memory leak by skipping buffer completion if sta=

>>>>> is NULL.
>>>>> Please drop it, the code is fine as-is.
>>>>=20
>=20
> Felix,
>=20
> I looked at the code path again and found the following path that
> can become a potential dereference downstream. My concern is
> about potential dereference downstream.
>=20
> First path: ath_tx_complete_buf()
>=20
> 1. ath_tx_process_buffer() passes sta to ath_tx_complete_buf()
> 2. ath_tx_complete_buf() doesn't check or dereference sta
>   Passes it on to ath_tx_complete()
> 3. ath_tx_complete() doesn't check or dereference sta, but assigns
>   it to tx_info->status.status_driver_data[0]
>   tx_info->status.status_driver_data[0] =3D sta;
>=20
> ath_tx_complete_buf() should be fixed to check sta perhaps?
>=20
> This assignment without checking could lead to dereference at some
> point in the future.
The assignment is fine, no check needed here. If there was any invalid deref=
erence here, we would see reports of crashes with NULL pointer dereference. S=
ending packets with sta=3D=3DNULL is quite common, especially in AP mode.

> Second path: ath_tx_complete_aggr()
>=20
> 1. ath_tx_process_buffer() passes sta to ath_tx_complete_aggr()
> 2. No problems in this path as ath_tx_complete_aggr() checks
>   sta before use.
>=20
> I can send the revert as it moves more code than necessary under
> the null check. As you pointed out, it could lead to memory leak.
> Not knowing this code well, I can't really tell where. However,
> my original concern is valid for ath_tx_complete_buf
I still don=E2=80=99t see anything to be concerned about. I don=E2=80=99t ev=
en think passing a pointer that could be NULL to another function even deser=
ves a comment in the code. Stuff like that is used in many other places as w=
ell.

- Felix=

