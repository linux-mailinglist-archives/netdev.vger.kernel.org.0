Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E198597989
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 00:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbiHQWK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 18:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242202AbiHQWKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 18:10:43 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A5E9F777;
        Wed, 17 Aug 2022 15:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S/5eXt6qxPOjrifOXrTAqDLvDo7S1RMnGh1w0oxBNRY=; b=LuyJGMy9jrbLt9nYppeNddgYWU
        D/BfJy4BBV8fYYFviGZU4XVL/QzXZPDbrkVGEDaAqgWdY+l4F6rDBMTYMIxabfCBvNerOk1eEaDUZ
        moCxBNac2IOqmQnsvQoD3HPI4Vw8tWBZg3rB1tJmJqzoYQYtr9dDZ4usgITC9y9+OZgvUlzUwb7yy
        8X3q/mtluoXia0VGjRR9uSR4jN0UYUHw4VGCgA+HCrJytPNQkdeyITxLZSVcXH0WuO39MGZ+LjC8O
        BHwntmREeJLccSE+kvCKiOqQaFNx1V1uuOKqDiUBOKSAJ67vcQCsz0udizEBpAhokvUi5fP0/9AVG
        G3ZOi+3w==;
Received: from [179.232.144.59] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oOREw-00Aycc-0j; Thu, 18 Aug 2022 00:10:18 +0200
Message-ID: <2f21b91c-4fb0-42f8-0820-a6036405cb29@igalia.com>
Date:   Wed, 17 Aug 2022 19:09:26 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 10/13] EDAC/altera: Skip the panic notifier if kdump is
 loaded
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     pmladek@suse.com, Dinh Nguyen <dinguyen@kernel.org>,
        Tony Luck <tony.luck@intel.com>, akpm@linux-foundation.org,
        bhe@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
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
 <c0250075-ec87-189f-52c5-e0520325a015@igalia.com> <Yv1hn2ayPoyKBAj8@zn.tnic>
 <1ee275b3-97e8-4c2b-be88-d50898d17e23@igalia.com> <Yv1lGpisQVFpUOGP@zn.tnic>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Yv1lGpisQVFpUOGP@zn.tnic>
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

On 17/08/2022 19:00, Borislav Petkov wrote:
> On Wed, Aug 17, 2022 at 06:56:11PM -0300, Guilherme G. Piccoli wrote:
>> But do you agree that currently, in case of a kdump, that information
>> *is not collected*, with our without my patch?
> 
> If for some reason that panic notifier does not get run before kdump,
> then that's a bug and that driver should not use a panic notifier to log
> hw errors in the first place.
> 

Indeed, the notifiers don't run before kdump by default, in a conscious
decision of the kdump maintainers.

You might be right, in the sense that maybe the edac error handler
shouldn't run as a panic notifier. Let's see if Tony / Dinh can chime in
on that discussion - we could move it to run in the kexec event as well,
so it'd always run before a kdump, but maybe the risk it offers during
panic time is not worth.

Again - a matter of a trade-off, a good compromise must be agreed by all
parties (kdump maintainers are usually extremely afraid of taking risks
to not break kdump).

Cheers!
