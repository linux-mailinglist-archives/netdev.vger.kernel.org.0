Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BCE1DCB75
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 12:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgEUKyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 06:54:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38999 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727864AbgEUKyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 06:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590058477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VUVyi/atpOj47t9gevngeyErf5if/P8pruyVYvTX6qg=;
        b=FbZRmicImcMEsjb7I45vZpTpt+/A1Yoh7/ItMvWfnW5JaCIBN4juNyOCJGSPDTbBO2c6XA
        igp4V3ydJNzcX7I8N/RlgEh7Ht6jNL3hyBijny9HJd4ksnbOV7szQ/dhvqA9v4/VuMkrEi
        tiqzH4C8IGSUnZGfeLp6aoqc8hxvC7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-cg7FSCEiOOKf7MitDdE6rg-1; Thu, 21 May 2020 06:54:33 -0400
X-MC-Unique: cg7FSCEiOOKf7MitDdE6rg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D62F219200C0;
        Thu, 21 May 2020 10:54:30 +0000 (UTC)
Received: from krava (unknown [10.40.195.217])
        by smtp.corp.redhat.com (Postfix) with SMTP id 674481059137;
        Thu, 21 May 2020 10:54:13 +0000 (UTC)
Date:   Thu, 21 May 2020 12:54:12 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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
Subject: Re: [PATCH 5/7] perf metricgroup: Remove duped metric group events
Message-ID: <20200521105412.GS157452@krava>
References: <20200520072814.128267-1-irogers@google.com>
 <20200520072814.128267-6-irogers@google.com>
 <20200520134847.GM157452@krava>
 <CAP-5=fVGf9i7hvQcht_8mnMMjzhQYdFqPzZFraE-iMR7Vcr1tw@mail.gmail.com>
 <20200520220912.GP157452@krava>
 <CAP-5=fU12vP45Sg3uRSuz-xoceTPTKw9-XZieKv1PaTnREMdrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fU12vP45Sg3uRSuz-xoceTPTKw9-XZieKv1PaTnREMdrw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 03:42:02PM -0700, Ian Rogers wrote:

SNIP

> >
> > hum, I think that's also concern if you are multiplexing 2 groups and one
> > metric getting events from both groups that were not meassured together
> >
> > it makes sense to me put all the merged events into single weak group
> > anything else will have the issue you described above, no?
> >
> > and perhaps add command line option for merging that to make sure it's
> > what user actuly wants
> 
> I'm not sure I'm following. With the patch set if we have 3 metrics
> with the event groups shown:
> M1: {A,B,C}:W
> M2: {A,B}:W
> M3: {A,B,D}:W
> 
> then what happens is we sort the metrics in to M1, M3, M2 then when we
> come to match the events:
> 
>  - by default: match events allowing sharing if all events come from
> the same group. So in the example M1 will first match with {A,B,C}
> then M3 will fail to match the group {A,B,C} but match {A,B,D}; M2
> will succeed with matching {A,B} from M1. The events/group for M2 can
> be removed as they are no longer used. This kind of sharing is
> opportunistic and respects existing groupings. While it may mean a
> metric is computed from a group that now multiplexes, that group will
> run for more of the time as there are fewer groups to multiplex with.
> In this example we've gone from 3 groups down to 2, 8 events down to
> 6. An improvement would be to realize that A,B is in both M1 and M3,
> so when we print the stat we could combine these values.

ok, I misunderstood and thought you would colaps also M3 to
have A,B computed via M1 group and with separate D ...

thanks a lot for the explanation, it might be great to have it
in the comments/changelog or even man page

> 
>  - with --metric-no-merge: no events are shared by metrics M1, M2 and
> M3 have their events and computation as things currently are. There
> are 3 groups and 8 events.
> 
>  - with --metric-no-group: all groups are removed and so the evlist
> has A,B,C,A,B,A,B,D in it. The matching will now match M1 to A,B,C at
> the beginning of the list, M2 to the first A,B and M3 to the same A,B
> and D at the end of the list. We've got no groups and the events have
> gone from 8 down to 4.
> 
> It is difficult to reason about which grouping is most accurate. If we
> have 4 counters (no NMI watchdog) then this example will fit with no
> multiplexing. The default above should achieve less multiplexing, in
> the same way merging PMU events currently does - this patch is trying
> to mirror the --no-merge functionality to a degree. Considering
> TopDownL1 then we go from metrics that never sum to 100%, to metrics
> that do in either the default or --metric-no-group cases.
> 
> I'm not sure what user option is missing with these combinations? The
> default is trying to strike a compromise and I think user interaction
> is unnecessary, just as --no-merge doesn't cause interaction. If the
> existing behavior is wanted using --metric-no-merge will give that.
> The new default and --metric-no-group are hopefully going to reduce
> the number of groups and events. I'm somewhat agnostic as to what the
> flag functionality should be as what I'm working with needs either the
> default or --metric-no-group, I can use whatever flag is agreed upon.

no other option is needed then

thanks,
jirka

