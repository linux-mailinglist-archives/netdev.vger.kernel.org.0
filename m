Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DD6515040
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378795AbiD2QIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378476AbiD2QII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:08:08 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8519D84ED1;
        Fri, 29 Apr 2022 09:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QQI5zmi1djYWNz2i53I6KuQGatDa49BWqjEk2Pav1i4=; b=dYOwdCYz8mfW6uRaErWUoCqmdx
        5T0+vzZBt6UK85jUK/bYBffPO6pHVBukVXgw40Mng8+hfEFyxsYupbDv17vw0eY73RVtJNUJhZeIk
        wjL2oPNMg0UJQkop2tznLUBtpwTgs2tJTFrh96RXyi3iI9oJ7Xg0HjOO5wFLxxatzCt/a1kjKIm+q
        GG90XSMTUteF9uAfx+0HJjQF0T7y90PJaZRFs3aM6M51tA02d53awi4I7n5GpC6cVQif5RrGFpU1r
        QhiVEfyVqroi50IPYPzYRbjvCqabrqPiHclqX4UZkfFE4tLq7njetpvB7ea+qAjYTdFscbWw6lpa8
        5AxSRVRQ==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nkT6a-0001BR-MS; Fri, 29 Apr 2022 18:04:28 +0200
Message-ID: <7518924e-5bb4-e6e9-0e3e-3f5cb03bf946@igalia.com>
Date:   Fri, 29 Apr 2022 13:04:01 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 24/30] panic: Refactor the panic path
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        bhe@redhat.com, pmladek@suse.com, kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-25-gpiccoli@igalia.com>
 <4fe85e9c-4e96-e9d5-9fd8-f062bafcda4f@infradead.org>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <4fe85e9c-4e96-e9d5-9fd8-f062bafcda4f@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/04/2022 21:28, Randy Dunlap wrote:
> 
> 
> On 4/27/22 15:49, Guilherme G. Piccoli wrote:
>> +	crash_kexec_post_notifiers
>> +			This was DEPRECATED - users should always prefer the
> 
> 			This is DEPRECATED - users should always prefer the
> 
>> +			parameter "panic_notifiers_level" - check its entry
>> +			in this documentation for details on how it works.
>> +			Setting this parameter is exactly the same as setting
>> +			"panic_notifiers_level=4".
> 

Thanks Randy, for your suggestion - but I confess I couldn't understand
it properly. It's related to spaces/tabs, right? What you suggest me to
change in this formatting? Just by looking the email I can't parse.

Cheers,


Guilherme
