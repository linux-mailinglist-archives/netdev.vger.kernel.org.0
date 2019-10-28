Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8ADE7940
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfJ1Tcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:32:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47327 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730038AbfJ1Tcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572291157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YIoVA/fFJrGQ97aiYNbpnayE4EinXi0s2gJ+zmT21Gs=;
        b=aP/LBvmibzKJnm1KM3Akz5MV9mUjhsJFtrVYKcrVPeKYrzZCMpZCrjCmbhFBQQCHuFY/Ds
        wGgj0RLiiU7JBiFkT0+Dhj/1KgIYIYJjD5Q0xf1qZ3uJp4JJYQCtot9EEueGJG4b6flDWX
        nHRJOuZftNPa7a8XyS8Rs9EhAMJUjpw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-NOa2wEhTPFy97C6tgrEGpQ-1; Mon, 28 Oct 2019 15:32:34 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3EB7107AD28;
        Mon, 28 Oct 2019 19:32:30 +0000 (UTC)
Received: from krava (ovpn-204-45.brq.redhat.com [10.40.204.45])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7AD9E46;
        Mon, 28 Oct 2019 19:32:25 +0000 (UTC)
Date:   Mon, 28 Oct 2019 20:32:24 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 1/9] perf tools: add parse events append error
Message-ID: <20191028193224.GB28772@krava>
References: <20191023005337.196160-1-irogers@google.com>
 <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-2-irogers@google.com>
 <20191025075820.GE31679@krava>
 <CAP-5=fV3yruuFagTz4=8b9t6Y1tzZpFU=VhVcOmrSMiV+h2fQA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAP-5=fV3yruuFagTz4=8b9t6Y1tzZpFU=VhVcOmrSMiV+h2fQA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: NOa2wEhTPFy97C6tgrEGpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 08:14:36AM -0700, Ian Rogers wrote:
> On Fri, Oct 25, 2019 at 12:58 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Oct 24, 2019 at 12:01:54PM -0700, Ian Rogers wrote:
> > > Parse event error handling may overwrite one error string with anothe=
r
> > > creating memory leaks and masking errors. Introduce a helper routine
> > > that appends error messages and avoids the memory leak.
> > >
> > > A reproduction of this problem can be seen with:
> > >   perf stat -e c/c/
> > > After this change this produces:
> > > event syntax error: 'c/c/'
> > >                        \___ unknown term (previous error: unknown ter=
m (previous error: unknown term (previous error: unknown term (previous err=
or: unknown term (previous error: unknown term (previous error: unknown ter=
m (previous error: unknown term (previous error: unknown term (previous err=
or: unknown term (previous error: unknown term (previous error: unknown ter=
m (previous error: unknown term (previous error: unknown term (previous err=
or: unknown term (previous error: unknown term (previous error: unknown ter=
m (previous error: unknown term (previous error: unknown term (previous err=
or: unknown term (previous error: unknown term (previous error: Cannot find=
 PMU `c'. Missing kernel support?)(help: valid terms: event,filter_rem,filt=
er_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter_o=
pc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,config=
,config1,config2,name,period,percore))(help: valid terms: event,filter_rem,=
filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filt=
er_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,co=
nfig,config1,config2,name,period,percore))(help: valid terms: event,filter_=
rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,=
filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_n=
m,config,config1,config2,name,period,percore))(help: valid terms: event,fil=
ter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,um=
ask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filt=
er_nm,config,config1,config2,name,period,percore))(help: valid terms: event=
,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,in=
v,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,=
filter_nm,config,config1,config2,name,period,percore))(help: valid terms: e=
vent,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_n=
c,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_st=
ate,filter_nm,config,config1,config2,name,period,percore))(help: valid term=
s: event,pc,in_tx,edge,any,offcore_rsp,in_tx_cp,ldlat,inv,umask,frontend,cm=
ask,config,config1,config2,name,period,percore))(help: valid terms: event,f=
ilter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,=
umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,fi=
lter_nm,config,config1,config2,name,period,percore))(help: valid terms: eve=
nt,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,=
inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_stat=
e,filter_nm,config,config1,config2,name,period,percore))(help: valid terms:=
 event,config,config1,config2,name,period,percore))(help: valid terms: even=
t,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,i=
nv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state=
,filter_nm,config,config1,config2,name,period,percore))(help: valid terms: =
event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_=
nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_s=
tate,filter_nm,config,config1,config2,name,period,percore))(help: valid ter=
ms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,fil=
ter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filt=
er_state,filter_nm,config,config1,config2,name,period,percore))(help: valid=
 terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc=
,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,=
filter_state,filter_nm,config,config1,config2,name,period,percore))(help: v=
alid terms: event,config,config1,config2,name,period,percore))(help: valid =
terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,=
filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,f=
ilter_state,filter_nm,config,config1,config2,name,period,percore))(help: va=
lid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_=
loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_=
nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(help=
: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,fil=
ter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_=
not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(=
help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid=
,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,fil=
ter_not_nm,filter_state,filter_nm,config,config1,config2,name,period,percor=
e))(help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter=
_tid,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op=
,filter_not_nm,filter_state,filter_nm,config,config1,config2,name,period,pe=
rcore))
> >
> >
> > hum... I'd argue that the previous state was better:
> >
> > [jolsa@krava perf]$ ./perf stat -e c/c/
> > event syntax error: 'c/c/'
> >                        \___ unknown term
> >
> >
> > jirka
>=20
> I am agnostic. We can either have the previous state or the new state,
> I'm keen to resolve the memory leak. Another alternative is to warn
> that multiple errors have occurred before dropping or printing the
> previous error. As the code is shared in memory places the approach
> taken here was to try to not conceal anything that could potentially
> be useful. Given this, is the preference to keep the status quo
> without any warning?

if the other alternative is string above, yes.. but perhaps
keeping just the first error would be the best way?

here it seems to be the:
   "Cannot find PMU `c'. Missing kernel support?)(help: valid..."

jirka

