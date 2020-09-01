Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4F3259F37
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgIAT3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:29:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47956 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728217AbgIAT27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:28:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598988538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bPHc6szmZlbrOtOqbNs0/cg8yPELZXDQhp70mcSqITI=;
        b=W7EQkesNsllP8KpcR7nfHgeGPYmO7Z/FZSDa0GUTkqvZVEjHBtRX7y/HMigUNBgO0ONm+p
        ORIeIIJ8/axciuOxOY8/31MsgEOKHYf+CP7XFhiXOnBoLQMqbk+u86ClXpVckMjzK+iRHV
        p3S4HDzRccEh9bhmaGfl1Yh6EZVtKnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-SIVuUiKCMuis8cS7XOwf7A-1; Tue, 01 Sep 2020 15:28:56 -0400
X-MC-Unique: SIVuUiKCMuis8cS7XOwf7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AE07802B66;
        Tue,  1 Sep 2020 19:28:55 +0000 (UTC)
Received: from krava (unknown [10.40.193.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11FA278B4F;
        Tue,  1 Sep 2020 19:28:49 +0000 (UTC)
Date:   Tue, 1 Sep 2020 21:28:48 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, jolsa@kernel.org
Subject: Re: [PATCH bpf] tools/bpf: build: make sure resolve_btfids cleans up
 after itself
Message-ID: <20200901192848.GB470123@krava>
References: <20200901144343.179552-1-toke@redhat.com>
 <20200901152048.GA470123@krava>
 <87sgc1iior.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sgc1iior.fsf@toke.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 06:08:04PM +0200, Toke H�iland-J�rgensen wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> > On Tue, Sep 01, 2020 at 04:43:43PM +0200, Toke Høiland-Jørgensen wrote:
> >> The new resolve_btfids tool did not clean up the feature detection folder
> >> on 'make clean', and also was not called properly from the clean rule in
> >> tools/make/ folder on its 'make clean'. This lead to stale objects being
> >> left around, which could cause feature detection to fail on subsequent
> >> builds.
> >> 
> >> Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >> ---
> >>  tools/bpf/Makefile                | 4 ++--
> >>  tools/bpf/resolve_btfids/Makefile | 1 +
> >>  2 files changed, 3 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
> >> index 0a6d09a3e91f..39bb322707b4 100644
> >> --- a/tools/bpf/Makefile
> >> +++ b/tools/bpf/Makefile
> >> @@ -38,7 +38,7 @@ FEATURE_TESTS = libbfd disassembler-four-args
> >>  FEATURE_DISPLAY = libbfd disassembler-four-args
> >>  
> >>  check_feat := 1
> >> -NON_CHECK_FEAT_TARGETS := clean bpftool_clean runqslower_clean
> >> +NON_CHECK_FEAT_TARGETS := clean bpftool_clean runqslower_clean resolve_btfids_clean
> >>  ifdef MAKECMDGOALS
> >>  ifeq ($(filter-out $(NON_CHECK_FEAT_TARGETS),$(MAKECMDGOALS)),)
> >>    check_feat := 0
> >> @@ -89,7 +89,7 @@ $(OUTPUT)bpf_exp.lex.c: $(OUTPUT)bpf_exp.yacc.c
> >>  $(OUTPUT)bpf_exp.yacc.o: $(OUTPUT)bpf_exp.yacc.c
> >>  $(OUTPUT)bpf_exp.lex.o: $(OUTPUT)bpf_exp.lex.c
> >>  
> >> -clean: bpftool_clean runqslower_clean
> >> +clean: bpftool_clean runqslower_clean resolve_btfids_clean
> >>  	$(call QUIET_CLEAN, bpf-progs)
> >>  	$(Q)$(RM) -r -- $(OUTPUT)*.o $(OUTPUT)bpf_jit_disasm $(OUTPUT)bpf_dbg \
> >>  	       $(OUTPUT)bpf_asm $(OUTPUT)bpf_exp.yacc.* $(OUTPUT)bpf_exp.lex.*
> >> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> >> index a88cd4426398..fe8eb537688b 100644
> >> --- a/tools/bpf/resolve_btfids/Makefile
> >> +++ b/tools/bpf/resolve_btfids/Makefile
> >> @@ -80,6 +80,7 @@ libbpf-clean:
> >>  clean: libsubcmd-clean libbpf-clean fixdep-clean
> >>  	$(call msg,CLEAN,$(BINARY))
> >>  	$(Q)$(RM) -f $(BINARY); \
> >> +	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
> >
> > I forgot this one.. thanks for fixing this
> 
> You're welcome - it was a bit frustrating to track down, but a simple
> fix once I figured out what was going on.
> 
> BTW, there's still an issue that a 'make clean' in the toplevel kernel
> dir will not clean up this feature dir, so if someone doesn't know to do
> 'cd tools/bpf && make clean' the main build may still break (I happened
> upon this because my main kernel build broke :/). Couldn't figure out
> how to convince make to fix that, so if you could take a look that would
> be great! :)

will check, thanks

jirka

