Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2952B1DB4B6
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgETNOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:14:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38577 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726576AbgETNOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589980453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZyJW0Q/g6i/6kSuHAySWrYItdVGQP1hyPNjvu+H1F/s=;
        b=UHpkr+PuD9Ws/VBro2OtuFTeJSTqyNZ/Fom+zpKgPVGhQiu5lz6ayM80rjYhKoIXbWEOCR
        nnco6hXtNAPGxrAwKMNhVpoCtAUdCWEidISIFTEdOXJDTKnSjv1GUOesP7ytEbxcY3lic+
        5rq3Vj/blwJUUuXPH0BRLvZhkTMXJfY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-GH-TA4nPM1-e3un7UbhALA-1; Wed, 20 May 2020 09:14:09 -0400
X-MC-Unique: GH-TA4nPM1-e3un7UbhALA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5D3F8015CE;
        Wed, 20 May 2020 13:14:05 +0000 (UTC)
Received: from krava (unknown [10.40.193.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id C49EF600E3;
        Wed, 20 May 2020 13:14:00 +0000 (UTC)
Date:   Wed, 20 May 2020 15:13:59 +0200
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/7] Share events between metrics
Message-ID: <20200520131359.GJ157452@krava>
References: <20200520072814.128267-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520072814.128267-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:28:07AM -0700, Ian Rogers wrote:
> Metric groups contain metrics. Metrics create groups of events to
> ideally be scheduled together. Often metrics refer to the same events,
> for example, a cache hit and cache miss rate. Using separate event
> groups means these metrics are multiplexed at different times and the
> counts don't sum to 100%. More multiplexing also decreases the
> accuracy of the measurement.
> 
> This change orders metrics from groups or the command line, so that
> the ones with the most events are set up first. Later metrics see if
> groups already provide their events, and reuse them if
> possible. Unnecessary events and groups are eliminated.
> 
> The option --metric-no-group is added so that metrics aren't placed in
> groups. This affects multiplexing and may increase sharing.
> 
> The option --metric-mo-merge is added and with this option the
> existing grouping behavior is preserved.
> 
> Using skylakex metrics I ran the following shell code to count the
> number of events for each metric group (this ignores metric groups
> with a single metric, and one of the duplicated TopdownL1 and
> TopDownL1 groups):

hi,
I'm getting parser error with:

[jolsa@krava perf]$ sudo ./perf stat -M IPC,CPI -a -I 1000
event syntax error: '..ed.thread}:W{inst_retired.any,cpu_clk_unhalted.thread}:W,{inst_retired.any,cycles}:W'
                                  \___ parser error


jirka

