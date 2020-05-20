Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2DA1DC1DE
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 00:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgETWLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 18:11:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27312 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728227AbgETWK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 18:10:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590012658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z1vIhurviEzP2nHp5BDqAvozGvnWo27CfFHlDxPi3JY=;
        b=G0Si5nfht9lYPgtZ1jJGuB9rJFLNl6FgBxhyMAc1AAFncp2pmPPKFuSv885xBBusWJk9rd
        pidI2JwM/cSJ6vMNA/LBKv2OaPMQFDY7noL2W2BOs14VcYz3FAbscLv+RHXgeNEpCWvyc9
        jb35xXilwiCGh7D8KGMGjiSiScPaRqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-aF9O-RrUPJOgoqyMTI5hDQ-1; Wed, 20 May 2020 18:10:54 -0400
X-MC-Unique: aF9O-RrUPJOgoqyMTI5hDQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E7BB800053;
        Wed, 20 May 2020 22:10:51 +0000 (UTC)
Received: from krava (unknown [10.40.193.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id E253160C05;
        Wed, 20 May 2020 22:10:45 +0000 (UTC)
Date:   Thu, 21 May 2020 00:10:44 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/7] perf metricgroup: Delay events string creation
Message-ID: <20200520221044.GQ157452@krava>
References: <20200520072814.128267-1-irogers@google.com>
 <20200520072814.128267-4-irogers@google.com>
 <20200520131412.GK157452@krava>
 <CAP-5=fXHRiahLZjQHcFiWW=zdXc7r+=WdMpzeCj-+xPcqB2khQ@mail.gmail.com>
 <20200520203409.GA26877@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520203409.GA26877@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 05:34:09PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, May 20, 2020 at 11:22:22AM -0700, Ian Rogers escreveu:
> > On Wed, May 20, 2020 at 6:14 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >                               break;
> > > >               }
> > > >       }
> > > > +     if (!ret) {
> > >
> > > could you please do instead:
> > >
> > >         if (ret)
> > >                 return ret;
> > >
> > > so the code below cuts down one indent level and you
> > > don't need to split up the lines
> > 
> > Done, broken out as a separate patch in v2:
> > https://lore.kernel.org/lkml/20200520182011.32236-3-irogers@google.com/
> 
> Jiri, was this the only issue with this patchkit? I've merged already
> the first one, that you acked.

I'm still wondering if we can keep groups after the merge,
it's in my other reply

jirka

