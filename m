Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FAE310962
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 11:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhBEKoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 05:44:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231555AbhBEKmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 05:42:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612521634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W6jBem4kZByMthisphHJewkWb84OmU3PnI0wLH3ysj4=;
        b=QEo88EKMBpmI6hC9sqEJ97tMjw88B38OOi6Zin4YIF2WXttRE60JvToLQBJZFPucBqN6G+
        nUBxFX5zV2eZwjnYfKf/lBk7+PZc4M1RiwA0pM1KW+qyEn+9KB5kiNZly+85Y0iP2kyAEq
        zYfugDWmToPvKlFU6hONPnNSCQ+zk6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-0pyJ_b4eMACpynE11xphbw-1; Fri, 05 Feb 2021 05:40:30 -0500
X-MC-Unique: 0pyJ_b4eMACpynE11xphbw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B68D1005501;
        Fri,  5 Feb 2021 10:40:28 +0000 (UTC)
Received: from krava (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8CA3D5C233;
        Fri,  5 Feb 2021 10:40:25 +0000 (UTC)
Date:   Fri, 5 Feb 2021 11:40:24 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/4] tools/resolve_btfids: Check objects before
 removing
Message-ID: <YB0gmBYTvgAvRPuk@krava>
References: <20210129134855.195810-1-jolsa@redhat.com>
 <20210204211825.588160-1-jolsa@kernel.org>
 <20210204211825.588160-3-jolsa@kernel.org>
 <CAEf4Bzb+Mf-Md1-T+K0ZPUUQKX_6efJLPrLDfKqijJFPdRc02A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb+Mf-Md1-T+K0ZPUUQKX_6efJLPrLDfKqijJFPdRc02A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 04:42:41PM -0800, Andrii Nakryiko wrote:
> On Thu, Feb 4, 2021 at 1:20 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > We want this clean to be called from tree's root clean
> > and that one is silent if there's nothing to clean.
> >
> > Adding check for all object to clean and display CLEAN
> > messages only if there are objects to remove.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/bpf/resolve_btfids/Makefile | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> > index b780b3a9fb07..3007cfabf5e6 100644
> > --- a/tools/bpf/resolve_btfids/Makefile
> > +++ b/tools/bpf/resolve_btfids/Makefile
> > @@ -64,13 +64,20 @@ $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
> >         $(call msg,LINK,$@)
> >         $(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
> >
> > +clean_objects := $(wildcard $(OUTPUT)/*.o                \
> > +                            $(OUTPUT)/.*.o.cmd           \
> > +                            $(OUTPUT)/.*.o.d             \
> > +                            $(OUTPUT)/libbpf             \
> > +                            $(OUTPUT)/libsubcmd          \
> > +                            $(OUTPUT)/resolve_btfids)
> > +
> > +clean:
> > +
> > +ifneq ($(clean_objects),)
> >  clean: fixdep-clean
> 
> this looks a bit weird, declaring clean twice. Wouldn't moving ifneq
> inside the clean work just fine?

it has the fixdep-clean dependency we don't want to run
if clean_objects is not defined.. I could move the empty
clean to the the else path

jirka


---
diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index 1d46a247ec95..be09ec4f03ff 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -64,13 +64,20 @@ $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
 	$(call msg,LINK,$@)
 	$(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
 
+clean_objects := $(wildcard $(OUTPUT)/*.o                \
+                            $(OUTPUT)/.*.o.cmd           \
+                            $(OUTPUT)/.*.o.d             \
+                            $(OUTPUT)/libbpf             \
+                            $(OUTPUT)/libsubcmd          \
+                            $(OUTPUT)/resolve_btfids)
+
+ifneq ($(clean_objects),)
 clean: fixdep-clean
 	$(call msg,CLEAN,$(BINARY))
-	$(Q)$(RM) -f $(BINARY); \
-	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
-	$(RM) -rf $(OUTPUT)/libbpf; \
-	$(RM) -rf $(OUTPUT)/libsubcmd; \
-	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
+	$(Q)$(RM) -rf $(clean_objects)
+else
+clean:
+endif
 
 tags:
 	$(call msg,GEN,,tags)

