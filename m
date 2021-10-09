Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CFD42782D
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 10:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhJIIp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 04:45:58 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:25113 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhJIIp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 04:45:57 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HRJTY3v3kz1DHTJ;
        Sat,  9 Oct 2021 16:42:25 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 16:43:57 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 16:43:56 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session if
 receive TP.DT with error length
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
 <20210930074206.GB7502@x1.vandijck-laurijssen.be>
 <1cab07f2-593a-1d1c-3a29-43ee9df4b29e@huawei.com>
 <20211008110007.GE29653@pengutronix.de>
Message-ID: <556a04ed-c350-7b2b-5bbe-98c03846630b@huawei.com>
Date:   Sat, 9 Oct 2021 16:43:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20211008110007.GE29653@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/10/8 19:00, Oleksij Rempel wrote:
> On Fri, Oct 08, 2021 at 05:22:12PM +0800, Zhang Changzhong wrote:
>> Hi Kurt,
>> Sorry for the late reply.
>>
>> On 2021/9/30 15:42, Kurt Van Dijck wrote:
>>> On Thu, 30 Sep 2021 11:33:20 +0800, Zhang Changzhong wrote:
>>>> According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
>>>> cancel session when receive unexpected TP.DT message.
>>>
>>> SAE-j1939-21 indeed says that all TP.DT must be 8 bytes.
>>> However, the last TP.DT may contain up to 6 stuff bytes, which have no meaning.
>>> If I remember well, they are even not 'reserved'.
>>
>> Agree, these bytes are meaningless for last TP.DT.
>>
>>>
>>>>
>>>> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
>>>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>>>> ---
>>>>  net/can/j1939/transport.c | 7 +++++--
>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
>>>> index bb5c4b8..eedaeaf 100644
>>>> --- a/net/can/j1939/transport.c
>>>> +++ b/net/can/j1939/transport.c
>>>> @@ -1789,6 +1789,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
>>>>  static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>>>>  				 struct sk_buff *skb)
>>>>  {
>>>> +	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
>>>>  	struct j1939_priv *priv = session->priv;
>>>>  	struct j1939_sk_buff_cb *skcb, *se_skcb;
>>>>  	struct sk_buff *se_skb = NULL;
>>>> @@ -1803,9 +1804,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>>>>  
>>>>  	skcb = j1939_skb_to_cb(skb);
>>>>  	dat = skb->data;
>>>> -	if (skb->len <= 1)
>>>> +	if (skb->len != 8) {
>>>>  		/* makes no sense */
>>>> +		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
>>>>  		goto out_session_cancel;
>>>
>>> I think this is a situation of
>>> "be strict on what you send, be tolerant on what you receive".
>>>
>>> Did you find a technical reason to abort a session because the last frame didn't
>>> bring overhead that you don't use?
>>
>> No technical reason. The only reason is that SAE-J1939-82 requires responder
>> to abort session if any TP.DT less than 8 bytes (section A.3.4, Row 7).
> 
> Do you mean: "BAM Transport: Ensure DUT discards BAM transport when
> TP.DT data packets are not correct size" ... "Verify DUT discards the
> BAM transport if any TP.DT data packet has less than 8 bytes"?

Yes.

Regards,
Changzhong

> 
> Regards,
> Oleksij
> 
