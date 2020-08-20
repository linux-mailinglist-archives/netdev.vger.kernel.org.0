Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D49B24C622
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgHTTGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:06:13 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:57632 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726772AbgHTTGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 15:06:09 -0400
X-Greylist: delayed 3036 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2020 15:06:09 EDT
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KID7hr012646;
        Thu, 20 Aug 2020 19:13:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=2H2U0bUzfzUQI2EwcnLmDOGu7A2f0Nk6jcVUHu0KIR4=;
 b=DCpO1J0qltxZE6OUrYuqD2jB8y5SuEslvWabCZf70G2oVyGZeMlv5qLAqH1wcxw0K4J/
 VaEwr5mXYAgP7eXdJbbNHV4bOJ/s+wsd02Qg6RN5rF/Jiajd84NDq7Oz72bk2vLF5HDg
 Y8PvRHRGKGFBsh3R4Eo1SN9ju8quTfh3CFtd74PbR8NsKcDH69pRJQZqdoc9vT02o74n
 2f/m3RR8hLqJR/DmFWvQVEs9KJZy7qcf0FAmVSMGkV+AUV0E++6xLl+WSInzMp/Ql/RL
 ujoeOHYdHylLF2IB9r+kHlprLyr4EgvaNUFASc3n+R3kAMw6wsh1in8VriB1fmV1V82q nw== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 331cy2tkr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 19:13:30 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 07KI5SRP005048;
        Thu, 20 Aug 2020 14:13:29 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint8.akamai.com with ESMTP id 32xb1yke91-1;
        Thu, 20 Aug 2020 14:13:29 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id AE0D26015C;
        Thu, 20 Aug 2020 18:13:27 +0000 (GMT)
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Jike Song <albcamus@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kehuan.feng@gmail.com
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com>
 <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
 <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
 <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <74921739-d344-38eb-aa19-c078783b6328@akamai.com>
Date:   Thu, 20 Aug 2020 11:13:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=907 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008200146
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxlogscore=769
 clxscore=1011 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jike

On 8/20/20 12:43 AM, Jike Song wrote:
> Hi Josh,
> 
> 
> We met possibly the same problem when testing nvidia/mellanox's
> GPUDirect RDMA product, we found that changing NET_SCH_DEFAULT to
> DEFAULT_FQ_CODEL mitigated the problem, having no idea why. Maybe you
> can also have a try?

We also did something similar where we've switched over to using the fq 
scheduler everywhere for now. We believe the bug is in the nolock code 
which only pfifo_fast uses atm, but we've been unable to come up with a 
satisfactory solution.

> 
> Besides, our testing is pretty complex, do you have a quick test to
> reproduce it?
> 

Unfortunately we don't have a simple test case either. Our current 
reproducer is complex as well, although it would seem like we should be 
able to come up with something where you have maybe 2 threads trying to 
send on the same tx queue running pfifo_fast every few hundred 
milliseconds and not much else/no other tx traffic on that queue. IIRC 
we believe the scenario is when one thread is in the process of 
dequeuing a packet while another is enqueuing, the enqueue-er (word? :)) 
sees the dequeue is in progress and so does not xmit the packet assuming 
the dequeue operation will take care of it. However b/c the dequeue is 
in the process of completing it doesn't and the newly enqueued packet 
stays in the qdisc until another packet is enqueued pushing both out.

Given that we have a workaround with using fq or any other qdisc not 
named pfifo_fast this has gotten bumped down in priority for us. I would 
like to work on a reproducer at some point, but won't likely be for a 
few weeks :(

Josh
