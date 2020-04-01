Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0319B7DE
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 23:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732537AbgDAVpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 17:45:00 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:62047 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732357AbgDAVo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 17:44:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585777499; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=e3zly8EY0dRy37KVBsBX4TrhRb0VszK/IxwznVQLwAc=;
 b=Cgf9oKN71gUdKJYbYiGGW775ogX73CJigYhe9zeZ4Fe1nlMBXJ2EKuXbUd0nkkWYNOCtP/Ey
 IfbdL8Q6kE/+cLJvxOU8CM6r0rQd5KRkr9VRj0IvV+6Qiy7OCAS7dAc75ToGN2Hl0PJixH+X
 uT/56VSIRjuuAbiVdiy6n/9kD38=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e850b54.7f768e61c260-smtp-out-n01;
 Wed, 01 Apr 2020 21:44:52 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 73191C433BA; Wed,  1 Apr 2020 21:44:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4E90C433F2;
        Wed,  1 Apr 2020 21:44:50 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 01 Apr 2020 15:44:50 -0600
From:   subashab@codeaurora.org
To:     Alex Elder <elder@linaro.org>
Cc:     ap420073@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: [PATCH net] net: qualcomm: rmnet: Allow configuration updates to
 existing devices
In-Reply-To: <b17b2e15-515f-a758-b8bd-e34a62f405bf@linaro.org>
References: <20200331224348.12539-1-subashab@codeaurora.org>
 <b17b2e15-515f-a758-b8bd-e34a62f405bf@linaro.org>
Message-ID: <f010365522863594b59d16901aeecbfd@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-31 18:06, Alex Elder wrote:
> On 3/31/20 5:43 PM, Subash Abhinov Kasiviswanathan wrote:
>> This allows the changelink operation to succeed if the mux_id was
>> specified as an argument. Note that the mux_id must match the
>> existing mux_id of the rmnet device or should be an unused mux_id.
>> 
>> Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux 
>> id is duplicated")
>> Reported-by: Alex Elder <elder@linaro.org>
>> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
>> Signed-off-by: Subash Abhinov Kasiviswanathan 
>> <subashab@codeaurora.org>
> 
> This was a regression in 5.6, and got back-ported to 5.5.11 and
> possibly further back.  Please be sure the fix gets applied to
> stable branches if appropriate.
> 
> If you happen to post a second version of this I have a suggestion,
> below.  But the patch looks OK to me as-is.
> 
> Thanks.
> 
> Tested-by: Alex Elder <elder@linaro.org>
> 
>> ---
>>  .../ethernet/qualcomm/rmnet/rmnet_config.c    | 21 
>> ++++++++++++-------
>>  1 file changed, 13 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c 
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
>> index fbf4cbcf1a65..06332984399d 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
>> @@ -294,19 +294,24 @@ static int rmnet_changelink(struct net_device 
>> *dev, struct nlattr *tb[],
>> 
>>  	if (data[IFLA_RMNET_MUX_ID]) {
>>  		mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
>> -		if (rmnet_get_endpoint(port, mux_id)) {
>> -			NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
>> -			return -EINVAL;
>> -		}
> 
> My suggestion is this:  Since the endpoint pointer isn't used
> outside the "if (mux_id != priv->mux_id)" block, you could
> do the lookup inside that block.

I've sent a v2 now based on your comment.
