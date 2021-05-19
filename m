Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1269B38922B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 17:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348493AbhESPGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 11:06:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22605 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhESPGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 11:06:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621436702; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=mbm/KQC14is0rErwVc62s6au2BQPmhOMig0Vh7EVlik=;
 b=CBL25lE1I2GzVwvZy///q17Rony7kmBqYD7JKp0DJJDf0nDgVC/nqc2pM+obqSaJPim6Wjp6
 Td+EZkqVDhpnPkIjbz1ja9nbgJZwZben3WORxSVOOrGSFfoZAUyIMMFQyDV5aKsszG1YHg2g
 tHMQUou9k+xCg+o+g9DiWZmRsT4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60a5291b2bff04e53b2d3be8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 19 May 2021 15:04:59
 GMT
Sender: jjohnson=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AB02CC4338A; Wed, 19 May 2021 15:04:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jjohnson)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1F866C433D3;
        Wed, 19 May 2021 15:04:59 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 19 May 2021 08:04:59 -0700
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
In-Reply-To: <YKScfFKhxtVqfRkt@kroah.com>
References: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
 <891f28e4c1f3c24ed1b257de83cbb3a0@codeaurora.org>
 <f539277054c06e1719832b9e99cbf7f1@codeaurora.org>
 <YKScfFKhxtVqfRkt@kroah.com>
Message-ID: <2eb3af43025436c0832c8f61fbf519ad@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-18 22:05, Greg Kroah-Hartman wrote:
> On Tue, May 18, 2021 at 03:00:44PM -0700, Jeff Johnson wrote:
>> On 2021-05-18 12:29, Jeff Johnson wrote:
>> Would still like guidance on if there is a recommended way to get a
>> dentry not associated with debugfs.
> 
> What do you exactly mean by "not associated with debugfs"?
> 
> And why are you passing a debugfs dentry to relay_open()?  That feels
> really wrong and fragile.

I don't know the history but the relay documentation tells us:
"If you want a directory structure to contain your relay files,
you should create it using the host filesystem’s directory
creation function, e.g. debugfs_create_dir()..."

So my guess is that the original implementation followed that
advice.  I see 5 clients of this functionality, and all 5 pass a
dentry returned from debugfs_create_dir():

drivers/gpu/drm/i915/gt/uc/intel_guc_log.c, line 384
drivers/net/wireless/ath/ath10k/spectral.c, line 534
drivers/net/wireless/ath/ath11k/spectral.c, line 902
drivers/net/wireless/ath/ath9k/common-spectral.c, line 1077
kernel/trace/blktrace.c, line 549

Jeff
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
