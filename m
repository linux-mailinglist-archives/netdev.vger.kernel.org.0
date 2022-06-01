Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AB9539D43
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349875AbiFAGdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241485AbiFAGdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:33:15 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382C31DD4;
        Tue, 31 May 2022 23:33:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VF.o2aG_1654065189;
Received: from 30.225.28.200(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VF.o2aG_1654065189)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Jun 2022 14:33:10 +0800
Message-ID: <7d57f299-115f-3d34-a45e-1c125a9a580a@linux.alibaba.com>
Date:   Wed, 1 Jun 2022 14:33:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
 <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
 <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/5/25 下午9:42, Alexandra Winter 写道:

> We need to carefully evaluate them and make sure everything is compatible
> with the existing implementations of SMC-D and SMC-R v1 and v2. In the
> typical s390 environment ROCE LAG is propably not good enough, as the card
> is still a single point of failure. So your ideas need to be compatible
> with link redundancy. We also need to consider that the extension of the
> protocol does not block other desirable extensions.
> 
> Your prototype is very helpful for the understanding. Before submitting any
> code patches to net-next, we should agree on the details of the protocol
> extension. Maybe you could formulate your proposal in plain text, so we can
> discuss it here?
> 
> We also need to inform you that several public holidays are upcoming in the
> next weeks and several of our team will be out for summer vacation, so please
> allow for longer response times.
> 
> Kind regards
> Alexandra Winter
> 

Hi alls,

In order to achieve signle-link compatibility, we must
complete at least once negotiation. We wish to provide
higher scalability while meeting this feature. There are
few ways to reach this.

1. Use the available reserved bits. According to
the SMC v2 protocol, there are at least 28 reserved octets
in PROPOSAL MESSAGE and at least 10 reserved octets in
ACCEPT MESSAGE are available. We can define an area in which
as a feature area, works like bitmap. Considering the subsequent 
scalability, we MAY use at least 2 reserved ctets, which can support 
negotiation of at least 16 features.

2. Unify all the areas named extension in current
SMC v2 protocol spec without reinterpreting any existing field
and field offset changes, including 'PROPOSAL V1 IP Subnet Extension',
'PROPOSAL V2 Extension', 'PROPOSAL SMC-DV2 EXTENSION' .etc. And provides
the ability to grow dynamically as needs expand. This scheme will use
at least 10 reserved octets in the PROPOSAL MESSAGE and at least 4 
reserved octets in ACCEPT MESSAGE and CONFIRM MESSAGE. Fortunately, we 
only need to use reserved fields, and the current reserved fields are 
sufficient. And then we can easily add a new extension named SIGNLE 
LINK. Limited by space, the details will be elaborated after the scheme 
is finalized.

But no matter what scheme is finalized, the workflow should be similar to:

Allow Single-link:

client							    server
	proposal with Single-link feature bit or extension
		-------->

	accept with Single-link feature bit extension
		<--------
		
		confirm
		-------->


Deny or not recognized:

client							     server
	proposal with Single-link feature bit or extension
		-------->

		rkey confirm
		<------
		------>

	accept without Single-link feature bit or extension
		<------

		rkey confirm
		------->
		<------
		
		confirm
		------->


Look forward to your advice and comments.

Thanks.

