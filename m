Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6814E18A97A
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgCRXuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:50:03 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35054 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgCRXuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:50:03 -0400
Received: by mail-ed1-f65.google.com with SMTP id a20so398598edj.2
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 16:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o5P//IGU0B1fbtQBBBaXBr2gpazCG2olY1bZnj6CAfM=;
        b=ct+ATNFVJrn3VKb5lby+6uwVXLapW/uZ/663YMP1KbQLzRN2o1ZXqiRFNIu30khQIZ
         UWHAZWFMLshnFevO9d3DKS9qWPSwyhLZ+hg3Zneb9f8Lgl6p/KAX1Wp0YYznxmTgilTl
         DJYOg14AfLdMbSmRp0bLXbtGxLZA2IkUfTDMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o5P//IGU0B1fbtQBBBaXBr2gpazCG2olY1bZnj6CAfM=;
        b=l9svX/fkb91HuJu/S5Ehjj3Rq72BvA04fUOuV9Pc0s3hdAwQvITvriZu5bPrEHUGeS
         cH9PkZYvgk7IpZS77DNjy289zh9X+cgDLM0QW0L5Rn7vQvX+EQvd7mEZy9oQE/pMRWcW
         NBRHqz/30nVhEToCFb7Z06Ond8lMjZwB/0iN08EQpwECV9dvgBIvH1FeoalegJi4/vjd
         Ov4S1JA/Er448zuE+L7bZuZGflwiLhE7g6FMfx+fRcZQmumt9z+MsvWmYyGTglj0vUG1
         uXzd9uoqJYtlyU+5u7ft4pKw0QFb/t/0MQHjZ5HBZMnqaydfOn9roJUlI/2vck0ypv1M
         grOw==
X-Gm-Message-State: ANhLgQ3aEGyb2MlfYy1O9tj4W7ZoWdlNBePFa6jcl18ZPYAY85FFUh/L
        VWwQTMyx+tJcLxZmzfxs/O2eMw==
X-Google-Smtp-Source: ADFU+vuSHRPCLj5frP/2lBllWiJ4obVvgyRgb7LUTptU9yzeycQULifRXDxCO1AvRU5pr64dqhPRzA==
X-Received: by 2002:a17:906:480a:: with SMTP id w10mr729452ejq.16.1584575401081;
        Wed, 18 Mar 2020 16:50:01 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id da23sm16196edb.85.2020.03.18.16.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 16:50:00 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bridge: vlan: include stats in dumps if
 requested
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
References: <20200318130325.100508-1-nikolay@cumulusnetworks.com>
 <20200318.164234.1141226942122598740.davem@davemloft.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <dfbabebc-6c04-0df9-6fb3-46fd875674d2@cumulusnetworks.com>
Date:   Thu, 19 Mar 2020 01:49:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200318.164234.1141226942122598740.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 1:42 AM, David Miller wrote:
> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Date: Wed, 18 Mar 2020 15:03:25 +0200
> 
>> @@ -170,11 +170,13 @@ struct bridge_stp_xstats {
>>   /* Bridge vlan RTM header */
>>   struct br_vlan_msg {
>>   	__u8 family;
>> -	__u8 reserved1;
>> +	__u8 flags;
>>   	__u16 reserved2;
>>   	__u32 ifindex;
>>   };
> 
> I can't allow this for two reasons:
> 
> 1) Userspace explicitly initializing all members will now get a compile
>     failure on the reference to ->reserved1
> 
> 2) Userspace not initiailizing reserved fields, which worked previously,
>     might send in flags that trigger the new behavior.
> 
> Sorry, this is UAPI breakage.
> 

Hmm, fair enough. I'll respin with a new dump attribute which achieves the same.

Thanks.


