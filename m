Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE5355227
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 16:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbfFYOkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 10:40:04 -0400
Received: from www1102.sakura.ne.jp ([219.94.129.142]:39257 "EHLO
        www1102.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfFYOkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 10:40:02 -0400
Received: from fsav101.sakura.ne.jp (fsav101.sakura.ne.jp [27.133.134.228])
        by www1102.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x5PEe0Jv044514;
        Tue, 25 Jun 2019 23:40:00 +0900 (JST)
        (envelope-from katsuhiro@katsuster.net)
Received: from www1102.sakura.ne.jp (219.94.129.142)
 by fsav101.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav101.sakura.ne.jp);
 Tue, 25 Jun 2019 23:40:00 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav101.sakura.ne.jp)
Received: from [192.168.1.2] (118.153.231.153.ap.dti.ne.jp [153.231.153.118])
        (authenticated bits=0)
        by www1102.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x5PEe0HW044501
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Tue, 25 Jun 2019 23:40:00 +0900 (JST)
        (envelope-from katsuhiro@katsuster.net)
Subject: Re: [PATCH net-next] net: stmmac: Fix the case when PHY handle is not
 present
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
References: <351cce38d1c572d8b171044f2856c7fae9f89cbc.1561450696.git.joabreu@synopsys.com>
 <78EB27739596EE489E55E81C33FEC33A0B9D78A2@DE02WEMBXB.internal.synopsys.com>
From:   Katsuhiro Suzuki <katsuhiro@katsuster.net>
Message-ID: <5859e2c5-112f-597c-3bd5-e30e96b86152@katsuster.net>
Date:   Tue, 25 Jun 2019 23:40:00 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B9D78A2@DE02WEMBXB.internal.synopsys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jose,

This patch works fine with my Tinker Board. Thanks a lot!

Tested-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>


BTW, from network guys point of view, is it better to add a phy node
into device trees that have no phy node such as the Tinker Board?


Best Regards,
Katsuhiro Suzuki


On 2019/06/25 22:11, Jose Abreu wrote:
> ++ Katsuhiro
> 
> From: Jose Abreu <joabreu@synopsys.com>
> 
>> Some DT bindings do not have the PHY handle. Let's fallback to manually
>> discovery in case phylink_of_phy_connect() fails.
>>
>> Reported-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
>> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Joao Pinto <jpinto@synopsys.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> Cc: Alexandre Torgue <alexandre.torgue@st.com>
>> ---
>> Hello Katsuhiro,
>>
>> Can you please test this patch ?
>> ---
>>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index a48751989fa6..f4593d2d9d20 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -950,9 +950,12 @@ static int stmmac_init_phy(struct net_device *dev)
>>   
>>   	node = priv->plat->phylink_node;
>>   
>> -	if (node) {
>> +	if (node)
>>   		ret = phylink_of_phy_connect(priv->phylink, node, 0);
>> -	} else {
>> +
>> +	/* Some DT bindings do not set-up the PHY handle. Let's try to
>> +	 * manually parse it */
>> +	if (!node || ret) {
>>   		int addr = priv->plat->phy_addr;
>>   		struct phy_device *phydev;
>>   
>> -- 
>> 2.7.4
> 
> 
> 
> 

