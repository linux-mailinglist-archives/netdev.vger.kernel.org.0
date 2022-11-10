Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9EC624DB3
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiKJWml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiKJWme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:42:34 -0500
X-Greylist: delayed 1798 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Nov 2022 14:42:33 PST
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C0249B4E
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mfrkgBO2aFdDwc60CdgvE9S9ISnTxlrxLXKGcZohYPI=; b=C7Ilm2+a2l4r1r95htrUrU37I8
        lMIJfaotnuBNkxcfo4/L/pbfE1f4ut7sTpCE8twAbc6ox3p9lD5UCf6EbqODhn+RXuk0rOjq/CPD1
        gcMYRMHiKRXaf1saqM/QWQ9BVE544pdXfFSX63kSa1R4SYF+2I0Zfm1eeXHATzRLw8samu/6/7mLA
        jPSHUUIfOHyeN4n9ZnjnqbDFAbHkbgGkhIlll/Uf4ZbIvtL1dmYb/eCcTtoK3nFDp8YQPkTz68fRV
        pUOXd0Ajaw6fsDOP8nAyPc1AMybspZ1ZsThb5k67Q5izC8rPwc2Z6S8O8dFA4iM+dNUe2WOkBIrKk
        mgZOxJVg==;
Received: from [177.102.6.147] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1otFAU-00FmBO-VZ; Thu, 10 Nov 2022 22:33:03 +0100
Message-ID: <efdaf27e-753e-e84f-dd7d-965101563679@igalia.com>
Date:   Thu, 10 Nov 2022 18:32:54 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 10/11] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Cc:     "bhe@redhat.com" <bhe@redhat.com>,
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
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <SN6PR2101MB1693BC627B22432BA42EEBC2D7299@SN6PR2101MB1693.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Trimming long CC list]

Hi Wei / Michael, just out of curiosity, did this (and patch 9) ended-up
being queued in hyperv-next?

Thanks in advance,


Guilherme

On 17/10/2022 12:26, Michael Kelley (LINUX) wrote:
> From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Tuesday, October 4, 2022 10:20 AM
>>
>> On 04/10/2022 13:24, Michael Kelley (LINUX) wrote:
>>> [...]
>>>
>>> Tested this patch in combination with Patch 9 in this series.  Verified
>>> that both the panic and die paths work correctly with notification to
>>> Hyper-V via hyperv_report_panic() or via hv_kmsg_dump().  Hyper-V
>>> framebuffer is updated as expected, though I did not reproduce
>>> a case where the ring buffer lock is held.  vmbus_initiate_unload() runs
>>> as expected.
>>>
>>> Tested-by: Michael Kelley <mikelley@microsoft.com>
>>>
>>
>> Thanks a lot for the tests/review Michael!
>>
>> Do you think Hyper-V folks could add both patches in hv tree? If you
>> prefer, I can re-send them individually.
>>
> 
> Wei Liu:  Could you pick up Patch 9 and Patch 10 from this series in the
> hyperv-next tree?
> 
> Michael
> 
