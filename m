Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFB658E008
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344326AbiHITS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345645AbiHITPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:15:20 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD0D27CCB;
        Tue,  9 Aug 2022 12:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=CE9ribd82Wfwyf4qIpdyVQVcb49dja2n3iMdmx/FOf8=;
        t=1660072120; x=1661281720; b=orlBgeBkwMRUzTnxtTciRUQbmcMW6MHm86LHtYuejp9uPbL
        DiwtSch/R7WEVGoOHWVTElvfA+lfFbVL07XaY2BSVKMbFSL+ItaT76YZZ4f+7Zhn8zHKHbRgxAKfc
        z6OWvbimmsAtePUSWgfzcT1SIchqCp7P/tILa/YzEJSbxOOpIZtPE+/0jLr6fxDcHbOdSHXg/5MEW
        eJNVwj9ttTPMxu54ZRTF11uqP2V6fa4E4DAnNZvXSg5Fu8vNi3qJSe6LdFS+z1Xm6/+OG2b9/2SFi
        xESy6kkAKWoZgAspEEFjsknjBYA5mA2h2LnbSf5UTuaIIvRbWtCMQygm47/3Hvwg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oLUac-003Ii0-22;
        Tue, 09 Aug 2022 21:08:30 +0200
Message-ID: <f366b3d50aa8b713b0a921e4507bae4779a7cd02.camel@sipsolutions.net>
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
Date:   Tue, 09 Aug 2022 21:08:28 +0200
In-Reply-To: <15188cf2-a510-2725-0c6e-3c4b264714c5@igalia.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
         <20220719195325.402745-7-gpiccoli@igalia.com>
         <5bbc4296-4858-d01c-0c76-09d942377ddf@igalia.com>
         <54cd8c11428db4c419edf2267db00ca10da7a178.camel@sipsolutions.net>
         <15188cf2-a510-2725-0c6e-3c4b264714c5@igalia.com>
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

On Tue, 2022-08-09 at 16:03 -0300, Guilherme G. Piccoli wrote:
> On 09/08/2022 15:09, Johannes Berg wrote:
> > [...]
> > > > V2:
> > > > - Kept the notifier header to avoid implicit usage - thanks
> > > > Johannes for the suggestion!
> > > >=20
> > > >  arch/um/drivers/mconsole_kern.c | 7 +++----
> > > >  arch/um/kernel/um_arch.c        | 8 ++++----
> > > >  2 files changed, 7 insertions(+), 8 deletions(-)
> > > > [...]
> > >=20
> > > Hi Johannes, do you feel this one is good now, after your last review=
?
> > > Thanks in advance,
> > >=20
> >=20
> > Yeah, no objections, my previous comment was just a minor almost style
> > issue anyway.
> >=20
> > johannes
>=20
> Perfect, thank you! Let me take the opportunity to ask you something I'm
> asking all the maintainers involved here - do you prefer taking the
> patch through your tree, or to get it landed with the whole series, at
> once, from some maintainer?
>=20
Hm. I don't think we'd really care, but so far I was thinking - since
it's a series - it'd go through some appropriate tree all together. If
you think it should be applied separately, let us know.

johannes
