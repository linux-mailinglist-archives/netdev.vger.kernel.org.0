Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17544DBD4A
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351780AbiCQC6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347012AbiCQC6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:58:08 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0FA20F6F
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 19:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647485812; x=1679021812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RvP0MfVS6aEk/gSCHtNVMbEW/ZsgyD5QfpgxGSMYiHE=;
  b=C5jw7cvbmWX9Mf9hl1vnRGOBgtOnI3dX/MN1nZNKCfTg/SpiFBTqfkSK
   HKddQuv1JDzS5h1a9YLC1i8t2uVTUKwTR1yQYpw6aPpqWEEdyAiV5o81r
   faHVqIw7l9qS05uTDrdZ88ZoB6KkJKFawrdGAqssku+5/PTnXERCAaZr6
   E=;
X-IronPort-AV: E=Sophos;i="5.90,188,1643673600"; 
   d="scan'208";a="202957152"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-ff3df2fe.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 17 Mar 2022 02:56:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-ff3df2fe.us-west-2.amazon.com (Postfix) with ESMTPS id A39CC41F4A;
        Thu, 17 Mar 2022 02:56:50 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 17 Mar 2022 02:56:50 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.118) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 17 Mar 2022 02:56:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuba@kernel.org>
CC:     <Rao.Shoaib@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net 2/2] af_unix: Support POLLPRI for OOB.
Date:   Thu, 17 Mar 2022 11:56:43 +0900
Message-ID: <20220317025643.62875-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220316194614.3e38cadc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220316194614.3e38cadc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.118]
X-ClientProxiedBy: EX13D45UWA002.ant.amazon.com (10.43.160.38) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 16 Mar 2022 19:46:14 -0700
> On Wed, 16 Mar 2022 03:38:55 +0900 Kuniyuki Iwashima wrote:
>> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
>> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
>> piece.
>> 
>> In the selftest, normal datagrams are sent followed by OOB data, so this
>> commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first test
>> case.
>> 
>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> 
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index 0c37e5595aae..f94afaa5a696 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -2049,7 +2049,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>>   */
>>  #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
>>  
>> -#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
>> +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
>>  static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
>>  {
>>  	struct unix_sock *ousk = unix_sk(other);
>> @@ -2115,7 +2115,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>>  
>>  	err = -EOPNOTSUPP;
>>  	if (msg->msg_flags & MSG_OOB) {
>> -#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
>> +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
>>  		if (len)
>>  			len--;
>>  		else
>> @@ -2186,7 +2186,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>>  		sent += size;
>>  	}
>>  
>> -#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
>> +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
>>  	if (msg->msg_flags & MSG_OOB) {
>>  		err = queue_oob(sock, msg, other);
>>  		if (err)
> 
> If we want to keep this change structured as a fix and backported we
> should avoid making unnecessary changes. Fixes need to be minimal
> as per stable rules.

Exactly, I should have taken care of that more.
I'll will keep this in mind.
Sorry for bothering and thank you!


> 
> Could you make removal of the brackets a patch separate from this
> series and targeted at net-next?

Sure, I will submit v4 and separate one soon.
