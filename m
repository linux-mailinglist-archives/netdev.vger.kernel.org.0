Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07457F17EB
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbfKFOHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:07:06 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34882 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727237AbfKFOHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:07:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573049225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQUJhTS5ZQPa+H7gyw31F1k30QCMAlnrwuTj8cTiw28=;
        b=gLaTYVUn6kD9WkF0dMmEDGdz2CosD2e3eoxCQT5zEMq07ip7LyRlWM20eaBadufyP328N2
        W+CZZttraCUlln0w3VsMbZ2ohh1e5oIt4TXccsdeMuKQXdPAFxEhMOfdouXMz2Nkya5ZJd
        wH1/fHMAhFu6KxbOZy2rOzypHwj4R+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-HIuIU22MPBuvr-Q7-vH7Vw-1; Wed, 06 Nov 2019 09:06:59 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 257561005500;
        Wed,  6 Nov 2019 14:06:57 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with SMTP id 513F25DA76;
        Wed,  6 Nov 2019 14:06:51 +0000 (UTC)
Date:   Wed, 6 Nov 2019 15:06:50 +0100
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v5 01/10] perf tools: add parse events handle error
Message-ID: <20191106140650.GE30214@krava>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-2-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191030223448.12930-2-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: HIuIU22MPBuvr-Q7-vH7Vw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:34:39PM -0700, Ian Rogers wrote:
> Parse event error handling may overwrite one error string with another
> creating memory leaks. Introduce a helper routine that warns about
> multiple error messages as well as avoiding the memory leak.
>=20
> A reproduction of this problem can be seen with:
>   perf stat -e c/c/
> After this change this produces:
> WARNING: multiple event parsing errors
> event syntax error: 'c/c/'
>                        \___ unknown term
>=20
> valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,fil=
ter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_=
not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore
> Run 'perf list' for a list of valid events
>=20
>  Usage: perf stat [<options>] [<command>]
>=20
>     -e, --event <event>   event selector. use 'perf list' to list availab=
le events
>=20
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

