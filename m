Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67F336DE0F
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 19:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241549AbhD1RT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 13:19:28 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:51288 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229931AbhD1RT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 13:19:28 -0400
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13SGSoOD027118;
        Wed, 28 Apr 2021 16:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pps0720; bh=FuywRiAvN6X4+WNwga978/a8H8a51VQ003aih6ECUsg=;
 b=hbhMajzKyVgFQ2yCoCX2cRm4QHe8+NaPsEy0hPYhDVVw1HtD6805dBXotO3ZvblMseCZ
 KOip45qWIdWUcjpvJnz/8E3cPqU19vr3cjuT/uyW5Lqmrl/qPoS/AlVUG3YfNlzplhHp
 dENaxKNas6IlpUcDN8CLXUamtRt3EM7v/WRzMVTBbDKuwhdThX1nzNQLnxERB/epereK
 IHfhr1TeCQgm1snqLhGTjBd3LpNFzuUoJmzpFQehn+Nnq4Tgxhvle16TZsz4MzDtQXys
 V5/vgIJ3V0jTn3tbzSNKlt1o1yXieuH5pAOKmAiOZboLfSz7bleEjX2sWkC2jMZJQ9Je zA== 
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0b-002e3701.pphosted.com with ESMTP id 387a27rt3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 16:31:26 +0000
Received: from g4t3433.houston.hpecorp.net (g4t3433.houston.hpecorp.net [16.208.49.245])
        by g4t3426.houston.hpe.com (Postfix) with ESMTP id EC1BA4E;
        Wed, 28 Apr 2021 16:31:25 +0000 (UTC)
Received: from bougret.labs.hpecorp.net (bougret.labs.hpecorp.net [10.93.238.30])
        by g4t3433.houston.hpecorp.net (Postfix) with ESMTP id 51F3C4A;
        Wed, 28 Apr 2021 16:31:25 +0000 (UTC)
Received: from jt by bougret.labs.hpecorp.net with local (Exim 4.92)
        (envelope-from <jt@labs.hpe.com>)
        id 1lbn5w-0007ZI-Jt; Wed, 28 Apr 2021 09:31:24 -0700
Date:   Wed, 28 Apr 2021 09:31:24 -0700
From:   Jean Tourrilhes <jean.tourrilhes@hpe.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andy Zhou <azhou@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, William Tu <u9012063@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH net] openvswitch: meter: remove rate from the bucket size
 calculation
Message-ID: <20210428163124.GA28950@labs.hpe.com>
Reply-To: jean.tourrilhes@hpe.com
References: <20210421135747.312095-1-i.maximets@ovn.org>
 <CAMDZJNVQ64NEhdfu3Z_EtnVkA2D1DshPzfur2541wA+jZgX+9Q@mail.gmail.com>
 <20210428064553.GA19023@labs.hpe.com>
 <04bd0073-6eb7-6747-a0b1-3c25cca7873a@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04bd0073-6eb7-6747-a0b1-3c25cca7873a@ovn.org>
Organisation: HP Labs Palo Alto
Address: HP Labs, MS1184, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: jean.tourrilhes@hpe.com
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-GUID: -gplV4EL_BNJiJzH-OpYrkM02K7xErJB
X-Proofpoint-ORIG-GUID: -gplV4EL_BNJiJzH-OpYrkM02K7xErJB
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_10:2021-04-28,2021-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 01:22:12PM +0200, Ilya Maximets wrote:
> 
> I didn't test it, but I looked at the implementation in
> net/sched/act_police.c and net/sched/sch_tbf.c, and they should work
> in a same way as this patch, i.e. it's a classic token bucket where
> burst is a burst and nothing else.

	Actually, act_police.c and sch_tbf.c will behave completely
differently, even if they are both based on the token bucket
algorithm.
	The reason is that sch_tbf.c is applied to a queue, and the
queue will smooth out traffic and avoid drops. The token bucket is
used to dequeue the queue, this is sometime called leaky bucket. I've
personally used sch_tbf.c with burst size barely bigger than the MTU,
and it works fine.
	This is why I was suggesting to compare to act_police.c, which
does not have a queue to smooth out traffic and can only drop
packets.
	I believe OVS meters are similar to policers, so that's why
they are suprising for people used to queues such as TBF and HTB.

	Regards,

	Jean
