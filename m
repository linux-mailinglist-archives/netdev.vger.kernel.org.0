Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E5558E06F
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344319AbiHITrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346242AbiHITqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:46:38 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A83EE5;
        Tue,  9 Aug 2022 12:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Wv8APvVZyD89f/M97jkVbhyYW+XM35Z6FtrwLTeI0Ng=; b=RCcB/LrzBH3G0hd3BiUTq8iPzI
        bGQkmpy/yNY1FfAOLo/zKygA2n+h0u0OtVZGYVbjBo+bwZ1z3xDOWn4dhHmfbrEnWp4dbjsaGSKn1
        zTSJmxvK3ubwpNBG0FMa3HgAmDuvL/slxbuZckrJpQwOe7M12cgFM1XCb0J2pm/XgLelpZ4higMt3
        rxOXk9brZJGlPhQhraSpYMvbt4vN+QHmV+EUpBRhzdFPKXq/rg556ge86qqn3DMn70r+10V+8NU4H
        jM4uIs9XAqItbSY3VrqxSXYsuN6wNkSDne3kSVbTuPFth3YMErFZHpVCnwcJREvTYoLkrn2tNn5Hz
        2tbp7dTw==;
Received: from [187.56.70.103] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oLVB3-003nDC-Fl; Tue, 09 Aug 2022 21:46:09 +0200
Message-ID: <ea98a267-6159-7ab8-703e-1ef314e1e0d8@igalia.com>
Date:   Tue, 9 Aug 2022 16:45:38 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 06/13] um: Improve panic notifiers consistency and
 ordering
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        kexec@lists.infradead.org, linux-um@lists.infradead.org
Cc:     pmladek@suse.com, bhe@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
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
        will@kernel.org, Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-7-gpiccoli@igalia.com>
 <5bbc4296-4858-d01c-0c76-09d942377ddf@igalia.com>
 <54cd8c11428db4c419edf2267db00ca10da7a178.camel@sipsolutions.net>
 <15188cf2-a510-2725-0c6e-3c4b264714c5@igalia.com>
 <f366b3d50aa8b713b0a921e4507bae4779a7cd02.camel@sipsolutions.net>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <f366b3d50aa8b713b0a921e4507bae4779a7cd02.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2022 16:08, Johannes Berg wrote:
> [...]
>> Perfect, thank you! Let me take the opportunity to ask you something I'm
>> asking all the maintainers involved here - do you prefer taking the
>> patch through your tree, or to get it landed with the whole series, at
>> once, from some maintainer?
>>
> Hm. I don't think we'd really care, but so far I was thinking - since
> it's a series - it'd go through some appropriate tree all together. If
> you think it should be applied separately, let us know.
> 
> johannes

For me, it would be easier if maintainers pick the patches into their
-next/-fixes trees when they think the patch is good enough, but some
maintainers complained that prefer the whole series approach (and some
others are already taking the patches into their trees).

Given that, in case you do have a linux-um tree and feel OK with that, I
appreciate if you merge it, so I can remove the patch in next iteration.
If you prefer the whole series approach, OK as well, your call =)

Thanks,


Guilherme
