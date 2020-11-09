Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14E62AB1E8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgKIHxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:53:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729694AbgKIHxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:53:05 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A97WIGq017815;
        Mon, 9 Nov 2020 02:53:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OXpvnKJTGjZbtghmn2g1wneefTLUdQcWo6+7TKvZ9AA=;
 b=CSnRAYpeX2s1I3fea615MEul1QnysFkp6sASVtrbVf/PQ4L1gu1j6zzesFSzypUr+Tff
 /NFtFy7W6dVJ8vf0jBPdfajzhK4jHonMOXQJo9sTR8pp2qnqILUOaO/DBz9eNAGjIxxU
 Vxa5V7tbBcffQSYkTFRNJANUZWUynh0XdLQE2XB3kY1viAlPTFv5gYvFUGy4AHGGBwDX
 QwQqDY4YP9eFE7AgLcrQX3vi2gtuy1LF10SCjRBH71bu1Kf/IR4EYRaE+G8M8oY4QDCP
 tseHB4a3G5iG4qWFPSL6Im0Q10V4+Kg3lZFGykaQaaJtXRSCfIpYtYwmpJApMxhUwDBG hA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34p9d89skb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 02:53:01 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A97mCS8030311;
        Mon, 9 Nov 2020 07:52:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 34njuh0wp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 07:52:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A97quR141877962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 07:52:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 978004203F;
        Mon,  9 Nov 2020 07:52:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7563842052;
        Mon,  9 Nov 2020 07:52:51 +0000 (GMT)
Received: from [9.145.159.20] (unknown [9.145.159.20])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 07:52:50 +0000 (GMT)
Subject: Re: [PATCH net 1/2] net/af_iucv: fix null pointer dereference on
 shutdown
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
References: <20201106125008.36478-1-jwi@linux.ibm.com>
 <20201106125008.36478-2-jwi@linux.ibm.com>
 <20201106085928.183e0c77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <b25101c7-e08d-81b2-a2da-99dfa476f66c@linux.ibm.com>
Date:   Mon, 9 Nov 2020 09:52:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201106085928.183e0c77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_02:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.11.20 18:59, Jakub Kicinski wrote:
> On Fri,  6 Nov 2020 13:50:07 +0100 Julian Wiedmann wrote:
>> From: Ursula Braun <ubraun@linux.ibm.com>
>>
>> syzbot reported the following KASAN finding:
>>
>> BUG: KASAN: nullptr-dereference in iucv_send_ctrl+0x390/0x3f0 net/iucv/af_iucv.c:385
>> Read of size 2 at addr 000000000000021e by task syz-executor907/519
>>
>> CPU: 0 PID: 519 Comm: syz-executor907 Not tainted 5.9.0-syzkaller-07043-gbcf9877ad213 #0
>> Hardware name: IBM 3906 M04 701 (KVM/Linux)
>> Call Trace:
>>  [<00000000c576af60>] unwind_start arch/s390/include/asm/unwind.h:65 [inline]
>>  [<00000000c576af60>] show_stack+0x180/0x228 arch/s390/kernel/dumpstack.c:135
>>  [<00000000c9dcd1f8>] __dump_stack lib/dump_stack.c:77 [inline]
>>  [<00000000c9dcd1f8>] dump_stack+0x268/0x2f0 lib/dump_stack.c:118
>>  [<00000000c5fed016>] print_address_description.constprop.0+0x5e/0x218 mm/kasan/report.c:383
>>  [<00000000c5fec82a>] __kasan_report mm/kasan/report.c:517 [inline]
>>  [<00000000c5fec82a>] kasan_report+0x11a/0x168 mm/kasan/report.c:534
>>  [<00000000c98b5b60>] iucv_send_ctrl+0x390/0x3f0 net/iucv/af_iucv.c:385
>>  [<00000000c98b6262>] iucv_sock_shutdown+0x44a/0x4c0 net/iucv/af_iucv.c:1457
>>  [<00000000c89d3a54>] __sys_shutdown+0x12c/0x1c8 net/socket.c:2204
>>  [<00000000c89d3b70>] __do_sys_shutdown net/socket.c:2212 [inline]
>>  [<00000000c89d3b70>] __s390x_sys_shutdown+0x38/0x48 net/socket.c:2210
>>  [<00000000c9e36eac>] system_call+0xe0/0x28c arch/s390/kernel/entry.S:415
>>
>> There is nothing to shutdown if a connection has never been established.
>> Besides that iucv->hs_dev is not yet initialized if a socket is in
>> IUCV_OPEN state and iucv->path is not yet initialized if socket is in
>> IUCV_BOUND state.
>> So, just skip the shutdown calls for a socket in these states.
>>
>> Fixes: eac3731bd04c ("s390: Add AF_IUCV socket support")
>> Fixes: 82492a355fac ("af_iucv: add shutdown for HS transport")
>> Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
>> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
>> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> 
> Fixes tag: Fixes: eac3731bd04c ("s390: Add AF_IUCV socket support")
> Has these problem(s):
> 	- Subject does not match target commit subject
> 	  Just use
> 		git log -1 --format='Fixes: %h ("%s")'
> 

sigh... yes, that should have been
Fixes: eac3731bd04c ("[S390]: Add AF_IUCV socket support")

Thanks. Will fix up and get you a v2 shortly.
