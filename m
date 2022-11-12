Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27C3626C17
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 22:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbiKLVyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 16:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbiKLVyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 16:54:19 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5463C1FE;
        Sat, 12 Nov 2022 13:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=e69G3zk0gUdq0LcFy0TDryQ6kdaJ3PoKF9Rf2f2etP0=; b=qXouuoBOybLJuRlLwC/26K4W+j
        168l31Eg/PBKzgScJxE8deJ0PfWGEeNURIB3efMQfH+4/uOFuacUr+ectWhoMTpooMsL+6Yz/vP+B
        +oWQ9x3hOjDwBPHvZuvy+cQOENfrMoCpxYzeT0O8xTi4XKdVK+szjQTWlUlV6Q9zLj2WvGFeuKoq5
        DVdn1zNHfn62Dkj7AukFgTW/tAKwPzGeMIO6fG8c2OMLBM0fQZtM61Bd6kCMUvPGh55GtvgkXzQxJ
        xqiQFo49g4eovaqaBxGE+PXYlGdJi9moRQZEveVv5LUdWld3Um2dnmsi6p+Ej9mTLZtmfIBX0i1mo
        FFVuFKOQ==;
Received: from [179.232.147.2] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1otyRy-00HHuA-IA; Sat, 12 Nov 2022 22:54:06 +0100
Message-ID: <44bce9f3-365b-9592-83a9-8608b0cba20b@igalia.com>
Date:   Sat, 12 Nov 2022 18:53:57 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 10/11] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Content-Language: en-US
To:     Wei Liu <wei.liu@kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-11-gpiccoli@igalia.com>
 <BYAPR21MB16880251FC59B60542D2D996D75A9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <ae0a1017-7ec6-9615-7154-ea34c7bd2248@igalia.com>
 <SN6PR2101MB1693BC627B22432BA42EEBC2D7299@SN6PR2101MB1693.namprd21.prod.outlook.com>
 <efdaf27e-753e-e84f-dd7d-965101563679@igalia.com>
 <Y27Q9SSM6WkGFwf5@liuwe-devbox-debian-v2>
 <Y27XsybzcgCQ3fzD@liuwe-devbox-debian-v2>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Y27XsybzcgCQ3fzD@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2022 20:16, Wei Liu wrote:
> On Fri, Nov 11, 2022 at 10:47:17PM +0000, Wei Liu wrote:
>> On Thu, Nov 10, 2022 at 06:32:54PM -0300, Guilherme G. Piccoli wrote:
>>> [Trimming long CC list]
>>>
>>> Hi Wei / Michael, just out of curiosity, did this (and patch 9) ended-up
>>> being queued in hyperv-next?
>>>
>>
>> No. They are not queued.
>>
>> I didn't notice Michael's email and thought they would be picked up by
>> someone else while dealing with the whole series.
>>
>> I will pick them up later.
> 
> They are now queued to hyperv-next. Thanks.

Thanks a lot Wei and Michael, much appreciated =)
