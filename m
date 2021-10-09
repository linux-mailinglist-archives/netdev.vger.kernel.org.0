Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C873A427852
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 11:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhJIJO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 05:14:56 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13882 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhJIJOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 05:14:55 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HRK3F44Xyz8skb;
        Sat,  9 Oct 2021 17:08:09 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 17:12:56 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 17:12:50 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session if
 receive TP.DT with error length
To:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
CC:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, Oliver Hartkopp <socketcan@hartkopp.net>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
 <20210930074206.GB7502@x1.vandijck-laurijssen.be>
 <1cab07f2-593a-1d1c-3a29-43ee9df4b29e@huawei.com>
 <20211008110007.GE29653@pengutronix.de>
 <20211008170937.GA12224@x1.vandijck-laurijssen.be>
Message-ID: <4d516eed-e45c-a694-9608-07eebe8a3382@huawei.com>
Date:   Sat, 9 Oct 2021 17:12:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20211008170937.GA12224@x1.vandijck-laurijssen.be>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/10/9 1:09, Kurt Van Dijck wrote:
> On Fri, 08 Oct 2021 13:00:07 +0200, Oleksij Rempel wrote:
>> On Fri, Oct 08, 2021 at 05:22:12PM +0800, Zhang Changzhong wrote:
>>> Hi Kurt,
>>> Sorry for the late reply.
>>>
>>> On 2021/9/30 15:42, Kurt Van Dijck wrote:
>>>> On Thu, 30 Sep 2021 11:33:20 +0800, Zhang Changzhong wrote:
>>>>> According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
>>>>> cancel session when receive unexpected TP.DT message.
>>>>
>>>> SAE-j1939-21 indeed says that all TP.DT must be 8 bytes.
>>>> However, the last TP.DT may contain up to 6 stuff bytes, which have no meaning.
>>>> If I remember well, they are even not 'reserved'.
>>>
>>> Agree, these bytes are meaningless for last TP.DT.
>>>
>>>>
>>>>>
>>>>> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
>>>>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>>>>> ---
>>>>>  net/can/j1939/transport.c | 7 +++++--
>>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
>>>>> index bb5c4b8..eedaeaf 100644
>>>>> --- a/net/can/j1939/transport.c
>>>>> +++ b/net/can/j1939/transport.c
>>>>> @@ -1789,6 +1789,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
>>>>>  static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>>>>>  				 struct sk_buff *skb)
>>>>>  {
>>>>> +	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
>>>>>  	struct j1939_priv *priv = session->priv;
>>>>>  	struct j1939_sk_buff_cb *skcb, *se_skcb;
>>>>>  	struct sk_buff *se_skb = NULL;
>>>>> @@ -1803,9 +1804,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>>>>>  
>>>>>  	skcb = j1939_skb_to_cb(skb);
>>>>>  	dat = skb->data;
>>>>> -	if (skb->len <= 1)
>>>>> +	if (skb->len != 8) {
>>>>>  		/* makes no sense */
>>>>> +		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
>>>>>  		goto out_session_cancel;
>>>>
>>>> I think this is a situation of
>>>> "be strict on what you send, be tolerant on what you receive".
>>>>
>>>> Did you find a technical reason to abort a session because the last frame didn't
>>>> bring overhead that you don't use?
>>>
>>> No technical reason. The only reason is that SAE-J1939-82 requires responder
>>> to abort session if any TP.DT less than 8 bytes (section A.3.4, Row 7).
> 
> IMHO, this is some kind of laziness to make the exception for the last TP.DT.
> 
> I attended an ISOBUS certification (back in 2013) where the transmitting
> node effectively stripped the trailing bytes, and this 'deviation' was
> not even noticed.

I found that SAE-J1939-82 contains the following test:
"BAM Transport: Ensure extra (unused) bytes of last Data Transfer data packet
is/are filled-in correctly. (DUT as Originator)" ... "Verify last TP.DT data
packet for a BAM transport is sent with an 8 byte data field and the unused
bytes of this packet are filled with FF" (section A.3.3, Row 8).

So the J1939 compliance test can detect this kind of 'deviation', perhaps
ISOBUS certification does not do this check?

> 
> This change applies to the receiving side. Would a sender that
> leaves the trailing bytes want you to discard the session bacause of this?
> So the spirit of the SAE-J1939-82 is, in this case, different from
> the strict literal interpretation.

Such packets should not be sent if the sender complies with SAE-J1939-82, but
if the transmitting node you mentioned above exist on the network, this patch
will casue their sessions to be aborted. From this point of view, I think it is
reasonable to drop this patch.

Regards,
Changzhong

> 
>>
>> Do you mean: "BAM Transport: Ensure DUT discards BAM transport when
>> TP.DT data packets are not correct size" ... "Verify DUT discards the
>> BAM transport if any TP.DT data packet has less than 8 bytes"?
> 
> Kind regards,
> Kurt
> .
> 
