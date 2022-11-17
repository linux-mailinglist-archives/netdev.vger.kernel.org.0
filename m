Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC45D62D043
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiKQAz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiKQAz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:55:57 -0500
Received: from omta033.useast.a.cloudfilter.net (omta033.useast.a.cloudfilter.net [44.202.169.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD9C68697
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:55:56 -0800 (PST)
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
        by cmsmtp with ESMTP
        id vRhMoJrC9SpIivTC7oFLoU; Thu, 17 Nov 2022 00:55:55 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id vTC6oHMmIYIGKvTC6omHWE; Thu, 17 Nov 2022 00:55:54 +0000
X-Authority-Analysis: v=2.4 cv=DJicXgBb c=1 sm=1 tr=0 ts=6375869a
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=wTog8WU66it3cfrESHnF4A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=9xFQ1JgjjksA:10
 a=wYkD_t78qR0A:10 a=9hnffCmvl_RKTy2oYacA:9 a=QEXdDO2ut3YA:10
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vWsztSAw6Xd/AVWrRnjZEspYx6MigMA8LIcIFc387Hs=; b=jV83/Jvak8rSgvoq6Mp+KTGs8T
        PHocpwe4PfY3hx4bjokBFx8RjC1nPL3lidcdLXcLxEl5+35CohZ+AQIaHoXRuron0EHMRy54MNFWe
        SSys14mE1nTfh+FPlRhSQ2PiI+np17vwu6bOUG4r2WG+XNvdSTLhlZX2oqxIS/WB41bS226qU7JxZ
        Fr7eyuR2feoQQ6ibrVlByBLKrG73Y2AxwkBeh6YgdoBiPwPwI8vvJexThiAT2zIl0biNuXCSXgbO5
        lUn2PSpVzwcwaJdygrI/3qCRT2scSpKYz06pH6ZPmdDm9uT1ZFyR5yvWyItOLs89jsQG2f2LA9WSx
        eAE74R7g==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:41342 helo=[192.168.15.7])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1ovTC5-001GJV-GW;
        Wed, 16 Nov 2022 18:55:53 -0600
Message-ID: <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
Date:   Wed, 16 Nov 2022 18:55:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-hardening@vger.kernel.org
References: <20221027212553.2640042-1-kuba@kernel.org>
 <20221114023927.GA685@u2004-local> <20221114090614.2bfeb81c@kernel.org>
 <202211161444.04F3EDEB@keescook> <202211161454.D5FA4ED44@keescook>
 <202211161502.142D146@keescook>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <202211161502.142D146@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1ovTC5-001GJV-GW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.7]) [187.162.31.110]:41342
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGWf9E4LKrcPhsOWfDDUOXJ6Ru2epGVvwC9MKoLX4yxjdGHvz72q7s94PQQVXBUpVVCVqlLWiMxZH94gG6HOyTxjFqKq0sjW8NAIjN5yfUV6W1UrtK+m
 rU+zLRUFD5SSsoVaMjhyjs3Rfc6Zehg2vKkRstd0XTOLLdYtjwHgwgDmIG68ByTC2KkjdbBOGVAjOCc7veLA2y1R6ht7Q0CdmQY=
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/22 18:27, Kees Cook wrote:
> On Wed, Nov 16, 2022 at 02:56:25PM -0800, Kees Cook wrote:
>> On Mon, Nov 14, 2022 at 09:06:14AM -0800, Jakub Kicinski wrote:
>>> On Sun, 13 Nov 2022 19:39:27 -0700 David Ahern wrote:
>>>> On Thu, Oct 27, 2022 at 02:25:53PM -0700, Jakub Kicinski wrote:
>>>>> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
>>>>> index e2ae82e3f9f7..5da0da59bf01 100644
>>>>> --- a/include/uapi/linux/netlink.h
>>>>> +++ b/include/uapi/linux/netlink.h
>>>>> @@ -48,6 +48,7 @@ struct sockaddr_nl {
>>>>>    * @nlmsg_flags: Additional flags
>>>>>    * @nlmsg_seq:   Sequence number
>>>>>    * @nlmsg_pid:   Sending process port ID
>>>>> + * @nlmsg_data:  Message payload
>>>>>    */
>>>>>   struct nlmsghdr {
>>>>>   	__u32		nlmsg_len;
>>>>> @@ -55,6 +56,7 @@ struct nlmsghdr {
>>>>>   	__u16		nlmsg_flags;
>>>>>   	__u32		nlmsg_seq;
>>>>>   	__u32		nlmsg_pid;
>>>>> +	__u8		nlmsg_data[];
>>>>
>>>> This breaks compile of iproute2 with clang. It does not like the
>>>> variable length array in the middle of a struct. While I could re-do the
>>>> structs in iproute2, I doubt it is alone in being affected by this
>>>> change.

Yep; this is a fine Clang warning. We cannot have a variable length object
immediately followed by another object because that would cause undefined
behavior.

>>
>> Eww.
>>
>>>
>>> Kees, would you mind lending your expertise?
> 
> Perhaps this would be better? We could leave the _header_ struct alone,
> but add the data to the nlmsgerr struct instead?
> 
> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> index 5da0da59bf01..d0629cb343b2 100644
> --- a/include/uapi/linux/netlink.h
> +++ b/include/uapi/linux/netlink.h
> @@ -48,7 +48,6 @@ struct sockaddr_nl {
>    * @nlmsg_flags: Additional flags
>    * @nlmsg_seq:   Sequence number
>    * @nlmsg_pid:   Sending process port ID
> - * @nlmsg_data:  Message payload
>    */
>   struct nlmsghdr {
>   	__u32		nlmsg_len;
> @@ -56,7 +55,6 @@ struct nlmsghdr {
>   	__u16		nlmsg_flags;
>   	__u32		nlmsg_seq;
>   	__u32		nlmsg_pid;
> -	__u8		nlmsg_data[];
>   };

This seems to be a sensible change. In general, it's not a good idea
to have variable length objects (flex-array members) in structures used
as headers, and that we know will ultimately be followed by more objects
when embedded inside other structures.

>   
>   /* Flags values */
> @@ -121,6 +119,7 @@ struct nlmsghdr {
>   struct nlmsgerr {
>   	int		error;
>   	struct nlmsghdr msg;
> +	__u8		data[];
>   	/*
>   	 * followed by the message contents unless NETLINK_CAP_ACK was set
>   	 * or the ACK indicates success (error == 0)
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index b8afec32cff6..fe8493d3ae56 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2514,8 +2514,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
>   		if (!nlmsg_append(skb, nlmsg_len(nlh)))
>   			goto err_bad_put;
>   
> -		memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
> -		       nlmsg_len(nlh));
> +		memcpy(errmsg->data, nlmsg_data(nlh), nlmsg_len(nlh));
>   	}
>   
>   	if (tlvlen)
> 
> 

--
Gustavo
