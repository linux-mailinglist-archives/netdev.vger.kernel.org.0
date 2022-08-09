Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4745E58DEFC
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 20:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245503AbiHIS27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 14:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346700AbiHIS0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 14:26:36 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B2832ED8;
        Tue,  9 Aug 2022 11:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=DWkpz8+ByW7L5elLg9cMcWybBCw50VP7bckI/LSep/o=;
        t=1660068575; x=1661278175; b=Z/PpNygG5+d4mRAsefuVgd2vfzodFgFfYEZenommRdVVtjU
        VdXWo2Nf2rewOLeKRGMpYiM2LQ7t6kFbCssOBQy/gH4UBPuyB1ia3YmSy06LWY4n7P8mhotr1bgmf
        kYJeVxizJFVk9LBik1bbbzlO1XhmCftqXQhKcfoVPy2fdSJuoxMoATecjswM9FWJsfrWz62jkFu/s
        ULc8dGrxR7IIcCKbJVhDmlIfaPHL8Olr6rXHObVXb9ozV/NyoVa34lISe1f39LnDiLOfkyHXo7wYf
        swVgcoO03FDpPNCoZIoeWxy3q2TU+oijt8e0fb3xAfSp4C98Y4IOWnfuLheFkWTg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oLTfR-003HXy-0m;
        Tue, 09 Aug 2022 20:09:25 +0200
Message-ID: <54cd8c11428db4c419edf2267db00ca10da7a178.camel@sipsolutions.net>
Subject: Re: [PATCH v2 06/13] um: Improve panic notifiers consistency and
 ordering
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
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
Date:   Tue, 09 Aug 2022 20:09:23 +0200
In-Reply-To: <5bbc4296-4858-d01c-0c76-09d942377ddf@igalia.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
         <20220719195325.402745-7-gpiccoli@igalia.com>
         <5bbc4296-4858-d01c-0c76-09d942377ddf@igalia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-08-07 at 12:40 -0300, Guilherme G. Piccoli wrote:
> On 19/07/2022 16:53, Guilherme G. Piccoli wrote:
> > Currently the panic notifiers from user mode linux don't follow
> > the convention for most of the other notifiers present in the
> > kernel (indentation, priority setting, numeric return).
> > More important, the priorities could be improved, since it's a
> > special case (userspace), hence we could run the notifiers earlier;
> > user mode linux shouldn't care much with other panic notifiers but
> > the ordering among the mconsole and arch notifier is important,
> > given that the arch one effectively triggers a core dump.
> >=20
> > Fix that by running the mconsole notifier as the first panic
> > notifier, followed by the architecture one (that coredumps).
> >=20
> > Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Cc: Richard Weinberger <richard@nod.at>
> > Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> >=20
> > ---
> >=20
> > V2:
> > - Kept the notifier header to avoid implicit usage - thanks
> > Johannes for the suggestion!
> >=20
> >  arch/um/drivers/mconsole_kern.c | 7 +++----
> >  arch/um/kernel/um_arch.c        | 8 ++++----
> >  2 files changed, 7 insertions(+), 8 deletions(-)
> > [...]
>=20
> Hi Johannes, do you feel this one is good now, after your last review?
> Thanks in advance,
>=20

Yeah, no objections, my previous comment was just a minor almost style
issue anyway.

johannes
