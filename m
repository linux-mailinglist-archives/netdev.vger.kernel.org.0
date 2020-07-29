Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF80232275
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgG2QTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2QTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:19:55 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A9DC061794;
        Wed, 29 Jul 2020 09:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zio9Bh9ICgviYTF6nfR7YhbLFeITHAHSu/75uYMJHEc=; b=FUxg1DnyxV3hLi0O8KdXdd8NnS
        M2SlIVh2JcKubTCIjn0LaQVNSFQh99FxEBP9gvNy5oG11Ii726NEatfFO7t3LJDKZU/fvrKZJTCvT
        nm2WmRWPiUaNqSj8/oofe29BTjEP6SogAlDXdgtZ16jep/CatpCyaFx6JsomSJl8hb4ismEQAwWIb
        CsNciGZmkk1phn/tMo/81GcfxwuyZIm75RA9tPSK70wxERl6dRBO3OPkjkamIdAdZQ6P4L28dHtXV
        iiBPR4sQ+EHpgWKRc/gehH35f+25sgQZlNUvj3IbtDKPOqtwG4EGWqbfWoKnzOjexVvwE0EIo9N1E
        Zk6HE6TA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0onu-0000ne-S8; Wed, 29 Jul 2020 16:19:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8681C300238;
        Wed, 29 Jul 2020 18:19:38 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 36F5322066CE6; Wed, 29 Jul 2020 18:19:38 +0200 (CEST)
Date:   Wed, 29 Jul 2020 18:19:38 +0200
From:   peterz@infradead.org
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, a.darwish@linutronix.de,
        tglx@linutronix.de, paulmck@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/5] seqlock: Fold seqcount_LOCKNAME_t definition
Message-ID: <20200729161938.GB2678@hirez.programming.kicks-ass.net>
References: <20200729135249.567415950@infradead.org>
 <20200729140142.347671778@infradead.org>
 <20200729145507.GW23808@casper.infradead.org>
 <20200729153341.GE2638@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729153341.GE2638@hirez.programming.kicks-ass.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 05:33:41PM +0200, peterz@infradead.org wrote:
> On Wed, Jul 29, 2020 at 03:55:07PM +0100, Matthew Wilcox wrote:
> > On Wed, Jul 29, 2020 at 03:52:51PM +0200, Peter Zijlstra wrote:
> > > Manual repetition is boring and error prone.
> > 
> > Yes, but generated functions are hard to grep for, and I'm pretty sure
> > that kernel-doc doesn't know how to expand macros into comments that it
> > can then extract documentation from.
> > 
> > I've been thinking about how to cure this (mostly in the context
> > of page-flags.h).  I don't particularly like the C preprocessor, but
> > m4 is worse and defining our own preprocessing language seems like a
> > terrible idea.
> > 
> > So I was thinking about moving the current contents of page-flags.h
> > to include/src/page-flags.h, making linux/page-flags.h depend on
> > src/page-flags.h and run '$(CPP) -C' to generate it.  I've been a little
> > busy recently and haven't had time to do more than muse about this, but
> > I think it might make sense for some of our more heavily macro-templated
> > header files.
> 
> Use ctags and add to scripts/tags.sh.

I'll make the below into a proper patch.

---

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 4e18ae5282a6..63b21881a873 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -211,6 +211,8 @@ regex_c=(
 	'/\<DEVICE_ATTR_\(RW\|RO\|WO\)(\([[:alnum:]_]\+\)/dev_attr_\2/'
 	'/\<DRIVER_ATTR_\(RW\|RO\|WO\)(\([[:alnum:]_]\+\)/driver_attr_\2/'
 	'/\<\(DEFINE\|DECLARE\)_STATIC_KEY_\(TRUE\|FALSE\)\(\|_RO\)(\([[:alnum:]_]\+\)/\4/'
+	'/^SEQCOUNT_LOCKTYPE(\([^,]*\),[[:space:]]*\([^,]*\),[^)]*)/seqcount_\2_t/'
+	'/^SEQCOUNT_LOCKTYPE(\([^,]*\),[[:space:]]*\([^,]*\),[^)]*)/seqcount_\2_init/'
 )
 regex_kconfig=(
 	'/^[[:blank:]]*\(menu\|\)config[[:blank:]]\+\([[:alnum:]_]\+\)/\2/'
