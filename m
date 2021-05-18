Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F365388286
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 00:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352670AbhERWCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 18:02:16 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:12573 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbhERWCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 18:02:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621375257; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=OcOBQoPHRZwUqgAv23Az6sbpsFYYr9MWtPojMc2GtPo=;
 b=IIsmxq3E8fvTebWmAMcKiMuYMH/RBu45Dt8awhU5Om2q2QrCx1LuNJgvfXoOpibNLbgsmjHs
 N/YXT5hLoyLz/94R4c7KUDIthTFerV3hpw1FmfMqt4Bc59JR3u/+rUJ3hxbB5WTxtzkcF3Oy
 zN+MT4z4dLaObzb3R9183zPoRI8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60a4390d8dd30e785f852f6e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 May 2021 22:00:45
 GMT
Sender: jjohnson=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E7AFEC4338A; Tue, 18 May 2021 22:00:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jjohnson)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5FB86C433D3;
        Tue, 18 May 2021 22:00:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 18 May 2021 15:00:44 -0700
From:   Jeff Johnson <jjohnson@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jjohnson=codeaurora.org@codeaurora.org
Subject: Re: [PATCH v2] b43: don't save dentries for debugfs
In-Reply-To: <891f28e4c1f3c24ed1b257de83cbb3a0@codeaurora.org>
References: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
 <891f28e4c1f3c24ed1b257de83cbb3a0@codeaurora.org>
Message-ID: <f539277054c06e1719832b9e99cbf7f1@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-18 12:29, Jeff Johnson wrote:
> On 2021-05-18 09:33, Greg Kroah-Hartman wrote:
>> There is no need to keep around the dentry pointers for the debugfs
>> files as they will all be automatically removed when the subdir is
>> removed.  So save the space and logic involved in keeping them around 
>> by
>> just getting rid of them entirely.
>> 
>> By doing this change, we remove one of the last in-kernel user that 
>> was
>> storing the result of debugfs_create_bool(), so that api can be 
>> cleaned
>> up.
> 
> Question not about this specific change, but the general concept
> of keeping (or not keeping) dentry pointers. In the ath drivers,
> as well as in an out-of-tree driver for Android, we keep a
> debugfs dentry pointer to use as a param to relay_open().
> 
> Will we still be able to have a dentry pointer for this purpose?
> Or better, is there a recommended way to get a dentry pointer
> NOT associated with debugfs at all (which would be ideal for
> Android where debugfs is disabled).

Answering one of my questions: The dentry passed to relay_open() comes
from debugfs_create_dir() which is expected to return a dentry.

Would still like guidance on if there is a recommended way to get a
dentry not associated with debugfs.

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
