Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8AC1C9DCB
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 23:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgEGVrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 17:47:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:30012 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgEGVrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 17:47:00 -0400
IronPort-SDR: lZy1lW9BpjeakLNig3qvWwA18fGMQhtZVfMP07O7UGbbtjgYhWNCdb45cw1jmvINoSVmYsad0d
 qoq8vHXJ1c0A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 14:46:54 -0700
IronPort-SDR: XSzS7dTe6Wy7C+q//uzNDJRFqXYcvr54hWsflNNGVA2u2d/Yo2Vb3KSk0fM0DqTCqOyLDGNX46
 U16slWjhO8sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,365,1583222400"; 
   d="scan'208";a="462004281"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by fmsmga005.fm.intel.com with ESMTP; 07 May 2020 14:46:52 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 5A34B301C1B; Thu,  7 May 2020 14:46:52 -0700 (PDT)
Date:   Thu, 7 May 2020 14:46:52 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH 0/7] Share events between metrics
Message-ID: <20200507214652.GC3538@tassilo.jf.intel.com>
References: <20200507081436.49071-1-irogers@google.com>
 <20200507174835.GB3538@tassilo.jf.intel.com>
 <CAP-5=fUdoGJs+yViq3BOcJa7YyF53AD9RGQm8aRW72nMH0sKDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fUdoGJs+yViq3BOcJa7YyF53AD9RGQm8aRW72nMH0sKDA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > - without this change events within a metric may get scheduled
> >   together, after they may appear as part of a larger group and be
> >   multiplexed at different times, lowering accuracy - however, less
> >   multiplexing may compensate for this.
> 
> I agree the heuristic in this patch set is naive and would welcome to
> improve it from your toplev experience. I think this change is
> progress on TopDownL1 - would you agree?

TopdownL1 in non SMT mode should always fit. Inside a group
deduping always makes sense. 

The problem is SMT mode where it doesn't fit. toplev tries
to group each node and each level together.

> 
> I'm wondering if what is needed are flags to control behavior. For
> example, avoiding the use of groups altogether. For TopDownL1 I see.

Yes the current situation isn't great.

For Topdown your patch clearly is an improvement, I'm not sure
it's for everything though.

Probably the advanced heuristics are only useful for a few
formulas, most are very simple. So maybe it's ok. I guess
would need some testing over the existing formulas.


-Andi
