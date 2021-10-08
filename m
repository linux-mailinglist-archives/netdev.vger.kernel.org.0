Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2522542669C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbhJHJYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 05:24:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13878 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhJHJYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 05:24:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HQjJR5b2dz90BM;
        Fri,  8 Oct 2021 17:17:27 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 8 Oct 2021 17:22:13 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 8 Oct 2021 17:22:12 +0800
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session if
 receive TP.DT with error length
To:     Robin van der Gracht <robin@protonic.nl>,
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
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <1cab07f2-593a-1d1c-3a29-43ee9df4b29e@huawei.com>
Date:   Fri, 8 Oct 2021 17:22:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210930074206.GB7502@x1.vandijck-laurijssen.be>
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

Hi Kurt,
Sorry for the late reply.

On 2021/9/30 15:42, Kurt Van Dijck wrote:
> On Thu, 30 Sep 2021 11:33:20 +0800, Zhang Changzhong wrote:
>> According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
>> cancel session when receive unexpected TP.DT message.
> 
> SAE-j1939-21 indeed says that all TP.DT must be 8 bytes.
> However, the last TP.DT may contain up to 6 stuff bytes, which have no meaning.
> If I remember well, they are even not 'reserved'.

Agree, these bytes are meaningless for last TP.DT.

>
>>
>> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>> ---
>>  net/can/j1939/transport.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
>> index bb5c4b8..eedaeaf 100644
>> --- a/net/can/j1939/transport.c
>> +++ b/net/can/j1939/transport.c
>> @@ -1789,6 +1789,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
>>  static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>>  				 struct sk_buff *skb)
>>  {
>> +	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
>>  	struct j1939_priv *priv = session->priv;
>>  	struct j1939_sk_buff_cb *skcb, *se_skcb;
>>  	struct sk_buff *se_skb = NULL;
>> @@ -1803,9 +1804,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>>  
>>  	skcb = j1939_skb_to_cb(skb);
>>  	dat = skb->data;
>> -	if (skb->len <= 1)
>> +	if (skb->len != 8) {
>>  		/* makes no sense */
>> +		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
>>  		goto out_session_cancel;
> 
> I think this is a situation of
> "be strict on what you send, be tolerant on what you receive".
> 
> Did you find a technical reason to abort a session because the last frame didn't
> bring overhead that you don't use?

No technical reason. The only reason is that SAE-J1939-82 requires responder
to abort session if any TP.DT less than 8 bytes (section A.3.4, Row 7).

Best regards,
Changzhong

> 
> Kind regards,
> Kurt
>> +	}
>>  
>>  	switch (session->last_cmd) {
>>  	case 0xff:
>> @@ -1904,7 +1907,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>>   out_session_cancel:
>>  	kfree_skb(se_skb);
>>  	j1939_session_timers_cancel(session);
>> -	j1939_session_cancel(session, J1939_XTP_ABORT_FAULT);
>> +	j1939_session_cancel(session, abort);
>>  	j1939_session_put(session);
>>  }
>>  
>> -- 
>> 2.9.5
>>
> .
> 
