Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1BA2D5F19
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390218AbgLJPIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:08:35 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18225 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390047AbgLJPI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 10:08:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd239c30000>; Thu, 10 Dec 2020 07:07:47 -0800
Received: from [172.27.0.216] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 10 Dec
 2020 15:07:32 +0000
Subject: Re: [PATCH net-next 3/4] sch_htb: Stats for offloaded HTB
To:     Dan Carpenter <dan.carpenter@oracle.com>, <kbuild@lists.01.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     <lkp@intel.com>, <kbuild-all@lists.01.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Tariq Toukan" <tariqt@mellanox.com>
References: <20201210082851.GL2767@kadam>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <7d1a6afe-d084-bdbd-168a-3bcb88910e2d@nvidia.com>
Date:   Thu, 10 Dec 2020 17:07:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210082851.GL2767@kadam>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607612867; bh=boZM8yCDYMDFtCoxMEVLJEDCQrl+fy73k7eS6X4A+HY=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=BhwIheKyK05hnrpBs/2h9A3yc0cFaSOR+HIfnsJGxd1Ff87ddj3MyqhJtpcRlvGU4
         rzV8GB172LPXzmSaT6stc/jaQ6XOyS6aYmschRNM/ekZc3bATjojgGBw9o9YYy82rm
         HeU0jdALrRcryXxnfjVbHRCPH/nr6lTuNDxT+oOoaV6ObVS4IYv0/QEWOVtDO/7Z7g
         m707MbK5mxS9OwrEdzaIiB5lhy9REg6dP624dLQ02nYxgEwR6Y8hPBPEvG3yWcNDvI
         NlRdt0XBEQKWpBXtxMUhe2zvasyQ7oAWvJLJNWRULuFGpemWvdfX1fWU3pmrpAaViG
         I85dvr42y8o6w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-10 10:28, Dan Carpenter wrote:
> Hi Maxim,
> 
> 
> url:    https://github.com/0day-ci/linux/commits/Maxim-Mikityanskiy/HTB-offload/20201210-000703
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git afae3cc2da100ead3cd6ef4bb1fb8bc9d4b817c5
> config: i386-randconfig-m021-20201209 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> net/sched/sch_htb.c:1310 htb_dump_class_stats() error: we previously assumed 'cl->leaf.q' could be null (see line 1300)
> 
> vim +1310 net/sched/sch_htb.c
> 
> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1289  static int
> 87990467d387f92 Stephen Hemminger     2006-08-10  1290  htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1291  {
> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1292  	struct htb_class *cl = (struct htb_class *)arg;
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1293  	struct htb_sched *q = qdisc_priv(sch);
> 338ed9b4de57c4b Eric Dumazet          2016-06-21  1294  	struct gnet_stats_queue qs = {
> 338ed9b4de57c4b Eric Dumazet          2016-06-21  1295  		.drops = cl->drops,
> 3c75f6ee139d464 Eric Dumazet          2017-09-18  1296  		.overlimits = cl->overlimits,
> 338ed9b4de57c4b Eric Dumazet          2016-06-21  1297  	};
> 6401585366326fc John Fastabend        2014-09-28  1298  	__u32 qlen = 0;
> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1299
> 5dd431b6b92c0db Paolo Abeni           2019-03-28 @1300  	if (!cl->level && cl->leaf.q)
>                                                                                    ^^^^^^^^^^
> Check for NULL

Well, I don't think this is real... I don't see any possibility how 
cl->leaf.q can be NULL for a leaf class. However, I'll add a similar 
check below anyway.

Also, I fixed the sparse warnings from the other email (sorry for them!)

I will wait for some time to collect more comments (hopefully from 
people, not only from static checkers) and respin with the fixes.

> 5dd431b6b92c0db Paolo Abeni           2019-03-28  1301  		qdisc_qstats_qlen_backlog(cl->leaf.q, &qlen, &qs.backlog);
> 5dd431b6b92c0db Paolo Abeni           2019-03-28  1302
> 0564bf0afae443d Konstantin Khlebnikov 2016-07-16  1303  	cl->xstats.tokens = clamp_t(s64, PSCHED_NS2TICKS(cl->tokens),
> 0564bf0afae443d Konstantin Khlebnikov 2016-07-16  1304  				    INT_MIN, INT_MAX);
> 0564bf0afae443d Konstantin Khlebnikov 2016-07-16  1305  	cl->xstats.ctokens = clamp_t(s64, PSCHED_NS2TICKS(cl->ctokens),
> 0564bf0afae443d Konstantin Khlebnikov 2016-07-16  1306  				     INT_MIN, INT_MAX);
> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1307
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1308  	if (q->offload) {
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1309  		if (!cl->level) {
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09 @1310  			cl->bstats = cl->leaf.q->bstats;
>                                                                                               ^^^^^^^^^^^^
> Unchecked dereference
> 
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1311  			cl->bstats.bytes += cl->bstats_bias.bytes;
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1312  			cl->bstats.packets += cl->bstats_bias.packets;
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1313  		} else {
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1314  			htb_offload_aggregate_stats(q, cl);
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1315  		}
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1316  	}
> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1317
> edb09eb17ed89ea Eric Dumazet          2016-06-06  1318  	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
> edb09eb17ed89ea Eric Dumazet          2016-06-06  1319  				  d, NULL, &cl->bstats) < 0 ||
> 1c0d32fde5bdf11 Eric Dumazet          2016-12-04  1320  	    gnet_stats_copy_rate_est(d, &cl->rate_est) < 0 ||
> 338ed9b4de57c4b Eric Dumazet          2016-06-21  1321  	    gnet_stats_copy_queue(d, NULL, &qs, qlen) < 0)
> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1322  		return -1;
> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1323
> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1324  	return gnet_stats_copy_app(d, &cl->xstats, sizeof(cl->xstats));
> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1325  }
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

