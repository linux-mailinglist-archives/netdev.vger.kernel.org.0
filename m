Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE0A633FD8
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiKVPHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbiKVPGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:06:51 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BEA2E5;
        Tue, 22 Nov 2022 07:06:49 -0800 (PST)
Received: from zn.tnic (p200300ea9733e79b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e79b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 14C1C1EC04E2;
        Tue, 22 Nov 2022 16:06:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669129608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5yMV1ZCNV3SL3KeDjf/6/5dfqDL8Ilh1prBf3IRM6ZU=;
        b=Wx1aIkqqyXz34T4ijeYsjo3X4fIguA60r9PaSI5S4+6cUmM14EhfTJMcwsE9KXP70C9FwM
        BhiTrP9Sz7nraeCt/sT3Gowww7prx3tsfmZUcBL5oLO9iCscr/hsHZ+emgo9QKxcUukwZ1
        6w0KNHT8mxHXL5v7BJ0K0Cm25jdAlpw=
Date:   Tue, 22 Nov 2022 16:06:42 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Tony Luck <tony.luck@intel.com>,
        Rabara Niravkumar L <niravkumar.l.rabara@intel.com>
Cc:     Dinh Nguyen <dinguyen@kernel.org>, linux-edac@vger.kernel.org,
        kexec@lists.infradead.org, pmladek@suse.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net
Subject: Re: [PATCH V3 08/11] EDAC/altera: Skip the panic notifier if kdump
 is loaded
Message-ID: <Y3zlghMzlc1kzVJx@zn.tnic>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-9-gpiccoli@igalia.com>
 <742d2a7e-efee-e212-178e-ba642ec94e2a@igalia.com>
 <eaba1a1a-31cd-932f-277c-267699d7be30@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eaba1a1a-31cd-932f-277c-267699d7be30@igalia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 10:33:12AM -0300, Guilherme G. Piccoli wrote:

Leaving in the whole thing for newly added people.

> On 18/09/2022 11:10, Guilherme G. Piccoli wrote:
> > On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
> >> The altera_edac panic notifier performs some data collection with
> >> regards errors detected; such code relies in the regmap layer to
> >> perform reads/writes, so the code is abstracted and there is some
> >> risk level to execute that, since the panic path runs in atomic
> >> context, with interrupts/preemption and secondary CPUs disabled.
> >>
> >> Users want the information collected in this panic notifier though,
> >> so in order to balance the risk/benefit, let's skip the altera panic
> >> notifier if kdump is loaded. While at it, remove a useless header
> >> and encompass a macro inside the sole ifdef block it is used.
> >>
> >> Cc: Borislav Petkov <bp@alien8.de>
> >> Cc: Petr Mladek <pmladek@suse.com>
> >> Cc: Tony Luck <tony.luck@intel.com>
> >> Acked-by: Dinh Nguyen <dinguyen@kernel.org>
> >> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> >>
> >> ---
> >>
> >> V3:
> >> - added the ack tag from Dinh - thanks!
> >> - had a good discussion with Boris about that in V2 [0],
> >> hopefully we can continue and reach a consensus in this V3.
> >> [0] https://lore.kernel.org/lkml/46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com/
> >>
> >> V2:
> >> - new patch, based on the discussion in [1].
> >> [1] https://lore.kernel.org/lkml/62a63fc2-346f-f375-043a-fa21385279df@igalia.com/
> >>
> >> [...]
> > 
> > Hi Dinh, Tony, Boris - sorry for the ping.
> > 
> > Appreciate reviews on this one - Dinh already ACKed the patch but Boris
> > raised some points in the past version [0], so any opinions or
> > discussions are welcome!
> 
> 
> Hi folks, monthly ping heheh
> Apologies for the re-pings, please let me know if there is anything
> required to move on this patch.

Looking at this again, I really don't like the sprinkling of

	if (kexec_crash_loaded())

in unrelated code. And I still think that the real fix here is to kill
this

	edac->panic_notifier

thing. And replace it with simply logging the error from the double bit
error interrupt handle. That DBERR IRQ thing altr_edac_a10_irq_handler().
Because this is what this panic notifier does - dump double-bit errors.

Now, if Dinh doesn't move, I guess we can ask Tony and/or Rabara (he has
sent a patch for this driver recently and Altera belongs to Intel now)
to find someone who can test such a change and we (you could give it a
try first :)) can do that change.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
