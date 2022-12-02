Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABF7641160
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 00:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiLBXSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 18:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLBXSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 18:18:44 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3A3E5AA6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 15:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1670023123; x=1701559123;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=A3gXEaryLUtwsdYRKLLXjWZrK2V5vXke781MSw2CTLw=;
  b=nkTkKpU/vR8Rbh58pn1ZFLHp22qbRQ6R3hIi8JrOKQ04J2iAgxUFvty4
   qoj6Mr/rpHI13rkVOHJIRuGwUtlpKhoIwLZl0lZB4YaDg6soV0LcHT0H0
   m9JuyGCFbW8VL+DWHRmJcMgY4N/XDO82iRasvcqdPN+f94VwPMo/ch8j4
   I=;
Subject: Re: [PATCH net v2] unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()
Thread-Topic: [PATCH net v2] unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 23:18:42 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id 086B44182E;
        Fri,  2 Dec 2022 23:18:39 +0000 (UTC)
Received: from EX19D004ANA004.ant.amazon.com (10.37.240.146) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 2 Dec 2022 23:18:39 +0000
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19D004ANA004.ant.amazon.com (10.37.240.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 2 Dec 2022 23:18:38 +0000
Received: from EX19D004ANA001.ant.amazon.com ([fe80::f099:cbca:cc6b:91ec]) by
 EX19D004ANA001.ant.amazon.com ([fe80::f099:cbca:cc6b:91ec%5]) with mapi id
 15.02.1118.020; Fri, 2 Dec 2022 23:18:38 +0000
From:   "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
To:     Kirill Tkhai <tkhai@ya.ru>
CC:     Paolo Abeni <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Thread-Index: AQHZBWfGi0OEzvpCBkmvyXswzu39O65bNEuAgAAJtsE=
Date:   Fri, 2 Dec 2022 23:18:38 +0000
Message-ID: <53BD8023-E114-4B3E-BB07-C1889C8A3E95@amazon.co.jp>
References: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
 <7f1277b54a76280cfdaa25d0765c825d665146b9.camel@redhat.com>,<b7172d71-5f64-104e-48cc-3e6b07ba75ac@ya.ru>
In-Reply-To: <b7172d71-5f64-104e-48cc-3e6b07ba75ac@ya.ru>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 3, 2022, at 7:44, Kirill Tkhai <tkhai@ya.ru> wrote:
>> On 01.12.2022 12:30, Paolo Abeni wrote:
>>> On Sun, 2022-11-27 at 01:46 +0300, Kirill Tkhai wrote:
>>> There is a race resulting in alive SOCK_SEQPACKET socket
>>> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
>>>=20
>>> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
>>>  sock_orphan(peer)
>>>    sock_set_flag(peer, SOCK_DEAD)
>>>                                           sock_alloc_send_pskb()
>>>                                             if !(sk->sk_shutdown & SEND=
_SHUTDOWN)
>>>                                               OK
>>>                                           if sock_flag(peer, SOCK_DEAD)
>>>                                             sk->sk_state =3D TCP_CLOSE
>>>  sk->sk_shutdown =3D SHUTDOWN_MASK
>>>=20
>>>=20
>>> After that socket sk remains almost normal: it is able to connect, list=
en, accept
>>> and recvmsg, while it can't sendmsg.
>>>=20
>>> Since this is the only possibility for alive SOCK_SEQPACKET to change
>>> the state in such way, we should better fix this strange and potentiall=
y
>>> danger corner case.
>>>=20
>>> Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
>>> to fix race with unix_dgram_connect():
>>>=20
>>> unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
>>>                                       unix_peer(sk) =3D NULL
>>>                                       unix_state_unlock(sk)
>>>  unix_state_double_lock(sk, other)
>>>  sk->sk_state  =3D TCP_ESTABLISHED
>>>  unix_peer(sk) =3D other
>>>  unix_state_double_unlock(sk, other)
>>>                                       sk->sk_state  =3D TCP_CLOSED
>>>=20
>>> This patch fixes both of these races.
>>>=20
>>> Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets=
 too")
>>=20
>> I don't think this commmit introduces the issues, both behavior
>> described above appear to be present even before?
>=20
> 1)Hm, I pointed to the commit suggested by Kuniyuki without checking it.
>=20
> Possible, the real problem commit is dc56ad7028c5 "af_unix: fix potential=
 NULL deref in unix_dgram_connect()",
> since it added TCP_CLOSED assignment to unix_dgram_sendmsg().

The commit just moved the assignment.

Note unix_dgram_disconnected() is called for SOCK_SEQPACKET=20
after releasing the lock, and 83301b5367a9 introduced the=20
TCP_CLOSE assignment.


> 2)What do you think about initial version of fix?
>=20
> https://patchwork.kernel.org/project/netdevbpf/patch/38a920a7-cfba-7929-8=
86d-c3c6effc0c43@ya.ru/
>=20
> Despite there are some arguments, I'm not still sure that v2 is better.
>=20
> Thanks,
> Kirill
