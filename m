Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E0B59790D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 23:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241815AbiHQVkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 17:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbiHQVk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 17:40:27 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C1BA50F8;
        Wed, 17 Aug 2022 14:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Yb08U+n4Pko/rjKY9WxgXaG1dGWDv/+eoZWbzofjewc=; b=fDyOq8wY0X9n5uFhdxcg912LeC
        Ep90b17TEg9NOJw8M4fQOGkQ69tZLrNvCWegUUhY2XdyIMvZOo1nV1jzYl/wAaNR0lG//tuUH0w2j
        9v/5JPIGLtz9b44F+iLguiwWSQrbk1lfy+M3CWn5eqgaxcvQTjUUSQVyOOPWXYQXaKm6jjiSWEQ3N
        Rn0QVv8hi9qDjXATTJF8XnpWzaRj95K/sAaus3u1NU7meLe9CbOwQaWGYZ4RXi4l39L4AWE1d3zf3
        Sdy7DBnpfz63PWTEwm9IyfiCiWn2SNfGqtPNoyTxl7yQnLbTB9EQN1POKvjX566hKfuB88X9XWU1z
        TBPSDBnQ==;
Received: from [179.232.144.59] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oOQlU-00AxTG-AY; Wed, 17 Aug 2022 23:39:52 +0200
Message-ID: <c0250075-ec87-189f-52c5-e0520325a015@igalia.com>
Date:   Wed, 17 Aug 2022 18:39:07 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 10/13] EDAC/altera: Skip the panic notifier if kdump is
 loaded
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, pmladek@suse.com,
        Dinh Nguyen <dinguyen@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, linux-edac@vger.kernel.org
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-11-gpiccoli@igalia.com> <Yv0mCY04heUXsGiC@zn.tnic>
 <46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com> <Yv1C0Y25u2IB7PCs@zn.tnic>
 <7f016d7f-a546-a45d-c65c-bc35269b4faa@igalia.com> <Yv1XVRmTXHLhOkER@zn.tnic>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Yv1XVRmTXHLhOkER@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/08/2022 18:02, Borislav Petkov wrote:
> On Wed, Aug 17, 2022 at 05:28:34PM -0300, Guilherme G. Piccoli wrote:
>> My understanding is the same as yours, i.e., this is not possible to
>> collect from vmcore, it requires register reading. But again: if you
>> kdump your machine today, you won't collect this information, patch
>> changed nothing in that regard.
> 
> Why won't you be able to collect it? You can certainly access dmesg in
> the vmcore and see those errors logged there.

Sorry for the confusion, let me try to be a bit more clear:

(1) if we kdump but we *didn't run* s10_edac_dberr_handler() before
kdump, the information is lost, since s10_edac_dberr_handler() performs
register readings. That information is not contained inside the vmcore.

(2) If for some reason the function s10_edac_dberr_handler() *was
executed prior to kdump*, of course the registers information would be
on dmesg, easy to collect in the vmcore.

Makes sense?


> 
>> The one thing it changes is that you'd skip the altera register dump if
>> kdump is set AND you managed to also set "crash_kexec_post_notifiers".
> 
> What your patch changes is, it prevents s10_edac_dberr_handler() from
> logging potentially important fatal hw errors when kdump is loaded.

Agreed. If kdump is loaded, we cannot log that information (modulo that
we do not collect it today by default on kdump as well).
The other part of story (the reason of the patch) is that we plan to
start running this panic notifier a bit earlier, being able to collect
such edac logs with pstore, for example.


> 
> If Dinh is fine with that, I'll take the patch. But it looks like a bad
> idea to me.
> 

I think we should seek what the majority of the folks consider the best,
in order to converge to some well-accepted solution. I'm completely OK
in dropping this one and rework with some other idea, or we can leave
this panic notifier as is, continue running that a bit later.

Tony / Petr (when back), suggestions are welcome =)
Cheers,


Guilherme
