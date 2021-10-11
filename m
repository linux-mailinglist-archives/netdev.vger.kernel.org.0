Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7583428AE2
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhJKKmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 06:42:20 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24239 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbhJKKmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 06:42:18 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HSZzM53YpzQj9v;
        Mon, 11 Oct 2021 18:39:11 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 11 Oct 2021 18:40:16 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 11 Oct 2021 18:40:15 +0800
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session if
 receive TP.DT with error length
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Robin van der Gracht <robin@protonic.nl>,
        <linux-kernel@vger.kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <netdev@vger.kernel.org>, Marc Kleine-Budde <mkl@pengutronix.de>,
        <kernel@pengutronix.de>, Oliver Hartkopp <socketcan@hartkopp.net>,
        Jakub Kicinski <kuba@kernel.org>, <linux-can@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
 <20210930074206.GB7502@x1.vandijck-laurijssen.be>
 <1cab07f2-593a-1d1c-3a29-43ee9df4b29e@huawei.com>
 <20211008110007.GE29653@pengutronix.de>
 <556a04ed-c350-7b2b-5bbe-98c03846630b@huawei.com>
 <20211011063507.GI29653@pengutronix.de>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <7b1b2e47-46e6-acec-5858-fae77266cec8@huawei.com>
Date:   Mon, 11 Oct 2021 18:40:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20211011063507.GI29653@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/10/11 14:35, Oleksij Rempel wrote:
> On Sat, Oct 09, 2021 at 04:43:56PM +0800, Zhang Changzhong wrote:
>> On 2021/10/8 19:00, Oleksij Rempel wrote:
>>> On Fri, Oct 08, 2021 at 05:22:12PM +0800, Zhang Changzhong wrote:
>>>> Hi Kurt,
>>>> Sorry for the late reply.
>>>>
>>>> On 2021/9/30 15:42, Kurt Van Dijck wrote:
>>>>> On Thu, 30 Sep 2021 11:33:20 +0800, Zhang Changzhong wrote:
>>>>>> According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
>>>>>> cancel session when receive unexpected TP.DT message.
>>>>>
>>>>> SAE-j1939-21 indeed says that all TP.DT must be 8 bytes.
>>>>> However, the last TP.DT may contain up to 6 stuff bytes, which have no meaning.
>>>>> If I remember well, they are even not 'reserved'.
>>>>
>>>> Agree, these bytes are meaningless for last TP.DT.
>>>>
>>>>>
>>>>>>
>>>>>> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
>>>>>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>>>>>> ---
>>>>>>  net/can/j1939/transport.c | 7 +++++--
>>>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
>>>>>> index bb5c4b8..eedaeaf 100644
>>>>>> --- a/net/can/j1939/transport.c
>>>>>> +++ b/net/can/j1939/transport.c
>>>>>> @@ -1789,6 +1789,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
>>>>>>  static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>>>>>>  				 struct sk_buff *skb)
>>>>>>  {
>>>>>> +	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
>>>>>>  	struct j1939_priv *priv = session->priv;
>>>>>>  	struct j1939_sk_buff_cb *skcb, *se_skcb;
>>>>>>  	struct sk_buff *se_skb = NULL;
>>>>>> @@ -1803,9 +1804,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>>>>>>  
>>>>>>  	skcb = j1939_skb_to_cb(skb);
>>>>>>  	dat = skb->data;
>>>>>> -	if (skb->len <= 1)
>>>>>> +	if (skb->len != 8) {
>>>>>>  		/* makes no sense */
>>>>>> +		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
>>>>>>  		goto out_session_cancel;
>>>>>
>>>>> I think this is a situation of
>>>>> "be strict on what you send, be tolerant on what you receive".
>>>>>
>>>>> Did you find a technical reason to abort a session because the last frame didn't
>>>>> bring overhead that you don't use?
>>>>
>>>> No technical reason. The only reason is that SAE-J1939-82 requires responder
>>>> to abort session if any TP.DT less than 8 bytes (section A.3.4, Row 7).
>>>
>>> Do you mean: "BAM Transport: Ensure DUT discards BAM transport when
>>> TP.DT data packets are not correct size" ... "Verify DUT discards the
>>> BAM transport if any TP.DT data packet has less than 8 bytes"?
>>
>> Yes.
> 
> OK, then I have some problems to understand this part:
> - 5.10.2.4 Connection Closure
>   The “connection abort” message is not allowed to be used by responders in the
>   case of a global destination (i.e. BAM).
> 
> My assumption would be: In case of broadcast transfer, multiple MCU are
> receivers. If one of MCU was not able to get complete TP.DT, it should
> not abort BAM for all.
> 
> So, "DUT discards the BAM transport" sounds for me as local action.
> Complete TP would be dropped locally.

Yeah, you are right. With this patch receivers drop BAM transport locally
because j1939_session_cancel() only send abort message in RTS/CTS transport.

For RTS/CTS transport, SAE-J1939-82 also has similar requirements:
"RTS/CTS Transport: Data field size of Transport Data packets for RTS/CTS
(DUT as Responder)"..."Verify DUT behavior, e.g., sends a TP.CM_CTS to have
packets resent or sends a TP.Conn_Abort, when it receives TP.DT data packets
with less than 8 bytes" (section A.3.6, Row 18)

Regards,
Changzhong
.
