Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9C61DC1D9
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 00:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgETWJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 18:09:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29461 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728270AbgETWJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 18:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590012566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QEQwrZ9mN6qPW1ehx2nCrQEVDqhuS13VYGcR08yXSDY=;
        b=d+l1voCrKQxKJ6IszptXJA/JjFxjBPbTUKNYEt6Rzq7hQwrwuODcOzeYY3i/CzCiC+qLjF
        aKUd5Lv0XENan3mk9MbnISpXgudQ9Xd/5s2/bOxmSEvWt7TT0UrW3+sYEDjOdxVjElt/GB
        kvTiGztyFJvEeNFp9V9BOt9Do0KNd5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-Uc5SSMUHMO2lqXXIO8-rjw-1; Wed, 20 May 2020 18:09:22 -0400
X-MC-Unique: Uc5SSMUHMO2lqXXIO8-rjw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5048819057C6;
        Wed, 20 May 2020 22:09:19 +0000 (UTC)
Received: from krava (unknown [10.40.193.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id 760D2106F764;
        Wed, 20 May 2020 22:09:13 +0000 (UTC)
Date:   Thu, 21 May 2020 00:09:12 +0200
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
Message-ID: <20200520220912.GP157452@krava>
References: <20200520072814.128267-1-irogers@google.com>
 <20200520072814.128267-6-irogers@google.com>
 <20200520134847.GM157452@krava>
 <CAP-5=fVGf9i7hvQcht_8mnMMjzhQYdFqPzZFraE-iMR7Vcr1tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fVGf9i7hvQcht_8mnMMjzhQYdFqPzZFraE-iMR7Vcr1tw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 09:50:13AM -0700, Ian Rogers wrote:

SNIP

> > > +             }
> >
> > is the groupping still enabled when we merge groups? could part
> > of the metric (events) be now computed in different groups?
> 
> By default the change will take two metrics and allow the shorter
> metric (in terms of number of events) to share the events of the
> longer metric. If the events for the shorter metric aren't in the
> longer metric then the shorter metric must use its own group of
> events. If sharing has occurred then the bitmap is used to work out
> which events and groups are no longer in use.
> 
> With --metric-no-group then any event can be used for a metric as
> there is no grouping. This is why more events can be eliminated.
> 
> With --metric-no-merge then the logic to share events between
> different metrics is disabled and every metric is in a group. This
> allows the current behavior to be had.
> 
> There are some corner cases, such as metrics with constraints (that
> don't group) and duration_time that is never placed into a group.
> 
> Partial sharing, with one event in 1 weak event group and 1 in another
> is never performed. Using --metric-no-group allows something similar.
> Given multiplexing, I'd be concerned about accuracy problems if events
> between groups were shared - say for IPC, were you measuring
> instructions and cycles at the same moment?

hum, I think that's also concern if you are multiplexing 2 groups and one
metric getting events from both groups that were not meassured together 

it makes sense to me put all the merged events into single weak group
anything else will have the issue you described above, no?

and perhaps add command line option for merging that to make sure it's
what user actuly wants

thanks,
jirka


> 
> > I was wondering if we could merge all the hasmaps into single
> > one before the parse the evlist.. this way we won't need removing
> > later.. but I did not thought this through completely, so it
> > might not work at some point
> 
> This could be done in the --metric-no-group case reasonably easily
> like the current hashmap. For groups you'd want something like a set
> of sets of events, but then you'd only be able to share events if the
> sets were the same. A directed acyclic graph could capture the events
> and the sharing relationships, it may be possible to optimize cases
> like {A,B,C}, {A,B,D}, {A,B} so that the small group on the end shares
> events with both the {A,B,C} and {A,B,D} group. This may be good
> follow up work. We could also solve this in the json, for example
> create a "phony" group of {A,B,C,D} that all three metrics share from.
> You could also use --metric-no-group to achieve that sharing now.
> 
> Thanks,
> Ian
> 
> > jirka
> >
> 

