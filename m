Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3854E62D304
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 06:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbiKQFyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 00:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiKQFyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 00:54:13 -0500
Received: from omta037.useast.a.cloudfilter.net (omta037.useast.a.cloudfilter.net [44.202.169.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAB54E43C;
        Wed, 16 Nov 2022 21:54:12 -0800 (PST)
Received: from eig-obgw-6011a.ext.cloudfilter.net ([10.0.30.170])
        by cmsmtp with ESMTP
        id vX3co0qNLGK0JvXqlowW8G; Thu, 17 Nov 2022 05:54:11 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id vXqjo66hHNkqcvXqkoVxpy; Thu, 17 Nov 2022 05:54:10 +0000
X-Authority-Analysis: v=2.4 cv=SKhR6cjH c=1 sm=1 tr=0 ts=6375cc82
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=wTog8WU66it3cfrESHnF4A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=9xFQ1JgjjksA:10
 a=wYkD_t78qR0A:10 a=mDV3o1hIAAAA:8 a=2MnAaCYfOD4pXKyC1zoA:9 a=QEXdDO2ut3YA:10
 a=DJlwVr9uAhcA:10 a=_FVE-zBwftR9WsbkzFJk:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IVX0Ndlx1QpYhjf6muh2ZPSSsujamdKE8h0m5gxriWg=; b=ugXaIBaR4SHJOdHpIfJSysQRJk
        hMygA3NHigKCOmE5iAW0VZjHyR0CwhUgP30QHNr6WsO4z05rCNLNSbspxE82ao1QRGzoq3RImwp9j
        GtQ9ZexrPKOHKREupWjN7634OqdDMGlVHQ6xaK5tw0bQlBdOhcEfUVn1lFAYYs0EJ/zvIh4BPinqP
        2hcDv/2Ahg/pDw2r4SHBqlqYSG+1KTcUfUSgFmkXOx6sI8xRR4ZOb5shl3PNocyfHjBUG6Yj6YIH3
        78Te8wPDAGFqJ68kpL3dmG8jVRkx/ECkwcC2KvnIAHwuZCi4JyMMsadD/emMtxoZZ8vgg1lzRFLGE
        H+/OXVLQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:57016 helo=[192.168.15.7])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1ovTaS-001jBu-26;
        Wed, 16 Nov 2022 19:21:04 -0600
Message-ID: <1b373b08-988d-b870-d363-814f8083157c@embeddedor.com>
Date:   Wed, 16 Nov 2022 19:20:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-hardening@vger.kernel.org
References: <20221027212553.2640042-1-kuba@kernel.org>
 <20221114023927.GA685@u2004-local> <20221114090614.2bfeb81c@kernel.org>
 <202211161444.04F3EDEB@keescook> <202211161454.D5FA4ED44@keescook>
 <202211161502.142D146@keescook>
 <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
 <20221116170526.752c304b@kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20221116170526.752c304b@kernel.org>
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
X-Exim-ID: 1ovTaS-001jBu-26
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.7]) [187.162.31.110]:57016
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGnFtwXyMzEZr0qCQ2E57yecRpTyr4V7mLRrI/N5+fofzAMLl/3YJvDZkX+M+AlacciKVOB7Yp6hNA7rDmy8K2NluJ61jKu3FxM94N0qC9U5ROmWOtan
 Maak1/0HAGGTy6eGvb9J1UPBMB7N9DL5Qz+ICFmSqsBWBCccPeHD/eHbDwfCmIhPuTa29mBHZWy04lb4bouMM4Drya2v0sQnhrdxdB2cCbB96HkUk/WR8xSU
 cKRI8Pjm3fstyZYzTsTuMw==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/22 19:05, Jakub Kicinski wrote:
> On Wed, 16 Nov 2022 18:55:36 -0600 Gustavo A. R. Silva wrote:
>>> @@ -56,7 +55,6 @@ struct nlmsghdr {
>>>    	__u16		nlmsg_flags;
>>>    	__u32		nlmsg_seq;
>>>    	__u32		nlmsg_pid;
>>> -	__u8		nlmsg_data[];
>>>    };
>>
>> This seems to be a sensible change. In general, it's not a good idea
>> to have variable length objects (flex-array members) in structures used
>> as headers, and that we know will ultimately be followed by more objects
>> when embedded inside other structures.
> 
> Meaning we should go back to zero-length arrays instead?

No.
> Is there something in the standard that makes flexible array
> at the end of an embedded struct a problem?

I haven't seen any problems ss long as the flex-array appears last:

struct foo {
	... members
	struct boo {
		... members
		char flex[];
	};
};

struct complex {
	... members
	struct foo embedded;
};

However, the GCC docs[1] mention this:

"A structure containing a flexible array member [..] may not be a
member of a structure [..] (However, these uses are permitted by GCC
as extensions.)"

And in this case it seems that's the reason why GCC doesn't complain?

--
Gustavo

[1] https://gcc.gnu.org/onlinedocs/gcc-12.2.0/gcc/Zero-Length.html#Zero-Length
