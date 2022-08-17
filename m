Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B97759795C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 23:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242445AbiHQV5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 17:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241904AbiHQV5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 17:57:53 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8EFA99FC;
        Wed, 17 Aug 2022 14:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zLpU54EftC0DXI+05o1Pu5PUXbOrHcHGmY2OTrh25Kc=; b=YHZgiYG91jjHXY2Gnwy4Usgvy2
        TFABzMk/0AGVANObHyOolMepk3BROf0gG4ONkYmu5lZp9NvXd0fWhFHO5dUxdaZyv6psD8r7pwv+I
        H1TtPUWfxN7QDOKRLKZnixIIFuh/GtJC8X43HqOCmdYDVUqCbH8XXJTZtAFJKT/vTvRS6S0LbkElv
        Pn3GwIBtqKys5+zD172cQ1x5sJ1O1ohxPzvRJDGWTTDBrAL5VW+yPFSbWpw/SUEWJbdDP77xUoK5q
        okvr9W9bth1I+LaRtmS8YJGnoU7AVDmz0EtrLF6HBQ52f33glb2ccuf4zji6DyiMY87JKzftYbNYj
        w7sQBH+A==;
Received: from [179.232.144.59] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oOR2T-00Axx5-9X; Wed, 17 Aug 2022 23:57:25 +0200
Message-ID: <1ee275b3-97e8-4c2b-be88-d50898d17e23@igalia.com>
Date:   Wed, 17 Aug 2022 18:56:11 -0300
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
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Yv1hn2ayPoyKBAj8@zn.tnic>
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

On 17/08/2022 18:46, Borislav Petkov wrote:
> On Wed, Aug 17, 2022 at 06:39:07PM -0300, Guilherme G. Piccoli wrote:
>> Sorry for the confusion, let me try to be a bit more clear:
> 
> I think you're missing the point. Lemme try again:
> 
> You *absolutely* must log those errors because they're important. It
> doesn't matter if this is done in a panic notifier and you're changing
> that whole shebang or through some other magic.
> 
> If you do, then this driver needs to *still* *log* those fatal errors -
> regardless through a panic notifier or some novel contraption it wants
> to use.
> 
> So if you want to change the panic notifiers, you *must* make sure those
> errors still do get logged.
> 
> Better?
> 

Boris, I understand the importance of the logs, for sure!

But do you agree that currently, in case of a kdump, that information
*is not collected*, with our without my patch?
