Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B496B3AF06D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 18:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhFUQtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 12:49:06 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:30675 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhFUQrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 12:47:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624293894; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=LU0zPN4GX3XCm4hKXqrE80vqb5CPyJoAnWvr33F6kow=;
 b=NORIKWTKvQel3SUxBwaL6OdNAmyFXGCAcmAopsYzpeh0R3joO4q2RNALY0d+lTE0oMNRYJCL
 OL9O3Xm4o3lW3wvmGPC9oepTMDdJPb9dMXUlLKoLCdSxIX9xtkWpSbEL+afoq/az2UkeYKHQ
 vYFbAUbKq/67b0LrowvqwvEuL+M=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60d0c2058491191eb3153170 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Jun 2021 16:44:53
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5B9BAC072A5; Mon, 21 Jun 2021 16:44:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A910BC072A5;
        Mon, 21 Jun 2021 16:44:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Jun 2021 10:44:51 -0600
From:   subashab@codeaurora.org
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: qualcomm: rmnet: fix two pointer math bugs
In-Reply-To: <20210621071831.GB1901@kadam>
References: <YM32lkJIJdSgpR87@mwanda>
 <027ae9e2ddc18f0ed30c5d9c7075c8b9@codeaurora.org>
 <20210621071158.GA1901@kadam> <20210621071831.GB1901@kadam>
Message-ID: <d03a69ce5a06f50230700b0e94e50193@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-21 01:18, Dan Carpenter wrote:
> On Mon, Jun 21, 2021 at 10:11:58AM +0300, Dan Carpenter wrote:
>> On Sat, Jun 19, 2021 at 01:12:09PM -0600, subashab@codeaurora.org 
>> wrote:
>> > On 2021-06-19 07:52, Dan Carpenter wrote:
>> >
>> > Hi Dan
>> >
>> > Thanks for fixing this. Could you cast the ip4h to char* instead of void*.
>> > Looks like gcc might raise issues if -Wpointer-arith is used.
>> >
>> > https://gcc.gnu.org/onlinedocs/gcc-4.5.0/gcc/Pointer-Arith.html#Pointer-Arith
>> 
>> The fix for that is to not enable -Wpointer-arith.  The warning is 
>> dumb.
> 
> Sorry, that was uncalled for and not correct.  The GCC warning would be
> useful if we were trying to write portable userspace code.  But in the
> kernel the kernel uses GCC extensions a lot.
> 
> The Clang compiler can also compile the kernel these days.  But it had
> to add support for a bunch of GCC extensions to make that work.  Really
> most of linux userspace is written with GCC in mind so Clang had to do
> this anyway.
> 
> So we will never enable -Wpointer-arith in the kernel because there is
> no need.
> 
> regards,
> dan carpenter

Thanks for the clarification.

Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
