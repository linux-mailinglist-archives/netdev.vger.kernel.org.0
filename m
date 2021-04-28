Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F2536D462
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 11:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbhD1JBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 05:01:10 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:21338 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237757AbhD1JBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 05:01:08 -0400
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13S6iZUc010716;
        Wed, 28 Apr 2021 06:45:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : content-type : in-reply-to
 : mime-version; s=pps0720;
 bh=yX8sjGtvRGtdaRZa0JMofG+qOKehAUAcfbuPnEDx2fo=;
 b=Jq3K6utLk2viNL3YjXuBPbsQnu/H28TxsARje12OIKZp23Bze4wacUD1nI1ZVOUe0VLN
 Ly3mzXYVIsl7DKbbDek97I13tjNsx1TalJF+k/S+kFtcxUy6m6VBlD5Dbeqm4Z0X2U31
 2YN6V0m6wUlEdm2nflbAQJjBoKdbF6N0Ohl53+GtTdHLBQPM5dmYKBJsu9C6TiQFy7xn
 lDPFh+0vJ84AX/RkOGFSyelMpr0dryusImWTll0JZ91sXbnNOoQPL1H0Y+7ETyljD2Cb
 jQKrJGqr2VabN/fHK/oXG+Re90qEhBN3dt7on3Cruc0QsDSp3MvEeCk5Ctsxj8mmImD3 8Q== 
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        by mx0b-002e3701.pphosted.com with ESMTP id 386fp40n6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 06:45:55 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id 9B1CB63;
        Wed, 28 Apr 2021 06:45:54 +0000 (UTC)
Received: from bougret.labs.hpecorp.net (bougret.labs.hpecorp.net [10.93.238.30])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id 4C4E94D;
        Wed, 28 Apr 2021 06:45:54 +0000 (UTC)
Received: from jt by bougret.labs.hpecorp.net with local (Exim 4.92)
        (envelope-from <jt@labs.hpe.com>)
        id 1lbdxJ-00050I-KT; Tue, 27 Apr 2021 23:45:53 -0700
Date:   Tue, 27 Apr 2021 23:45:53 -0700
From:   Jean Tourrilhes <jean.tourrilhes@hpe.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andy Zhou <azhou@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, William Tu <u9012063@gmail.com>
Subject: Re: [PATCH net] openvswitch: meter: remove rate from the bucket size
 calculation
Message-ID: <20210428064553.GA19023@labs.hpe.com>
Reply-To: jean.tourrilhes@hpe.com
References: <20210421135747.312095-1-i.maximets@ovn.org>
 <CAMDZJNVQ64NEhdfu3Z_EtnVkA2D1DshPzfur2541wA+jZgX+9Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNVQ64NEhdfu3Z_EtnVkA2D1DshPzfur2541wA+jZgX+9Q@mail.gmail.com>
Organisation: HP Labs Palo Alto
Address: HP Labs, MS1184, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: jean.tourrilhes@hpe.com
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-GUID: vNfUXcOf9RESgiY_XeaHG3VXD_C81uCq
X-Proofpoint-ORIG-GUID: vNfUXcOf9RESgiY_XeaHG3VXD_C81uCq
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_03:2021-04-27,2021-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 02:24:10PM +0800, Tonghao Zhang wrote:
> Hi Ilya
> If we set the burst size too small, the meters of ovs don't work.

	Most likely, you need to set the burst size larger.
	A quick Google on finding a good burst size :
https://www.juniper.net/documentation/us/en/software/junos/routing-policy/topics/concept/policer-mx-m120-m320-burstsize-determining.html

	Now, the interesting question, is the behaviour of OVS
different from a standard token bucket, such as a kernel policer ?
	Here is how to set up a kernel policer :
----------------------------------------------------------
# Create a dummy classful discipline to attach filter
tc qdisc del dev eth6 root
tc qdisc add dev eth6 root handle 1: prio bands 2 priomap  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
tc qdisc add dev eth6 parent 1:1 handle 10: pfifo limit 1000
tc qdisc add dev eth6 parent 1:2 handle 20: pfifo limit 1000
tc -s qdisc show dev eth6
tc -s class show dev eth6

# Filter to do hard rate limiting
tc filter del dev eth6 parent 1: protocol all prio 1 handle 800::100 u32 
tc filter add dev eth6 parent 1: protocol all prio 1 handle 800::100 u32 match u32 0 0 police rate 200mbit burst 20K mtu 10000 drop
tc -s filter show dev eth6
tc filter change dev eth6 parent 1: protocol all prio 1 handle 800::100 u32 match u32 0 0 police rate 200mbit burst 50K mtu 10000 drop
----------------------------------------------------------

	Regards,

	Jean
