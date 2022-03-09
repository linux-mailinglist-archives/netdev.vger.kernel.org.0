Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9B74D27C3
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiCIB0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiCIB0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:26:49 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85B938781;
        Tue,  8 Mar 2022 17:25:36 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:09:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1646788170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CoYbkvqX7SVrmA+5dEmgUrCctf3A7Hfs0hhsJiwcdT0=;
        b=gOilLZsrg582SBBi9rjggwn2nkeTUMgAaVPXGahDrfK6nr5srF19MFNZjwZPFovUzfUX+w
        5OnnujQ7pg5YPmWDr5O/YCzzJgjcrpky6oPcxiqYOAAwR44pidDSr41LKBMp1jqhHe3GdY
        7+i+ROgz0Q2xdSaQbnyS9Ff7/xi7v24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        guro@fb.com, linux-mm@kvack.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] bpf, mm: recharge bpf memory from offline memcg
Message-ID: <Yif+QZbCALQcYrFZ@carbon.dhcp.thefacebook.com>
References: <20220308131056.6732-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308131056.6732-1-laoar.shao@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 01:10:47PM +0000, Yafang Shao wrote:
> When we use memcg to limit the containers which load bpf progs and maps,
> we find there is an issue that the lifecycle of container and bpf are not
> always the same, because we may pin the maps and progs while update the
> container only. So once the container which has alreay pinned progs and
> maps is restarted, the pinned progs and maps are no longer charged to it
> any more. In other words, this kind of container can steal memory from the
> host, that is not expected by us. This patchset means to resolve this
> issue.
> 
> After the container is restarted, the old memcg which is charged by the
> pinned progs and maps will be offline but won't be freed until all of the
> related maps and progs are freed. If we want to charge these bpf memory to
> the new started memcg, we should uncharge them from the offline memcg first
> and then charge it to the new one. As we have already known how the bpf
> memroy is allocated and freed, we can also know how to charge and uncharge
> it. This pathset implements various charge and uncharge methords for these
> memory.
> 
> Regarding how to do the recharge, we decide to implement new bpf syscalls
> to do it. With the new implemented bpf syscall, the agent running in the
> container can use it to do the recharge. As of now we only implement it for
> the bpf hash maps. Below is a simple example how to do the recharge,
> 
> ====
> int main(int argc, char *argv[])
> {
> 	union bpf_attr attr = {};
> 	int map_id;
> 	int pfd;
> 
> 	if (argc < 2) {
> 		printf("Pls. give a map id \n");
> 		exit(-1);
> 	}
> 
> 	map_id = atoi(argv[1]);
> 	attr.map_id = map_id;
> 	pfd = syscall(SYS_bpf, BPF_MAP_RECHARGE, &attr, sizeof(attr));
> 	if (pfd < 0)
> 		perror("BPF_MAP_RECHARGE");
> 
> 	return 0;
> }
> 
> ====
> 
> Patch #1 and #2 is for the observability, with which we can easily check
> whether the bpf maps is charged to a memcg and whether the memcg is offline.
> Patch #3, #4 and #5 is for the charge and uncharge methord for vmalloc-ed,
> kmalloc-ed and percpu memory.
> Patch #6~#9 implements the recharge of bpf hash map, which is mostly used
> by our bpf services. The other maps hasn't been implemented yet. The bpf progs
> hasn't been implemented neither.
> 
> This pathset is still a POC now, with limited testing. Any feedback is
> welcomed.

Hello Yafang!

It's an interesting topic, which goes well beyond bpf. In general, on cgroup
offlining we either do nothing either recharge pages to the parent cgroup
(latter is preferred), which helps to release the pinned memcg structure.

Your approach raises some questions:
1) what if the new cgroup is not large enough to contain the bpf map?
2) does it mean that some userspace app will monitor the state of the cgroup
which was the original owner of the bpf map and recharge once it's deleted?
3) what if there are several cgroups are sharing the same map? who will be
the next owner?
4) because recharging is fully voluntary, why any application should want to do
it, if it can just use the memory for free? it doesn't really look as a working
resource control mechanism.

Will reparenting work for your case? If not, can you, please, describe the
problem you're trying to solve by recharging the memory?

Thanks!
