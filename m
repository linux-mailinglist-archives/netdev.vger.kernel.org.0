Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24CA4D3015
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiCINkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiCINkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:40:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3FF4C7A7
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 05:39:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6264EB81EE7
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6A8C340F3;
        Wed,  9 Mar 2022 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646833174;
        bh=G0CCOVbWmzhW0tHkuDqe6bf+H74Cfh1K8XIE00D7N9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B1gBmmr3/TmjIV3MftWgUpRHrNnN0PaCTQSs/5GFKlMhRUL4PmdNDgDOo4m/PaEJN
         9B9KG5M3rzZqyuaAs0HfyNXLv9woWpEytiE1syiyesG3YfotQ5dCD4rzuz9K+7MwxE
         GNnDjH3GAImeUeewWWzTkLwfo68vdzwNXZA2n/RvQQDnAORffB5Mp83TBumEGlyga1
         oOYGRx8ircfUVACBEmAajl11CkldTflDfx+sOgUIQX39RW5Y6H3gmclNQQzs7GAmBS
         gF6cJm4RrPnZE/0a9iOl494VcLEOtqespGwuSWyICrWStvrCPM2poUFsdW1hF6BttK
         I0nvfxVe3Hhmw==
Date:   Wed, 9 Mar 2022 15:39:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, markzhang@nvidia.com
Subject: Re: [PATCH iproute2 v2 1/2] lib/fs: fix memory leak in
 get_task_name()
Message-ID: <YiiuEu/2+f5Ur4Mu@unreal>
References: <cover.1646223467.git.aclaudi@redhat.com>
 <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
 <YiEPeU8z5Y+qd3+l@unreal>
 <YiZJzokKojVtEH4S@tc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiZJzokKojVtEH4S@tc2>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 07:07:10PM +0100, Andrea Claudi wrote:
> Hi Leon,
> Thanks for your review.
> 
> On Thu, Mar 03, 2022 at 08:56:57PM +0200, Leon Romanovsky wrote:
> > On Wed, Mar 02, 2022 at 01:28:47PM +0100, Andrea Claudi wrote:
> > > asprintf() allocates memory which is not freed on the error path of
> > > get_task_name(), thus potentially leading to memory leaks.
> > 
> > Not really, memory is released when the application exits, which is the
> > case here.
> >
> 
> That's certainly true. However this is still a leak in the time frame
> between get_task_name function call and the application exit. For
> example:
> 
> $ ip -d -b - << EOF
> tuntap show
> monitor
> EOF
> 
> calls get_task_name one or more time (once for each tun interface), and
> leaks memory indefinitely, if ip is not interrupted in some way.
> 
> Of course this is a corner case, and the leaks should anyway be small.
> However I cannot see this as a good reason not to fix it.
> 
> > > 
> > > Rework get_task_name() and avoid asprintf() usage and memory allocation,
> > > returning the task string to the caller using an additional char*
> > > parameter.
> > > 
> > > Fixes: 81bfd01a4c9e ("lib: move get_task_name() from rdma")
> > 
> > As I was told before, in netdev Fixes means that it is a bug that
> > affects users. This is not the case here.
> 
> Thanks for letting me know. I usually rely a lot on Fixes: as iproute2
> package maintainer, but I'll change my habits if this is the common
> understanding. Stephen, David, WDYT?
> 
> > 
> > > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > > ---
> > >  include/utils.h |  2 +-
> > >  ip/iptuntap.c   | 17 ++++++++++-------

Ahh, sorry, I missed this user.
So yes, Fixes is needed here.

Thanks

