Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834EF588B76
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiHCLpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiHCLpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:45:20 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85C226CB;
        Wed,  3 Aug 2022 04:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WwoYUtZ0SBTmBiplSSvGAX51ksFV+vMwKXq76cKmqZc=; b=PH12LYzaBJIsPsoorzy/LOBk5b
        DAOCX7TeriDwoMrFWce+imjisHDjOUS6VebMOD4MKkAKoi3/06ZTZxqGYd6tHLqJG3m3/g03IEiRd
        cdx+LXVeIoNdp1GykmgvwDmzYt510+KI7GCtl/kN9/yG0hBmRV8NjBv0ZfAn3QAnITSgZN/iM/Hr5
        z/jod+tSK7jWfa8nKT6A3NJCTnwESuTQ+WhsSeIYAw7tRMdrgDi36Fw1l2oarC72jun4+QOKQu6Sw
        epKtE8zVB6n4PBly3ussy+gVloREkv+rf3PlCC4EkARbXhmiWNUBcEPUaHX87BWF1Hq2DBStbKaTG
        CoADEnDA==;
Received: from [187.56.70.103] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oJCo2-00FTyF-Ow; Wed, 03 Aug 2022 13:44:54 +0200
Message-ID: <943cb74b-96b8-a8d4-881e-4ff56b35bd7f@igalia.com>
Date:   Wed, 3 Aug 2022 08:44:22 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 08/13] tracing: Improve panic/die notifiers
Content-Language: en-US
To:     Baoquan He <bhe@redhat.com>
Cc:     akpm@linux-foundation.org, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Sergei Shtylyov <sergei.shtylyov@gmail.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-9-gpiccoli@igalia.com>
 <YupBtiVkrmE7YQnr@MiWiFi-R3L-srv> <YupFeQ6AcfjUVpOW@MiWiFi-R3L-srv>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YupFeQ6AcfjUVpOW@MiWiFi-R3L-srv>
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

On 03/08/2022 06:52, Baoquan He wrote:
> [...]
>>
>> Although the switch-case code of original trace_die_handler() is werid, 
>> this unification is not much more comfortable. Just personal feeling
>> from code style, not strong opinion. Leave it to trace reviewers.
> 
> Please ignore this comment.
> 
> I use b4 to grab this patchset and applied, and started to check patch
> one by one. Then I realize it's all about cleanups which have got
> consensus in earlier rounds. Hope it can be merged when other people's
> concern is addressed, the whole series looks good to me, I have no
> strong concern to them.
> 

Thanks a lot for your reviews Baoquan, much appreciated =)
