Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9903F606B53
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJTWiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJTWiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:38:19 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909621C5A73;
        Thu, 20 Oct 2022 15:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=d1uOCKlJdY/yPHuKmQEyZZ8R2iRmAZNykCdT1OMy84s=; b=hJjRN+9eKGnr+4+zGPmG0xStZx
        DmKNQolz1r3Thm99kcT1Fcvq4mgQkSJybJHt8PGV+yx11j0adMDpX7hfA+sKiBWFu2OT7ZriVR1ok
        75kxOAypPBWZMPpz6uhcBMSY5v1VVEDF8C4NtQDNIh4VHhT1oHNC1yOARuc616zpMcb3XprYd8rzu
        nn5Qb5sU7mv5UN9uyWAiyT/xQN1hlt444TE2NmGkdoOEW2RCmqIc0fxs+l0cRPzvL7lTIK7qT7fZD
        Eora7w2UPe0L4BShALsNWJwPbcaNYASxhknHkqEkkCQ9TksN+FzK2opjCm7aQ22UUu9w7e35d31f3
        7O5hk7fA==;
Received: from [179.113.159.85] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oleAu-002Whx-TJ; Fri, 21 Oct 2022 00:38:06 +0200
Message-ID: <ec384313-e19b-379b-4dd5-23ec8cefc9b0@igalia.com>
Date:   Thu, 20 Oct 2022 19:37:48 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 06/11] tracing: Improve panic/die notifiers
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
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
        paulmck@kernel.org, peterz@infradead.org, senozhatsky@chromium.org,
        stern@rowland.harvard.edu, tglx@linutronix.de, vgoyal@redhat.com,
        vkuznets@redhat.com, will@kernel.org, xuqiang36@huawei.com,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-7-gpiccoli@igalia.com>
 <20221020172908.25c6e3a5@gandalf.local.home>
 <6e2396d1-d0b2-0d1e-d146-f3ad7f2b39f8@igalia.com>
 <20221020182249.691bb82a@gandalf.local.home>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20221020182249.691bb82a@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/10/2022 19:22, Steven Rostedt wrote:
> On Thu, 20 Oct 2022 18:53:43 -0300
> "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:
> 
>> Could you pick it in your tree? Or do you prefer that I re-send as a
>> solo patch, with your ACK?
> 
> I wasn't sure there were any dependencies on this. If not, I can take it.
> 
> -- Steve

Thank you! No dependency at all...I just piled a bunch of independent
panic notifiers fixes, so they can be reviewed by the maintainers and
picked individually.

Some maintainers though prefer them to be sent individually, as solo
patches...hence my question.

Cheers,


Guilherme