> > >  lib/fs.c        | 20 ++++++++++----------
> > >  rdma/res-cmid.c |  8 +++++---
> > >  rdma/res-cq.c   |  8 +++++---
> > >  rdma/res-ctx.c  |  7 ++++---
> > >  rdma/res-mr.c   |  7 ++++---
> > >  rdma/res-pd.c   |  8 +++++---
> > >  rdma/res-qp.c   |  7 ++++---
> > >  rdma/res-srq.c  |  7 ++++---
> > >  rdma/stat.c     |  5 ++++-
> > >  11 files changed, 56 insertions(+), 40 deletions(-)
> > 
> > Honestly, I don't see any need in both patches.
> > 
> > Thanks
> > 
> > > 
> > > diff --git a/include/utils.h b/include/utils.h
> > > index b6c468e9..81294488 100644
> > > --- a/include/utils.h
> > > +++ b/include/utils.h
> > > @@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
> > >  __u64 get_cgroup2_id(const char *path);
> > >  char *get_cgroup2_path(__u64 id, bool full);
> > >  int get_command_name(const char *pid, char *comm, size_t len);
> > > -char *get_task_name(pid_t pid);
> > > +int get_task_name(pid_t pid, char *name);
> > >  
> > >  int get_rtnl_link_stats_rta(struct rtnl_link_stats64 *stats64,
> > >  			    struct rtattr *tb[]);
> > > diff --git a/ip/iptuntap.c b/ip/iptuntap.c
> > > index 385d2bd8..2ae6b1a1 100644
> > > --- a/ip/iptuntap.c
> > > +++ b/ip/iptuntap.c
> > > @@ -321,14 +321,17 @@ static void show_processes(const char *name)
> > >  			} else if (err == 2 &&
> > >  				   !strcmp("iff", key) &&
> > >  				   !strcmp(name, value)) {
> > > -				char *pname = get_task_name(pid);
> > > -
> > > -				print_string(PRINT_ANY, "name",
> > > -					     "%s", pname ? : "<NULL>");
> > > +				SPRINT_BUF(pname);
> > > +
> > > +				if (get_task_name(pid, pname)) {
> > > +					print_string(PRINT_ANY, "name",
> > > +						     "%s", "<NULL>");
> > > +				} else {
> > > +					print_string(PRINT_ANY, "name",
> > > +						     "%s", pname);
> > > +				}
> > >  
> > > -				print_uint(PRINT_ANY, "pid",
> > > -					   "(%d)", pid);
> > > -				free(pname);
> > > +				print_uint(PRINT_ANY, "pid", "(%d)", pid);
> > >  			}
> > >  
> > >  			free(key);
> > > diff --git a/lib/fs.c b/lib/fs.c
> > > index f6f5f8a0..03df0f6a 100644
> > > --- a/lib/fs.c
> > > +++ b/lib/fs.c
> > > @@ -342,25 +342,25 @@ int get_command_name(const char *pid, char *comm, size_t len)
> > >  	return 0;
> > >  }
> > >  
> > > -char *get_task_name(pid_t pid)
> > > +int get_task_name(pid_t pid, char *name)
> > >  {
> > > -	char *comm;
> > > +	char path[PATH_MAX];
> > >  	FILE *f;
> > >  
> > >  	if (!pid)
> > > -		return NULL;
> > > +		return -1;
> > >  
> > > -	if (asprintf(&comm, "/proc/%d/comm", pid) < 0)
> > > -		return NULL;
> > > +	if (snprintf(path, sizeof(path), "/proc/%d/comm", pid) >= sizeof(path))
> > > +		return -1;
> > >  
> > > -	f = fopen(comm, "r");
> > > +	f = fopen(path, "r");
> > >  	if (!f)
> > > -		return NULL;
> > > +		return -1;
> > >  
> > > -	if (fscanf(f, "%ms\n", &comm) != 1)
> > > -		comm = NULL;
> > > +	if (fscanf(f, "%s\n", name) != 1)
> > > +		return -1;
> > >  
> > >  	fclose(f);
> > >  
> > > -	return comm;
> > > +	return 0;
> > >  }
> > > diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
> > > index bfaa47b5..3475349d 100644
> > > --- a/rdma/res-cmid.c
> > > +++ b/rdma/res-cmid.c
> > > @@ -159,8 +159,11 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
> > >  		goto out;
> > >  
> > >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > > +		SPRINT_BUF(b);
> > > +
> > >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > > -		comm = get_task_name(pid);
> > > +		if (!get_task_name(pid, b))
> > > +			comm = b;
> > >  	}
> > >  
> > >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > > @@ -199,8 +202,7 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
> > >  	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
> > >  	newline(rd);
> > >  
> > > -out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > > -		free(comm);
> > > +out:
> > >  	return MNL_CB_OK;
> > >  }
> > >  
> > > diff --git a/rdma/res-cq.c b/rdma/res-cq.c
> > > index 9e7c4f51..5ed455ea 100644
> > > --- a/rdma/res-cq.c
> > > +++ b/rdma/res-cq.c
> > > @@ -84,8 +84,11 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
> > >  		goto out;
> > >  
> > >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > > +		SPRINT_BUF(b);
> > > +
> > >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > > -		comm = get_task_name(pid);
> > > +		if (!get_task_name(pid, b))
> > > +			comm = b;
> > >  	}
> > >  
> > >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > > @@ -123,8 +126,7 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
> > >  	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
> > >  	newline(rd);
> > >  
> > > -out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > > -		free(comm);
> > > +out:
> > >  	return MNL_CB_OK;
> > >  }
> > >  
> > > diff --git a/rdma/res-ctx.c b/rdma/res-ctx.c
> > > index 30afe97a..fbd52dd5 100644
> > > --- a/rdma/res-ctx.c
> > > +++ b/rdma/res-ctx.c
> > > @@ -18,8 +18,11 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
> > >  		return MNL_CB_ERROR;
> > >  
> > >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > > +		SPRINT_BUF(b);
> > > +
> > >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > > -		comm = get_task_name(pid);
> > > +		if (!get_task_name(pid, b))
> > > +			comm = b;
> > >  	}
> > >  
> > >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > > @@ -48,8 +51,6 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
> > >  	newline(rd);
> > >  
> > >  out:
> > > -	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > > -		free(comm);
> > >  	return MNL_CB_OK;
> > >  }
> > >  
> > > diff --git a/rdma/res-mr.c b/rdma/res-mr.c
> > > index 1bf73f3a..6a59d9e4 100644
> > > --- a/rdma/res-mr.c
> > > +++ b/rdma/res-mr.c
> > > @@ -47,8 +47,11 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
> > >  		goto out;
> > >  
> > >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > > +		SPRINT_BUF(b);
> > > +
> > >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > > -		comm = get_task_name(pid);
> > > +		if (!get_task_name(pid, b))
> > > +			comm = b;
> > >  	}
> > >  
> > >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > > @@ -87,8 +90,6 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
> > >  	newline(rd);
> > >  
> > >  out:
> > > -	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > > -		free(comm);
> > >  	return MNL_CB_OK;
> > >  }
> > >  
> > > diff --git a/rdma/res-pd.c b/rdma/res-pd.c
> > > index df538010..a51bb634 100644
> > > --- a/rdma/res-pd.c
> > > +++ b/rdma/res-pd.c
> > > @@ -34,8 +34,11 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
> > >  			nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
> > >  
> > >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > > +		SPRINT_BUF(b);
> > > +
> > >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > > -		comm = get_task_name(pid);
> > > +		if (!get_task_name(pid, b))
> > > +			comm = b;
> > >  	}
> > >  
> > >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > > @@ -76,8 +79,7 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
> > >  	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
> > >  	newline(rd);
> > >  
> > > -out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > > -		free(comm);
> > > +out:
> > >  	return MNL_CB_OK;
> > >  }
> > >  
> > > diff --git a/rdma/res-qp.c b/rdma/res-qp.c
> > > index a38be399..575e0529 100644
> > > --- a/rdma/res-qp.c
> > > +++ b/rdma/res-qp.c
> > > @@ -146,8 +146,11 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
> > >  		goto out;
> > >  
> > >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > > +		SPRINT_BUF(b);
> > > +
> > >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > > -		comm = get_task_name(pid);
> > > +		if (!get_task_name(pid, b))
> > > +			comm = b;
> > >  	}
> > >  
> > >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > > @@ -179,8 +182,6 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
> > >  	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
> > >  	newline(rd);
> > >  out:
> > > -	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > > -		free(comm);
> > >  	return MNL_CB_OK;
> > >  }
> > >  
> > > diff --git a/rdma/res-srq.c b/rdma/res-srq.c
> > > index 3038c352..945109fc 100644
> > > --- a/rdma/res-srq.c
> > > +++ b/rdma/res-srq.c
> > > @@ -174,8 +174,11 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
> > >  		return MNL_CB_ERROR;
> > >  
> > >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > > +		SPRINT_BUF(b);
> > > +
> > >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > > -		comm = get_task_name(pid);
> > > +		if (!get_task_name(pid, b))
> > > +			comm = b;
> > >  	}
> > >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > >  				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
> > > @@ -228,8 +231,6 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
> > >  	newline(rd);
> > >  
> > >  out:
> > > -	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > > -		free(comm);
> > >  	return MNL_CB_OK;
> > >  }
> > >  
> > > diff --git a/rdma/stat.c b/rdma/stat.c
> > > index adfcd34a..a63b70a4 100644
> > > --- a/rdma/stat.c
> > > +++ b/rdma/stat.c
> > > @@ -248,8 +248,11 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
> > >  		return MNL_CB_OK;
> > >  
> > >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > > +		SPRINT_BUF(b);
> > > +
> > >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > > -		comm = get_task_name(pid);
> > > +		if (!get_task_name(pid, b))
> > > +			comm = b;
> > >  	}
> > >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > >  				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
> > > -- 
> > > 2.35.1
> > > 
> > 
> 
